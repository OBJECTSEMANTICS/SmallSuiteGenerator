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
		'crossoverRate'
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

{ #category : #'as yet unclassified' }
SGAEngine >> colors [
	^ Dictionary new 
		at: 'background' put: (Color r: 0.12549019607843137 g: 0.1803921568627451 b: 0.23529411764705882);
		at: 'backgroundBoxMethod' put: (Color r: 0.1607843137254902 g: 0.3686274509803922 b: 0.4470588235294118);
		at: 'scaleLighter' put: (Color r: 0.5098039215686274 g: 0.9607843137254902 b: 0.7725490196078432);
		at: 'scaleDarker' put: (Color r: 0.30980392156862746 g: 0.6235294117647059 b: 0.49019607843137253);
		at: 'backgroundLighter' put: (Color r: 0.7647058823529411 g: 0.803921568627451 b: 0.788235294117647);
		at: 'numberClasses' put: (Color r: 0.5098039215686274 g: 0.7803921568627451 b: 0.9607843137254902);
		at: 'numberMethods' put: (Color r: 0.9607843137254902 g: 0.5098039215686274 b: 0.7215686274509804);
		at: 'border' put: Color white;
		yourself.
]

{ #category : #actions }
SGAEngine >> computeFitness [
	fitness compute: population.
]

{ #category : #actions }
SGAEngine >> createNewPopulation [
  | newPopulation currentPopulationSize newNumber |
	currentPopulationSize := initialPopulation size.
  newPopulation := self eliteOfCurrentPopulation.
  [ newPopulation size < currentPopulationSize ] whileTrue: [ | selectedList P1copy P2copy P1 P2 O1 O2 OM1 OM2 selectedOptions children options |
		  selectedList := selectionStrategy selectOf: initialPopulation.
        P1 := selectedList first .
        P2 := selectedList second.
		  P1copy := self similarChild: P1.
		  P2copy := self similarChild: P2.
        self shouldCrossOver 
				ifTrue: [ children := self crossoverOperator crossover: P1 with: P2.
              O1 := children first.
              O2 := children second.
              O1 generationNumber: P1 generationNumber + 1.
              O2 generationNumber: P2 generationNumber + 1 ] 
				ifFalse: [ 
					O1 := P1copy deepCopy.
				  	O1 addParent: P1.
              	O2 := P2copy deepCopy.
              	O2 addParent: P2 ].
        OM1 := self mutate: O1.
		  OM1 clean.
        OM1 updateWith: O1.
        OM2 := self mutate: O2.
		  OM2 clean.
        OM2 updateWith: O2.
        fitness compute: (Array with: OM1 with: OM2).
        options := (Array with: OM1 with: OM2 with: P1copy with: P2copy) difference: newPopulation.
        options := options asSortedCollection: 
			  [:a :b |  self is: a betterThan: b ].
        selectedOptions := options first: 2.
		  newNumber := newPopulation size.
		  newPopulation addAll: (selectedOptions collect: [:option | 
				newNumber:= newNumber + 1.
			option idPopulation: newNumber ])
        "selectedOptions do: [:option |  newPopulation add: (option idPopulation: newPopulation size + 1) ]"
		   ].
  population := newPopulation.
  self updateTypeInfoOfPopulation
		  
]

{ #category : #actions }
SGAEngine >> createRandomPopulation [
  ^ (1 to: populationSize) collect: [:val |  | value test |
        value := SPlatform randomGenerator next * populationSize + 1.
        test := SSTestCase with: typeInfo.
        test
           addTargetClassName: self targetClassName;
           addFactoryMessage: self targetClassName;
           generateStatements: value;
           lastMessage: lastMessage;
           idPopulation: val.
        test ]
]

{ #category : #initialization }
SGAEngine >> crossoverOperator [
	^ crossoverOperator
]

{ #category : #accessing }
SGAEngine >> crossoverOperator: aCrossoverOperator [
	crossoverOperator := aCrossoverOperator.
	crossoverOperator randomGenerator: randomGenerator 
]

{ #category : #accessing }
SGAEngine >> crossoverRate [
	^ crossoverRate
]

{ #category : #'as yet unclassified' }
SGAEngine >> crossoverRate: aNumber [
	selectionStrategy crossoverRate: aNumber
]

{ #category : #actions }
SGAEngine >> doSelection [
	self createNewPopulation.
	initialPopulation := population.
]

{ #category : #'as yet unclassified' }
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

{ #category : #accessing }
SGAEngine >> elitismRate [
	^ elitismRate
]

{ #category : #'as yet unclassified' }
SGAEngine >> elitismRate: aNumber [
	selectionStrategy elitismRate: aNumber.
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
  
  logs := OrderedCollection new.
  randomGenerator := SPlatform newRandomGenerator.
  populationSize := 100.
  numberOfGenerations := 100.
  selectionStrategy := SGARankSelection new.
	crossoverRate := 0.8.
	elitismRate := 10.
  
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
		^ 			fitness1 = fitness2
						ifTrue: [ (testCase1 idPopulation > testCase2 idPopulation) or: [ testCase1 length <= testCase2 length] ]
						ifFalse: [ fitness1 > fitness2 ]
]

{ #category : #actions }
SGAEngine >> lastMessage: anObject [
	lastMessage := anObject 
	
]

{ #category : #log }
SGAEngine >> logOfGeneration: anInteger inTime: t [
	| log dictFitness |
	log := SGALog new 
		generationNumber: anInteger;
		fittestTestCase: self pickBestTest;
		timeToProduceGeneration: Time new asSeconds - t;
		population: population.
	dictFitness := self collectFitnessByName.
	log lowestFit: (self pickMinFitTest: dictFitness);
	averageFit: (self pickAverageFitTest: dictFitness).
	^ log
]

{ #category : #accessing }
SGAEngine >> logs [
	^ logs
]

{ #category : #updating }
SGAEngine >> mergeTypeInfo: otherTypeInfo [
	initialPopulation do: [ :testCase | testCase typeInfo joinWith: otherTypeInfo ].
	population do: [ :testCase | testCase typeInfo joinWith: otherTypeInfo ].
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

{ #category : #accessing }
SGAEngine >> packageRegex: aString [
	packageRegex := aString
]

{ #category : #actions }
SGAEngine >> pickAverageFitTest: aDictionary [
	^ (aDictionary keys collect: [ :key | 
		   key -> (aDictionary at: key) average ]) asDictionary
]

{ #category : #actions }
SGAEngine >> pickBestTest [
	|best|
	best := population first.
	population do: [ :test | 
		(self is: test betterThan: best) ifTrue: [ best := test ]
	].
	^ best
]

{ #category : #actions }
SGAEngine >> pickMinFitTest: aDictionary [
  ^ (aDictionary keys collect: [:key |  key -> (aDictionary at: key) min ]) asDictionary
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

{ #category : #'as yet unclassified' }
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
  | t |
  t := Time now asSeconds.
  population := self createRandomPopulation.
  SExpression resetId.
  self computeFitness.
	initialPopulation := population.
  logs add: (self logOfGeneration: 0 inTime: t).
  (1 to: numberOfGenerations) do: [:iteration | 
		  t := Time now asSeconds.
        self doSelection.
        logs add: (self logOfGeneration: iteration inTime: t) ] displayingProgress: [:iteration |  'Evolving - Iteration' , iteration printString ]
]

{ #category : #accessing }
SGAEngine >> selectionStrategy [ 
	^ selectionStrategy
]

{ #category : #accessing }
SGAEngine >> selectionStrategy: selectStrategy [
	selectionStrategy := selectStrategy 
]

{ #category : #actions }
SGAEngine >> shouldCrossOver [
	^ SPlatform randomGenerator next < self crossoverRate
]

{ #category : #'as yet unclassified' }
SGAEngine >> similarChild: testCase [ 
	^ testCase deepCopy 
		addParent: testCase; 
		generationNumber: testCase generationNumber + 1;
		yourself
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

{ #category : #'as yet unclassified' }
SGAEngine >> tournamentSize: aNumber [
	selectionStrategy tournamentSize: aNumber
]

{ #category : #accessing }
SGAEngine >> typeInfo [
	^ typeInfo
]

{ #category : #accessing }
SGAEngine >> typeInfo: aTypeInfo [
	typeInfo := aTypeInfo
]

{ #category : #updating }
SGAEngine >> uninstall [
	typeInfoProfiler afterProfiling;
		uninstall.
	Transcript show: 'ended...'; cr.
]

{ #category : #updating }
SGAEngine >> updateTypeInfoOfPopulation [
	fitness profiler uninstallClass: targetClassName.
   self profilerForTargetClass .
   population do:
		[ :testCase | testCase runWithoutAssertions ].
   self mergeTypeInfo: (STypeInfo asTypeInfo: typeInfoProfiler).
   self uninstall .
   fitness profiler updateClass: ((self initializeProfiler packages at:1) classes at: targetClassName).
	fitness profiler deleteCache.
	
]
