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

{ #category : #accessing }
SGAViz >> aTestCaseFactory [
	^ aTestCaseFactory
]

{ #category : #accessing }
SGAViz >> aTestCaseFactory: anObject [
	aTestCaseFactory := anObject
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
