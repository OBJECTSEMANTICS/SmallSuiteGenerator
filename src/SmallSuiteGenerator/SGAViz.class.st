Class {
	#name : #SGAViz,
	#superclass : #SObject,
	#instVars : [
		'aTestCaseFactory'
	],
	#category : #'SmallSuiteGenerator-Strategies'
}

{ #category : #'gt-inspector-extension' }
SGAViz class >> gtInspectorCanvasIn: composite for: testCaseFactory [
	composite roassal3
		title: 'GenerationEvolution';
		initializeCanvas: [ self new aTestCaseFactory: testCaseFactory; generationEvolutionCanvas ]
]

{ #category : #'gt-inspector-extension' }
SGAViz class >> gtInspectorViewIn: composite for: testCaseFactory [
	composite roassal3
		title: 'Evolution';
		initializeCanvas: [ self new aTestCaseFactory: testCaseFactory; visualizeEvolutionFitness ]
]

{ #category : #accessing }
SGAViz >> aTestCaseFactory [
	^ aTestCaseFactory
]

{ #category : #accessing }
SGAViz >> aTestCaseFactory: anObject [
	aTestCaseFactory := anObject
]
