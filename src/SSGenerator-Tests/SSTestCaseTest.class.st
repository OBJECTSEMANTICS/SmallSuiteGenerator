Class {
	#name : #SSTestCaseTest,
	#superclass : #TestCase,
	#category : #'SSGenerator-Tests'
}

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
