Class {
	#name : #SSTestCaseTest,
	#superclass : #TestCase,
	#category : #'SSGenerator-Tests'
}

{ #category : #tests }
SSTestCaseTest >> testAddFactoryMessage [
	| testCase aTypeInfo |
	testCase := SSTestCase new.
	aTypeInfo := STypeInfo new.
	aTypeInfo types
		at: #SEvent
		put:
			{(STypeMethodInfo new
				selector: #discount;
				returnType: #SmallInteger;
				yourself)}.
	testCase typeInfo: aTypeInfo.
	testCase addFactoryMessage.
	self assert: testCase statements size equals: 1.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements: {'_var0 := SEvent new.'}.
	testCase typeInfo types
		at: #SStack
		ifAbsentPut: [ {(STypeMethodInfo new
				selector: #newStack:;
				returnType: #SStack;
				argTypes: {#Array} yourself)} ].
	testCase addFactoryMessage: SStack.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements: {'_var0 := SEvent new.' . '_var1 := SStack newStack:.'}
]

{ #category : #tests }
SSTestCaseTest >> testAddStatement [
	| testCase assignment |
	testCase := SSTestCase new.
	assignment := SFactoryMessage default: SEvent.
	testCase addStatement: assignment.
	self assert: testCase statements size equals: 1.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements: {'_var1 := SEvent new.'}
]

{ #category : #tests }
SSTestCaseTest >> testFieldAccessMessage [
	| testCase aTypeInfo |
	testCase := SSTestCase new.
	aTypeInfo := STypeInfo new.
	aTypeInfo types
		at: #SEvent
		put:
			{(STypeMethodInfo new
				selector: #discount;
				returnType: #SmallInteger;
				yourself)}.
	testCase typeInfo: aTypeInfo.
	testCase addFactoryMessage.
	testCase addFieldAccessMessage.
	self assert: testCase statements size equals: 2.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements: {'_var0 := SEvent new.'. '_var1 := _var0 discount.'}.
	"testCase typeInfo addTypeOf: #SStack
		with: {(STypeMethodInfo new
				selector: #newStack:;
				returnType: #SStack;
				argTypes: {#Array}; yourself). (STypeMethodInfo new selector: #top; returnType: #SStack; yourself)}.
	testCase addFactoryMessage: SStack.
	testCase addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements: {'_var0 := SEvent new.' . '_var1 := SStack newStack:.'}"
]
