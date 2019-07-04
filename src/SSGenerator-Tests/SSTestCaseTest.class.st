Class {
	#name : #SSTestCaseTest,
	#superclass : #TestCase,
	#category : #'SSGenerator-Tests-Core'
}

{ #category : #'as yet unclassified' }
SSTestCaseTest class >> typeInfoFoo [
	| aTypeInfo typeClassInfo |
	aTypeInfo := STypeInfo new.
	typeClassInfo := STypeClassInfo newFrom: #SFoo and: aTypeInfo.
	typeClassInfo
		addMethod:
			(STypeMethodInfo new
				selector: #score;
				returnType: #SmallInteger;
				isQuick: true;
				yourself);
		addMethod:
			(STypeMethodInfo new
				selector: #score:;
				returnType: #SmallInteger;
				argTypes: {#SmallInteger};
				yourself);
		addMethod:
			(STypeMethodInfo new
				selector: #returnString;
				returnType: #ByteString;
				yourself);
		addClassMethod:
			(STypeMethodInfo new
				selector: #score:;
				returnType: #SFoo;
				argTypes: {#SmallInteger};
				yourself).
	aTypeInfo
		scalars:
			(Dictionary new
				at: #SmallInteger put: {5} asSet;
				at: #ByteString put: {'hello'} asSet;
				yourself).
	aTypeInfo addClassInfo: typeClassInfo.
	^ aTypeInfo
]

{ #category : #tests }
SSTestCaseTest >> setUp [
]

{ #category : #tests }
SSTestCaseTest >> testAddFactoryMessage [
	| testCase aTypeInfo typeClassInfo |
	testCase := SSTestCase new.
	aTypeInfo := STypeInfo new.
	typeClassInfo := STypeClassInfo newFrom: #SFoo and: aTypeInfo.
	typeClassInfo
		addMethod:
			(STypeMethodInfo new
				selector: #returnString;
				returnType: #ByteString;
				yourself);
		addClassMethod:
			(STypeMethodInfo new
				selector: #score:;
				returnType: #SFoo;
				argTypes: {#SmallInteger};
				yourself).
	aTypeInfo
		scalars:
			(Dictionary new
				at: #SmallInteger put: {3} asSet;
				yourself).
	aTypeInfo addClassInfo: typeClassInfo.
	testCase typeInfo: aTypeInfo.
	testCase addLiteral.
	testCase addFactoryMessage.
	self assert: testCase statements size equals: 2.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements: {'_var0 := 3.' . '_var1 := SFoo score: _var0.'}.
	typeClassInfo := STypeClassInfo newFrom: #SStack and: aTypeInfo.
	typeClassInfo
		addMethod:
			(STypeMethodInfo new
				selector: #top;
				returnType: nil;
				yourself).
	aTypeInfo addClassInfo: typeClassInfo.
	testCase addFactoryMessage: SStack.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_var0 := 3.' . '_var1 := SFoo score: _var0.'.
			'_var2 := SStack new.'}
	"testCase typeInfo types
		at: #SStack
		ifAbsentPut: [ {(STypeMethodInfo new
				selector: #newStack:;
				returnType: #SStack;
				argTypes: {#Array} yourself)} ].
	testCase addFactoryMessage: SStack.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements: {'_var0 := SEvent new.' . '_var1 := SStack newStack:.'}"
]

{ #category : #tests }
SSTestCaseTest >> testAddLiteral [
	| testCase aTypeInfo typeClassInfo |
	testCase := SSTestCase new.
	aTypeInfo := STypeInfo new.
	typeClassInfo := STypeClassInfo newFrom: #SFoo and: aTypeInfo.
	typeClassInfo
		addMethod: (STypeMethodInfo new 
		selector: #return:;
		returnType: #OrderedCollection;
		argTypes: {#OrderedCollection}).
	aTypeInfo
		scalars:
			(Dictionary new
				at: #OrderedCollection put: {OrderedCollection newFrom: #(1 4)} asSet;
				at: #ByteString put: { 'World' } asSet;
				at: #SmallInteger put: { 2 } asSet;
				yourself).
	aTypeInfo addClassInfo: typeClassInfo.
	testCase typeInfo: aTypeInfo.
	testCase addLiteral: #ByteString;
	
	addLiteral: #OrderedCollection;addLiteral: #SmallInteger.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements: {'_var0 := ''World''.' .'_var1 := ((OrderedCollection new) add: 1; add: 4; yourself).'.  '_var2 := 2.'.}.
]

{ #category : #tests }
SSTestCaseTest >> testAddMessage [
	| testCase aTypeInfo typeClassInfo |
	testCase := SSTestCase new.
	aTypeInfo := STypeInfo new.
	typeClassInfo := STypeClassInfo newFrom: #SFoo and: aTypeInfo.
	typeClassInfo
		addMethod: (STypeMethodInfo new 
		selector: #return:;
		returnType: #OrderedCollection;
		argTypes: {#OrderedCollection}).
	aTypeInfo
		scalars:
			(Dictionary new
				at: #OrderedCollection put: {OrderedCollection newFrom: #(1 4)} asSet;
				yourself).
	aTypeInfo addClassInfo: typeClassInfo.
	testCase typeInfo: aTypeInfo.
	testCase addFactoryMessage.
	testCase addLiteral.
	testCase addMessage.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements: {'_var0 := SFoo new.' .'_var1 := ((OrderedCollection new) add: 1; add: 4; yourself).'.  '_var2 := _var0 return: _var1.'.}.
	"typeClassInfo
		addMethod:
			(STypeMethodInfo new
				selector: #returnString;
				returnType: #ByteString;
				yourself).
	testCase addMessage.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements: {'_var0 := SFoo new.' . '_var1 := '.'_var1 := _var0 return: ((OrderedCollection new) add: 1; add: 4; yourself)'. '_var2 := _var0 returnString.'}.
	typeClassInfo := STypeClassInfo newFrom: #SStack and: aTypeInfo.
	typeClassInfo
		addMethod:
			(STypeMethodInfo new
				selector: #top;
				returnType: nil;
				yourself).
	aTypeInfo addClassInfo: typeClassInfo.
	testCase addFactoryMessage: SStack.
	testCase addMessage.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_var0 := SFoo new.' . '_var1 := _var0 returnString.'.
			'_var2 := SStack new.'}"
]

{ #category : #tests }
SSTestCaseTest >> testFieldAccessMessage [
	| testCase aTypeInfo typeClassInfo |
	testCase := SSTestCase new.
	aTypeInfo := STypeInfo new.
	typeClassInfo := STypeClassInfo newFrom: #SFoo and: aTypeInfo.
	typeClassInfo
		addMethod:
			(STypeMethodInfo new
				selector: #score;
				returnType: #SmallInteger;
				isQuick: true;
				yourself);
		addMethod:
			(STypeMethodInfo new
				selector: #score:;
				returnType: #SmallInteger;
				argTypes: {#SmallInteger};
				yourself);
		addMethod:
			(STypeMethodInfo new
				selector: #returnString;
				returnType: #ByteString;
				yourself);
		addClassMethod:
			(STypeMethodInfo new
				selector: #score:;
				returnType: #SFoo;
				argTypes: {#SmallInteger};
				yourself).
	aTypeInfo
		scalars:
			(Dictionary new
				at: #SmallInteger put: {5} asSet;
				at: #ByteString put: {'hello'} asSet;
				yourself).
	aTypeInfo addClassInfo: typeClassInfo.
	testCase typeInfo: aTypeInfo.
	testCase addLiteral: #SmallInteger.
	testCase addFactoryMessage.
	testCase addFieldAccessMessage.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_var0 := 5.' . '_var1 := SFoo score: _var0.'.
			'_var2 := _var1 score.'}
]

{ #category : #tests }
SSTestCaseTest >> testGenerateStatements [
	| testCase typeInfo |
	typeInfo := self class typeInfoFoo.
	testCase := SSTestCase with: typeInfo.
	testCase numberStatements: 30.
	self shouldnt: [ testCase generateStatements ] raise: SError
]
