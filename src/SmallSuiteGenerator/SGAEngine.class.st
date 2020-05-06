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

	crossoverOperator:			<SGACrossoverOperator>
	fitness:						<SFitnessFunction>
	logs:							<OrderedCollection>
	mutationOperator:			<SGAMutationOperator>
	numberOfIterations:		<SmallInteger>
	numberOfStatements:		<SmallInteger>
	population:					<OrderedCollection>
	populationSize:				<SmallInteger>
	selectionStrategy:			<SGATournamentSelection>
	targetClassName:			<ByteString>
	typeInfo:						<STypeInfo>
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
		'selectionStrategy',
		'targetClassName',
		'numberOfGenerations',
		'lastMessage',
		'profiler',
		'packageRegex',
		'initialPopulation',
		'typeInfoProfiler',
		'targetPackageRegex',
		'elitismRate',
		'crossoverRate',
		'stopIterations',
		'totalExecutionGA'
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

{ #category : #'groups collecting' }
SGAEngine >> collectFitnessByName [
	| dictFit |
	dictFit := Dictionary new.
	((population collect: #fitness) flatCollect: #associations) do: [ 
		:assoc | 
		| aValue |
		aValue := dictFit at: assoc key ifAbsentPut: [ OrderedCollection new].
		aValue add: assoc value].
	^ dictFit
]

{ #category : #updating }
SGAEngine >> completeTypeInfo [
	typeInfo types keysDo: [:aClass | |classInfo realClassInfo|
	classInfo := SmallTypeCollector new collectTypeFrom: aClass asClass.
	realClassInfo := typeInfo types at: aClass.
	classInfo methodTypes keysAndValuesDo: [ :key :value | 
		(key isUnary not and: [ value argTypes allSatisfy: [ :arg | arg types notEmpty ] ]) ifTrue:[
		realClassInfo methodTypes at: key
		ifPresent: [  ]
		ifAbsentPut: [ 
			self updateArgsOf: value.
			value returnType types ifEmpty: [value returnType type: #SUndefinedObject].
			value receiver type: aClass.
			value hasProfiler: false.
			value executions: 0.5 ] ] ] ]
]

{ #category : #actions }
SGAEngine >> computeFitness [
	fitness compute: population.
]

{ #category : #creating }
SGAEngine >> createNewPopulation [
	| newPopulation currentPopulationSize newNumber lastLowestFitness |
	lastLowestFitness := logs last lowestFit at: fitness functionName.
	currentPopulationSize := initialPopulation size.
   newPopulation := self eliteOfCurrentPopulation.
  	[ newPopulation size < currentPopulationSize ] whileTrue: [ | selectedList P1copy P2copy P1 P2 O1 O2 OM1 OM2 selectedOptions children |
		  selectedList := selectionStrategy selectOf: initialPopulation.
        P1 := selectedList first.
        P2 := selectedList second.
		  P1copy := (self similarChild: P1) idPopulation: 1.
		  P2copy := (self similarChild: P2) idPopulation: 2.
        self shouldCrossOver 
				ifTrue: [ children := self crossoverOperator crossover: P1 with: P2.
              O1 := children first.
              O2 := children second] 
				ifFalse: [ 
					O1 := (P1copy deepCopy) addParent: P1.
              	O2 := (P2copy deepCopy) addParent: P2 ].
        OM1 := (self mutateAndUpdate: O1) idPopulation: 3.
        OM2 := (self mutateAndUpdate: O2) idPopulation: 4.
        fitness compute: (Array with: OM1 with: OM2).
        selectedOptions := self selectTwoBestOf: (Array with: OM1 with: OM2 with: P1copy with: P2copy) excludingAll: newPopulation.
		  newNumber := newPopulation size.
		  selectedOptions 
		  	   select: [ :option | (option fitness at: fitness functionName) >= lastLowestFitness ]       
				thenDo: [ :option | 
					newNumber:= newNumber + 1.
					option idPopulation: newNumber.
					newPopulation size < currentPopulationSize ifTrue: [ newPopulation add: option ] ]].
   self updateTypeInfoWith: newPopulation.
   self fixPopulation: newPopulation.
   population := newPopulation.
   self order: population
]

{ #category : #creating }
SGAEngine >> createRandomPopulation [
  ^ (1 to: populationSize) collect: [:val |  | value test |
        value := self next * numberOfStatements + 1.
        test := SSTestCase with: typeInfo.
        test
           addTargetClassName: self targetClassName;
           addFactoryMessage: self targetClassName;
           generateStatements: value;
           lastMessage: lastMessage;
           idPopulation: val;
			  clean.
        test ]
]

{ #category : #accessing }
SGAEngine >> crossoverOperator [
	^ crossoverOperator
]

{ #category : #accessing }
SGAEngine >> crossoverOperator: aCrossoverOperator [
	crossoverOperator := aCrossoverOperator
]

{ #category : #rating }
SGAEngine >> crossoverRate [
	^ crossoverRate
]

{ #category : #rating }
SGAEngine >> crossoverRate: aNumber [
	selectionStrategy crossoverRate: aNumber
]

{ #category : #testing }
SGAEngine >> differencesBtw: summary1 and: summary2 [
	| result |
   result := OrderedCollection new.
   summary1 with: summary2 do: [:x :y |  x = y 
		ifFalse: [ | aux |
			aux := OrderedCollection new.
         x keysAndValuesDo: [:key :value |  (x at: key) = (y at: key) 
				ifFalse: [ aux add: key -> (Array with: value with: (y at: key)) ] ]. 
		aux ifNotEmpty: [ aux addFirst: (x at: 'MethodName').
	result add: aux] ] ].
 	^ result
]

{ #category : #actions }
SGAEngine >> doSelection [
	self createNewPopulation.
	initialPopulation := population.
]

{ #category : #'groups collecting' }
SGAEngine >> eliteOfCurrentPopulation [
	| endIndex index |
	endIndex := (population size * elitismRate * 0.01) asInteger.
	index := 0.
	endIndex >= 1 ifTrue: [ ^ (((population copyFrom: 1 to: endIndex) collect: [:testCase |
			index := index + 1.
			(self similarChild: testCase) idPopulation: index; yourself.
			])) asOrderedCollection ].
	^ OrderedCollection new
]

{ #category : #rating }
SGAEngine >> elitismRate [
	^ elitismRate
]

{ #category : #rating }
SGAEngine >> elitismRate: aNumber [
	selectionStrategy elitismRate: aNumber.
]

{ #category : #accessing }
SGAEngine >> fitness [
	^ fitness
]

{ #category : #accessing }
SGAEngine >> fitness: aFitness [
	fitness := aFitness.
	selectionStrategy fitness: aFitness
]

{ #category : #actions }
SGAEngine >> fitnessFor: aTestCase [
	^ aTestCase fitness at: fitness functionName.
]

{ #category : #actions }
SGAEngine >> fixPopulation: aCollection [ 
	| targetClassMessages |
	targetClassMessages := (typeInfo types at: self targetClassName)methodTypes values asOrderedCollection 
		removeAllSuchThat: [:method | method returnType mustBeFixed not ].
	 
	aCollection do: [ :testCase | 
		testCase statements select: [ :stm | [(targetClassMessages collect: #selector) includes: stm value selector]
			on: Error do: [ false ] ] thenDo: [ :stm | testCase fixTypeReturnOf: (stm needsBeFixed: true) ] ]
]

{ #category : #reporting }
SGAEngine >> generateReportOfDifferencesBtwGenerations [
	| generations result |
	generations := self summaryGenerations.
	result := OrderedCollection new.
	2 to: generations size do: [ :index | |diff|
		diff := self differencesBtw: (generations at: index-1) and: (generations at: index).
		diff ifNotEmpty: [ result add: (index -> diff)] ].
	^ result
]

{ #category : #initialization }
SGAEngine >> initialize [
  super initialize.
  logs := OrderedCollection new.
  populationSize := 30.
  numberOfGenerations := 100.
  selectionStrategy := SGARankSelection new.
  crossoverRate := 0.8.
  elitismRate := 10.
  numberOfStatements := 10.
  stopIterations := 30.
	totalExecutionGA := 0.
  self initializeMutationOperator.
  self initializeCrossoverOperator
]

{ #category : #initialization }
SGAEngine >> initializeCrossoverOperator [
	crossoverOperator := SGACrossoverOperation new.
]

{ #category : #initialization }
SGAEngine >> initializeMutationOperator [
	mutationOperator := SGAMutationOperation new.
	mutationOperator mutationRate: (1 / 3) asFloat.
]

{ #category : #initialization }
SGAEngine >> initializePopulation [
	| t |
	t := Time now asSeconds.
   population := self createRandomPopulation.
   SExpression resetId.
	self updateTypeInfoWith: population.
   self computeFitness.
   self order: population.
   initialPopulation := population.
   logs add: (self logOfGeneration: 0 inTime: t).
]

{ #category : #initialization }
SGAEngine >> initializeProfiler [
	| aProfiler |
	aProfiler := SLProfilerCoverage profilerForClass: targetClassName.
	(aProfiler allMethods select: #isNotMethodExtension)
		do: #installGhosts
		displayingProgress: 'Instrumenting ' , targetClassName.
	^ aProfiler
]

{ #category : #testing }
SGAEngine >> is: testCase1 betterThan: testCase2 [
    |fitness1 fitness2|
    fitness1 := self fitnessFor: testCase1.
    fitness2 := self fitnessFor: testCase2.
    (fitness1 > fitness2) ifTrue:[ ^ true ].
	 (testCase1 hasErrors and: [ testCase2 hasErrors not and: [ self next < 0.5 ]]) ifTrue: [^ false].
    ((fitness1 = fitness2) and:
        [testCase1 length < testCase2 length]) 
                ifTrue:[^ true]. 
    (fitness1 = fitness2 and:
        [testCase1 length = testCase2 length and:[ testCase1 idPopulation > testCase2 idPopulation]])
                ifTrue:[^ true]. 
    ^ false.
]

{ #category : #accessing }
SGAEngine >> lastMessage: anObject [
	lastMessage := anObject 
	
]

{ #category : #log }
SGAEngine >> logOfGeneration: anInteger inTime: t [
	| log dictFitness |
	log := SGALog new 
		generationNumber: anInteger;
		fittestTestCase: population first;
		timeToProduceGeneration: Time new asSeconds - t;
		population: population.
	dictFitness := self collectFitnessByName.
	log lowestFit: population last fitness;
	averageFit: (self pickAverageFitTest: dictFitness). 
	log summaryTargetClass: (fitness runPopulation: population).
	log typeInfoGeneration: (typeInfo classAt: targetClassName) deepCopy.
	^ log
]

{ #category : #accessing }
SGAEngine >> logs [
	^ logs
]

{ #category : #updating }
SGAEngine >> mergeTypeInfo: otherTypeInfo [
	typeInfo joinWith: otherTypeInfo.
]

{ #category : #actions }
SGAEngine >> mutateAndUpdate: aTestCase [
	| newStm |
	newStm := mutationOperator mutate: aTestCase.
   newStm updateWith: aTestCase.
	^ newStm 
]

{ #category : #actions }
SGAEngine >> mutationRate: aFloat [
	mutationOperator mutationRate: aFloat
]

{ #category : #accessing }
SGAEngine >> numberOfGenerations: anInteger [
	"Set the number of generation the genetic algorithm has to run"
	numberOfGenerations := anInteger
]

{ #category : #accessing }
SGAEngine >> numberOfStatements [
	^ numberOfStatements
]

{ #category : #accessing }
SGAEngine >> numberOfStatements: anInteger [
	"Set the number of statements the initial population should have.
	Ideally, a small number, such as 3, is convenient. The evolution makes the individuals grow over time"
	numberOfStatements := anInteger
]

{ #category : #actions }
SGAEngine >> order: aCollection [
	aCollection sort: [ :stm1 :stm2 | self is: stm1 betterThan: stm2 ].
	^ aCollection
]

{ #category : #accessing }
SGAEngine >> packageRegex: aString [
	packageRegex := aString
]

{ #category : #actions }
SGAEngine >> pickAverageFitTest: aDictionary [
	^ (aDictionary keys collect: [ :key | 
		   key -> (aDictionary at: key) average ]) asDictionary
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

{ #category : #updating }
SGAEngine >> profilerForPackagesMatching [
	Transcript show: 'profiling...'; cr.
	typeInfoProfiler := SSTypeCollector 
		profilerForPackagesMatching: targetPackageRegex.
	typeInfoProfiler beforeProfiling.
]

{ #category : #updating }
SGAEngine >> profilerForTargetClass [
	| packageSpy cls classSpy |
	cls := Smalltalk at: targetClassName .
	Transcript show: 'profiling...'; cr.
	typeInfoProfiler := SSTypeCollector new.
	SSTypeCollector installOnClass: cls.
	typeInfoProfiler beforeProfiling .
	classSpy := typeInfoProfiler spyForClass: cls.
	packageSpy := typeInfoProfiler class spyClassForPackage new.
	packageSpy classAt: targetClassName put: classSpy.
	typeInfoProfiler addPackage: packageSpy.
	classSpy packageSpy: packageSpy.
]

{ #category : #actions }
SGAEngine >> run [
  | counter bestFitness stopFlag |
  totalExecutionGA := Time millisecondClockValue.
  counter := 0.
  stopFlag := false.
  self initializePopulation.
	totalExecutionGA := Time millisecondClockValue - totalExecutionGA.
  bestFitness := self fitnessFor: logs last fittestTestCase.
  (1 to: numberOfGenerations) do: [:iteration |  | t lastBestFitness |
        stopFlag ifFalse: [ t := Time millisecondClockValue.
              self doSelection.
              logs add: (self logOfGeneration: iteration inTime: t).
              lastBestFitness := self fitnessFor: logs last fittestTestCase.
              lastBestFitness <= bestFitness ifTrue: [ counter := counter + 1.
                    counter > stopIterations ifTrue: [ stopFlag := true ] ] ifFalse: [ counter := 0.
                    bestFitness := lastBestFitness ].
				totalExecutionGA := totalExecutionGA + Time millisecondClockValue - t ]
	 ] displayingProgress: [:iteration |  'Evolving - Iteration' , iteration printString ]
]

{ #category : #actions }
SGAEngine >> selectTwoBestOf: aCollection excludingAll: excludingColl [
	| options |
	options := (aCollection asOrderedCollection select: #notEmpty) removeAllSuchThat: [ :e | excludingColl includes: e ].
   options := self order: options.
   ^ options first: (2 min: options size).
]

{ #category : #accessing }
SGAEngine >> selectionStrategy: aSelectionStrategy [
	selectionStrategy := aSelectionStrategy 
]

{ #category : #testing }
SGAEngine >> shouldCrossOver [
	^ self next < self crossoverRate
]

{ #category : #actions }
SGAEngine >> similarChild: testCase [ 
	^ testCase deepCopy 
		addParent: testCase; 
		generationNumber: testCase generationNumber + 1;
		yourself
]

{ #category : #actions }
SGAEngine >> summaryGenerations [
	^ logs collect: [ :aLog | aLog summaryTargetClass collect: [ :e | e ifNotNil: [ Dictionary newFromKeys: #('ClassName' 'MethodName' 'IsClassSide' 'WasExecuted' 'HasTypeInfo' 'Code' 'ArgTypes' 'ReturnType' 'ExecutedBlock' 'UnexecutedBlock') andValues: e summaryAsColl ] ] ]
	
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
SGAEngine >> targetPackageRegex [
	^ targetPackageRegex 
]

{ #category : #accessing }
SGAEngine >> targetPackageRegex: aString [
	targetPackageRegex := aString
]

{ #category : #accessing }
SGAEngine >> totalExecutionGA [
	^ totalExecutionGA 
]

{ #category : #accessing }
SGAEngine >> tournamentSize: aNumber [
	selectionStrategy tournamentSize: aNumber
]

{ #category : #accessing }
SGAEngine >> typeInfo [
	^ typeInfo
]

{ #category : #accessing }
SGAEngine >> typeInfo: aTypeInfo [
	typeInfo := aTypeInfo.
	self completeTypeInfo
]

{ #category : #updating }
SGAEngine >> uninstall [
	typeInfoProfiler afterProfiling;
		uninstall.
	Transcript show: 'ended...'; cr.
]

{ #category : #updating }
SGAEngine >> updateArgsOf: aMethod [ 
	aMethod argTypes do: [ :argType |
	|res|
	res := argType types anySatisfy: [ :type | typeInfo scalars keys includes: type ].
	res ifFalse: [ argType types do: [ :type | typeInfo scalars keys select: [ :scalar | 
			 (type asClass allSubclasses collect: #name) includes: scalar ] thenDo: [ :scalar |
			argType type: scalar ] ] ] ]
]

{ #category : #updating }
SGAEngine >> updateTypeInfoWith: aPopulation [
	fitness profiler uninstallClass: targetClassName.
   self profilerForTargetClass.
   aPopulation do:
		[ :testCase | testCase runWithoutAssertions ].
   self mergeTypeInfo: (STypeInfo asTypeInfo: typeInfoProfiler).
   self uninstall .
   fitness profiler updateClass: ((self initializeProfiler packages at:1) classes at: targetClassName).
	fitness profiler deleteCache.
	
]
