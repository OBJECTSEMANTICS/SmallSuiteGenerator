Extension { #name : #SGAEngine }

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> articleVisualization [
  | c b1 b2 b3 |
c := RTComposer new.
c gap: 35.

"-------"b1 := RTBox new.
b1 view: c view.
self sparkVisualization: b1.
b1 build.
c group: #abstract.

"-------"b2 := RTComposer new.
b2 view: c view.
self contentVisualization: b2.
b2 build.
c group: #content.

"-------"b3 := RTGrapher new.
b3 view: c view.
b3 evolutionVisualization: b3.
b3 build.
c group: #evolution.

"-------"c move: #content between: #abstract and: #evolution.
c nameGroup: #abstract as: 'Preview'.
c nameGroup: #content as: '#Graphic'.
c nameGroup: #evolution as: 'Evolution Fitness'.
^c view
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> contentVisualization: container [ 
	| shape generations els aBlock |
	generations := numberOfGenerations + 1.
	shape := RTCompositeShape new.
	els :=  shape elementsOn: ((logs flatCollect: #population) 
	select: [:tC | (tC ni = generations or: 
		[ tC allChildren detect: [:tCe |  tCe ni = generations ] ifFound: [ true ] ifNone: [ false ]
		])
	]).
	aBlock := [ :testCase | | builder |
		builder := RTShapeBuilder new.
		builder rectangle 
			size: testCase fitness values first;
			fillColor: (Color blue alpha: 0.3);
			withText.
		container view addAll: (builder elementsOn: (testCase summaryExecutionMethods collect: [:assoc | 
				assoc key -> assoc value first first. "body of method"
			])  ).
	].
	container view addAll: els.
	"els do: [ :element | 
		
	]."
	RTCellLayout on: container view elements.
	container view build.
	^ container view.
	
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> evolutionContainer [
	| composite startPoint endPoint scale extent points values axis polyLine stepY nice niceY generations numbers |
	composite := RSComposite new 
		color: Color black;
		"height: 1000;
		width: 700;"
		draggable.
	stepY := 30.
	generations := numberOfGenerations + 1.
	startPoint := 0 @ 0.
	endPoint := 0 @ stepY.
	points := OrderedCollection new.
	values := OrderedCollection new.
	(self logs collect: #averageFit) reverse doWithIndex: [ :dict :index | 
		| valueFitness x |
		valueFitness := dict values first.
		values add: valueFitness.
		x := (valueFitness - startPoint x) @ 0.
		startPoint := startPoint + x.
		endPoint := endPoint + x.
		points add: startPoint;
		add: endPoint.
		startPoint := endPoint.
		endPoint := (endPoint x) @ (endPoint y + stepY).
	].
	extent := 700@1000.
	scale := NSScale linear 
		domain: {(values min)@0. (values max)@(generations * stepY)};
		range: {0@0. extent x@ extent y negated}.
	axis := RSPolyline new 
		color: Color white;
		controlPoints: ({(values min - (values min * 0.01))@((generations *stepY) + 5). (values min - (values min * 0.01))@0. (values max+ (values max * 0.01))@0} collect: [:p | scale scale: p]);
		markerEnd: (RSShapeFactory arrow
			extent: 5@7;
			color: Color white);
		yourself.
	polyLine := RSPolyline new 
		controlPoints: (points collect: [:p | scale scale: p]); 
		color: Color red;
		yourself.
	composite addShape: axis; addShape: polyLine.
	nice := RSLabelGenerator new searchMin: values min max: values max desired: 5. 
	(nice min to: nice max by: nice step) do: [ :i |
		| aTick lbl |
		aTick := RSLine new startPoint: (scale scale: (i@0));
			color: Color white;
			endPoint: (scale scale: (i@(-2)));
			yourself.
		composite addShape: aTick.
		lbl := RSLabel new 
		fontSize: 20;
		color: Color white;
		text: (i asFloat).
		RSLocation new below move: lbl on: aTick.
		composite addShape: lbl.
		].
	numbers := 1 to: generations.
	niceY := RSLabelGenerator new searchMin: stepY max: (generations * stepY) desired: generations.
	(niceY max to: niceY min by: (niceY step) * -1) doWithIndex: [ :i :index | 
		| tick lbl |
		tick := RSLine new startPoint: (scale scale: (values min - (values min * 0.01)@i));
			color: Color white;
			endPoint: (scale scale: ((values min - (values min * 0.015))@i));
			yourself.
		composite addShape: tick.
		lbl := RSLabel new 	
			fontSize: 20;
			color: Color white;
			text: (numbers at: index).
		RSLocation new outer left move: lbl on: tick.
		composite addShape: lbl.
	].
	composite adjustToChildren"; 
	padding: 2".
	^ composite
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> evolutionContainer: height [
	| composite startPoint endPoint scale extent points values axis polyLine stepY nice niceY generations numbers |
	composite := RSComposite new 
		color: Color black;
		draggable.
	stepY := 30.
	generations := numberOfGenerations + 1.
	startPoint := 0 @ 0.
	endPoint := 0 @ stepY.
	points := OrderedCollection new.
	values := OrderedCollection new.
	(self logs collect: #averageFit) reverse doWithIndex: [ :dict :index | 
		| valueFitness x |
		valueFitness := dict values first.
		values add: valueFitness.
		x := (valueFitness - startPoint x) @ 0.
		startPoint := startPoint + x.
		endPoint := endPoint + x.
		points add: startPoint;
		add: endPoint.
		startPoint := endPoint.
		endPoint := (endPoint x) @ (endPoint y + stepY).
	].
	extent := (height * 0.6)@height.
	scale := NSScale linear 
		domain: {(values min)@0. (values max)@(generations * stepY)};
		range: {0@0. extent x@ extent y negated}.
	axis := RSPolyline new 
		color: Color white;
		width: 10;
		controlPoints: ({(values min - (values min * 0.01))@(generations *stepY). (values min - (values min * 0.01))@0. (values max+ (values max * 0.01))@0} collect: [:p | scale scale: p]);
		markerEnd: (RSShapeFactory arrow
			extent: 10@10;
			color: Color white);
		yourself.
	polyLine := RSPolyline new 
		controlPoints: (points collect: [:p | scale scale: p]); 
		color: Color red;
		width: 10;
		yourself.
	composite addShape: axis; addShape: polyLine.
	nice := RSLabelGenerator new searchMin: values min max: values max desired: 5. 
	(nice min to: nice max by: nice step) do: [ :i |
		| aTick lbl |
		aTick := RSLine new startPoint: (scale scale: (i@0));
			color: Color white;
			width: 10;
			endPoint: (scale scale: (i@(-3)));
			yourself.
		composite addShape: aTick.
		lbl := RSLabel new 
		fontSize: (height*0.02);
		color: Color white;
		text: (i asFloat) asString, '%'.
		RSLocation new below move: lbl on: aTick.
		composite addShape: lbl.
	].
	composite addShape: (RSLabel new 
			fontSize: (height*0.02);
			color: Color white;
			text: 'Evolution coverage %';
			position: (scale scale: (values min + ((values max-values min)/2))@ -15)).
	"numbers := 1 to: generations.
	niceY := RSLabelGenerator new searchMin: stepY max: (generations * stepY) desired: generations.
	(niceY max to: niceY min by: (niceY step) * -1) doWithIndex: [ :i :index | 
		| tick lbl |
		tick := RSLine new startPoint: (scale scale: (values min - (values min * 0.01)@i));
			color: Color white;
			width: 10;
			endPoint: (scale scale: ((values min - (values min * 0.02))@i));
			yourself.
		composite addShape: tick.
		lbl := RSLabel new 	
			fontSize: (height*0.02);
			color: Color white;
			text: (numbers at: index).
		RSLocation new outer left move: lbl on: tick.
		composite addShape: lbl.
	]."
	composite adjustToChildren.
	^ composite
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> evolutionContainerOfHeight: height andStartX: aNumber [
	| composite startPoint endPoint scale extent points values axis polyLine stepY nice niceY generations numbers |
	composite := RSComposite new 
		color: Color black;
		draggable.
	stepY := 30.
	generations := numberOfGenerations + 1.
	startPoint := aNumber @ 0.
	endPoint := aNumber @ stepY.
	points := OrderedCollection new.
	values := OrderedCollection new.
	(self logs collect: #averageFit) reverse doWithIndex: [ :dict :index | 
		| valueFitness x |
		valueFitness := dict values first.
		values add: valueFitness.
		x := (valueFitness + aNumber - startPoint x) @ 0.
		startPoint := startPoint + x.
		endPoint := endPoint + x.
		points add: startPoint;
		add: endPoint.
		startPoint := endPoint.
		endPoint := (endPoint x) @ (endPoint y + stepY).
	].
	extent := (height * 0.6)@height.
	scale := NSScale linear 
		domain: {(values min )@0. (values max )@(generations * stepY)};
		range: {0@0. (extent x + aNumber)@ extent y negated}.
	axis := RSPolyline new 
		color: Color white;
		width: 10;
		controlPoints: ({(aNumber)@(generations *stepY). (aNumber)@0. (values max+ (values max * 0.01) + aNumber)@0} collect: [:p | scale scale: p]);
		markerEnd: (RSShapeFactory arrow
			extent: 5@7;
			color: Color white);
		yourself.
	polyLine := RSPolyline new 
		controlPoints: (points collect: [:p | scale scale: p]); 
		color: Color red;
		width: 10;
		yourself.
	composite addShape: axis; addShape: polyLine.
	nice := RSLabelGenerator new searchMin: values min max: values max desired: 5. 
	(nice min to: nice max by: nice step) do: [ :i |
		| aTick lbl |
		aTick := RSLine new startPoint: (scale scale: (i@0));
			color: Color white;
			width: 10;
			endPoint: (scale scale: (i@(-3)));
			yourself.
		composite addShape: aTick.
		lbl := RSLabel new 
		fontSize: (height*0.03);
		color: Color white;
		text: (i asFloat).
		RSLocation new below move: lbl on: aTick.
		composite addShape: lbl.
		].
	"numbers := 1 to: generations.
	niceY := RSLabelGenerator new searchMin: stepY max: (generations * stepY) desired: generations.
	(niceY max to: niceY min by: (niceY step) * -1) doWithIndex: [ :i :index | 
		| tick lbl |
		tick := RSLine new startPoint: (scale scale: (values min - (values min * 0.01)@i));
			color: Color white;
			width: 10;
			endPoint: (scale scale: ((values min - (values min * 0.02))@i));
			yourself.
		composite addShape: tick.
		lbl := RSLabel new 	
			fontSize: (height*0.03);
			color: Color white;
			text: (numbers at: index).
		RSLocation new outer left move: lbl on: tick.
		composite addShape: lbl.
	]."
	composite adjustToChildren.
	^ composite
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> infoCoverageContainer [
	| testCaseGroup list generations |
	testCaseGroup := RSGroup new.
	generations := numberOfGenerations + 1.
	list := ((logs flatCollect: #population) select: [:tC | (tC generationNumber = generations or: [ tC allChildren detect: [:tCe |  tCe generationNumber = generations ] ifFound: [ true ] ifNone: [ false ]])]) asSet.
	(list groupedBy: [:tC | tC generationNumber]) do: [ :testCases | 
		| group |
		group := RSGroup new.
		group addAll: (testCases collect: [ :testCase | 
			self visualizationCoverageMethods: testCase	
		]).
		RSHorizontalLineLayout new gapSize: 20; on: group.
		testCaseGroup add: group.
	].
	RSVerticalLineLayout new on: testCaseGroup; gapSize: 30.
	testCaseGroup edges connectFromAll: [ :testCase | testCase parents ].
	^ RSComposite new shapes: (testCaseGroup flatCollect: #yourself)
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> infoCoverageContainer: canvas [
	| generationGroup list generations memo |
	generationGroup := RSGroup new.
	generations := numberOfGenerations + 1.
	list := ((logs flatCollect: #population) select: [:tC | (tC generationNumber = generations or: [ tC allChildren detect: [:tCe |  tCe generationNumber = generations ] ifFound: [ true ] ifNone: [ false ]])]).
	memo := SMemo new.
	(list groupedBy: [:tC | tC generationNumber]) do: [ :testCases | 
		| group |
		group := RSGroup new.
		group addAll: (testCases collect: [ :testCase | 
			self visualizationCoverageMethods: testCase	 using: memo.
		]).
		RSHorizontalLineLayout new gapSize: 20; on: group.
		generationGroup add: group.
	].
	RSVerticalLineLayout new gapSize: 100;  on: generationGroup.
	"testCaseGroup edges connectFromAll: [ :testCase | testCase parents ]."
	RSEdgeBuilder line 
		shapes: (generationGroup flatCollect: #yourself);
		canvas: canvas;
		width: 5;
		color: Color white;
		connectFromAll: [ :testCase | testCase parents ].
		"connectFrom: [ :value | value //2 ] to: #yourself."
	^ generationGroup flatCollect: #yourself
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> isCoverageSummary: summaryMethod of: testCase newOrHigherThan: previous using: memo [
	| prevSummaries currentCoverage |
	prevSummaries := previous select: [:summary | summary selector = summaryMethod selector].
	prevSummaries ifEmpty: [ ^ true ].
	currentCoverage := self percentCoverage: summaryMethod.
	^ prevSummaries 
		anySatisfy: [ :summary | 
			memo at: summary of: testCase 
			ifPresent: [ :value | value < currentCoverage ]
			ifAbsent: [ false ] ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> percentCoverage: summaryExecMethod [
	^ summaryExecMethod summaryStatements 
		ifEmpty: [ 100 ] 
		ifNotEmpty: [ ((summaryExecMethod summaryStatements select: #executed) size / summaryExecMethod summaryStatements size) asFloat * 100 ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> summaryContainer [
  	| es shape block blockMetric dict |
	dict := Dictionary new.
	block := [ :log | (log population flatCollect: [ :t | 
			(t summaryExecutionMethods collect: [:summary | 
				(summary executorClass -> summary selector)]) asSet ]) asSet ].
	dict at: #nClasses put: (
		Array with: 
			[:model | ((block value: model ) collect: [ :assoc | (assoc key splitOn: ' ') first ]) size / self typeInfo classes size] 
		with: Color blue);
	at: #nMethods put: (
		Array with: 
			[:model | (block value: model) size / (self typeInfo types flatCollect: #allMethods) size ] with: Color white);
	at: #fitnessByClass put: (
		Array with: 
			[:model | (model fittestTestCase fitness values first "fitnessByClass values first at: targetClassName") /100  ]
		with: Color yellow).
	blockMetric := [ :model :metric | 
		(dict at: metric) first value: model].
  shape := RTSparkCircle new.
		shape size: 20;
		names: [ :model | #(#nClasses #nMethods #fitnessByClass) ];
		percent: blockMetric; 
		oldMetric: blockMetric;
		colorBlock: [ :model :metric | (dict at: metric) second].
  es := shape elementsOn: logs.
	RTVerticalLineLayout new gapSize: 5; on: es.
  ^ es
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizateMethods: aView [
	|  populationGroup el |
	populationGroup := RTGroup new.
	self population collect: [:testCase | testCase summaryExecutionMethods associations ] thenDo: [:assocs |
		| group |
		group := RTGroup new.
		assocs do: [ :assoc | 
			group add: (self visualizeMethod: assoc key with: assoc value in: aView).
		].
		RTGridLayout on: group.
		"aView add: group."
		populationGroup add: group	
	].
	el := (RTBox new width: self population size * 20; height: 50) element"On: populationGroup".
	el @ RTDraggable.
	"el elementOn: populationGroup."
	"RTHorizontalLineLayout on: populationGroup."
	RTNest new layout: RTHorizontalLineLayout new; on: el nest: populationGroup.
	aView add: el;
	add: populationGroup.
	^ aView
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizationCoverageMethods: testCase [ 
	| group |
	group := RSGroup new.
	group add: (self visualizationMethodsOf: testCase);
	add: (self visualizationCoverageOf: testCase).
	RSVerticalLineLayout on: group.
	^ RSComposite new 
		shapes: (group flatCollect: #yourself);
		paint: (Color r: 0.5 g: 0.57 b: 0.6);
		model: testCase;
		padding: 10;
		draggable 
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizationCoverageMethods: testCase using: memo [
	| group |
	group := RSGroup new.
	group add: (self visualizationMethodsOf: testCase using: memo);
	add: (self visualizationCoverageOf: testCase).
	RSVerticalLineLayout on: group.
	^ RSComposite new 
		shapes: (group flatCollect: #yourself);
		paint: (Color r: 0.5 g: 0.57 b: 0.6);
		model: testCase;
		padding: 10;
		draggable 
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizationCoverageOf: testCase [ 
	| group groupData1 groupData2 textPr textCl |
	group := RSGroup new.
	groupData1 := RSGroup new.
	textPr := testCase fitness values first.
	groupData1 
		add: (RSLabel new text: 'Project Coverage:'; color: Color white; fontSize: 8);
		add: (RSBox new height: 10; color: Color red; width: textPr);
		add: (RSLabel new text: textPr asString, '%'; color: Color white; fontSize: 8).
	RSHorizontalLineLayout on: groupData1.
	group add: (RSComposite new shapes: groupData1 ).
	groupData2 := RSGroup new.
	textCl := testCase fitnessByClass values first at: targetClassName.
	groupData2 
		add: (RSLabel new text: 'Class Coverage'; color: Color white; fontSize: 8);
		add: (RSBox new height: 10; color: Color blue; width: textCl);
		add: (RSLabel new text: textCl asString, '%'; color: Color white; fontSize: 8).
	RSHorizontalLineLayout on: groupData2.
	group add: (RSComposite new shapes: groupData2).
	RSVerticalLineLayout on: group.
	^ group
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizationExecutionMethod: summaryExecMethod [
	| max indStatement nLine group string |
	group := RSGroup new.
	string := summaryExecMethod code.
	max := summaryExecMethod summaryStatements size.
	indStatement := 1.
	nLine := 1.
	string lines doWithIndex: [ :line :indLine | 
		| groupLabel found subString index lastStr |
		groupLabel := RSGroup new.
		found := false.
		indStatement  <= max ifTrue: [ 
			nLine <= (summaryExecMethod summaryStatements at: indStatement) code lines size 
				ifFalse: [ nLine := 1. 
					indStatement := indStatement + 1 ]].
		indStatement <= max ifTrue: [ 
			subString := ((summaryExecMethod summaryStatements at: indStatement) code lines at: nLine) trimLeft: [:char | char = Character tab].
			index := line indexOfSubCollection: subString.
			found := index > 0.
		].
		found ifTrue: [ 
			groupLabel 
				add: (RSLabel new color: Color pink; text: ((line copyFrom: 1 to: index - 1) trimLeft: [:char | char = Character tab]));
				add: (RSLabel new color: ((summaryExecMethod summaryStatements at: indStatement) executed ifTrue: [ Color pink ] ifFalse: [ Color white ]); text: subString).
			lastStr := line copyFrom: index + subString size to: line size.
			lastStr ifNotEmpty: [ groupLabel add: (RSLabel new color: Color pink; text: lastStr) ].
			nLine := nLine + 1
		].
		found ifFalse: [ groupLabel add: (RSLabel new color: (indLine ~= 1 ifTrue: [ Color pink ] ifFalse: [ Color white ]) "((max = 0 and: [ indLine ~= 1 ]) ifTrue: [ Color pink ] ifFalse: [ Color white ])"; text: (line trimLeft: [:char | char = Character tab ]) ) ].
		RSHorizontalLineLayout new on: groupLabel; gapSize: 0.
		group add: groupLabel
	].
	RSVerticalLineLayout new gapSize: 0; on: group.
	^ RSComposite new 
		shapes: (group flatCollect: #yourself);
		paint: Color black;
		model: summaryExecMethod;
		padding: 10;
		draggable.
	
	
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizationExecutionMethods: array [
	| group |
	group := RSGroup new.
	group addAll: (array collect: [:summaryMethod | self visualizationExecutionMethod: summaryMethod ]).
	RSGridLayout on: group.
	^ RSComposite new 
		shapes: (group collect: #yourself);
		paint: Color gray;
		model: array;
		padding: 10;
		draggable.
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizationMethods: aView [
	| builder |
	builder := RTShapeBuilder new.
	builder rectangle 
				height: [:str | str lineCount * 30 ]; 
				width: [ :str | (str lines collect: #size) max * 10 ];
				fillColor: (Color black alpha: 0.3);
				withText.
	aView addAll: (builder elementsOn: (self population collect: [:testCase | 
		|assoc |
		assoc := testCase summaryExecutionMethods associations first.
		assoc key asString, String cr, assoc value first second ])).
	RTCellLayout on: aView elements.
	aView build.
	^ aView 
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizationMethodsOf: testCase [ 
	| group |
	group := RSGroup new.
	group addAll: (testCase summaryExecutionMethods 
		select: [:summary | summary executorClass = self targetClassName 
			or: [ (summary executorClass splitOn: ' ') first = self targetClassName ] ] 
		thenCollect: [:summary | 
			self visualizationSummary: summary
	]).
	RSGridLayout on: group.
	^ group
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizationMethodsOf: testCase using: memo [
	| group conditionBlock prevSummaryMethods |
	group := RSGroup new.
	conditionBlock := [:summary | (summary executorClass = self targetClassName) 
			or: [ (summary executorClass splitOn: ' ') first = self targetClassName ] ].
	prevSummaryMethods := (testCase parents
		flatCollect: [:tC | tC summaryExecutionMethods select: [ :summary | conditionBlock value: summary ]
			]) asSet.
	group addAll: (testCase summaryExecutionMethods 
		select: [:summary | (conditionBlock value: summary) and: [ 
				self isCoverageSummary: summary of: testCase newOrHigherThan: prevSummaryMethods using: memo
				"testCase generationNumber = 1 or: [ 
				dictionary at: summary selector 
					ifPresent: [ :value | 
						value < (summary summaryStatements 
							ifEmpty: [100] 
							ifNotEmpty: [((summary summaryStatements select: #executed) size / summary summaryStatements size) asFloat * 100 ])] 
					ifAbsent: [ true ] ]" ] ]
		thenCollect: [:summary | 
			self visualizationSummary: summary of: testCase using: memo
		]).
	RSGridLayout on: group.
	^ group
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizationPaper [
	| canvas coverageContainer |
	canvas := RSCanvas new 
		color: Color black.
	coverageContainer := self infoCoverageContainer: canvas.
	canvas 
		"addAll: (self summaryContainer: canvas);"
		addAll: coverageContainer;
		add: (self evolutionContainer: coverageContainer height).
	"RSHorizontalLineLayout new gapSize: 10; on: group."
	"containers := RSComposite new 
		shapes: containers;
		paint: Color black;
		padding: 10;
		draggable."
	canvas @ RSCanvasController.
	^ canvas
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizationSummary: summaryExecMethod [
	| percent |
	percent := (summaryExecMethod summaryStatements ifEmpty: [ 100 ] ifNotEmpty: [ ((summaryExecMethod summaryStatements select: #executed) size / summaryExecMethod summaryStatements size) asFloat * 100 ]) + 20.
	^ RSComposite new size: percent; 
		color: Color black; 
		addShape: (RSLabel new color: Color white; 
						text: (summaryExecMethod executorClass, '->', summaryExecMethod selector);
						fontSize: 8);
		model: summaryExecMethod 
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizationSummary: summaryExecMethod of: testCase using: memo [
	| percent |
	percent := self percentCoverage: summaryExecMethod.
	memo at: summaryExecMethod of: testCase put: percent.
	^ RSComposite new size: percent + 20; 
				color: Color black; 
				addShape: (RSLabel new color: Color white; 
						text: (summaryExecMethod executorClass, '->', summaryExecMethod selector);
						fontSize: 8);
				model: summaryExecMethod
	
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeChartEvolution [
	| canvas startPoint endPoint xs ys |
	canvas := RSChart new.
	startPoint := 0 @ 0.
	endPoint := 0 @ 100.
	xs := OrderedCollection new.
	ys := OrderedCollection new.
	(self logs collect: #averageFit) reverse doWithIndex: [ :dict :index | 
		| valueFitness x |
		valueFitness := dict values first.
		x := (valueFitness - startPoint x) @ 0.
		"x := valueFitness @ 0."
		startPoint := startPoint + x.
		endPoint := endPoint + x.
		xs add: startPoint x;
		add: endPoint x.
		ys add: startPoint y;
		add: endPoint y.
		"xs add: valueFitness.
		ys add: endPoint y."
		"canvas addShape: (RSLine new 
			startPoint: startPoint;
			endPoint: endPoint;
			width: 1;
			capButt;
			color: Color random;
			yourself)."
		startPoint := endPoint "+ ((gap * index) @ 0)".
		endPoint := (endPoint x) @ ("(gap * index)" endPoint y + 100).
	].
	canvas addPlot: (RSLinePlot new x: xs y: ys).
	canvas addDecoration: RSHorizontalTick new integer;
	addDecoration: RSVerticalTick new;
	show
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeChartEvolutionR3 [
	| startPoint endPoint xs ys chart |
	chart := RSChart new.
	startPoint := 0 @ 0.
	endPoint := 0 @ 1.
	xs := OrderedCollection new.
	ys := OrderedCollection new.
	(self logs collect: #averageFit) reverse doWithIndex: [ :dict :index | 
		| valueFitness x |
		valueFitness := dict values first asFloat round: 1.
		x := (valueFitness - startPoint x) @ 0.
		startPoint := startPoint + x.
		endPoint := endPoint + x.
		xs add: (startPoint x asFloat round: 1);
		add: (endPoint x asFloat round: 1).
		ys add: startPoint y;
		add: endPoint y.
		startPoint := endPoint .
		endPoint := (endPoint x) @ (endPoint y + 1).
	].
	chart addPlot: (RSLinePlot new x: xs y: ys).
	chart addDecoration: (RSHorizontalTick new numberOfTicks: 10 );
	addDecoration: RSVerticalTick new.
	chart build.
	^ chart canvas
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeCoverageEvolution [
	| canvas startPoint endPoint scale extent points axis polyLine values |
	canvas := RSCanvas new addInteraction: RSCanvasController.
	startPoint := 0 @ 0.
	endPoint := 0 @ 10.
	points := OrderedCollection new.
	values := OrderedCollection new.
	(self logs collect: #averageFit) reverse doWithIndex: [ :dict :index | 
		| valueFitness x |
		valueFitness := dict values first.
		values add: valueFitness.
		x := (valueFitness - startPoint x) @ 0.
		startPoint := startPoint + x.
		endPoint := endPoint + x.
		points add: startPoint;
		add: endPoint.
		startPoint := endPoint.
		endPoint := (endPoint x) @ (endPoint y + 10).
	].
	"extent := maxValue@(self logs size * 10)."
	extent := 1000@500.
	scale := NSScale linear 
		domain: {0@0. 100@100};
		range: {0@extent y. extent x@ 0}.
	axis := RSPolyline new 
		controlPoints: ({(values min - 1)@ ((self logs size * 10) + 5). (values min - 1)@0. (values max+ (values max * 0.2))@0} collect: [:p | scale scale: p]);
		markerStartEnd: (RSShapeFactory arrow
			extent: 5@7;
			color: Color black);
		yourself.
	polyLine := RSPolyline new 
		controlPoints: (points collect: [:p | scale scale: p]); 
		color: Color red;
		yourself.
	canvas add: axis; add: polyLine.
	^ canvas
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeCoverageEvolutionM [
	| canvas startPoint endPoint scale extent points values axis polyLine nice niceY |
	canvas := RSCanvas new addInteraction: RSCanvasController.
	startPoint := 0 @ 0.
	endPoint := 0 @ 10.
	points := OrderedCollection new.
	values := OrderedCollection new.
	(self logs collect: #averageFit) reverse doWithIndex: [ :dict :index | 
		| valueFitness x |
		valueFitness := dict values first.
		values add: valueFitness.
		x := (valueFitness - startPoint x) @ 0.
		startPoint := startPoint + x.
		endPoint := endPoint + x.
		points add: startPoint;
		add: endPoint.
		startPoint := endPoint.
		endPoint := (endPoint x) @ (endPoint y + 10).
	].
	extent := 200@200.
	scale := NSScale linear 
		domain: {(values min)@0. (values max)@(self logs size * 10)};
		range: {0@0. extent x@ extent y negated}.
	axis := RSPolyline new 
		controlPoints: ({(values min - (values min * 0.01))@((self logs size * 10) + 5). (values min - (values min * 0.01))@0. (values max+ (values max * 0.01))@0} collect: [:p | scale scale: p]);
		markerEnd: (RSShapeFactory arrow
			extent: 5@7;
			color: Color black);
		yourself.
	polyLine := RSPolyline new 
		controlPoints: (points collect: [:p | scale scale: p]); 
		color: Color red;
		yourself.
	canvas add: axis; add: polyLine.
	nice := RSLabelGenerator new searchMin: values min max: values max desired: 5. 
	(nice min to: nice max by: nice step) do: [ :i |
		| aTick lbl |
		aTick := RSLine new startPoint: (scale scale: (i@0));
			endPoint: (scale scale: (i@(-2)));
			yourself.
		canvas addShape: aTick.
		lbl := RSLabel new 
		fontSize: 8;
		text: (i asFloat).
		RSLocation new below move: lbl on: aTick.
			canvas addShape: lbl.
		].
	niceY := RSLabelGenerator new searchMin: 10 max: (self logs size * 10) desired: self logs size.
	(niceY max to: nice min by: (niceY step) * -1) do: [ :i | 
		| tick lbl |
		tick := RSLine new startPoint: (scale scale: (values min - (values min * 0.01)@i));
			endPoint: (scale scale: ((values min - (values min * 0.015))@i));
			yourself.
		canvas addShape: tick.
		lbl := RSLabel new 	
			fontSize: 8;
			text: (niceY max/i) asInteger + ((niceY max \\ i)/10) asInteger.
		RSLocation new outer left move: lbl on: tick.
		canvas addShape: lbl.
	].
	^ canvas
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeCoverageR3 [
	| canvas testCaseGroup list generations |
	canvas := RSCanvas new addInteraction: RSCanvasController.
	testCaseGroup := RSGroup new.
	generations := numberOfGenerations + 1.
	list := ((logs flatCollect: #population) select: [:tC | (tC generationNumber = generations or: [ tC allChildren detect: [:tCe |  tCe generationNumber = generations ] ifFound: [ true ] ifNone: [ false ]])]) asSet.
	"self logs collect: #population thenDo: [ :testCases | "
	(list groupedBy: [:tC | tC generationNumber]) do: [ :testCases | 
		| group |
		group := RSGroup new.
		group addAll: (testCases collect: [ :testCase | 
			self visualizationCoverageMethods: testCase	
		]).
		RSHorizontalLineLayout new gapSize: 20; on: group.
		testCaseGroup add: group.
	].
	RSVerticalLineLayout new on: testCaseGroup; gapSize: 50.
	canvas add: (RSComposite new shapes: (testCaseGroup flatCollect: #yourself)).
	RSEdgeBuilder line 
		shapes: (testCaseGroup flatCollect: #yourself);
		canvas: canvas;
		width: 5;
		color: Color black;
		moveBehind;
		noRepetition;
		connectFromAll: [ :testCase | testCase parents ].
	^ canvas
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeCoverageRSPie [
  	| canvas block  colors |
  	canvas := RSCanvas new.
	block := [ :log | (log population flatCollect: [ :t | 
			(t summaryExecutionMethods collect: [:summary | 
				(summary executorClass -> summary selector)]) asSet ]) asSet ].
	colors := Array  
		with: (Color r: 0.05 g: 0.75 b: 0.91)
		with: (Color r:0.88 g:0.26 b:0.5)
		with: (Color r: 0 g: 1 b: 0.67).
	canvas addAll: (logs collect: [ :log | 
		| spark group |
		group := RSGroup new.
		spark := RSSparkCircleB new
			objects: log;
			container: group;
			slices: (Array 
				with: [:model | ((block value: model ) collect: [ :assoc | (assoc key splitOn: ' ') first ]) size / self typeInfo classes size] 
				with: [:model | (block value: model) size / (self typeInfo types flatCollect: #allMethods) size ]
				with: [:model | (model fittestTestCase fitnessByClass values first at: targetClassName) /100  ]);
		sliceColor: [ :shape | colors at: shape index].
		spark defaultSliceShape innerRadius: 3.
		spark build.
		RSComposite new
			shapes: group;
			yourself. ]).
	RSVerticalLineLayout on: canvas nodes.
	canvas @ RSCanvasController.
  ^ canvas
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeCoverageSparkCircle [
  	| view es shape block blockMetric dict |
  	view := RTView new.
	dict := Dictionary new.
	block := [ :log | (log population flatCollect: [ :t | 
			(t summaryExecutionMethods collect: [:summary | 
				(summary executorClass -> summary selector)]) asSet ]) asSet ].
	dict at: #nClasses put: (
		Array with: 
			[:model | ((block value: model ) collect: [ :assoc | (assoc key splitOn: ' ') first ]) size / self typeInfo classes size] 
		with: (Color r: 0.05 g: 0.75 b: 0.91));
	at: #nMethods put: (
		Array with: 
			[:model | (block value: model) size / (self typeInfo types flatCollect: #allMethods) size ] with: (Color r:0.88 g:0.26 b:0.5));
	at: #fitnessByClass put: (
		Array with: 
			[:model | (model fittestTestCase "fitness values first" fitnessByClass values first at: targetClassName) /100  ]
		with: (Color r: 0 g: 1 b: 0.67)).
	blockMetric := [ :model :metric | 
		(dict at: metric) first value: model].
  shape := RTSparkCircle new.
		shape size: 20;
		names: [ :model | #(#nClasses #nMethods #fitnessByClass) ];
		percent: blockMetric; 
		oldMetric: blockMetric;
		colorBlock: [ :model :metric | (dict at: metric) second].
  es := shape elementsOn: logs.
	view addAll: es.
	view @ RTDraggableView.
	RTVerticalLineLayout new gapSize: 5; on: es.
  ^ view
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeCoverageSparkCircleR3 [
  	| canvas es shape block blockMetric dict group |
  	canvas := RSCanvas new addInteraction: RSCanvasController.
	group := RSGroup new.
	dict := Dictionary new.
	block := [ :log | (log population flatCollect: [ :t | 
			(t summaryExecutionMethods collect: [:summary | 
				(summary executorClass -> summary selector)]) asSet ]) asSet ].
	dict at: #nClasses put: (
		Array with: 
			[:model | ((block value: model ) collect: [ :assoc | (assoc key splitOn: ' ') first ]) size / self typeInfo classes size] 
		with: (Color r: 0.05 g: 0.75 b: 0.91));
	at: #nMethods put: (
		Array with: 
			[:model | (block value: model) size / (self typeInfo types flatCollect: #allMethods) size ] with: (Color r:0.88 g:0.26 b:0.5));
	at: #fitnessByClass put: (
		Array with: 
			[:model | (model fittestTestCase "fitness values first" fitnessByClass values first at: targetClassName) /100  ]
		with: (Color r: 0 g: 1 b: 0.67)).
	blockMetric := [ :model :metric | 
		(dict at: metric) first value: model].
  shape := RSSparkCircle new.
		shape size: 20;
		names: [ :model | #(#nClasses #nMethods #fitnessByClass) ];
		percent: blockMetric; 
		oldMetric: blockMetric;
		colorBlock: [ :model :metric | (dict at: metric) second].
	group addAll: [ :log | RSSparkCircle new.
		shape size: 20;
		model: log;
		names: [ :model | #(#nClasses #nMethods #fitnessByClass) ];
		percent: blockMetric; 
		oldMetric: blockMetric;
		colorBlock: [ :model :metric | (dict at: metric) second]  ].
	RTVerticalLineLayout new gapSize: 5; on: group.
	canvas add: group.
  ^ canvas
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeExecutionMethods [
	| canvas populationGroup |
	canvas := RSCanvas new addInteraction: RSCanvasController.
	populationGroup := RSGroup new.
	self logs collect: #population thenDo: [ :testCases | 
		| group |
		group := RSGroup new.
		testCases collect: [ :testCase | 
			self visualizationExecutionMethods: testCase summaryExecutionMethods
		] thenDo: [:element | 
			canvas add: element.
			group add: element.
		].
		RSHorizontalLineLayout new gapSize: 20; on: group.
		populationGroup add: group.
	].
	RSVerticalLineLayout new gapSize: 20; on: populationGroup.
	^ canvas
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeFitnessEvolution [
	| canvas startPoint endPoint gap |
	canvas := RSCanvas new addInteraction: RSCanvasController.
	startPoint := 0 @ 0.
	endPoint := 0 @ 100.
	gap := 50.
	(self logs collect: #averageFit) doWithIndex: [ :dict :index | 
		| valueFitness x |
		valueFitness := dict values first.
		x := ((valueFitness = startPoint x) ifTrue: [ 0 ] ifFalse: [ valueFitness - startPoint x + 1 ]) @ 0.
		startPoint := startPoint + x.
		endPoint := endPoint + x.
		canvas addShape: (RSLine new 
			startPoint: startPoint;
			endPoint: endPoint;
			width: 1;
			capButt;
			color: Color random;
			yourself).
		startPoint := endPoint "+ ((gap * index) @ 0)".
		endPoint := (endPoint x) @ ("(gap * index)" endPoint y + 100).
	].
	^ canvas
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeM [
  | b es |
  b := RTMondrian new.
  b interaction highlight.
  "b shape rectangle
	  noBorder;
     width: [:cls |  (cls fitnessByClass values first at: targetClassName) * 1.5 ];
     height: [:cls |  cls length * 1.5 ]."
  es := b nodes: (logs flatCollect: #population) forEach: [:testCase |  
	| shape stmts |
	shape := RTCompositeShape new.
   b shape: shape.
   b shape add: (RTBox new color: #mutantColor; width: 1; height: 1);
	add: (RTBox new color: #stmColor; width: 6; height: 1);
	horizontal.
	"b shape width: [ :cls | 5 ];
   height: [ :cls | 6 ]."
   stmts := b nodes: testCase statements.
   stmts @ (RTHighlightable highlight: [:stm | stm allParents]).
        b layout verticalLine gapSize: 0 ].
   es @ (RTHighlightable highlight: [:testCase | 
	testCase allParents
	]).
  es do: [:el | el width: 10; height: (el model length * 2)"; color: Color white"].
  b shape verticalBezierLine.
  b edges moveBehind.
  b edges connectFromAll: [:testCase |  testCase parents ].
  b normalizer normalizeColor: [:testCase |  [testCase fitness values first] on: Error do: [ :e | self halt. 0 ] ] using: (Array with: Color white with: Color black).
  b layout smallSuite.
  
  "b normalizer normalizeColorAsGray: [:testCase |  testCase fitness values first ]."
  ^ b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeMatrix [
  | b es |
  	b := RTMondrian new.
  	b interaction highlight.
  	"b shape rectangle
	  noBorder;
     width: [:cls |  (cls fitnessByClass values first at: targetClassName) * 1.5 ];
     height: [:cls |  cls length * 1.5 ]."
  	es := b nodes: (logs flatCollect: #population) forEach: [:testCase |  
		| shape stmts |
		shape := RTCompositeShape new.
   		b shape: shape.
   		b shape add: (RTBox new color: #mutantColor; width: 1; height: 1);
		add: (RTBox new color: #stmColor; width: 6; height: 1);
		horizontal.
   		stmts := b nodes: testCase statements.
   		stmts @ (RTHighlightable highlight: [:stm | stm allParents]).
      b layout verticalLine gapSize: 0 
	].

   es @ (RTHighlightable highlight: [:testCase | testCase allParents ]).
  	es do: [:el | el width: 10; height: (el model length * 2)"; color: Color white"].
  	b shape verticalBezierLine.
  	b edges moveBehind.
  	b edges connectFromAll: [:testCase |  testCase parents ].
	b normalizer elements: es.
  	b normalizer normalizeColor: [:testCase | testCase fitness values first ] 
	using: (Array with: Color black with: Color white).
  	b layout smallSuite.
  ^ b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeMatrixP [
  | b es generations |
  generations := numberOfGenerations + 1.
  b := RTMondrian new.
  b interaction highlight.
  es := b nodes: ((logs flatCollect: #population) select: [:tC | (tC generationNumber = generations or: [ tC allChildren detect: [:tCe |  tCe generationNumber = generations ] ifFound: [ true ] ifNone: [ false ]])])
"((logs flatCollect: #population) select: [:tC |  tC allChildren detect: [:tCe |  tCe ni = generations ] ifFound: [ true ] ifNone: [ false ] ])" forEach: [:testCase |  | shape stmts |
        shape := RTCompositeShape new.
        b shape: shape.
        b shape
           add: (RTBox new
                 color: #mutantColor;
                 width: 1;
                 height: 1);
           add: (RTBox new
                 color: #stmColor;
                 width: 6;
                 height: 1);
           horizontal.
        stmts := b nodes: testCase statements.
        stmts @ (RTHighlightable highlight: [:stm |  stm allParents ]).
        b layout verticalLine gapSize: 0 ].
  es @ (RTHighlightable highlight: [:testCase |  testCase allParents ]).
  es do: [:el |  el
           width: 10;
           height: el model length * 2
        "; color: Color white" ].
  b shape verticalBezierLine.
  b edges moveBehind.
  b edges connectFromAll: [:testCase |  testCase parents ].
  b normalizer elements: es.
  b normalizer normalizeColor: [:testCase |  testCase fitness values first] using: (Array with: Color black with: Color white)."(Array with: Color red with: Color blue) min:0 max: 100."
  b layout smallSuite.
  ^b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeMethod: assoc [ 
	|string substrings max indSubstring nLine group|
	string := assoc key asString, String cr, assoc value first second.
	substrings := assoc value allButFirst select: [ :data | data first ] 
		thenCollect: [ :data | data second trimLeft: [ :char | char = Character tab] ].
	max := substrings size.
	indSubstring := 1.
	nLine := 1.
	group := RSGroup new.
	string linesDo: [ :line | 
		| groupLabel found subString index lastStr |
		groupLabel := RSGroup new.
		found := false.
		indSubstring  <= max ifTrue: [ 
		nLine <= (substrings at: indSubstring) lines size 
			ifFalse: [ nLine := 1. 
			indSubstring := indSubstring + 1 ].
		subString := (substrings at: indSubstring) lines at: nLine.
		index := line indexOfSubCollection: subString.
		found := index > 0.
		].
		found ifTrue: [ 
			groupLabel 
				add: (RSLabel new color: Color white; text: (line copyFrom: 1 to: index - 1));
				add: (RSLabel new color: Color pink; text: subString).
			lastStr := line copyFrom: index + subString size to: line size.
			lastStr ifNotEmpty: [ groupLabel 
				add: (RSLabel new color: Color white; text: lastStr) ].
		].
		found ifFalse: [ groupLabel add: (RSLabel new color: Color white; text: line ) ].
		RSHorizontalLineLayout on: groupLabel.
		group add: groupLabel
	].
	RSVerticalLineLayout new gapSize: 0; on: group.
	^ RSComposite new 
		shapes: (group flatCollect: #yourself);
		paint: Color black;
		model: 'sadsdfg';
		padding: 10;
		draggable.
	
	
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeMethod: assoc with: list in: aView [
	| bodyMethod execCode indExecCode group max element nLine |
	bodyMethod := assoc key asString, String cr, list first second.
	execCode := list allButFirst select: [ :data | data first ] 
		thenCollect: [ :data | data second ].
	group := RTGroup new.
	indExecCode := 1.
	nLine := 1.
	max := execCode size.
	bodyMethod linesDo: [ :line | 
		| groupLabel found subString index lastStr |
		groupLabel := RTGroup new.
		found := false.
		indExecCode <= max ifTrue: [ 
		nLine <= (execCode at: indExecCode) lines size 
			ifFalse: [ nLine := 1. 
			indExecCode := indExecCode + 1 ].
		subString := (execCode at: indExecCode) lines at: nLine.
		index := line indexOfSubCollection: subString.
		found := index > 0.
		].
		found ifTrue: [ 
			groupLabel add: ((RTLabel new color: Color white) elementOn: ((line copyFrom: 1 to: index - 1) trimLeft: [:char | char = Character tab]));
			add: ((RTLabel new color: Color pink) elementOn: (subString trimLeft: [:char | char = Character tab])).
			lastStr := line copyFrom: index + subString size to: line size.
			lastStr ifNotEmpty: [ groupLabel add: ((RTLabel new color: Color white) elementOn: lastStr) ].
		].
		found ifFalse: [ groupLabel add: ((RTLabel new color: Color white) elementOn: (line trimLeft: [:char | char = Character tab])) ].
		RTHorizontalLineLayout on: groupLabel.
		group add: groupLabel
	].
	RTVerticalLineLayout on: group.
	"element := (RTBox new width: (bodyMethod lines collect: #size) max * 10; height: bodyMethod lines size * 10; color: Color black) elementOn: bodyMethod.
	element @ RTDraggable.
	RTNest new layout: RTVerticalLineLayout new;
	on: element nest: group.
	"
	^ aView
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeRadial [
  | b es firstPopulation root |
  b := RTMondrian new.
  b interaction highlight.
  root := SSTestCase with: typeInfo.
  root addTargetClassName: targetClassName; generateStatements.
  firstPopulation := logs first population.
  firstPopulation do: [ :testCase | testCase addParent: root ].
  es := b nodes: ((Array with: root), (logs flatCollect: #population)) forEach: [:testCase |  
	| shape stmts |
	shape := RTCompositeShape new.
   b shape: shape.
   b shape add: (RTBox new color: #mutantColor; width: 1; height: 1);
	add: (RTBox new color: #stmColor; width: 6; height: 1);
	horizontal.
   stmts := b nodes: testCase statements.
   stmts @ (RTHighlightable highlight: [:stm | stm allParents]).
        b layout verticalLine gapSize: 0 ].
   es @ (RTHighlightable highlight: [:testCase | 
	testCase allParents
	]).
  es do: [:el | el width: 10; height: (el model length * 2)"; color: Color white"].
  b shape verticalBezierLine.
  b edges moveBehind.
  b edges connectFromAll: [:testCase |  testCase parents ].
  b layout radial.
  ^ b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeRadial1 [
  | es view shape |
  "b := RTMondrian new.
  b interaction highlight."
  view := RTView new.
  shape :=  RTEllipse new.
   "es := b nodes: (logs flatCollect: #population)."
  es := shape elementsOn: (logs flatCollect: #population).
   "es := b nodes:  (logs flatCollect: #population) forEach: [:testCase |  
	| shape stmts |
	shape := RTCompositeShape new.
   b shape: shape.
   b shape add: (RTBox new color: #mutantColor; width: 1; height: 1);
	add: (RTBox new color: #stmColor; width: 6; height: 1);
	horizontal.
   stmts := b nodes: testCase statements.
   stmts @ (RTHighlightable highlight: [:stm | stm allParents]).
        b layout verticalLine gapSize: 0 ]."
   es @ (RTHighlightable highlight: [:testCase | 
	testCase allParents
	]).
  es do: [:el | el width: 10; height: (el model length * 2)"; color: Color white"].
  view addAll: es.
  RTEdgeBuilder new 
     view: view; elements: es; connectFrom: [ :testCase | [randomGenerator selectAtRandom: testCase parents] on: Error do: [ testCase parents ]  ]; moveBehind.
  SRadialTreeLayout new on: es.
  "view edges do: #remove."
  ^ view
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeRadial2 [
  	| b objects limit |
	b := RTKiviatBuilder new.
	objects := logs flatCollect: #population.
  limit := populationSize + (populationSize \\ 2 ).
	b objects: objects.
	"b addMetric: [ :o | 
		o collect: #idPopulation  ]."
	(1 to: limit ) do: [:e| 
		b addMetric: [:v | 
			v  generationNumber ]].
	"b objects: (Array with: 'object1' -> ((1 to: 25) collect: [:i |  i atRandom ]) with: 'object2' -> ((1 to: 25) collect: [:i |  i atRandom ])).
b shapes: ((Array with: Color blue with: Color red) do: [:c |  c alpha: 0.3 ]).
(1 to: 25) doWithIndex: [:ei :i |  b addMetric: [:e |  e idPopulation ] ]."
   b build.
   "b view edges do: #remove."
   ^ b view
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeRadial3 [
  	| b objects limit |
	b := SKiviatBuilder new.
	objects := logs collect: #population.
  limit := populationSize + (populationSize \\ 2 ).
	b objects: objects.
	b shape size: [ :e | e model value fitness values first ].
	b shapes: ((RTColorPalette qualitative 
		colors: (numberOfGenerations + 1) scheme: 'Paired') do: [:c |  c alpha: 0.3 ]).
	1 to: limit do: [:i | 
		b addMetric: [ :o | 
		(o at: i) generationNumber ] ].
   "b desactivateHighlight."
	"b objects: (Array with: 'object1' -> ((1 to: 25) collect: [:i |  i atRandom ]) with: 'object2' -> ((1 to: 25) collect: [:i |  i atRandom ])).
b shapes: ((Array with: Color blue with: Color red) do: [:c |  c alpha: 0.3 ]).
(1 to: 25) doWithIndex: [:ei :i |  b addMetric: [:e |  e idPopulation ] ]."
   b build.
	b view elements select: [:el | el shape isKindOf: RTLabel ] thenDo: #remove.
   "b view edges do: #remove."
   ^ b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeRadial3P [
  | b objects limit generations |
  b := SKiviatBuilder new.
  generations := numberOfGenerations + 1.
  objects := (logs flatCollect: #population) select: [:tC |  tC generationNumber = generations or: [ tC allChildren detect: [:tCe |  tCe generationNumber = generations ] ifFound: [ true ] ifNone: [ false ] ] ].
  limit := populationSize + (populationSize \\ 2).
  b objects: objects.
  b shape size: [:e |  e model value fitness values first ].
  b shapes: ((RTColorPalette qualitative colors: numberOfGenerations + 1 scheme: 'Paired') do: [:c |  c alpha: 0.3 ]).
  1 to: limit do: [:i |  b addMetric: [:o |  (o at: i) generationNumber ] ].
  b build.
  b view elements select: [:el |  el shape isKindOf: RTLabel ] thenDo: #remove.
  ^b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeRadial4 [
  	| b objects limit |
	b := SKiviatBuilder new.
	objects := logs flatCollect: #population.
  limit := populationSize + (populationSize \\ 2 ).
	b objects: objects.
	1 to: limit do: [:i | 
		b addMetric: [ :o | 
		"(o at: i)"o generationNumber ]].
   "b desactivateHighlight."
	"b objects: (Array with: 'object1' -> ((1 to: 25) collect: [:i |  i atRandom ]) with: 'object2' -> ((1 to: 25) collect: [:i |  i atRandom ])).
b shapes: ((Array with: Color blue with: Color red) do: [:c |  c alpha: 0.3 ]).
(1 to: 25) doWithIndex: [:ei :i |  b addMetric: [:e |  e idPopulation ] ]."
   b build.
   "b view edges do: #remove."
   ^ b view
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeRadialModified [
  | b es |
  b := RTMondrian new.
  b interaction highlight.
  es := b nodes: (logs flatCollect: #population) forEach: [:testCase |  
	| shape stmts |
	shape := RTCompositeShape new.
   b shape: shape.
   b shape add: (RTBox new color: #mutantColor; width: 1; height: 1);
	add: (RTBox new color: #stmColor; width: 6; height: 1);
	horizontal.
   stmts := b nodes: testCase statements.
   stmts @ (RTHighlightable highlight: [:stm | stm allParents]).
        b layout verticalLine gapSize: 0 ].
   es @ (RTHighlightable highlight: [:testCase | 
	testCase allParents
	]).
  es do: [:el | el width: 10; height: (el model length * 2)"; color: Color white"].
  b shape verticalBezierLine.
  b edges moveBehind.
  b edges connectFromAll: [:testCase |  testCase parents ].
  b layout radial.
  ^ b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeWithRandomColor [
  | b |
  b := RTMondrian new.
  b shape rectangle
     withBorder;
     width: [:cls |  (cls fitnessByClass values first at: targetClassName) * 1.5 ];
     height: [:cls |  cls length * 1.5 ].
  b nodes: (logs flatCollect: #population) forEach: [:testCase |  b shape rectangle
           heightElement: 1;
           color: [:line |  Color random ].
        b nodes: testCase statements.
        b layout verticalLine gapSize: 0 ].
  b shape verticalBezierLine.
  b edges moveBehind.
  b edges connectFromAll: [:testCase |  testCase parents ].
  b layout smallSuite.
  
  "b normalizer normalizeColorAsGray: [:testCase |  testCase fitness values first ]."^b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeWithRoassal3 [
	| canvas assocGroup |
	canvas := RSCanvas new addInteraction: RSCanvasController.
	assocGroup := RSGroup new.
	self population collect: [:testCase | testCase summaryExecutionMethods associations ] 
	thenDo: [:assocs | 
		| group |
		group := RSGroup new.
		assocs do: [ :assoc |
			| element |
			element := self visualizeMethod: assoc.
			canvas add: element.
			group add: element
		].
		RSGridLayout on: group.
		assocGroup add: group.
	].
	RSGridLayout new gapSize: 20; on: assocGroup.
	^ canvas
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeWithSparkCircle [
  | b es generations shape |
  generations := numberOfGenerations + 1.
  b := RTMondrian new.
  b interaction highlight.
  shape := RTSparkCircle new.
		shape size: 5.
  		shape names: [ :model | Array with: fitness functionName with: (fitness functionName, 'ByProject') ].
      shape percent: [ :model :metric | 
		metric = fitness functionName ifTrue: [ (((model fitnessByClass at: metric) at: targetClassName)/100) asFloat ] ifFalse: [ model fitness values first ] ].
		shape oldMetric: [ :model :metric | 
		metric = fitness functionName ifTrue: [ (((model fitnessByClass at: metric) at: targetClassName)/100) asFloat ] ifFalse: [ model fitness values first ] ].
		shape colorBlock: [ :model :metric | metric = fitness functionName ifTrue: [ Color white ] ifFalse: [ Color blue ] ].
  b shape: shape.
  es := b nodes: ((logs flatCollect: #population) select: [:tC | (tC generationNumber = generations or: [ tC allChildren detect: [:tCe |  tCe generationNumber = generations ] ifFound: [ true ] ifNone: [ false ]])]).
  es @ (RTHighlightable highlight: [:testCase |  testCase allParents ]).
  "es do: [:el |  el
           width: 10; 
			  height: el model length * 2
  ]."
  b shape verticalBezierLine.
  b edges moveBehind.
  b edges connectFromAll: [:testCase |  testCase parents ].
  b normalizer elements: es.
  b normalizer normalizeColor: [:testCase |  testCase fitness values first] using: (Array with: Color black with: Color white)."(Array with: Color red with: Color blue) min:0 max: 100."
  b layout smallSuite.
  ^b 
]
