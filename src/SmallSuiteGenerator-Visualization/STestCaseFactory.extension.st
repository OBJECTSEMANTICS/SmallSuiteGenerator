Extension { #name : #STestCaseFactory }

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory >> gtInspectorViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal3
		title: 'Evolution';
		initializeCanvas: [ self visualizeEvolutionFitness ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory >> visualizeEvolutionFitness [
	| colors canvas legend extent |
	colors := NSScale category20b range.
	canvas := RSCanvas new.
	extent := 300@200.
	scale := NSScale linear 
		domain: (Array with: 0@0 with: (numberOfIterations + 1)@100);
		range: (Array with: 0@extent y with: extent x @ 0).
	canvas add: (RSPolyline new
		controlPoints:  ({ 1@100. 1@0. (numberOfIterations + 2)@0} collect: [:p| scale scale: p]);
		markerStartEnd: (RSShapeFactory arrow
			extent: 10@15;
			color: Color black);
		yourself).
	legend := RSLegend new 
		title: 'Fitness evolution';
		container: canvas;
		yourself.
	self fitnessValues associations doWithIndex: [ :association :index | 
		canvas add: (RSPolyline new
			color: (colors at: index);
			controlPoints: (association value collect: [:p | scale scale: p]);
			yourself).
		legend text: association key withBoxColor: (colors at: index)
		 ].
	legend leyendDo: [ :l |
		l
			draggable;
			withBorder;
			padding: 20;
			scaleBy: 0.5 ].
	legend location offset: 10.
	legend build.
	canvas @ RSCanvasController.
	^ canvas
]
