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

{ #category : #'as yet unclassified' }
SSTestCaseTest class >> typeInfoSFoo [
	| typeInfo |
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					{{(#returnNum
						->
							{#SmallInteger.
							{}.
							false}).
					(#returnFloat
						->
							{#SmallFloat64.
							{}.
							false}).
					(#score
						->
							{#SmallFloat64.
							{}.
							true}).
					(#return:
						->
							{#ByteString.
							{#ByteString}.
							false})}.
					{(#score:
						->
							{#SFoo.
							{#SmallFloat64}.
							false})}};
		scalar: #ByteString with: {'hello'};
		scalar: #SmallInteger with: {5};
		scalar: #SmallFloat64 with: {7.3}.
	^ typeInfo
]

{ #category : #tests }
SSTestCaseTest >> setUp [
]

{ #category : #tests }
SSTestCaseTest >> testAddFactoryMessage [
	| testCase aTypeInfo |
	testCase := SSTestCase new.
	aTypeInfo := STypeInfo new
		type:
			#SFoo
				->
					{{(#returnString
						->
							{#ByteString.
							{}.
							false})}.
					{(#score:
						->
							{#SFoo.
							{#SmallInteger}.
							false})}}.
	aTypeInfo scalar: #SmallInteger with: #(3).
	testCase typeInfo: aTypeInfo.
	testCase addFactoryMessage.
	self assert: testCase statements size equals: 2.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements: {'_var0 := 3.' . '_var1 := SFoo score: _var0.'}.
	aTypeInfo
		type:
			#SStack
				->
					{{(#top
						->
							{nil.
							{}.
							false})}.
					{(#newStack:
						->
							{#SStack.
							{#Array}.
							false})}}.
	aTypeInfo scalar: #Array with: {#(1 3 2)}.
	testCase addFactoryMessage: #SStack.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_var0 := 3.' . '_var1 := SFoo score: _var0.'.
			'_var2 := #(1 3 2 ).' . '_var3 := SStack newStack: _var2.'}
]

{ #category : #tests }
SSTestCaseTest >> testAddLiteral [
	| testCase aTypeInfo |
	testCase := SSTestCase new.
	aTypeInfo := STypeInfo new
		type:
			#SFoo
				->
					{{(#return:
						->
							{#OrderedCollection.
							{#OrderedCollection}.
							false})}.
					{}}.
	aTypeInfo
		scalar: #OrderedCollection
		with: {(OrderedCollection newFrom: #(1 4))}.
	aTypeInfo scalar: #ByteString with: #('World').
	aTypeInfo scalar: #SmallInteger with: #(2).
	testCase typeInfo: aTypeInfo.
	testCase
		addLiteral: #ByteString;
		addLiteral: #OrderedCollection;
		addLiteral: #SmallInteger.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_var0 := ''World''.' . '_var1 := ((OrderedCollection new) add: 1; add: 4; yourself).'.
			'_var2 := 2.'}
]

{ #category : #tests }
SSTestCaseTest >> testAddMessage [
	| testCase aTypeInfo |
	testCase := SSTestCase new.
	aTypeInfo := STypeInfo new
		type:
			#SFoo
				->
					{{(#return:
						->
							{#OrderedCollection.
							{#OrderedCollection}.
							false})}.
					{}}.
	aTypeInfo
		scalar: #OrderedCollection
		with: {(OrderedCollection newFrom: #(1 4))}.
	testCase typeInfo: aTypeInfo.
	testCase addMessage.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_var0 := SFoo new.' . '_var1 := ((OrderedCollection new) add: 1; add: 4; yourself).'.
			'_var2 := _var0 return: _var1.'}.
	(aTypeInfo classAt: #SFoo)
		typeMethod:
			#returnString
				->
					{#ByteString.
					{}.
					false}.
	testCase addMessage: #returnString from: #SFoo.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_var0 := SFoo new.' . '_var1 := ((OrderedCollection new) add: 1; add: 4; yourself).'.
			'_var2 := _var0 return: _var1.' . '_var3 := _var0 returnString.'}
]

{ #category : #tests }
SSTestCaseTest >> testCopy [
	| testCase typeInfo otherTestCase |
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					{{(#returnNum
						->
							{#SmallInteger.
							{}.
							false}).
					(#returnFloat
						->
							{#SmallFloat64.
							{}.
							false}).
					(#score
						->
							{#SmallInteger.
							{}.
							true}).
					(#return:
						->
							{#ByteString.
							{#ByteString}.
							false})}.
					{(#score:
						->
							{#SFoo.
							{#SmallFloat64}.
							false})}}.
	typeInfo scalar: #ByteString with: {'hello'}.
	typeInfo scalar: #SmallInteger with: {5}.
	typeInfo scalar: #SmallFloat64 with: {7.3}.
	testCase := SSTestCase with: typeInfo.
	testCase
		addMessage: #returnNum from: #SFoo;
		addFieldAccessMessage: #score from: #SFoo;
		addLiteral: #SmallInteger.
	otherTestCase := testCase copy.
	self assert: testCase numberStatements equals: 5.
	self assert: testCase equals: otherTestCase.
	testCase addLiteral: #ByteString.
	otherTestCase addMessage: #returnFloat from: #SFoo.
	otherTestCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'.
			'_var2 := _var1 returnNum.' . '_var3 := _var1 score.'.
			'_var4 := 5.' . '_var5 := ''hello''.'}.
	self
		assertCollection: (otherTestCase statements collect: #printString)
		hasSameElements:
			{'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'.
			'_var2 := _var1 returnNum.' . '_var3 := _var1 score.'.
			'_var4 := 5.' . '_var5 := _var1 returnFloat.'.
			'_var6 := ''hello''.' . '_var7 := _var1 return: _var6.'}
]

{ #category : #tests }
SSTestCaseTest >> testFieldAccessMessage [
	| testCase aTypeInfo|
	testCase := SSTestCase new.
	aTypeInfo := STypeInfo new
		type:
			#SFoo
				->
					{{(#score
						->
							{#SmallInteger.
							{}.
							true}).
					(#score:
						->
							{#SmallInteger.
							{#SmallInteger}.
							false})}.
					{(#score:
						->
							{#SFoo.
							{#SmallInteger}.
							false})}}.
	aTypeInfo scalar: #SmallInteger with: #(5).
	testCase typeInfo: aTypeInfo.
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
	testCase numMaxStatements: 30.
	self shouldnt: [ testCase generateStatements ] raise: SError
]

{ #category : #mutation }
SSTestCaseTest >> testInsertStatementOfSelectorRandomMessage [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'}.
	testCase removeStatementOfVarName: '_var1'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := 7.3.'}
]

{ #category : #mutation }
SSTestCaseTest >> testRemoveArgsFactoryMessage [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'}.
	testCase removeStatementOfVarName: '_var0'.
	
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var2 := 7.3.' . '_var1 := SFoo score: _var2.'}
]

{ #category : #mutation }
SSTestCaseTest >> testRemoveArgsMessage [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'.
			'_var2 := ''hello''.' . '_var3 := _var1 return: _var2.'}.
	testCase removeStatementOfVarName: '_var2'.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll:
			{'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'.
			'_var4 := ''hello''.'}.	" '_var3 := _var1 return: _var4.'"
	self
		assert:
			(testCase
				includesStatementOfVarName: (testCase statementOfVarName: '_var3') value args first printString)
]

{ #category : #mutation }
SSTestCaseTest >> testRemoveFactoryMessage [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'}.
	testCase removeStatementOfVarName: '_var1'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := 7.3.'}
]

{ #category : #mutation }
SSTestCaseTest >> testRemoveFieldAccessMessage [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'.
			'_var2 := _var1 score.'}.
	testCase removeStatementOfVarName: '_var2'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'}
]

{ #category : #mutation }
SSTestCaseTest >> testRemoveMessage [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'.
			'_var2 := ''hello''.' . '_var3 := _var1 return: _var2.'}.
	
	testCase removeStatementOfVarName: '_var3'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'.
			'_var2 := ''hello''.'}
]

{ #category : #mutation }
SSTestCaseTest >> testRemoveReceiverFieldAccessMessage [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'.
			'_var2 := _var1 score.'}.
	testCase removeStatementOfVarName: '_var1'.
	
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := 7.3.' . '_var3 := SFoo score: _var0.'.
			'_var2 := _var3 score.'}
]

{ #category : #mutation }
SSTestCaseTest >> testRemoveReceiverMessage [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'.
			'_var2 := ''hello''.' . '_var3 := _var1 return: _var2.'}.
	testCase removeStatementOfVarName: '_var1'.
	
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := 7.3.' . '_var4 := SFoo score: _var0.'.
			'_var2 := ''hello''.' . '_var3 := _var4 return: _var2.'}
]
