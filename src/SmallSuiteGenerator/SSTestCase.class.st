"
SSTestCase is a subclass that defines or initializes some instance variables which are util in the genetic algorithm evolution
"
Class {
	#name : #SSTestCase,
	#superclass : #SSTestShifter,
	#instVars : [
		'idPopulation',
		'summaryExecutionMethods',
		'generationNumber',
		'hasErrors'
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
				and: [ generationNumber = another generationNumber and: [ idPopulation = another idPopulation  ] ] ] ] ]
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
  copy generationNumber: self generationNumber.
  copy summaryExecutionMethods: self summaryExecutionMethods.
  copy hasErrors: self hasErrors.
  ^ copy
]

{ #category : #actions }
SSTestCase >> fitnessFor: functionName [ 
	^ self fitness at: functionName
]

{ #category : #accessing }
SSTestCase >> generationNumber [
	^ generationNumber
]

{ #category : #accessing }
SSTestCase >> generationNumber: anObject [
	generationNumber := anObject
]

{ #category : #actions }
SSTestCase >> hasErrors [
	^ hasErrors
]

{ #category : #actions }
SSTestCase >> hasErrors: aBoolean [
	hasErrors := aBoolean 
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
   generationNumber := 1.
   idPopulation := 1.
   summaryExecutionMethods := OrderedCollection new.
	hasErrors := false
]

{ #category : #accessing }
SSTestCase >> isBetterThan: testCase2 using: fitnessStrategy [
    |fitness1 fitness2|
    fitness1 := self fitness at: fitnessStrategy.
    fitness2 := testCase2 fitness at: fitnessStrategy.
    (fitness1 > fitness2) ifTrue:[ ^ true ].
	 (self hasErrors and: [ testCase2 hasErrors not and: [ self next < 0.5 ]]) ifTrue: [^ false].
    ((fitness1 = fitness2) and:
        [self length < testCase2 length]) 
                ifTrue:[^ true]. 
    (fitness1 = fitness2 and:
        [self length = testCase2 length and:[ self idPopulation > testCase2 idPopulation]])
                ifTrue:[^ true]. 
    ^ false
]

{ #category : #printing }
SSTestCase >> printOn: aStream [
	self statements do: [ :stm | 
			stm printOn: aStream.
			aStream nextPut: Character cr ]
]

{ #category : #initialization }
SSTestCase >> setFitness: aDictionary [ 
	fitness := aDictionary copy
]

{ #category : #initialization }
SSTestCase >> setFitnessByClass: aDictionary [ 
	fitnessByClass := aDictionary copy
]

{ #category : #accessing }
SSTestCase >> summaryExecutionMethods [
	^ summaryExecutionMethods
]

{ #category : #accessing }
SSTestCase >> summaryExecutionMethods: summaryExecutionMethod [ 
	summaryExecutionMethods := summaryExecutionMethod 
]

{ #category : #repairing }
SSTestCase >> updateWith: anotherTestCase [
	self generationNumber: anotherTestCase generationNumber.
	self idPopulation: anotherTestCase idPopulation.
	anotherTestCase parents do: [ :parent | 
		parent removeChild: anotherTestCase.
		self addParent:  parent ]
]
