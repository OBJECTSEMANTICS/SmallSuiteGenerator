Extension { #name : #STestCaseFactory }

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory >> gtInspectorViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal3
		title: 'View';
		initializeView: [ self visualizeR3 ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory >> visualize [
	| p g d |
	p := RTPalette c3.
	g := RTGrapher new.
	self fitnessValues associations doWithIndex: [ :association :index | 
		d := RTData new.
		d
			connectColor: (p at: index);
			noDot;
			points: association value;
			label: association key.
		g add: d ].
	g legend addText: 'Fitness evolution'.
	^ g
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory >> visualizeR3 [
	| colors canvas legend |
	colors := NSScale category20b range.
	canvas := RSCanvas new.
	legend := RSLegend new 
		container: canvas;
		title: 'Fitness evolution'.
	self fitnessValues associations doWithIndex: [ :association :index | 
		canvas add: (RSPolyline new
			color: (colors at: index);
			controlPoints: association value).
		legend text: association key withBoxColor: (colors at: index)
		 ].
	legend leyendDo: [ :l |
		l
			withBorder;
			padding: 20 ].
	legend build.
	canvas @ RSCanvasController.
	^ canvas
]
