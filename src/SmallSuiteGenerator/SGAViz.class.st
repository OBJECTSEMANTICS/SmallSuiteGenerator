"
I am a null visualization class, that is, when using this class you will not get any visualization of the GA
"
Class {
	#name : #SGAViz,
	#superclass : #SGAAbstractViz,
	#instVars : [
		'aTestCaseFactory'
	],
	#category : #'SmallSuiteGenerator-Strategies'
}

{ #category : #'as yet unclassified' }
SGAViz class >> discoveredMethodEvolution: builder [
	 ^ self new aTestCaseFactory: builder; 
		discoveredMethodEvolutionUsing: self lightColors 
]

{ #category : #'as yet unclassified' }
SGAViz class >> disimilarity: builder [
	 ^ self new aTestCaseFactory: builder; 
		disimilarityByGeneration: self lightColors 
]

{ #category : #'instance creation' }
SGAViz class >> gtInspectorCanvasIn: composite for: testCaseFactory [
	composite roassal3
		title: 'GenerationEvolution';
		initializeCanvas: [ self new aTestCaseFactory: testCaseFactory; generationEvolutionCanvas ]
]

{ #category : #'instance creation' }
SGAViz class >> gtInspectorViewIn: composite for: testCaseFactory [
	composite roassal3
		title: 'Evolution';
		initializeCanvas: [ self new aTestCaseFactory: testCaseFactory; visualizeEvolutionFitness ]
]

{ #category : #'as yet unclassified' }
SGAViz class >> infoTypeEvolution: builder [
	 ^ self new aTestCaseFactory: builder; 
		infoTypeEvolutionWith: self lightColors 
]

{ #category : #'instance creation' }
SGAViz class >> on: testCaseFactory [
	^ self new aTestCaseFactory: testCaseFactory
]

{ #category : #'as yet unclassified' }
SGAViz class >> similarity: builder [
	 ^ self new aTestCaseFactory: builder; 
		similarityByGeneration: self lightColors 
]

{ #category : #accessing }
SGAViz >> aTestCaseFactory [
	^ aTestCaseFactory
]

{ #category : #accessing }
SGAViz >> aTestCaseFactory: anObject [
	aTestCaseFactory := anObject
]

{ #category : #'as yet unclassified' }
SGAViz >> calledSelectors: aClassName by: testCase [
	| dict selectors |
	selectors := OrderedCollection new.
	dict := ((testCase statements collect: #value) reject: #isLiteralExpression) 
		groupedBy: [ :expr | expr class name ].
	selectors addAll: ((dict at: #SFactoryMessage ifAbsent: [#()]) select: [ :fM | fM returnType = aClassName ] thenCollect: [ :fM | fM selector ]).
	selectors addAll: ((dict at: #SMessage ifAbsent: [#()]) select: [ :m | m receiver returnType = aClassName ] thenCollect: [:m | m selector ]).
	selectors addAll: ((dict at: #SFieldMessage ifAbsent: [#()]) select: [ :m | m receiver returnType = aClassName ] thenCollect: [:m | m selector ]).
	^ selectors
]

{ #category : #'as yet unclassified' }
SGAViz >> discoveredMethodEvolutionUsing: dictColor [
| canvas composite scale points axis spaceStick xMax yMax size yPositions step totalExecutedMethods |
   canvas := RSCanvas new.
	size := 800 @ 200.
	yPositions := (0 to: self engine numberOfGenerations) collect: [:n | n * 100 ].
	composite := RSComposite new 
		color: Color transparent.
	xMax := self logs last typeInfoGeneration allMethods size.
	scale := NSScale linear 
		domain: (Array with: 0 with: xMax);
		range: (Array with: 0 with: size x).
	yMax := yPositions last.
	totalExecutedMethods := self executedMethodsByGeneration.
	points := self infoDiscoveredMethods: yPositions, #(0) withScale: scale and: totalExecutedMethods.
	"points := self infoEvolutionPoints: yPositions , #(0) withScale: scale."
	spaceStick := yMax - (0.01 * size y).
	axis := RSPolyline new 
		color: (dictColor at: 'axis');
		width: 10;	
		controlPoints: ((Array with: 0@0 with: 0@spaceStick with: (scale scale:xMax)@spaceStick));
		yourself.
	composite addShape: axis; 
		addShape: (RSPolyline new 
			controlPoints: points; 
			color: "(dictColor at: 'lowestCoverage')" Color blue;
			width: 10; yourself).
	step := xMax > 10 ifTrue: [ 5 ] ifFalse: [ xMax ].
	self addTickX: composite withScale: scale color: Color black "(dictColor at: 'font')" y: yMax step: step and: xMax @ size y.
	self addTickY: composite withScale: scale xMax: xMax ofColor: "(dictColor at: 'font')" Color black andPositions:  yPositions.
	yPositions doWithIndex: [ :y :index | 
		| lbl |
		lbl := RSLabel new 	
			fontSize: 30;
			color: Color black;
			text: (totalExecutedMethods at: index);
			position: (scale scale: xMax+(xMax * 0.1))@y.
		composite addShape: lbl.
	].
   canvas add:	composite adjustToChildren.
	canvas @ RSCanvasController.
	^ canvas
]

{ #category : #'as yet unclassified' }
SGAViz >> disimilarityByGeneration: dictColor [
	| canvas group col edges |
   canvas := RSCanvas new.
	group := RSGroup new.
	col := self engine logs collect: #population.
	edges := RSGroup new.
	"group addAll: ("
		col do: [ :tCs | | comp |
			comp := self groupTestCases: tCs with: dictColor and: canvas.
			group add: comp.
			comp shapes do: [:from |
				comp shapes do: [ :to | 
				(from model generationNumber == to model generationNumber 
					and: [ from model idPopulation == to model idPopulation ]) 
				ifFalse: [ | jacIndex |
					jacIndex := self jaccarIndexOf: from model and: to model.
					"Transcript show: 'Jac index of t', from model idPopulation asString, ' and: t', to model idPopulation asString, ' is: ', jacIndex asString, String cr."
					edges add: (RSLine new 
					model: from model -> to model;
					width: jacIndex ** 2;
					from: from;
					to: to;
					yourself ) ] ] ] ]
	")".
	RSVerticalLineLayout new gapSize: 20; on: group.
	canvas addAll: (group collect: #yourself).
	canvas addAll: (edges collect: #yourself).
	"group do: [ :com |
		RSEdgeBuilder line 
				canvas: canvas;
				shapes: (com shapes collect: #yourself);
				width: 1;
				color: Color black;
				connectToAll: (com shapes collect: #model) ]."
	canvas @ RSCanvasController.
	^ canvas
	
]

{ #category : #'as yet unclassified' }
SGAViz >> executedMethodsByGeneration [
	^ self logs collect: [:log | 
		(log summaryTargetClass 
			select: [ :summ | summ isNotNil and: [ summ executed ] ]) size ]
]

{ #category : #'as yet unclassified' }
SGAViz >> groupTestCases: testCases ofColor: dictColor and: size [	
	| group index |
	group := RSGroup new.
	index := 0.
	group addAll: (testCases collect: [:tC | 
		index := index + 1.
		RSComposite new 
			addShape: (RSEllipse new 
				size: (size/12)@(size/12); 
				color: (dictColor at: 'testcaseNode');
				draggable;
				yourself);
			addShape: (RSLabel new 
				text: 't', index asString;
				color: (dictColor at: 'testcaseFontColor');
				fontSize: (size/25);
				bold;
				position: 0@0);
			model: tC;
			adjustToChildren;
			yourself.
		 ]).
	RSCircleLayout new radius: size / 2; on: group.
	^ RSComposite new
		shapes: (group collect: #yourself);
		"paint: Color blue;"
		model: testCases;
		draggable
	
]

{ #category : #'as yet unclassified' }
SGAViz >> groupTestCases: testCases with: dictColor and: canvas [	
	| group index |
	group := RSGroup new.
	index := 0.
	group addAll: (testCases collect: [:tC | 
		index := index + 1.
		RSComposite new 
			addShape: (RSEllipse new 
				size: 25@25; 
				color: Color gray lighter lighter lighter;
				draggable;
				yourself);
			addShape: (RSLabel new 
				text: 't', index asString;
				color: Color black;
				position: 0@0);
			model: tC;
			adjustToChildren;
			yourself.
		 ]).
	RSCircleLayout new radius: testCases size * 20; on: group.
	^ RSComposite new
		shapes: (group collect: #yourself);
		"paint: Color blue;"
		model: testCases;
		draggable
	
]

{ #category : #'as yet unclassified' }
SGAViz >> groupTestCases: testCases with: testIds ofColor: dictColor and: size [	
	| group index |
	group := RSGroup new.
	index := 0.
	group addAll: (testCases collect: [:tC | 
		index := index + 1.
		RSComposite new 
			addShape: (RSEllipse new 
				size: (size/12)@(size/12); 
				color: (((testIds at: tC generationNumber ifAbsent: [#()]) includes: tC idPopulation) ifTrue: [ dictColor at: 'markedTestCaseNode' ] ifFalse: [ 'testcaseNode' ] )"(dictColor at: 'testcaseNode')";
				draggable;
				yourself);
			addShape: (RSLabel new 
				text: 't', index asString;
				color: (dictColor at: 'testcaseFontColor');
				fontSize: (size/25);
				bold;
				position: 0@0);
			model: tC;
			adjustToChildren;
			yourself.
		 ]).
	RSCircleLayout new radius: size / 2; on: group.
	^ RSComposite new
		shapes: (group collect: #yourself);
		"paint: Color blue;"
		model: testCases;
		draggable
	
]

{ #category : #'as yet unclassified' }
SGAViz >> infoDiscoveredMethods: yPositions withScale: scale and: values [
	| points |
	points := OrderedCollection new add: 0@0; yourself.
	points addAll: (values withIndexCollect: [:val :index | 
		(scale scale: val) @ (yPositions at: index).
		]).
	^ points
]

{ #category : #'as yet unclassified' }
SGAViz >> infoEvolutionPoints: yPositions withScale: scale [
	| points index |
	points := OrderedCollection new add: 0@0; yourself.
	index := 0.
	points addAll: (self logs collect: [:log | 
		index := index + 1.
		(scale scale: (log typeInfoGeneration allMethods select: [ :meth | meth executions > 0 and: [ (meth returnType types size > 1 or: [ meth argTypes isNotEmpty ]) or: [    meth returnType types first ~= #SUndefinedObject ] ] ]) size) @ (yPositions at: index).
		]).
	^ points
]

{ #category : #'as yet unclassified' }
SGAViz >> infoTypeEvolutionWith: dictColor [
| canvas composite scale points axis spaceStick xMax yMax size yPositions|
   canvas := RSCanvas new.
	size := 800 @ 200.
	yPositions := (0 to: self engine numberOfGenerations) collect: [:n | n * 100 ].
	composite := RSComposite new 
		color: Color transparent.
	xMax := self logs last typeInfoGeneration allMethods size.
	scale := NSScale linear 
		domain: (Array with: 0 with: xMax);
		range: (Array with: 0 with: size x).
	yMax := yPositions last.
	points := self infoEvolutionPoints: yPositions , #(0) withScale: scale.
	spaceStick := yMax - (0.01 * size y).
	axis := RSPolyline new 
		color: (dictColor at: 'axis');
		width: 10;	
		controlPoints: ((Array with: 0@0 with: 0@spaceStick with: (scale scale:xMax)@spaceStick));
		yourself.
	composite addShape: axis; 
		addShape: (RSPolyline new 
			controlPoints: points; 
			color: "(dictColor at: 'lowestCoverage')" Color red;
			width: 10; yourself).
	self addTickX: composite withScale: scale color: Color black "(dictColor at: 'font')" y: yMax and: xMax @ size y.
	self addTickY: composite withScale: scale xMax: xMax ofColor: "(dictColor at: 'font')" Color black andPositions:  yPositions.
   canvas add:	composite adjustToChildren.
	canvas @ RSCanvasController.
	^ canvas
]

{ #category : #'as yet unclassified' }
SGAViz >> jaccarIndexOf: testCase1 and: testCase2 [
	| block targetClass group1 group2 intersect union |
	targetClass := self engine targetClassName.
	block := [ :tC | 
		tC summaryExecutionMethods 
			select: [ :sum | sum executed and: [ sum executorClass beginsWith: targetClass ] ]
			thenCollect: [ :sum | sum selector ]
		 ].
	group1 := block value: testCase1.
	group2 := block value: testCase2.
	intersect := (group1 intersection: group2) size.
	union := (group1 union: group2) size.
	^ (intersect == 0 and: [ union == 0 ]) 
		ifTrue: [ 1 ] 
		ifFalse: [ [intersect / union] on: ZeroDivide do: [ 0 ]]
]

{ #category : #'as yet unclassified' }
SGAViz >> jaccarIndexStaticOf: testCase1 and: testCase2 [
	| targetClass group1 group2 intersect union |
	targetClass := self engine targetClassName.
	group1 := self calledSelectors: targetClass by: testCase1.
	group2 := self calledSelectors: targetClass by: testCase2.
	intersect := (group1 intersection: group2) size.
	union := (group1 union: group2) size.
	^ (intersect == 0 and: [ union == 0 ]) 
		ifTrue: [ 1 ] 
		ifFalse: [ [intersect / union] on: ZeroDivide do: [ 0 ]]
]

{ #category : #'as yet unclassified' }
SGAViz >> similarityByGeneration: dictColor [
	| canvas group col edges jacIndexes minMax cols factor |
   canvas := RSCanvas new.
	group := RSGroup new.
	col := self engine logs collect: #population.
	edges := RSGroup new.
	factor := 2.
	group addAll: (
		col collect: [ :tCs |
			self groupTestCases: tCs with: dictColor and: canvas ] ).
	jacIndexes := col collect: [ :tCs | 
		(tCs flatCollect: [ :tC1 |
			tCs select: [ :tC2 | tC2 generationNumber ~= tC1 generationNumber 
						or: [ tC2 idPopulation ~= tC1 idPopulation ] ]
				thenCollect: [ :tC2 | self jaccarIndexOf: tC1 and: tC2 ] ]) asSet ].
	minMax := (jacIndexes withIndexCollect: [ :colJac :index | 
		index -> (Array with: colJac min with: colJac max ) ]) asDictionary.
	cols := OrderedCollection new.
	group do: [ :comp | 
				comp shapes do: [:from |
					cols add: (comp shapes select: [ :to | 
						(from model generationNumber ~= to model generationNumber 
						or: [ from model idPopulation ~= to model idPopulation ]) ]
					thenCollect: [ :to | "| jacIndex |
					jacIndex := self jaccarIndexOf: from model and: to model."
					"edges add: "(RSLine new 
					model: from model -> to model;
					"width: jacIndex;"
					from: from;
					to: to;
					yourself ) ] ) ] ].
	RSVerticalLineLayout new gapSize: 20; on: group.
	cols do: [ :sps |
	RSNormalizer new
		from: (minMax at: sps first model key generationNumber) first * factor;
		to: (minMax at: sps first model key generationNumber) second * factor;
		shapes: sps;
		executeBlock: [ :shape :val | shape width: val ];
		normalize: [ :assoc | self jaccarIndexOf: assoc key and: assoc value ].
		edges addAll: sps ].
	canvas addAll: (group collect: #yourself).
	canvas addAll: (edges collect: #yourself).
	canvas @ RSCanvasController.
	^ canvas
	
]
