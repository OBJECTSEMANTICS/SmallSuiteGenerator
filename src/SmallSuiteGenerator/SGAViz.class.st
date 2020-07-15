Class {
	#name : #SGAViz,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #'gt-inspector-extension' }
SGAViz class >> gtInspectorCanvasIn: composite for: testCaseFactory [
	composite roassal3
		title: 'GenerationEvoution';
		initializeCanvas: [ testCaseFactory generationEvolutionCanvas ].
	"SPlatform vizClass: nil"
]

{ #category : #'gt-inspector-extension' }
SGAViz class >> gtInspectorViewIn: composite for: testCaseFactory [
	composite roassal3
		title: 'Evolution';
		initializeCanvas: [ testCaseFactory visualizeEvolutionFitness ].
	SPlatform vizClass: nil
]
