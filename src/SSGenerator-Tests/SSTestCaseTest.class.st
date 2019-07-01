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
	"assignment := SAssignment new
		variable: (SVariable new name: '_var1');
		value:
			(SFactoryMessage new
				receiver: #SStack;
				selector: #new)."
	testCase addStatement: assignment.
	self assert: testCase statements size equals: 1.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements: {'_var1 := SEvent new.'}.
	
]
