Class {
	#name : #SMutatorTestCase,
	#superclass : #Object,
	#instVars : [
		'testCase'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'instance creation' }
SMutatorTestCase class >> with: aTestCase [
	^ self new testCase: aTestCase
]

{ #category : #'error handling' }
SMutatorTestCase >> error: string [
	^ SError signal: string 
]

{ #category : #'as yet unclassified' }
SMutatorTestCase >> factoryMessage: aClassName [
	^ self factoryMessage: aClassName before: nil
]

{ #category : #'as yet unclassified' }
SMutatorTestCase >> insertExpression [
	| l stop alpha count random |
	l := 1.
	count := 0.
	stop := testCase numberStatements.
	alpha := 0.5.
	random := Random new seed: DateAndTime current nanoSecond / 100.
	[ l < stop and: [ random next <= (alpha raisedTo: count) ] ]
		whileTrue: [ self insertExpressionRandomly.
			l := l + 1.
			count := count + 1 ]
]

{ #category : #'as yet unclassified' }
SMutatorTestCase >> insertExpressionRandomly [
		#(#insertRandomMessage:using: #insertMethodMessage:using: #insertAsParameter:using:)
		shuffle
		do: [ :selector | 
			[ ^ testCase insertStatementOfSelector: selector ]
				on: SError
				do: [  ] ]
]

{ #category : #removing }
SMutatorTestCase >> removeExpression: expression [
	| exprsToRemove |
	testCase removeFromStatements: expression.
	exprsToRemove := self repair: expression.
	exprsToRemove do: [ :expr | self removeExpression: expr ]
]

{ #category : #removing }
SMutatorTestCase >> removeExpressionWithoutRepairing: expression [
	testCase removeFromStatements: expression.
	[ testCase statementAt: expression ]
		on: SError
		do: [ (testCase statements copy
				flatCollect: [ :stm | 
					(stm pickUpReferences: expression)
						ifNotEmpty: [ Array with: stm ] ])
				do: [ :stm | self removeExpressionWithoutRepairing: stm ] ]
]

{ #category : #'as yet unclassified' }
SMutatorTestCase >> repair: expression [
	[ testCase statementAt: expression ]
		on: SError
		do: [ ^ testCase statements copy
				flatCollect: [ :stm | self repairReferenceTo: expression of: stm ] ].
	self error: 'expression must not exist in the testCase'
]

{ #category : #'as yet unclassified' }
SMutatorTestCase >> repair: exprToReplace of: expression [
	| aType replacement |
	aType := exprToReplace returnType.
	replacement := (testCase
		subStatementsFrom: 1
		toPrevIndexOf: expression) shuffle
		detect:
			[ :stm | stm reference ~= exprToReplace and: [ stm returnType = aType ] ]
		ifNone: [ testCase addStatementOfType: aType before: expression ].
	testCase replace: exprToReplace by: replacement on: expression
]

{ #category : #'as yet unclassified' }
SMutatorTestCase >> repairReferenceTo: removedExpression of: expression [
	| references exprsToDelete |
	references := expression pickUpReferences: removedExpression.
	exprsToDelete := OrderedCollection new.
	references
		do: [ :reference | 
			[ self repair: reference of: expression ]
				on: SError
				do: [ exprsToDelete add: reference ] ].
	^ exprsToDelete
]

{ #category : #accessing }
SMutatorTestCase >> testCase: anObject [
	testCase := anObject
]

{ #category : #'as yet unclassified' }
SMutatorTestCase >> validateTestCase [
	testCase ifNil: [ self error: 'Set the testCase correctly' ].
	testCase typeInfo ifNil: [ self error: 'Set the testCase with the correct typeInfo' ]
]
