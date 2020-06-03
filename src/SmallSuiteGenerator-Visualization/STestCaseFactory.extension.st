Extension { #name : #STestCaseFactory }

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory >> fitnessResultAsDictionary [
	| functionNames dictResult |
	self
		assert: (engine isNil not and: [ engine logs isNotEmpty ])
		description: 'Run the generation before'.
	functionNames := (Array with: engine fitness functionName) asSet.
	dictResult := Dictionary new.
	engine logs doWithIndex: [ :log :index | 
			functionNames do: [ :functionName | 
			| val |
			val := dictResult
				       at: functionName , '_fittest'
				       ifAbsentPut: [ OrderedCollection new ].
			val add: (index @ (log fittestTestCase fitness at: functionName)).
			val := dictResult
				       at: functionName , '_average'
				       ifAbsentPut: [ OrderedCollection new ].
			val add: (index @ (log averageFit at: functionName)).
			val := dictResult
				       at: functionName , '_lowest'
				       ifAbsentPut: [ OrderedCollection new ].
			val add: (index @ (log lowestFit at: functionName)) ] ].
	^ dictResult
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory >> generationEvolutionCanvas [
	^ engine generationVisualization: fitnessSeed ofColor: self class lightColors 
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory >> gtInspectorCanvasIn: composite [
	<gtInspectorPresentationOrder: -5>
	composite roassal3
		title: 'GenerationEvoution';
		initializeCanvas: [ self generationEvolutionCanvas ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory >> gtInspectorViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal3
		title: 'Evolution';
		initializeCanvas: [ self visualizeEvolutionFitness ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory >> visualizeEvolutionFitness [
	| canvas group legend g d y |
	canvas := RSCanvas new.
	group := RSGroup new.
	legend := RSLegend new 
		title: 'Fitness evolution';
		container: canvas;
		yourself.
	y := (1 to: engine logs size) asArray.
	g := RSChart new.
	g container: group.
	self fitnessResultAsDictionary associations doWithIndex: [ :association :index | 
		d := RSLinePlot new x: (association value collect: #x) y: (association value collect: #y).
		g addPlot: d.
		legend text: association key withBoxColor: (g colors range at: index) ].
	d := RSLinePlot new x: y y: ((OrderedCollection ofSize: engine logs size) atAllPut: fitnessSeed).
	g addPlot: d.
	legend text: 'Fitness seed' withBoxColor: (g colors range at: 4).
	g addDecoration: (RSVerticalTick new).
	g addDecoration: (RSHorizontalTick new). 
	
	g title: 'Fitness Evolution'.
	g xlabel: 'Iterations'.
	g addDecoration: (RSYLabelDecoration new title: 'Fitness'; offset: -15; vertical).
	g build.
	canvas add: group asShape.
	legend leyendDo: [ :l |
		l
			draggable;
			withBorder;
			padding: 20;
			scaleBy: 0.5 ].
	legend location offset: 10.
	legend build.
	canvas @ RSCanvasController.
	^ canvas
]
