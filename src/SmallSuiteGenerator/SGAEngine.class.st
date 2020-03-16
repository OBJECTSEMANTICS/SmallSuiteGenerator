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
		'lastMessage'
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

{ #category : #'as yet unclassified' }
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

{ #category : #actions }
SGAEngine >> computeFitness [
	fitness compute: population.
]

{ #category : #'as yet unclassified' }
SGAEngine >> contentVisualization: container [ 
	| shape generations els aBlock |
	generations := numberOfGenerations + 1.
	shape := RTCompositeShape new.
	els :=  shape elementsOn: ((logs flatCollect: #population) 
	select: [:tC | (tC ni = generations or: 
		[ tC allChildren detect: [:tCe |  tCe ni = generations ] ifFound: [ true ] ifNone: [ false ]
		])
	]).
	aBlock := [ :testCase | | builder |
		builder := RTShapeBuilder new.
		builder rectangle 
			size: testCase fitness values first;
			fillColor: (Color blue alpha: 0.3);
			withText.
		container view addAll: (builder elementsOn: (testCase summaryExecutedCode collect: [:assoc | 
				assoc key -> assoc value first first. "body of method"
			])  ).
	].
	container view addAll: els.
	"els do: [ :element | 
		
	]."
	RTCellLayout on: container view elements.
	container view build.
	^ container view.
	
	
]

{ #category : #actions }
SGAEngine >> createRandomPopulation [
  ^ (1 to: populationSize) collect: [:val |  | value test |
        value := SConfiguration randomGenerator next * populationSize + 1.
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
  randomGenerator := SConfiguration newRandomGenerator.
  populationSize := 100.
  numberOfGenerations := 100.
  selectionStrategy := SGATournamentSelection new.
  
  selectionStrategy engine: self.
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

{ #category : #testing }
SGAEngine >> is: testCase1 betterThan: testCase2 [
	|fitness1 fitness2|
	fitness1 := self fitnessFor: testCase1.
	fitness2 := self fitnessFor: testCase2.
		^ 			fitness1 = fitness2
						ifTrue: [ testCase1 length <= testCase2 length ]
						ifFalse: [ fitness1 > fitness2 ]
]

{ #category : #'as yet unclassified' }
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
SGAEngine >> lastMessage: anObject [
	lastMessage := anObject
]

{ #category : #accessing }
SGAEngine >> logs [
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

{ #category : #actions }
SGAEngine >> run [
  | t |
  t := Time now asSeconds.
  population := self createRandomPopulation.
  SExpression resetId.
  self computeFitness.
  selectionStrategy
     initialPopulation: population;
     fitness: fitness;
	  tournamentSize: self populationSize.
  logs add: (self logOfGeneration: 0 inTime: t).
  (1 to: numberOfGenerations) do: [:iteration |  t := Time now asSeconds.
        selectionStrategy doSelection.
        population := selectionStrategy population.
        logs add: (self logOfGeneration: iteration inTime: t) ] displayingProgress: [:iteration |  'Evolving - Iteration' , iteration printString ]
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

{ #category : #'as yet unclassified' }
SGAEngine >> visualizateMethods: aView [
	|  populationGroup el |
	populationGroup := RTGroup new.
	self population collect: [:testCase | testCase summaryExecutedCode associations ] thenDo: [:assocs |
		| group |
		group := RTGroup new.
		assocs do: [ :assoc | 
			group add: (self visualizeMethod: assoc key with: assoc value in: aView).
		].
		RTGridLayout on: group.
		"aView add: group."
		populationGroup add: group	
	].
	el := (RTBox new width: self population size * 20; height: 50) element"On: populationGroup".
	el @ RTDraggable.
	"el elementOn: populationGroup."
	"RTHorizontalLineLayout on: populationGroup."
	RTNest new layout: RTHorizontalLineLayout new; on: el nest: populationGroup.
	aView add: el;
	add: populationGroup.
	^ aView
]

{ #category : #'as yet unclassified' }
SGAEngine >> visualizationMethods: aView [
	| builder |
	builder := RTShapeBuilder new.
	builder rectangle 
				height: [:str | str lineCount * 30 ]; 
				width: [ :str | (str lines collect: #size) max * 10 ];
				fillColor: (Color black alpha: 0.3);
				withText.
	aView addAll: (builder elementsOn: (self population collect: [:testCase | 
		|assoc |
		assoc := testCase summaryExecutedCode associations first.
		assoc key asString, String cr, assoc value first second ])).
	RTCellLayout on: aView elements.
	aView build.
	^ aView 
]

{ #category : #'as yet unclassified' }
SGAEngine >> visualizeMethod: assoc [ 
	|string substrings max indSubstring nLine group|
	string := assoc key asString, String cr, assoc value first second.
	substrings := assoc value allButFirst select: [ :data | data first ] 
		thenCollect: [ :data | data second trimLeft: [ :char | char = Character tab] ].
	max := substrings size.
	indSubstring := 1.
	nLine := 1.
	group := RSGroup new.
	string linesDo: [ :line | 
		| groupLabel found subString index lastStr |
		groupLabel := RSGroup new.
		found := false.
		indSubstring  <= max ifTrue: [ 
		nLine <= (substrings at: indSubstring) lines size 
			ifFalse: [ nLine := 1. 
			indSubstring := indSubstring + 1 ].
		subString := (substrings at: indSubstring) lines at: nLine.
		index := line indexOfSubCollection: subString.
		found := index > 0.
		].
		found ifTrue: [ 
			groupLabel 
				add: (RSLabel new color: Color white; text: (line copyFrom: 1 to: index - 1));
				add: (RSLabel new color: Color pink; text: subString).
			lastStr := line copyFrom: index + subString size to: line size.
			lastStr ifNotEmpty: [ groupLabel 
				add: (RSLabel new color: Color white; text: lastStr) ].
		].
		found ifFalse: [ groupLabel add: (RSLabel new color: Color white; text: line ) ].
		RSHorizontalLineLayout on: groupLabel.
		group add: groupLabel
	].
	RSVerticalLineLayout new gapSize: 0; on: group.
	^ RSComposite new 
		shapes: (group flatCollect: #yourself);
		paint: Color black;
		model: 'sadsdfg';
		padding: 10;
		draggable.
	
	
	
]

{ #category : #'as yet unclassified' }
SGAEngine >> visualizeWithRoassal3 [
	| canvas assocGroup |
	canvas := RSCanvas new addInteraction: RSCanvasController.
	assocGroup := RSGroup new.
	self population collect: [:testCase | testCase summaryExecutedCode associations ] 
	thenDo: [:assocs | 
		| group |
		group := RSGroup new.
		assocs do: [ :assoc |
			| element |
			element := self visualizeMethod: assoc.
			canvas add: element.
			group add: element
		].
		RSGridLayout on: group.
		assocGroup add: group.
	].
	RSGridLayout new gapSize: 20; on: assocGroup.
	^ canvas
]
