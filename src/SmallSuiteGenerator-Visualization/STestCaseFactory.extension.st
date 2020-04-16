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
STestCaseFactory >> gtInspectorViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal3
		title: 'Evolution';
		initializeCanvas: [ self visualizeEvolutionFitness ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory >> visualizeEvolutionFitness [
	| colors canvas legend extent scale |
	colors := Array with: (Color r: 0.14076246334310852 g: 0.48191593352883677 b: 0.6265884652981427)
		with: (Color r: 0.4389051808406647 g: 0.7565982404692082 b: 0.7018572825024438)
		with: (Color r: 0.6979472140762464 g: 0.8582600195503421 b: 0.7487781036168133)
		with: (Color r: 0.9521016617790812 g: 1.0 b: 0.7409579667644184).
	canvas := RSCanvas new.
	extent := 300@200.
	scale := NSScale linear 
		domain: (Array with: 0@0 with: (numberOfIterations + 1)@100);
		range: (Array with: 0@extent y with: extent x @ 0).
	canvas add: (RSPolyline new
		controlPoints:  ({ 1@100. 1@0. (numberOfIterations + 2)@0} collect: [:p| scale scale: p]);
		markerStartEnd: (RSShapeFactory arrow
			extent: 10@15;
			color: Color black);
		yourself).
	legend := RSLegend new 
		title: 'Fitness evolution';
		container: canvas;
		yourself.
	self fitnessResultAsDictionary associations doWithIndex: [ :association :index | 
		canvas add: (RSPolyline new
			color: (colors at: index);
			controlPoints: (association value collect: [:p | scale scale: p]);
			yourself).
		legend text: association key withBoxColor: (colors at: index)
		 ].
	canvas add: (RSPolyline new 
		color: (colors at: 4);
		controlPoints: ((1 to: numberOfIterations + 1) collect: [:n | scale scale: n@fitnessSeed ]);
		yourself). 
	legend text: 'Seed fitness' withBoxColor: (colors at: 4).
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
