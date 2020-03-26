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
		paint: Color gray;
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
	group addAll: (testCase summaryExecutionMethods collect: [:summary | 
		self visualizationSummary: summary
	]).
	RSGridLayout on: group.
	^ group
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
SGAEngine >> visualize [
  | b |
  b := RTMondrian new.
  b shape rectangle
     withBorder;
     width: [:cls |  (cls fitnessByClass values first at: targetClassName) * 1.5 ];
     height: [:cls |  cls length * 1.5 ].
  b nodes: (logs flatCollect: #population) forEach: [:testCase |  b shape smallSuiteBox.
  b nodes: testCase statements.
        b layout verticalLine gapSize: 0 ].
  b shape verticalBezierLine.
  b edges moveBehind.
  b edges connectFromAll: [:testCase |  testCase parents ].
  b layout smallSuite.
  
  "b normalizer normalizeColorAsGray: [:testCase |  testCase fitness values first ]."^b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeCoverageR3 [
	| canvas testCaseGroup |
	canvas := RSCanvas new addInteraction: RSCanvasController.
	testCaseGroup := RSGroup new.
	self logs collect: #population thenDo: [ :testCases | 
		| group |
		group := RSGroup new.
		group addAll: (testCases collect: [ :testCase | 
			self visualizationCoverageMethods: testCase	
		]).
		RSHorizontalLineLayout new gapSize: 20; on: group.
		testCaseGroup add: group.
	].
	RSVerticalLineLayout new on: testCaseGroup; gapSize: 30.
	canvas add: (RSComposite new shapes: (testCaseGroup flatCollect: #yourself)).
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
