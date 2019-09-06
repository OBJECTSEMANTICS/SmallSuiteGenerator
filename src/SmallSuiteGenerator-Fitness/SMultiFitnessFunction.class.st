Class {
	#name : #SMultiFitnessFunction,
	#superclass : #SFitnessFunction,
	#instVars : [
		'functions',
		'selectorMethod'
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
SMultiFitnessFunction class >> allFitnessFunction [
	self validateInstance.
	^ multiFitnessFunction allFitnessFunction
]

{ #category : #accessing }
SMultiFitnessFunction class >> clear [
	multiFitnessFunction ifNotNil: [ 
		multiFitnessFunction allFitnessFunction do: #clear. 
		multiFitnessFunction := nil
	].
]

{ #category : #'as yet unclassified' }
SMultiFitnessFunction class >> computeFitness: aTestCase [
	self validateInstance.
	^ multiFitnessFunction computeFitness: aTestCase
]

{ #category : #testing }
SMultiFitnessFunction class >> is: aTestCase1 betterThan: aTestCase2 [
	self validateInstance.
	^ multiFitnessFunction is: aTestCase1 betterThan: aTestCase2
]

{ #category : #'as yet unclassified' }
SMultiFitnessFunction class >> linearSum: aFitness [
	"realiza una suma ponderada de los objetivos: res = sum(w* f(x))."
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
SMultiFitnessFunction class >> selectorMethod: aSelectorMethod [
	self validateInstance.
	^ multiFitnessFunction selectorMethod: aSelectorMethod 
]

{ #category : #'as yet unclassified' }
SMultiFitnessFunction class >> validateInstance [
	self
		assert: (multiFitnessFunction isNotNil
		and: [ multiFitnessFunction allFitnessFunction isNotEmpty ])
		description: 'Set a multiFitnessFunction with its respectives fitness functions'
]

{ #category : #adding }
SMultiFitnessFunction class >> with: aFitnessFunction [
	self addFitnessFunction: aFitnessFunction
]

{ #category : #adding }
SMultiFitnessFunction >> addFitnessFunction: aFitnessFunction [
	functions add: aFitnessFunction 
	
]

{ #category : #accessing }
SMultiFitnessFunction >> allFitnessFunction [
	^ functions
]

{ #category : #'as yet unclassified' }
SMultiFitnessFunction >> computeFitness: aTestCase [
	|dict|
	dict := Dictionary new.
	functions collect: [ :f | f computeFitness: aTestCase] thenDo: [:assoc | dict add: assoc].
	^ dict
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

{ #category : #initialization }
SMultiFitnessFunction >> initializeDefaultSelectorMethod [
	selectorMethod := SGreaterThanMethod functions: self allFitnessFunction
]

{ #category : #testing }
SMultiFitnessFunction >> is: aTestCase1 betterThan: aTestCase2 [
	selectorMethod ifNil: [ self initializeDefaultSelectorMethod ].
	^ selectorMethod is: aTestCase1 betterThan: aTestCase2
]

{ #category : #'as yet unclassified' }
SMultiFitnessFunction >> numFunctions [
	^ functions size
]

{ #category : #accessing }
SMultiFitnessFunction >> selectorMethod [
	^ selectorMethod
]

{ #category : #accessing }
SMultiFitnessFunction >> selectorMethod: anObject [
	selectorMethod := anObject
]
