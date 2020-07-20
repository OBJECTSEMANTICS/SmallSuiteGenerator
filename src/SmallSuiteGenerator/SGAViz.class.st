Class {
	#name : #SGAViz,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-Builder'
}

{ #category : #'gt-inspector-extension' }
SGAViz class >> gtInspectorCanvasIn: composite for: testCaseFactory [
	composite roassal3
		title: 'GenerationEvolution';
		initializeCanvas: [ testCaseFactory generationEvolutionCanvas ]
]

{ #category : #'gt-inspector-extension' }
SGAViz class >> gtInspectorViewIn: composite for: testCaseFactory [
	composite roassal3
		title: 'Evolution';
		initializeCanvas: [ testCaseFactory visualizeEvolutionFitness ]
]
