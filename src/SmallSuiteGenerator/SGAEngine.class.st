Class {
	#name : #SGAEngine,
	#superclass : #SGAObject,
	#instVars : [
		'populationSize',
		'mutationOperator',
		'crossoverOperator',
		'numberOfStatements',
		'population',
		'logs',
		'typeInfo',
		'fitness',
		'numberOfIterations',
		'selectionStrategy',
		'targetClassName'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #testing }
SGAEngine >> checkFitness [
	self
		assert: [ fitness notNil ]
		description: 'Need to set a fitnessBlock'
]

{ #category : #testing }
SGAEngine >> checkIfReadyToRun [
	self checkTypeInfo.
	self checkFitness.
	self checkLogs
]

{ #category : #testing }
SGAEngine >> checkLogs [
	self assert: [ logs isEmpty ] description: 'Already been run'
]

{ #category : #testing }
SGAEngine >> checkTypeInfo [
	self
		assert: [ typeInfo notNil ]
		description: 'Set a typeInfo'
]

{ #category : #accessing }
SGAEngine >> clean [
	fitness ifNotNil: [ fitness tearDown ]
]

{ #category : #actions }
SGAEngine >> computeFitness [
	fitness compute: population.
]

{ #category : #actions }
SGAEngine >> createNewPopulation [
	| newPopulation TB |
	TB := self pickBestTest.
	newPopulation := OrderedCollection new.
	selectionStrategy load: population copy.
	selectionStrategy fitness: fitness.
	[ newPopulation size < self populationSize ]
		whileTrue: [ | P1 P2 O1 O2 fp fo lp lo child parents |
			P1 := selectionStrategy pickOne.
			P2 := selectionStrategy pickOne.
			self shouldCrossOver
				ifTrue: [ 
					
					child := crossoverOperator crossover: P1 with: P2.
					Transcript show:'corows';cr.
					O1 := child first.
					O2 := child second ]
				ifFalse: [ O1 := P1.
					O2 := P2 ].
			mutationOperator mutate: O1.
			mutationOperator mutate: O2.
			fitness compute:{O1.O2}.
			fp := (self fitnessFor: P1) min: (self fitnessFor: P2).
			fo := (self fitnessFor: O1) min: (self fitnessFor: O2).
			lp := P1 length + P2 length.
			lo := O1 length + O2 length.
			(fo < fp or: [ fo = fp and: [ lo <= lp ] ])
				ifTrue: [ 
					parents := {P1. P2} shuffle asSortedCollection: [:a :b| a length < b length].
					{O1. O2} do: [ :o | 
							o length <= (2 *TB length)
								ifTrue: [ newPopulation add: o ]
								ifFalse: [ newPopulation add: parents removeFirst	"it is p1 o p2" ] ] ]
				ifFalse: [ newPopulation
						addAll: {P1.P2} ] ].
	population := newPopulation
]

{ #category : #actions }
SGAEngine >> createRandomPopulation [
	^ (1 to: 30)
		collect: [ :val | 
			| value test |
			value := SharedRandom globalGenerator next * 30 + 1.
			test := SSTestCase with: typeInfo.
			test addFactoryMessage: self targetClassName.
			test generateStatements: value.
			test ]
]

{ #category : #accessing }
SGAEngine >> crossoverOperator: aCrossoverOperator [
	crossoverOperator := aCrossoverOperator.
	crossoverOperator random: random
]

{ #category : #accessing }
SGAEngine >> fitness [
	^ fitness
]

{ #category : #accessing }
SGAEngine >> fitness: aFitness [
	fitness := aFitness
]

{ #category : #actions }
SGAEngine >> fitnessFor: aTestCase [
	^ aTestCase fitness at: fitness funtionName.
]

{ #category : #initialization }
SGAEngine >> initialize [
	super initialize.
	self initializeMutationOperator.
	self initializeCrossoverOperator.
	logs := OrderedCollection new.
	random := Random new.
	populationSize := 100.
	numberOfIterations := 100.
	selectionStrategy := SGATournamentSelection new.
	self initializeMutationOperator.
	self initializeCrossoverOperator.

]

{ #category : #initialization }
SGAEngine >> initializeCrossoverOperator [
	crossoverOperator := SGACrossoverOperation new.
	crossoverOperator random: random.
]

{ #category : #initialization }
SGAEngine >> initializeMutationOperator [
	mutationOperator := SGAMutationOperation new.
	mutationOperator mutationRate: (1 / 3) asFloat.
	mutationOperator random: random.
]

{ #category : #accessing }
SGAEngine >> logs [
	^ logs copy
]

{ #category : #accessing }
SGAEngine >> logs1 [
	^ logs
]

{ #category : #actions }
SGAEngine >> mutate: testCase [
	^ mutationOperator mutate: testCase
]

{ #category : #accessing }
SGAEngine >> mutationRate: aFloat [
	mutationOperator mutationRate: aFloat
]

{ #category : #accessing }
SGAEngine >> numberOfIterations: anObject [
	numberOfIterations := anObject
]

{ #category : #accessing }
SGAEngine >> numberOfStatements [
	^ numberOfStatements
]

{ #category : #accessing }
SGAEngine >> numberOfStatements: aInt [
	numberOfStatements := aInt
]

{ #category : #actions }
SGAEngine >> pickBestTest [
	|best|
	best := population first.
	population do:[:test|
		|valA valB|
		valA := self fitnessFor: best.
		valB := self fitnessFor: test.
		(valB > valA) ifTrue:[ best := test.].
		].
	^ best.
]

{ #category : #accessing }
SGAEngine >> population [
	^ population
]

{ #category : #accessing }
SGAEngine >> populationSize [ 	
	^ populationSize 
]

{ #category : #accessing }
SGAEngine >> populationSize: aInteger [
	populationSize := aInteger
]

{ #category : #actions }
SGAEngine >> run [
	population := self createRandomPopulation.
	self computeFitness.
	(1 to: numberOfIterations) do:[:iteration|
		logs add: (SGALog new 
						generationNumber: iteration; 
						fittestTestCase: self pickBestTest; 
						timeToProduceGeneration: Time now asSeconds; 
						yourself).
		self createNewPopulation.
		] displayingProgress:[:iteration| iteration asString].
]

{ #category : #actions }
SGAEngine >> shouldCrossOver [
	^ SharedRandom globalGenerator next < (3/4).
]

{ #category : #accessing }
SGAEngine >> targetClassName [
	^ targetClassName
]

{ #category : #accessing }
SGAEngine >> targetClassName: anObject [
	targetClassName := anObject
]

{ #category : #accessing }
SGAEngine >> typeInfo [
	^ typeInfo
]

{ #category : #accessing }
SGAEngine >> typeInfo: aTypeInfo [
	typeInfo := aTypeInfo
]
