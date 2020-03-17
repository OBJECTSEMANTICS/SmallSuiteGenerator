"
SSTestCase is a subclass that defines or initializes some instance variables which are util in the genetic algorithm evolution
"
Class {
	#name : #SSTestCase,
	#superclass : #SSTestShifter,
	#instVars : [
		'idPopulation',
		'ni',
		'previousOpenWindows',
		'summaryExecutionMethods'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'instance creation' }
SSTestCase class >> with: aTypeInfo [
  | testCase |
  testCase := self new.
  testCase typeInfo: aTypeInfo.
  ^testCase
]

{ #category : #comparing }
SSTestCase >> = another [
  ^ self class = another class 
	and: [ statements = another statements 
		and: [ fitness = another fitness 
			and: [ parents = another parents 
				and: [ ni = another ni and: [ idPopulation = another idPopulation  ] ] ] ] ]
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
	copy := self class with: typeInfo copy.
	copy addTargetClassNames: targetClassesNames.
	statements do: [ :stm | copy addStatement: stm copy ].
	copy updateNextId.
	^ copy
]

{ #category : #copying }
SSTestCase >> deepCopy [
  | copy |
  copy := self copy.
  copy setFitness: self fitness.
  copy setFitnessByClass: self fitnessByClass.
  copy ni: self ni.
  copy summaryExecutionMethods: self summaryExecutionMethods.
  ^ copy
]

{ #category : #comparing }
SSTestCase >> hash [
  ^ super hash bitXor: "(self number hash bitXor:" self statements hash")"
]

{ #category : #accessing }
SSTestCase >> idPopulation [
	^ idPopulation
]

{ #category : #accessing }
SSTestCase >> idPopulation: anObject [
	idPopulation := anObject
]

{ #category : #initialization }
SSTestCase >> initialize [
  super initialize.
  ni := 1.
  idPopulation := 1.
]

{ #category : #accessing }
SSTestCase >> ni [
	^ ni
]

{ #category : #accessing }
SSTestCase >> ni: anObject [
	ni := anObject
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
	previousOpenWindows := SystemWindow allInstances.
]

{ #category : #accessing }
SSTestCase >> summaryExecutionMethods [
	^ summaryExecutionMethods
]

{ #category : #accessing }
SSTestCase >> summaryExecutionMethods: summaryExecutionMethod [ 
	summaryExecutionMethods := summaryExecutionMethod 
]

{ #category : #actions }
SSTestCase >> tearDown [ 
	|windowsToDelete|
	windowsToDelete := SystemWindow allInstances asOrderedCollection removeAll: previousOpenWindows.
	windowsToDelete do:[:w| w close].
]
