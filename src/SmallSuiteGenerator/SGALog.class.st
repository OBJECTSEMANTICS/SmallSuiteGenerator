"
SGALog saves some important data about genetic algorithm evolution like: genetic algotithm's generation number, testCase with the highest fitness and time in which is produced the generation.

In each iteration of the genetic algorithm a new instance of the class is created.

Instance Variables

	fittestTestCase:				<STestCase>
	generationNumber:				<Smallnteger>
	timeToProduceGeneration:		<SmallInteger>
"
Class {
	#name : #SGALog,
	#superclass : #SGAAbstractLog,
	#instVars : [
		'mutationResult',
		'averageFit',
		'population',
		'summaryTargetClass',
		'typeInfoGeneration'
	],
	#category : #'SmallSuiteGenerator-Strategies'
}

{ #category : #actions }
SGALog class >> collectFitnessByNameOf: population [
  | dictFit |
  dictFit := Dictionary new.
  (self fitnessAndAssociationsOf: population) do: [:assoc |  | aValue |
	aValue := dictFit at: assoc key ifAbsentPut: [ OrderedCollection new ].
	aValue add: assoc value ].
  ^ dictFit
]

{ #category : #actions }
SGALog class >> fitnessAndAssociationsOf: population [
  ^(population collect: #fitness) flatCollect: #associations
]

{ #category : #log }
SGALog class >> logOf: aSGAEngine inGeneration: anInteger inTime: t [
	| log dictFitness |
	log := self new 
		generationNumber: anInteger;
		fittestTestCase: aSGAEngine population first;
		timeToProduceGeneration: Time new asSeconds - t;
		population: aSGAEngine population.
	dictFitness := self collectFitnessByNameOf: aSGAEngine population.
	log lowestFit: aSGAEngine population last fitness;
	averageFit: (self pickAverageFitTest: dictFitness). 
	log summaryTargetClass: (aSGAEngine fitness runPopulation: aSGAEngine population).
	log typeInfoGeneration: (aSGAEngine typeInfo classAt: aSGAEngine targetClassName) deepCopy.
	^ log
]

{ #category : #actions }
SGALog class >> pickAverageFitTest: aDictionary [
	^ (aDictionary keys collect: [ :key | 
		   key -> (aDictionary at: key) average ]) asDictionary
]

{ #category : #summaries }
SGALog class >> summaryExecutionMethodsOf: aTestCase with: aProfiler [
	aTestCase summaryExecutionMethods: aProfiler summaryExecutionMethods.
]

{ #category : #accessing }
SGALog >> averageFit [
	^ averageFit 
]

{ #category : #accessing }
SGALog >> averageFit: aNumber [
	averageFit := aNumber
]

{ #category : #accessing }
SGALog >> averageTestSize [
	^ (self population collect: [ :x |  x statements size ]) average asFloat
]

{ #category : #initialization }
SGALog >> exportDataCSV: neoCSVWriter withFilter: aSymbol [
	(self filteredMethodsBy: aSymbol) doWithIndex: [ :each :i |
		each writeDataCSV: neoCSVWriter withIndex: i ]  
]

{ #category : #initialization }
SGALog >> filteredMethodsBy: aSymbol [
	^ ((self selectorsFilter includes: aSymbol)
		ifTrue: [ self summaryTargetClass select: aSymbol ]
		ifFalse: [ self summaryTargetClass ]) select: #isNotNil
]

{ #category : #accessing }
SGALog >> fitness [ 	
	^ fittestTestCase fitness
	
]

{ #category : #initialization }
SGALog >> initialize [ 	
	mutationResult := Dictionary new
]

{ #category : #accessing }
SGALog >> mutationResult: mutationTestingResult [
	self
		assert: mutationResult isEmpty
		description: 'The analysis of mutants has already been calculated'.
	[ mutationResult
		at: 'noEvaluatedMutants'
			put: mutationTestingResult numberOfEvaluatedMutants;
		at: 'noKilledOrTerminatedMutants'
			put: mutationTestingResult numberOfKilledOrTerminatedMutants;
		at: 'noAliveMutants'
			put: mutationTestingResult numberOfAliveMutants;
		at: 'mutationScore' put: mutationTestingResult mutationScore ]
		on: Exception
		do: [ nil ]
]

{ #category : #accessing }
SGALog >> percentageOftestCasesWithErrors [
	^((population select: [ :e | e hasErrors ]) size / population size) asFloat
]

{ #category : #accessing }
SGALog >> population [
	^ population
]

{ #category : #accessing }
SGALog >> population: anObject [
	population := anObject
]

{ #category : #printing }
SGALog >> printOn: str [
	super printOn: str.
	str
		nextPut: $<;
		nextPutAll: fittestTestCase statements printString;
		nextPut: $>
]

{ #category : #initialization }
SGALog >> selectorsFilter [
	^ #( #executed #unexecuted #notAllBlocksExecuted #allBlocksExecuted)
]

{ #category : #accessing }
SGALog >> summaryTargetClass [
	^ summaryTargetClass
]

{ #category : #accessing }
SGALog >> summaryTargetClass: anObject [
	summaryTargetClass := anObject
]

{ #category : #accessing }
SGALog >> typeInfoGeneration [
	^ typeInfoGeneration
]

{ #category : #accessing }
SGALog >> typeInfoGeneration: anObject [
	typeInfoGeneration := anObject
]
