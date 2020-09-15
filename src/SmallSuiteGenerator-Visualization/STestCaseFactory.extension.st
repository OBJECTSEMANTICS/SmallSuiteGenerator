Extension { #name : #STestCaseFactory }

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory >> generateViews [
	self vizClass: SGAViz;
		logClass: SGALog
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory >> generationEvolutionCanvas [
	^ (self class vizClass on: self) generationEvolutionCanvas
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory >> gtInspectorCanvasIn: composite [
	<gtInspectorPresentationOrder: -5>
	self class vizClass gtInspectorCanvasIn: composite for: self
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory >> gtInspectorViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	self class vizClass gtInspectorViewIn: composite for: self
]
