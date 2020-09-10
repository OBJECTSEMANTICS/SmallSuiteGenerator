"
I am an abstract class to generate the visualization of the genetic algorithms.

I define the necessary methods that must be implemented to show the visualization from the inspector of the STestCaseFactory class
"
Class {
	#name : #SGAAbstractViz,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-Strategies'
}

{ #category : #'gt-inspector-extension' }
SGAAbstractViz class >> gtInspectorCanvasIn: composite for: testCaseFactory [
	self shouldBeImplemented 
]

{ #category : #'gt-inspector-extension' }
SGAAbstractViz class >> gtInspectorViewIn: composite for: testCaseFactory [
	self shouldBeImplemented 
]
