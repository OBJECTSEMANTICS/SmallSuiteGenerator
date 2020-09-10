"
I am the standard visualization class that SmallSuiteGeneration has, I show two types of visualizations:

- Fitness evolution: a line graph that shows the evolution of fitness through the generations; a line is displayed for the best, worst and average fitness.

- TestEvoViz: a complex chart made up of 3 subgraphs: Generation evolution, TestCase evolution and Coverage evolution

"
Class {
	#name : #SGANullViz,
	#superclass : #SGAAbstractViz,
	#category : #'SmallSuiteGenerator-Strategies'
}

{ #category : #'gt-inspector-extension' }
SGANullViz class >> gtInspectorCanvasIn: composite for: testCaseFactory [
	
]

{ #category : #'gt-inspector-extension' }
SGANullViz class >> gtInspectorViewIn: composite for: testCaseFactory [
	
]
