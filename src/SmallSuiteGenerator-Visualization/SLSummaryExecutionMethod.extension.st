Extension { #name : #SLSummaryExecutionMethod }

{ #category : #'*SmallSuiteGenerator-Visualization' }
SLSummaryExecutionMethod >> gtInspectorSourceIn: composite [
	<gtInspectorPresentationOrder: 1>
	^ composite pharoMethod
		title: 'Source';
		display: [ self code ]
]
