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
