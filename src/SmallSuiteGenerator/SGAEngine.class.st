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
		'targetPackageRegex'
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

{ #category : #actions }
SGAEngine >> createNewPopulation [
  | newPopulation |
  newPopulation := OrderedCollection new.
  [ newPopulation size < initialPopulation size ] whileTrue: [ | selectedList P1copy P2copy P1 P2 O1 O2 OM1 OM2 selectedOptions children options |
		  selectedList := selectionStrategy selectOf: initialPopulation.
        P1 := selectedList first .
        P2 := selectedList second.
        P1copy := P1 deepCopy.
        P1copy addParent: P1.
        P2copy := P2 deepCopy.
        P2copy addParent: P2.
        P1copy generationNumber: P1 generationNumber + 1.
        P2copy generationNumber: P2 generationNumber + 1.
        self shouldCrossOver ifTrue: [ children := self crossoverOperator crossover: P1 with: P2.
              O1 := children first.
              O2 := children second.
              O1 generationNumber: P1 generationNumber + 1.
              O2 generationNumber: P2 generationNumber + 1 ] ifFalse: [ O1 := P1copy deepCopy.
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
        selectedOptions do: [:option |  newPopulation add: (option idPopulation: newPopulation size + 1) ] ].
  self updateTypeInfoWith: newPopulation.
  self fixPopulation: newPopulation.
  population := newPopulation.
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

{ #category : #actions }
SGAEngine >> doSelection [
	self createNewPopulation.
	initialPopulation := population.
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
		removeAllSuchThat: [:method | method hasProfiler not ].
	 
	aCollection do: [ :testCase |
		testCase statements select: #needsBeFixed thenDo: [ :stm | 
			(stm value receiver returnType = self targetClassName) ifTrue: [ 
			targetClassMessages select: [ :method | method selector = stm value selector ]
			thenDo: [ :method |
				stm fixWith: method in: testCase ]
	   ] ] ]
]

{ #category : #initialization }
SGAEngine >> initialize [
  super initialize.
  
  logs := OrderedCollection new.
  randomGenerator := SPlatform newRandomGenerator.
  populationSize := 100.
  numberOfGenerations := 100.
  selectionStrategy := SGARankSelection new.
  
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
	typeInfo joinWith: otherTypeInfo.
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
SGAEngine >> selectionStrategy: aSelectionStrategy [
	selectionStrategy := aSelectionStrategy 
]

{ #category : #actions }
SGAEngine >> shouldCrossOver [
	^ SPlatform randomGenerator next < (3 / 4)
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
	res ifFalse: [ argType types do: [ :type | | scalars |
		scalars := typeInfo scalars keys select: [ :scalar | 
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
