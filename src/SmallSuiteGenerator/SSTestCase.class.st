"
SSTestCase is a subclass that defines or initializes some instance variables which are util in the genetic algorithm evolution
"
Class {
	#name : #SSTestCase,
	#superclass : #SSTestShifter,
	#instVars : [
		'previousOpenWindows'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'instance creation' }
SSTestCase class >> with: aTypeInfo [
	|testCase|
	testCase := self new.
	testCase typeInfo: aTypeInfo.
	^ testCase.
]

{ #category : #comparing }
SSTestCase >> = other [
	^ self class = other class and: [ statements = other statements ]
]

{ #category : #actions }
SSTestCase >> analyze [
	" we delegate the responsibility to a test runner, in the future we would like to add new ways to run the tests "
	|result|
	self setUp.
	result := SSTestRunner new evaluate: self.
	self tearDown.
	^ result.
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
	copy := SSTestCase with: typeInfo copy.
	copy addTargetClassNames: targetClassesNames.
	statements do: [ :stm | copy addStatement: stm copy ].
	copy updateNextId.
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

{ #category : #actions }
SSTestCase >> run [
	" we delegate the responsibility to a test runner, in the future we would like to add new ways to run the tests "
	|result|
	self setUp.
	result := SSTestRunner new run: self.
	self tearDown.
	^ result.
]

{ #category : #actions }
SSTestCase >> runWithoutAssertions [
	" we delegate the responsibility to a test runner, in the future we would like to add new ways to run the tests "
	|result|
	self setUp.
	result := SSTestRunner new runWithoutAssertions: self.
	self tearDown.
	^ result.
]

{ #category : #actions }
SSTestCase >> setUp [
	previousOpenWindows := SystemWindow allInstances.
]

{ #category : #actions }
SSTestCase >> tearDown [ 
	|windowsToDelete|
	windowsToDelete := SystemWindow allInstances asOrderedCollection removeAll: previousOpenWindows.
	windowsToDelete do:[:w| w close].
]
