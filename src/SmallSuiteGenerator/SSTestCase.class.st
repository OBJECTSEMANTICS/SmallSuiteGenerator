"
SSTestCase is a subclass that defines or initializes some instance variables which are util in the genetic algorithm evolution
"
Class {
	#name : #SSTestCase,
	#superclass : #SSTestShifter,
	#instVars : [
		'number'
	],
	#classInstVars : [
		'numberTestCase'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #accessing }
SSTestCase class >> numberTestCase [
	numberTestCase ifNil: [ numberTestCase := 0 ].
	numberTestCase := numberTestCase + 1.
	^ numberTestCase 
]

{ #category : #initialization }
SSTestCase class >> resetNumberTestCase [
	numberTestCase := nil
]

{ #category : #'instance creation' }
SSTestCase class >> with: aTypeInfo [
	|testCase|
	testCase := self new.
	testCase typeInfo: aTypeInfo;
	number: self numberTestCase.
	^ testCase.
]

{ #category : #comparing }
SSTestCase >> = another [
  ^self class = another class and: [ statements = another statements and: [ fitness = another fitness and: [ parents = another parents and: [ number = another number ] "and: [ childs size = other childs size ]" ] ] ]
]

{ #category : #actions }
SSTestCase >> computeFitness: fitnessClass [

	| valueFitness |
	valueFitness := fitnessClass computeFitness: self.
	[ fitness addAll: valueFitness ]
		on: MessageNotUnderstood
		do: [ fitness add: valueFitness ]
]

{ #category : #copying }
SSTestCase >> copy [
	| copy |
	copy := self class with: typeInfo copy.
	copy addTargetClassNames: targetClassesNames.
	statements do: [ :stm | copy addStatement: stm copy ].
	copy updateNextId.
	^ copy
]

{ #category : #copying }
SSTestCase >> deepCopy [
	| copy |
	copy := self class with: typeInfo copy.
	copy addTargetClassNames: targetClassesNames.
	statements do: [ :stm | copy addStatement: stm copy ].
	copy updateNextId.
	copy setFitness: self fitness.
	copy setFitnessByClass: self fitnessByClass.
	^ copy
]

{ #category : #comparing }
SSTestCase >> hash [
	^ self statements hash
]

{ #category : #initialization }
SSTestCase >> initialize [
	super initialize.
	
]

{ #category : #actions }
SSTestCase >> length [
	^ self numberStatements.
]

{ #category : #accessing }
SSTestCase >> number [ 	
	^ number
]

{ #category : #accessing }
SSTestCase >> number: anInteger [
	number := anInteger 
]

{ #category : #actions }
SSTestCase >> run [
	" we delegate the responsibility to a test runner, in the future we would like to add new ways to run the tests "
	^ SSTestRunner new run: self.
]

{ #category : #actions }
SSTestCase >> runWithoutAssertions [
	" we delegate the responsibility to a test runner, in the future we would like to add new ways to run the tests "
	^ SSTestRunner new runWithoutAssertions: self.
]

{ #category : #initialization }
SSTestCase >> setFitness: aDictionary [ 
	fitness := aDictionary copy
]

{ #category : #initialization }
SSTestCase >> setFitnessByClass: aDictionary [ 
	fitnessByClass := aDictionary copy
]

{ #category : #actions }
SSTestCase >> setUp [
]

{ #category : #actions }
SSTestCase >> tearDown [ 
]
