Class {
	#name : #SMultiFitnessFunction,
	#superclass : #SFitnessFunction,
	#instVars : [
		'functions'
	],
	#classInstVars : [
		'multiFitnessFunction'
	],
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #adding }
SMultiFitnessFunction class >> addFitnessFunction: aFitnessFunction [
	multiFitnessFunction ifNil: [ 
		multiFitnessFunction := self  new ].
	multiFitnessFunction addFitnessFunction: aFitnessFunction 
]

{ #category : #accessing }
SMultiFitnessFunction class >> clear [ 
	multiFitnessFunction := nil
]

{ #category : #'as yet unclassified' }
SMultiFitnessFunction class >> computeFitness: aTestCase [
	self validateInstance.
	^ multiFitnessFunction computeFitness: aTestCase
]

{ #category : #accessing }
SMultiFitnessFunction class >> functions [
	self validateInstance.
	^ multiFitnessFunction functions
]

{ #category : #testing }
SMultiFitnessFunction class >> is: aTestCase1 betterThan: aTestCase2 [
	self validateInstance.
	^ multiFitnessFunction is: aTestCase1 betterThan: aTestCase2
]

{ #category : #accessing }
SMultiFitnessFunction class >> multiFitnessFunction [
	^ multiFitnessFunction
]

{ #category : #accessing }
SMultiFitnessFunction class >> multiFitnessFunction: anObject [
	multiFitnessFunction := anObject
]

{ #category : #'as yet unclassified' }
SMultiFitnessFunction class >> numFunctions [
	self validateInstance.
	^ multiFitnessFunction numFunctions
]

{ #category : #'as yet unclassified' }
SMultiFitnessFunction class >> validateInstance [
	self
		assert: (multiFitnessFunction isNotNil
		and: [ multiFitnessFunction functions isNotEmpty ])
		description: 'Set a multiFitnessFunction with its respectives fitness functions'
]

{ #category : #adding }
SMultiFitnessFunction >> addFitnessFunction: aFitnessFunction [
	functions add: aFitnessFunction 
	
]

{ #category : #'as yet unclassified' }
SMultiFitnessFunction >> computeFitness: aTestCase [
	^ functions collect: [ :f | f computeFitness: aTestCase ]
]

{ #category : #accessing }
SMultiFitnessFunction >> functions [
	^ functions
]

{ #category : #accessing }
SMultiFitnessFunction >> functions: anObject [
	functions := anObject
]

{ #category : #initialization }
SMultiFitnessFunction >> initialize [ 
	super initialize.
	functions := OrderedCollection new
]

{ #category : #testing }
SMultiFitnessFunction >> is: aTestCase1 betterThan: aTestCase2 [
	|isBetter|
	isBetter := false.
	functions doWithIndex: [ :f :index | 
		isBetter := (aTestCase1 fitness at: index) perform: f comparisonOperator with: (aTestCase2 fitness at: index).
		isBetter ifFalse: [ (aTestCase1 fitness at: index) = (aTestCase2 fitness at: index) ifFalse: [ ^ false ] ]
		].
	^ isBetter
]

{ #category : #'as yet unclassified' }
SMultiFitnessFunction >> numFunctions [
	^ functions size
]
