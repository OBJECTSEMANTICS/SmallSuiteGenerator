"
SGAEngine is responsible for executing the genetic algorithm, it means that it follows the phases to get a testCase population with the highest fitness score.

The phases followed are:
	1. Create an initial population 
	2. Use the fitness function established to calculate the fitness score of each testCase in the population
	3. Determine the selection strategy to select the fittest testCases and let them pass their statements to the next generation
	4. Apply the crossover operation to get offsprings (new testCases) by exchanging the statements of parents (testCases). 
	5. Apply mutation operation with a low random probability to modify some statements.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	crossoverOperator:		<SGACrossoverOperator>
	fitness:		<SFitnessFunction>
	logs:		<OrderedCollection>
	mutationOperator:		<SGAMutationOperator>
	numberOfIterations:		<SmallInteger>
	numberOfStatements:		<SmallInteger>
	population:		<OrderedCollection>
	populationSize:		<SmallInteger>
	selectionStrategy:		<SGATournamentSelection>
	targetClassName:		<ByteString>
	typeInfo:		<STypeInfo>
"
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
	[ newPopulation size < self populationSize
		and: [ selectionStrategy population size >= 2 ] ]
		whileTrue: [ | P1 P2 O1 O2 fp fo lp lo child options |
			P1 := selectionStrategy pickOne.
			P2 := selectionStrategy pickOne.
			self shouldCrossOver
				ifTrue: [ child := crossoverOperator crossover: P1 with: P2.
					O1 := child first.
					O2 := child second ]
				ifFalse: [ O1 := P1.
					O2 := P2 ].
			mutationOperator mutate: O1.
			mutationOperator mutate: O2.
			fitness compute: (Array with: O1 with: O2).
			options := (Array
				with: O1
				with: O2
				with: P1
				with: P2)
				asSortedCollection: [ :a :b | 
					(self fitnessFor: a) = (self fitnessFor: b)
						ifTrue: [ a length < b length ]
						ifFalse: [ (self fitnessFor: a) > (self fitnessFor: b) ] ].
			newPopulation addAll: (options first: 2) ].
	population := newPopulation
]

{ #category : #actions }
SGAEngine >> createRandomPopulation [
	^ (1 to: 30)
		collect: [ :val | 
			| value test |
			value := SConfiguration randomGenerator next * 30 + 1.
			test := SSTestCase with: typeInfo.
			test
				addTargetClassName: self targetClassName;
				addFactoryMessage: self targetClassName;
				generateStatements: value.
			test ]
]

{ #category : #accessing }
SGAEngine >> crossoverOperator: aCrossoverOperator [
	crossoverOperator := aCrossoverOperator.
	crossoverOperator randomGenerator: randomGenerator 
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
	^ aTestCase fitness at: fitness functionName.
]

{ #category : #initialization }
SGAEngine >> initialize [
	super initialize.
	self initializeMutationOperator.
	self initializeCrossoverOperator.
	logs := OrderedCollection new.
	randomGenerator := SConfiguration newRandomGenerator.
	populationSize := 100.
	numberOfIterations := 100.
	selectionStrategy := SGATournamentSelection new.
	self initializeMutationOperator.
	self initializeCrossoverOperator
]

{ #category : #initialization }
SGAEngine >> initializeCrossoverOperator [
	crossoverOperator := SGACrossoverOperation new.
	crossoverOperator randomGenerator: randomGenerator
]

{ #category : #initialization }
SGAEngine >> initializeMutationOperator [
	mutationOperator := SGAMutationOperation new.
	mutationOperator mutationRate: (1 / 3) asFloat.
	mutationOperator randomGenerator: randomGenerator
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
	(1 to: numberOfIterations)
		do: [ :iteration | 
			logs
				add:
					(SGALog new
						generationNumber: iteration;
						fittestTestCase: self pickBestTest;
						timeToProduceGeneration: Time now asSeconds;
						yourself).
			self createNewPopulation ]
		displayingProgress: [ :iteration | 'Evolving - Iteration' , iteration printString ]
]

{ #category : #actions }
SGAEngine >> shouldCrossOver [
	^ SConfiguration randomGenerator next < (3 / 4)
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
