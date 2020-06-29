Extension { #name : #SGAEngine }

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> addDescriptiveTextOn: canvas ofColor: color and: offsets [
	| blockText text dictionary |
	blockText := [:string | RSLabel new 
		text: string;
		color: color;
		fontSize: 40;
		yourself ].
	dictionary := Dictionary new 
		at: 'Generation contribution' put: (RSLocation new top left offset: (100 negated@110 negated); yourself);
		at: 'Evolution of Genetic Algorithm' put: (RSLocation new top center offset: (offsets first@0); yourself);
		at: 'Evolution Coverage %' put: (RSLocation new top right offset: (offsets second@0); yourself);
		yourself.
	dictionary associationsDo: [ :assoc |
		| label |
		label := blockText value: assoc key. 
		assoc value move: label on: canvas shapes.
		canvas addShape: label
	].
	text := blockText value: 'TargetClass: ', self targetClassName, ' in package: ', self targetPackageRegex.
	RSLocation new top center offset: 0@130 negated; move: text on: canvas shapes.
	canvas addShape: text.
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> addHighlightMethodEvent: highlight on: canvas ofColor: color [
	| interaction |
	interaction := RSHighlightable new highlightColor: color; yourself.
	highlight 
		when: RSHighlightEvent do: [ :evt | 
			| shapes shape index |
			index := 0.
			shape := canvas shapes detect: [ :sh | 
				index := index + 1.
				sh model isNotNil and: [ sh children isNotNil and: [ sh children includes: evt shape ] ]  ] ifNone: [ nil ].
			shape ifNotNil: [ 
				shapes := shape model allParents.
				shapes := (canvas shapes first: index - 1) select: [ :s | shapes includes: s model ].
				shapes := (shapes flatCollect: #children) select: [ :sh |
					[ sh model selector = evt shape model selector ] on: MessageNotUnderstood do: [ false ]
					 ].
				interaction doHighlightShapes: shapes.
				canvas propertyAt: #summaryExecutedMethods put: shapes
			] ];
		when: RSUnHighlightEvent do: [ :evt | 
			(canvas propertyAt: #summaryExecutedMethods ifAbsent: [ #() ]) do: [:shape | 
				interaction restore: shape selector: #color
				]]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> addHighlightTestCaseEvent: highlight on: canvas ofColor: color [
	| interaction  |
	interaction := RSHighlightable new highlightColor: color; yourself.
	highlight 
		when: RSHighlightEvent do: [ :evt | 
			| shapes edges index |
			index := canvas shapes indexOf: evt shape.
			shapes := evt shape model allParents.
			shapes := (canvas shapes first: index) select: [ :shape | shapes includes: shape model ].
			edges := ((Array with: evt shape),  shapes) flatCollect: [ :testCase | testCase incomingEdges collect: #yourself as: RSGroup ].
			interaction doHighlightShapes: shapes, edges.
			canvas propertyAt: #testCases put: shapes.
			canvas propertyAt: #edges put: edges ];
		when: RSUnHighlightEvent do: [ :evt | 
			(canvas propertyAt: #testCases ifAbsent: [ #() ]) do: [:shape | 
				interaction restore: shape selector: #color
				].
			(canvas propertyAt: #edges ifAbsent: [ #() ]) do: [ :edge | 
				interaction restore: edge selector: #color
				 ] ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> addLegend: associations on: container withFontColor: color and: blockLocation [
	| legend |
	legend := RSLegend new 
		container: container;
		defaultLabel: (RSLabel new color: color; yourself);
		yourself.
		associations do: [ :assoc | | colorBox |
			colorBox := assoc value.
			colorBox isArray ifFalse: [ legend text: assoc key withBoxColor: colorBox ] 
				ifTrue:  [ colorBox first isColor 
					ifTrue: [ legend text: assoc key withShape: (legend defaultBox border: (RSBorder new color: colorBox second); paint: colorBox first) ] 
					ifFalse: [ legend text: assoc key withFadingRamp: colorBox ] ] ].
		legend leyendDo: [ :l |
				l
					padding: 5;
					scaleBy: 2.5 ].
		blockLocation value: legend.
		legend build
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> addLegendOn: canvas with: dictColor [
	| colors |
	self addLegend: (Array with: 'Class coverage' -> (dictColor at: 'classCoverage')
		with: 'Method coverage' -> (dictColor at: 'methodCoverage')
		with: 'Branch coverage' -> (dictColor at: 'statementCoverage')) on: canvas withFontColor: (dictColor at: 'font') and: [:legend | legend location below left offset: (500@0) ].
		
	colors := dictColor at: 'rangeMethodColor'.
	self addLegend: (Array  
			with: 'Testcase (TC)' -> (dictColor at: 'backgroundTestCase') 
			with: 'TC with higher coverage than parents' -> (Array with: (dictColor at: 'backgroundTestCase') with: (dictColor at: 'borderTestCase'))
			with: 'Executed methods' -> (Array with: 0 -> colors first with: 1 -> (colors at: 19))) on: canvas  withFontColor: (dictColor at: 'font') and: [ :legend | legend location below center offset: -100@150 negated ].
			
	self addLegend: (Array with: 'Lowest-Fitness' -> (dictColor at: 'lowestCoverage')
		with: ('Average-Fitness' -> (dictColor at: 'averageCoverage'))
		with: ('Fittest-Fitness' -> (dictColor at: 'fittestCoverage'))) on: canvas withFontColor: (dictColor at: 'font') and: [:legend | legend location below right offset: -700@150 negated ].
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> addSurvivorTestCase: testCase on: collection using: set and: maxNumber [
	| selected association |
	association := testCase generationNumber -> testCase idPopulation.
	selected := testCase generationNumber == maxNumber.
	selected ifFalse: [
		testCase children do: [ :each | | aux | 
			aux := (set includes: each generationNumber -> each idPopulation) or: [self addSurvivorTestCase: each on: collection using: set and: maxNumber ].
			selected := selected or: [ aux ] ] ].
	selected ifTrue: [ 
		(set includes: association) ifFalse: [ set add: association.
		collection add: testCase ].
		^ true ]. 
	^ false
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> addTickX: composite withScale: scale color: color y: y and: posMax [
	| stepX |
	stepX := posMax x / 5.
	stepX to: posMax x by: stepX do: [ :i |
		| aTick lbl |
		aTick := RSLine new 
			startPoint: (scale scale: i)@(y - (0.01 * posMax y));
			color: color;
			width: 10;
			endPoint: (scale scale: i)@(y - ((0.01 * posMax y) - 35));
			yourself.
		composite addShape: aTick.
		lbl := RSLabel new 
		fontSize: scale range second * 0.04;
		color: color;
		text: (i round: 1) asString, '%'.
		RSLocation new below move: lbl on: aTick.
		composite addShape: lbl.
	].
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> addTickY: composite withScale: xScale xMax: xMax ofColor: color andPositions: ys [
	ys doWithIndex: [ :y :index | 
		| tick lbl |
		tick := RSLine new 
			startPoint: (xScale scale: 0)@y;
			color: color;
			width: 10;
			endPoint: (xScale scale: (xMax * -0.03))@y;
			yourself.
		composite addShape: tick.
		lbl := RSLabel new 	
			fontSize: 30;
			color: color;
			text: index.
		RSLocation new outer left move: lbl on: tick.
		composite addShape: lbl.
	].
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> borderOfSize: size andColor: color [
	^ RSBox new 
		color: Color transparent;
		border: (RSBorder new width: 2; color: color; yourself);
		width: size x + 40;
		height: size y;
		yourself.
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> contributionShapeOfHeight: height color: dictColor and: ys [
  	| infoColor groupSpark element scale x |
	infoColor := Dictionary new 
		at: 1 put: ('Class coverage' -> (dictColor at: 'classCoverage'));
		at: 2 put: ('Method coverage' -> (dictColor at: 'methodCoverage'));
		at: 3 put: ('Branch coverage' -> (dictColor at: 'statementCoverage'));
		yourself.
	scale := NSScale linear
		domain: (Array with: 0 with: ys size);
		range: (Array with: 0 with: height).
	groupSpark := self sparkCircleGroupOfColor: infoColor andSize: (scale scale: 1).
	x := (groupSpark maxValue: #width) / 2.0.
	groupSpark with: (ys collect: [:y | x @ y ]) do: [ :shape :position | 
		shape translateTo: position + (shape nodes first extent / 2 *  (0 @ 1)).
		 ].
	element := RSComposite new 
		shapes: groupSpark;
		yourself.
	^ element
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> evolutionPoints: ypositions withScale: scale [
	| endPoint points listFittest listLowest listAverage |
	points := Dictionary new.
	endPoint := 0 @ 0.
	listLowest := OrderedCollection new add: endPoint; yourself.
	listAverage := OrderedCollection new add: endPoint; yourself.
	listFittest := OrderedCollection new add: endPoint; yourself.
	points at: 'fittest' put: listFittest;
		at: 'average' put: listAverage;
		at: 'lowest' put: listLowest.
	(self logs collect: [:log | 
		Array with: log lowestFit values first
			with: log averageFit values first
			with: (log fittestTestCase fitnessByClass values first at: targetClassName)])
		doWithIndex: [ :array  :index | | y |
			y := ypositions at: index.
			listLowest add: (scale scale: array first) @ y.
			listAverage add: (scale scale: array second) @ y.
			listFittest add: (scale scale: array third) @ y
		].
	^ points
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> evolutionShapeWith: yPositions ofColor: dictColor size: size [
	| composite scale points axis spaceStick xMax yMax |
	composite := RSComposite new 
		color: Color transparent.
	xMax := self logs last fittestTestCase fitnessByClass values first at: targetClassName.
	scale := NSScale linear 
		domain: (Array with: 0 with: xMax);
		range: (Array with: 0 with: size x).
	yMax := yPositions last.
	points := self evolutionPoints: yPositions, #(0) withScale: scale.
	spaceStick := yMax - (0.01 * size y).
	axis := RSPolyline new 
		color: (dictColor at: 'axis');
		width: 10;	
		controlPoints: ((Array with: 0@0 with: 0@spaceStick with: (scale scale:xMax)@spaceStick));
		yourself.
	composite addShape: axis; 
		addShape: (RSPolyline new 
			controlPoints: (points at: 'lowest'); 
			color: (dictColor at: 'lowestCoverage');
			width: 10; yourself);
		addShape: (RSPolyline new 
			controlPoints: (points at: 'average'); 
			color: (dictColor at: 'averageCoverage');
			width: 10; yourself);
		addShape: (RSPolyline new 
			controlPoints: (points at: 'fittest'); 
			color: (dictColor at: 'fittestCoverage');
			width: 10; yourself).
	self addTickX: composite withScale: scale color: (dictColor at: 'font') y: yMax and: xMax @ size y.
	self addTickY: composite withScale: scale xMax: xMax ofColor: (dictColor at: 'font') andPositions: yPositions.
	^ composite adjustToChildren
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> fitnessOf: summaryExecMethod [
	^ summaryExecMethod summaryStatements 
		ifEmpty: [ 100 ] 
		ifNotEmpty: [ ((summaryExecMethod summaryStatements select: #executed) size / summaryExecMethod summaryStatements size) asFloat * 100 ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> generationVisualization: fitnessSeed ofColor: dictColor [
	| canvas contributionShape infoMethodShape evolutionShape highlightTestCase highlightMethod ys border widthShape barGroup height |
	canvas := RSCanvas new 
		color: (dictColor at: 'background').
	highlightTestCase := RSHighlightable new 
		highlightColor: (dictColor at: 'highlightTestCase');
		yourself.
	highlightMethod := RSHighlightable new 
		highlightColor: (dictColor at: 'highlightMethod');
		yourself.
	infoMethodShape := self infoMethodShapesOn: canvas ofColor: dictColor highlight: (Array with: highlightTestCase with: highlightMethod).	
	ys := infoMethodShape at: 3.
	barGroup := infoMethodShape at: 2.
	infoMethodShape := infoMethodShape at: 1.
	height := infoMethodShape height.
	contributionShape := self contributionShapeOfHeight: height color: dictColor and: ys.
	barGroup := RSComposite new shapes: (self setPositions: barGroup using: ys).
	"align the contribution element"
	contributionShape translateTo: infoMethodShape encompassingRectangle topLeft x - (contributionShape encompassingRectangle width) @ contributionShape position y.
	"add contributionShape on canvas"
	canvas addShape: contributionShape.
	"add infoMethodShapeGroup on canvas"
	canvas addAll: infoMethodShape.
	"add barGroup on canvas"
	RSLocation new right offset: ((barGroup width * 1.2)@0); move: barGroup on: canvas shapes.
	canvas addShape: barGroup.
	"addition of highlight"
	self addHighlightTestCaseEvent: highlightTestCase on: canvas ofColor: (dictColor at: 'highlightTestCase').
	self addHighlightMethodEvent: highlightMethod on: canvas ofColor: (dictColor at: 'highlightMethod').
	widthShape := 800.
	evolutionShape := self evolutionShapeWith: ys ofColor: dictColor size: widthShape @height negated.
	height := (Array with: contributionShape height with: height with: evolutionShape height) max + ((infoMethodShape select: [:e | (e model isKindOf: SSTestCase) and: [ e model generationNumber == (numberOfGenerations + 1)  ] ] thenCollect: #height) max).
	"addition of contributionShape border"
	border := self borderOfSize: contributionShape width @ (height + 20) andColor: (dictColor at: 'border').
	border translateTo: infoMethodShape encompassingRectangle topLeft x - (contributionShape encompassingRectangle width) @ contributionShape position y.
	canvas addShape: border.
	"addition of infoMethodShape border"
	border := self borderOfSize: (infoMethodShape width + (barGroup width * 1.3)) @ (height+20) andColor: (dictColor at: 'border').
	RSLocation new middle offset: 120@0; move: border on: canvas shapes. 
	canvas addShape: border.
	"add evolutionShape on canvas"
	evolutionShape translateTo: (barGroup encompassingRectangle topRight x + 500) @ (contributionShape position y + 25).
	canvas addShape: evolutionShape.
	"border of evolutionShape"
	border := self borderOfSize: ((widthShape * 1.1) @ (height + 20)) andColor: (dictColor at: 'border').
	RSLocation new top right offset: 0@5 negated; move: border on: canvas shapes.
	canvas addShape: border.
	"add descriptive text on canvas"
	self addDescriptiveTextOn: canvas ofColor: (dictColor at: 'font') and: (Array with: ((infoMethodShape width / 10) negated ) with: -200).
	self addLegendOn: canvas with: dictColor.
	canvas @ RSCanvasController.
	^ canvas
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> infoMethodShapesOn: canvas ofColor: dictColor highlight: highlights [
	| generationGroup filteredList memo scaleColorBlock set barGroup shapes ys |
	generationGroup := RSGroup new.
	barGroup := RSGroup new.
	filteredList := OrderedCollection new.
	set := Set new.
	ys := OrderedCollection new.
	logs first population do: [ :tC | self addSurvivorTestCase: tC on: filteredList using: set and: logs size ].
	filteredList sort: [ :tC1 :tC2 | (tC1 generationNumber < tC2 generationNumber) or: [ (tC1 generationNumber = tC2 generationNumber) and: [  tC1 children size < tC2 children size ] ] ].
  memo := SMemo new.
	scaleColorBlock := self scaleColorBlock: (self methodColorDictionary: (dictColor at: 'rangeMethodColor')).
	generationGroup addAll: (
		(filteredList groupedBy: [:tC | tC generationNumber]) collect: [ :testCases | 
			| group generationNumber |
			group := RSGroup new.
			group addAll: (testCases collect: [ :testCase | 
				(self testCaseShape: testCase 
					ofColor: dictColor 
					with: memo
					highlight: highlights second
					scale: scaleColorBlock) @ highlights first; yourself.
			]).
			RSHorizontalLineLayout new gapSize: 20; on: group.
			generationNumber := testCases first generationNumber.
			barGroup add: (self progressBarFrom: testCases size value to: (logs at: generationNumber) population size ofColor: dictColor).
			group
	]).
	RSVerticalLineLayout new gapSize: 100;  on: generationGroup.
	shapes := generationGroup flatCollect: #yourself.
	shapes collect: [ :s | s encompassingRectangle origin y ] 
		thenDo: [:y | (ys includes: y) ifFalse: [ys add: y]].
	RSEdgeBuilder verticalBezier  
		shapes: shapes;
		canvas: canvas;
		width: 5;
		color: (dictColor at: 'edge');
		connectFromAll: [ :testCase | testCase parents ].
	^ Array with: shapes with: barGroup with: ys
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> isCoverage: coverage ofSummaryMethod: summaryMethod in: testCase newOrHigher: memo [
	| previousValues |
	testCase parents ifEmpty: [ ^ true ].
	previousValues := testCase parents 
		collect: [ :tC | memo at: summaryMethod of: tC generationNumber and: tC idPopulation ]
		thenSelect: [ :val | val isNotNil ].
	^ previousValues 
		ifNotEmpty: [ previousValues max < coverage ] 
		ifEmpty: [ testCase parents allSatisfy: [ :tC |
				self isCoverage: coverage ofSummaryMethod: summaryMethod in: tC newOrHigher: memo ] ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> methodColorDictionary: rangeColor [
	| typeInfoClass color methodColorList index scale sizeRangeColor |
	typeInfoClass := typeInfo classAt: self targetClassName.
	methodColorList := OrderedCollection new.
	sizeRangeColor := rangeColor size.
	scale := NSScale linear range: (Array with: 1 with: typeInfoClass allMethods size); domain: (Array with: 1 with: sizeRangeColor).
	color := NSScale linear range: rangeColor; domain: ((1 to: sizeRangeColor) collect: [:n | scale scale: n]).
	index := 0.
	methodColorList addAll: (typeInfoClass methodTypes collect: [:method | 
		index := index + 1.
		(targetClassName -> method selector) -> (color scale: index)
		]).
	methodColorList addAll: (typeInfoClass classMethodTypes collect: [:method | 
		index := index + 1.
		(targetClassName, ' class' -> method selector) -> (color scale: index)]).
	^ methodColorList asDictionary 
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> methodShape: summaryExecMethod withGradientFrom: darkColor to: lightColor [
	| gradient group |
	gradient := LinearGradientPaint fromArray: (Array with: 0->darkColor with: 1->lightColor).
	gradient start: -50@0; stop: 50@0.
	group := RSGroup new.
	RSVerticalLineLayout new on: group; gapSize: 0.
	^ RSComposite new size: 50;
				color: gradient; 
				border: RSBorder new;
				model: summaryExecMethod;
				popupText: [ :summary |  String streamContents: [ :stream | 
							stream nextPutAll: summary executorClass;
							nextPutAll: '->';
							nextPutAll: summary selector.
							summaryExecMethod summaryStatements 
								select: #executed 
								thenDo: [:sSt | stream nextPut: Character cr;
									nextPutAll: sSt code] ] ];
				shapes: (group collect: #yourself);
				yourself.
				
	
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> methodShapeGroup: testCase with: memo highlight: highlight scale: scaleColorBlock [
	| group |
	group := RSGroup new.
	group addAll: ((self summaryMethodsOfTargetClass: testCase summaryExecutionMethods)
		select: [:summary |
			| coverage |
			coverage := self fitnessOf: summary.
			memo at: summary of: testCase generationNumber and: testCase idPopulation put: coverage.
			self isCoverage: coverage ofSummaryMethod: summary in: testCase newOrHigher: memo ]
		thenCollect: [:summary | 
			| scaleColor |
			scaleColor := scaleColorBlock value: summary executorClass -> summary selector.
			(self methodShape: summary withGradientFrom: (scaleColor scale: (self fitnessOf: summary)) to: (scaleColor scale: 100)) @ highlight; yourself.
		]).
	RSGridLayout on: group.
	^ group
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> progressBarFrom: progressValue to: maxValue ofColor: dictColor [
	| groupBox groupData bar scale |
	groupBox := RSGroup new.
	groupData := RSGroup new.
	scale := NSScale linear domain: (Array with: 0 with: maxValue);
		range: (Array with: 0 with: 200).
	groupBox 
		add: (RSBox new height: 50; color: (dictColor at: 'baseBar'); width: (scale scale: progressValue));
		add: (RSBox new height: 50; color: (dictColor at: 'forwardBar'); width: (scale scale: (maxValue - progressValue)); withBorder).
	RSHorizontalLineLayout new gapSize: 0; on: groupBox.
	bar := RSComposite new
		shapes: groupBox;
		yourself.
	groupData 
		add: bar;
		add: (RSLabel new text: (maxValue - progressValue) asString; color: (dictColor at: 'fontMethodBox'); fontSize: 30).
	RSHorizontalLineLayout new gapSize: 10; on: groupData.
	^ RSComposite new shapes: groupData
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> scaleColorBlock: methodColorDictionary [
	^ [:key | 
		| color |
		color := [ methodColorDictionary at: key] on: KeyNotFound do: [ Color black ].
		NSScale linear 
		range: (Array with: (color alphaMixed: 0.6 with: Color black) with: color);
		domain: #(0 100)].
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> setPositions: barGroup using: ys [
	ys doWithIndex: [ :y :index | 
		(barGroup at: index) translateTo: 0@y ].
	^ barGroup
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> sparkCircleGroupOfColor: dictColor andSize: size [
	| block dictPrevData totalClasses totalMethods |
	dictPrevData := Dictionary new 
		at: 'classCoverage' put: 0;
		at: 'methodCoverage' put: 0;
		at: 'branchCoverage' put: 0;
		yourself.
	totalClasses := self typeInfo classes size.
	totalMethods := (self typeInfo types flatCollect: #allMethods) size.
	block := [ :log | (log population flatCollect: [ :t | 
			(t summaryExecutionMethods collect: [:summary | 
				(summary executorClass -> summary selector)]) asSet ]) asSet ].
	^ logs collect: [ :log | 
		| spark group |
		group := RSGroup new.
		spark := RSSparkCircle new
			objects: log;
			container: group;
			slices: (Array 
				with: [:model | | numClasses difference previous |
					numClasses := ((block value: model ) collect: [ :assoc | (assoc key splitOn: ' ') first ]) asSet size.
					previous := dictPrevData at: 'classCoverage'.
					difference := numClasses - previous.
					dictPrevData at: 'classCoverage' put: numClasses.
					[difference / previous] on: ZeroDivide do: [ difference / totalClasses ] ] 
				with: [:model | | numberMethods difference previous |
					numberMethods := (block value: model) size.
					previous := dictPrevData at: 'methodCoverage'.
					difference := numberMethods - previous.
					dictPrevData at: 'methodCoverage' put: numberMethods.
					[ difference / previous] on: ZeroDivide do: [difference / totalMethods ] ]
				with: [:model | | coverage difference previous |
					coverage := model fitness values first.
					previous := dictPrevData at: 'branchCoverage'.
					difference := coverage - previous.
					dictPrevData at: 'branchCoverage' put: coverage.
					[ difference / previous ] on: ZeroDivide do: [ difference / 100 ]  ]);
		sliceColor: [ :shape | (dictColor at: shape index) value ].
		spark scaleTo: size.
		spark build.
		RSComposite new
			shapes: group;
			yourself ] as: RSGroup
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> summaryMethodsOfTargetClass: summaryMethods [
	^ summaryMethods select: [ :summary | 
		(summary executorClass = self targetClassName) or: 
		[ (summary executorClass splitOn: ' ') first = self targetClassName ] ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> testCaseShape: testCase ofColor: dictColor with: memo highlight: highlight scale: scaleColorBlock [
	| group higher block progressValue methodGroup contribute |
	block := [ :tC | [ tC fitnessByClass values first at: self targetClassName ifAbsent: 0 ] on: SubscriptOutOfBounds do: [ 0 ] ].
	progressValue := block value: testCase.
	higher := testCase parents ifEmpty: [ false ] 
		ifNotEmpty: [ testCase parents allSatisfy: [ :tC | (block value: tC) < progressValue ] ].
	group := RSGroup new.
	methodGroup := self methodShapeGroup: testCase with: memo highlight: highlight scale: scaleColorBlock.
	contribute := methodGroup isNotEmpty or: [ higher ].
	group add: methodGroup;
		add: (RSGroup new 
			add: (RSComposite new 
				addShape: (RSLabel new text: progressValue asString, '%'; bold; 
					color: ((dictColor at: 'fontMethodBox') alpha: (contribute ifFalse: [ 0.5 ] ifTrue: [ 1 ])); fontSize: 20); 
					padding: (Margin left: 10 right: 10 top: 1 bottom: 1)); yourself).
	RSVerticalLineLayout on: group.
	^ RSComposite new 
		shapes: (group flatCollect: #yourself);
		paint: ((dictColor at: 'backgroundTestCase') alpha: (contribute ifFalse: [ 0.5 ] ifTrue: [ 1 ]));
		model: testCase;
		border: (RSBorder new width: (higher ifTrue: [ 8 ] ifFalse: [ 1 ]); color: (dictColor at: 'borderTestCase'));
		padding: 10;
		popupText: testCase asString;
		draggable 
]
