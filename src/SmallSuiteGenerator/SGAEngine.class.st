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
		'packageRegex',
		'initialPopulation',
		'typeInfoProfiler',
		'targetPackageRegex',
		'elitismRate',
		'crossoverStrategy',
		'stopIterations',
		'totalExecutionGA',
		'selectionStrategyTestCase',
		'needCompletion'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #'API-accessing' }
SGAEngine class >> logClass [
	^ SGANullLog
]

{ #category : #'API-accessing' }
SGAEngine class >> resetToDefaults [
	"reset log class to NullLog"
	
	{ #logClass -> SGANullLog } 
		do: [ :val |
			self class compile: 
			( val key asString , String cr , '	^ ' , val value printString) ]
]

{ #category : #updating }
SGAEngine >> assignTypeToArgumentsOf: argType [

  ^ argType types 
		do: [ :type |
			self scalarsKeysOfTypeInfo 
				select: [ :scalar |
					self collectNameOfAllSubclassesOf: type includesOn: scalar ] 
				thenDo: [ :scalar |  argType type: scalar ] ]
]

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

{ #category : #cleaning }
SGAEngine >> clean [

	fitness ifNotNil: [ fitness tearDown ]
]

{ #category : #actions }
SGAEngine >> collectNameOfAllSubclassesOf: type includesOn: scalar [

	^ (type class allSubclasses collect: #name) includes: scalar
]

{ #category : #actions }
SGAEngine >> computeFitness [
	"compute fitness of all population"

	fitness compute: population.
]

{ #category : #creating }
SGAEngine >> createNewPopulation [
	| newPopulation currentPopulationSize lastLowestFitness options newNumber |
	
	lastLowestFitness := logs last lowestFit at: fitness functionName.
	currentPopulationSize := initialPopulation size.
   newPopulation := self eliteOfCurrentPopulation.
	newNumber := newPopulation size.
  	[ newPopulation size < currentPopulationSize ] 
		whileTrue: [ | selectedIndividuals p1copy p2copy p1 p2 o1 o2 om1 om2 selectedOptions children |
			selectedIndividuals := selectionStrategy selectOf: initialPopulation.   
		  	p1 := selectedIndividuals first.
        	p2 := selectedIndividuals second.
		  	p1copy := self similarChild: p1 with: newNumber + 1.
		  	p2copy := self similarChild: p2 with: newNumber + 2.
         (crossoverStrategy shouldCrossOver: p1 with: p2) 
				ifTrue: [ 
					children := crossoverOperator crossover: p1 with: p2.
					o1 := self updateHierarchyData: { p1 . p2 } of: (children first idPopulation: newNumber + 3).
					o2 := self updateHierarchyData: { p1 . p2 } of: (children second idPopulation: newNumber + 4).] 
				ifFalse: [ 
					o1 := (p1copy deepCopy) idPopulation: newNumber + 3; addParent: p1.
              	o2 := (p2copy deepCopy) idPopulation: newNumber + 4; addParent: p2 ].
        om1 := self mutateAndUpdate: o1.
        om2 := self mutateAndUpdate: o2.
        fitness compute: (Array with: om1 with: om2).
		  options := Array with: om1 with: om2 with: p1copy with: p2copy.
        selectedOptions := (self selectTwoBestOf: options excludingAll: newPopulation) select: [ :option | (option fitness at: fitness functionName) >= lastLowestFitness ].
		  selectedOptions := selectedOptions first: (selectedOptions size min: currentPopulationSize - newPopulation size).
		  options reject: [ :opt | selectedOptions includes: opt ] 
				thenDo: [ :opt | p1 removeChild: opt.
					p2 removeChild: opt ].
			newPopulation addAll: (selectedOptions collect: [:option | 
				newNumber := newNumber +1.
				option idPopulation: newNumber ]) ].
   self updateTypeInfoWith: newPopulation.
   population := newPopulation.
   population := self order: population
]

{ #category : #creating }
SGAEngine >> createRandomPopulation [

	^ (1 to: populationSize) collect: [:idPop |  | value test |
        value := self next * numberOfStatements + 1.
        test := SSTestCase with: typeInfo.
        test
           targetClassName: targetClassName;
           addFactoryMessage: targetClassName;
           generateStatements: value;
           lastMessage: lastMessage;
           idPopulation: idPop;
			  clean.
		  selectionStrategyTestCase ifNotNil: [ test selectionStrategy: selectionStrategyTestCase ].
        test ]
]

{ #category : #accessing }
SGAEngine >> crossoverOperator: aCrossoverOperator [

	crossoverOperator := aCrossoverOperator
]

{ #category : #accessing }
SGAEngine >> crossoverStrategy: aCrossoverStrategy [

	crossoverStrategy := aCrossoverStrategy.
]

{ #category : #actions }
SGAEngine >> doSelection [

	self createNewPopulation.
	initialPopulation := population.
]

{ #category : #actions }
SGAEngine >> eliteOfCurrentPopulation [
	"select the best testCases according elitismRate"
	| endIndex index popSize |
	
	popSize := population size.
	endIndex := ((popSize * elitismRate "* 0.01") round: 0) asInteger.
	(popSize > 0 and: [ endIndex == 0 ]) ifTrue: [ endIndex := 1 ].
	index := 0.
	endIndex >= 1 ifTrue: [ ^ (((population copyFrom: 1 to: endIndex) collect: [:testCase |
			index := index + 1.
			self similarChild: testCase with: index.
			])) asOrderedCollection ].
	^ OrderedCollection new
]

{ #category : #rating }
SGAEngine >> elitismRate: aNumber [

	elitismRate := aNumber
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

{ #category : #initialization }
SGAEngine >> initialize [

  super initialize.
  logs := OrderedCollection new.
  populationSize := 30.
  numberOfGenerations := 100.
  selectionStrategy := SGARandomSelection new.
  crossoverStrategy := SGACrossoverRate new.
  elitismRate := 0.1.
  numberOfStatements := 10.
  stopIterations := 30.
  totalExecutionGA := 0.
  lastMessage := SSGParser parseFrom: ( SPlatform rbParserClass parseExpression: '').
  needCompletion := true.
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
	population ifNil: [
	   population := self createRandomPopulation.
 	   SExpression resetId.
  		self computeFitness.
   		population := self order: population.
   		initialPopulation := population.
		self updateTypeInfoWith: population.
		logs add: (self logClass logOf: self inGeneration: 0 inTime: t).
	]
]

{ #category : #initialization }
SGAEngine >> initializeProfiler [
	| aProfiler |
	
	aProfiler := self aSLProfilerCoverage profilerForClass: targetClassName.
	(aProfiler allMethods select: #isNotMethodExtension)
		do: #installGhosts
		displayingProgress: 'Instrumenting ' , targetClassName.
	^ aProfiler
]

{ #category : #actions }
SGAEngine >> lastBestFitness [
	"returns the testCase that had the best fitness of the previous generation"

	^ logs last fittestTestCase fitnessFor: fitness functionName
]

{ #category : #actions }
SGAEngine >> lastGenerationNumber [
	"returns the ID of the previous generation"

	^ logs last generationNumber
]

{ #category : #accessing }
SGAEngine >> lastMessage: anObject [

	lastMessage := anObject 
	
]

{ #category : #accessing }
SGAEngine >> logClass [

	^ self class logClass
]

{ #category : #actions }
SGAEngine >> logInGeneration: iteration withTime: t [
	"returns a log for each iteration"

	^ self logClass logOf: self inGeneration: iteration inTime: t
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
	| newTestCase |
	
	newTestCase := mutationOperator mutate: aTestCase.
   newTestCase updateWith: aTestCase.
	^ newTestCase 
]

{ #category : #actions }
SGAEngine >> mutationRate: aFloat [

	mutationOperator mutationRate: aFloat
]

{ #category : #accessing }
SGAEngine >> needCompletion [

	^ needCompletion
]

{ #category : #accessing }
SGAEngine >> needCompletion: aBoolean [

	needCompletion := aBoolean
]

{ #category : #accessing }
SGAEngine >> numberOfGenerations [

	^ numberOfGenerations
]

{ #category : #accessing }
SGAEngine >> numberOfGenerations: anInteger [
	"Set the number of generation the genetic algorithm has to run"
	
	numberOfGenerations := anInteger
]

{ #category : #accessing }
SGAEngine >> numberOfStatements: anInteger [
	"Set the number of statements the initial population should have.
	Ideally, a small number, such as 3, is convenient. The evolution makes the individuals grow over time"
	
	numberOfStatements := anInteger
]

{ #category : #sorting }
SGAEngine >> order: aCollection [

	^ aCollection sort: [ :stm1 :stm2 | stm1 isBetterThan: stm2 using: fitness functionName ]
]

{ #category : #accessing }
SGAEngine >> packageRegex: aString [

	packageRegex := aString
]

{ #category : #accessing }
SGAEngine >> population [

	^ population
]

{ #category : #accessing }
SGAEngine >> populationSize: aInteger [

	populationSize := aInteger
]

{ #category : #updating }
SGAEngine >> profilerForPackagesMatching [

	Transcript show: 'profiling...'; cr.
	typeInfoProfiler := self aSTypeCollectorClass 
		profilerForPackagesMatching: targetPackageRegex.
	typeInfoProfiler beforeProfiling.
]

{ #category : #updating }
SGAEngine >> profilerForTargetClass [
	| packageSpy cls classSpy |
	
	cls := Smalltalk at: targetClassName.
	Transcript show: 'profiling...'; cr.
	typeInfoProfiler := self aSTypeCollectorClass new.
	self aSTypeCollectorClass installOnClass: cls.
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
  bestFitness := self lastBestFitness.
  (1 to: numberOfGenerations) do: [:iteration |  | t lastBestFitness |
        stopFlag ifFalse: [ t := Time millisecondClockValue.
              self doSelection.
              logs add: (self logInGeneration: iteration withTime: t).
              lastBestFitness := self lastBestFitness.
              lastBestFitness <= bestFitness ifTrue: [ counter := counter + 1.
                    counter > stopIterations ifTrue: [ stopFlag := true ] ] ifFalse: [ counter := 0.
                    bestFitness := lastBestFitness ].
              totalExecutionGA := totalExecutionGA + Time millisecondClockValue - t ] ] displayingProgress: [:iteration |  'Evolving - Iteration', iteration printString ]
]

{ #category : #accessing }
SGAEngine >> scalarsKeysOfTypeInfo [

  ^ typeInfo scalars keys
]

{ #category : #actions }
SGAEngine >> selectTwoBestOf: aCollection excludingAll: excludingColl [
	| options |
	
	options := (aCollection asOrderedCollection select: #notEmpty) removeAllSuchThat: [ :e | excludingColl includes: e ]; yourself.
   options := self order: options.
   ^ options first: (2 min: options size).
]

{ #category : #accessing }
SGAEngine >> selectionStrategy: aSelectionStrategy [

	selectionStrategy := aSelectionStrategy 
]

{ #category : #accessing }
SGAEngine >> selectionStrategyTestCase: aSelectionStrategy [

	selectionStrategyTestCase := aSelectionStrategy 
]

{ #category : #actions }
SGAEngine >> similarChild: testCase with: idPopulation [

	^ testCase deepCopy 
		generationNumber: testCase generationNumber + 1;
		idPopulation: idPopulation;
		addParent: testCase; 
		yourself
]

{ #category : #initialization }
SGAEngine >> stopIterations [

	^ stopIterations
]

{ #category : #initialization }
SGAEngine >> stopIterations: aNumber [

	stopIterations := aNumber
]

{ #category : #actions }
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
SGAEngine >> typeInfo [

	^ typeInfo
]

{ #category : #accessing }
SGAEngine >> typeInfo: aTypeInfo [

	typeInfo := aTypeInfo.
	needCompletion 
		ifTrue: [ typeInfo completeTypeInfo ]
]

{ #category : #accessing }
SGAEngine >> typeInfoProfilerAsTypeInfo [

  ^ STypeInfo asTypeInfo: typeInfoProfiler
]

{ #category : #updating }
SGAEngine >> uninstall [

	typeInfoProfiler afterProfiling;
		uninstall.
	Transcript show: 'ended...'; cr.
]

{ #category : #updating }
SGAEngine >> updateArgsOf: aMethod [

  aMethod argTypes do: [:argType |  | res |
        res := argType types anySatisfy: [:type |  self scalarsKeysOfTypeInfo includes: type ].
        res ifFalse: [ self assignTypeToArgumentsOf: argType ] ]
]

{ #category : #actions }
SGAEngine >> updateHierarchyData: parents of: testCase [

	parents do: [ :parent | testCase addParent: parent ].
	^ testCase
]

{ #category : #updating }
SGAEngine >> updateTypeInfoWith: aPopulation [

   fitness profiler uninstallClass: targetClassName.
   self profilerForTargetClass.
   aPopulation do: [:aTestCase | aTestCase runWithoutAssertionsAndLastStatement ].
   self mergeTypeInfo: self typeInfoProfilerAsTypeInfo.
   self uninstall.
   fitness profiler updateClass: ((self initializeProfiler packages at: 1) classes at: targetClassName).
   fitness profiler deleteCache.
]
