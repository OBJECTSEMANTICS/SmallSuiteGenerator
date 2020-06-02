Extension { #name : #SGAEngine }

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> addDescriptiveTextOn: canvas with: fitnessSeed ofColor: color and: offsets [
	| blockText text dictionary |
	blockText := [:string | RSLabel new 
		text: string;
		color: color;
		fontSize: 30;
		yourself ].
	text := blockText value: 'TargetClass: ', self targetClassName, ' in package: ', self targetPackageRegex, ' and fitnessSeed: ', fitnessSeed asString.
	RSLocation new top left offset: -60; move: text on: canvas shapes.
	canvas addShape: text.
	dictionary := Dictionary new 
		at: 'Generation contribution' put: (RSLocation new bottom left offset: (0@50); yourself);
		at: 'Evolution of Genetic Algorithm' put: (RSLocation new bottom center offset: (offsets first@0); yourself);
		at: 'Evolution Coverage %' put: (RSLocation new bottom right offset: (offsets second@0); yourself);
		yourself.
	dictionary associationsDo: [ :assoc |
		| label |
		label := blockText value: assoc key. 
		assoc value move: label on: canvas shapes.
		canvas addShape: label
	].
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
		associations do: [ :assoc | legend text: assoc key withBoxColor: assoc value ].
		legend leyendDo: [ :l |
				l
					scaleBy: 1 ].
		blockLocation value: legend.
		legend build
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
SGAEngine >> addTickX: composite withScale: scale xMax: xMax andColor: color [ 
	(xMax * 0.2) to: xMax by: (xMax * 0.2) do: [ :i |
		| aTick lbl |
		aTick := RSLine new 
			startPoint: (scale scale: i@0.1 negated);
			color: color;
			width: 10;
			endPoint: (scale scale: i@0.3 negated);
			yourself.
		composite addShape: aTick.
		lbl := RSLabel new 
		fontSize: scale range second x * 0.04;
		color: color;
		text: (i round: 2) asString, '%'.
		RSLocation new below move: lbl on: aTick.
		composite addShape: lbl.
	].
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> addTickY: composite withScale: xScale ofColor: color andPositions: ys [
	ys doWithIndex: [ :y :index | 
		| tick lbl |
		tick := RSLine new 
			startPoint: (xScale scale: 0@y);
			color: color;
			width: 10;
			endPoint: (xScale scale: (xScale domain last x * -0.03)@y);
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
		shape translateTo: position + (shape extent / 2 *  (0 @ 1)).
		 ].
	element := RSComposite new 
		shapes: groupSpark;
		padding: (Margin
				left: 30
				right: 30
				top: 20
				bottom: 100);
		border: (RSBorder new width: 2; color: (dictColor at: 'border'); yourself);
		yourself.
	self addLegend: infoColor values on: element withFontColor: (dictColor at: 'font') and: [:legend | legend location below offset: 10 ].
	^ element
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> evolutionPoints: ypositions fitnessSeed: fitnessSeed withScale: scale [
	| endPoint points listFittest listLowest listAverage listSeed |
	points := Dictionary new.
	endPoint := scale scale: (0 @ ypositions first).
	listLowest := OrderedCollection new add: endPoint; yourself.
	listAverage := OrderedCollection new add: endPoint; yourself.
	listFittest := OrderedCollection new add: endPoint; yourself.
	listSeed := OrderedCollection new add: endPoint; yourself.
	points at: 'seed' put: listSeed; 
		at: 'fittest' put: listFittest;
		at: 'average' put: listAverage;
		at: 'lowest' put: listLowest.
	(self logs collect: [:log | 
		Array with: log lowestFit values first
			with: log averageFit values first
			with: (log fittestTestCase fitnessByClass values first at: targetClassName)])
		doWithIndex: [ :array  :index | | y |
			y := ypositions at: index.
			listLowest add: (scale scale: array first @ y).
			listAverage add: (scale scale: array second @ y).
			listFittest add: (scale scale: array third @ y).
			listSeed add: (scale scale: fitnessSeed @ y)
		].
	^ points
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> evolutionShapeWith: yPositions ofColor: dictColor fitnessSeed: fitnessSeed andSize: size [
	| composite scale yMax points axis spaceStick xMax |
	composite := RSComposite new 
		color: Color transparent.
	yMax := yPositions first.
	xMax := (logs last fittestTestCase fitnessByClass values first at: targetClassName) max: fitnessSeed.
	scale := NSScale linear 
		domain: (Array with: 0@0 with: xMax@yMax);
		range: (Array with: 0@0 with: size).
	points := self evolutionPoints: yPositions, #(0) fitnessSeed: fitnessSeed withScale: scale.
	spaceStick := 0.1 negated.
	axis := RSPolyline new 
		color: (dictColor at: 'axis');
		width: 10;	
		controlPoints: ((Array with: 0@yMax with: 0@spaceStick with: xMax@spaceStick) collect: [:p | scale scale: p]);
		yourself.
	composite addShape: axis; 
		addShape: (RSPolyline new 
			controlPoints: (points at: 'seed'); 
			color: (dictColor at: 'seedCoverage');
			width: 10; yourself);
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
	self addTickX: composite withScale: scale xMax: xMax andColor: (dictColor at: 'font').
	self addTickY: composite withScale: scale ofColor: (dictColor at: 'font') andPositions: yPositions.
	self addLegend: (Array with: 'Lowest-Fitness' -> (dictColor at: 'lowestCoverage')
		with: ('Average-Fitness' -> (dictColor at: 'averageCoverage'))
		with: ('Fittest-Fitness' -> (dictColor at: 'fittestCoverage'))
		with: ('Seed-Fitness' -> (dictColor at: 'seedCoverage'))) on: composite withFontColor: (dictColor at: 'font') and: [:legend | legend location below left offset: (140@60 negated) ]. 
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
	| canvas contributionShape infoMethodShape evolutionShape infoHeights highlightTestCase highlightMethod shapeHeight ys border widthShape |
	canvas := RSCanvas new 
		color: (dictColor at: 'background').
	highlightTestCase := RSHighlightable new 
		highlightColor: (dictColor at: 'highlightTestCase');
		yourself.
	highlightMethod := RSHighlightable new 
		highlightColor: (dictColor at: 'highlightMethod');
		yourself.
	infoMethodShape := self infoMethodShapesOn: canvas ofColor: dictColor highlight: (Array with: highlightTestCase with: highlightMethod) and: fitnessSeed.	
	infoHeights := infoMethodShape at: 2.
	infoMethodShape := infoMethodShape at: 1.
	shapeHeight := infoMethodShape height.
	ys := self positionsOf: infoHeights onYAxis: shapeHeight.
	shapeHeight := shapeHeight - (shapeHeight * 0.015).
	contributionShape := self contributionShapeOfHeight: shapeHeight color: dictColor and: (self scaleOf: ys withDomain: ys first andRange: shapeHeight negated).
	"align the contribution element"
	RSLocation new top left offset: ((contributionShape width negated * 1.5)@110 negated); move: contributionShape on: canvas shapes.
	"add contributionShape on canvas"
	canvas addShape: contributionShape.
	"add infoMethodShapeGroup on canvas"
	canvas addAll: infoMethodShape.
	self addHighlightTestCaseEvent: highlightTestCase on: canvas ofColor: (dictColor at: 'highlightTestCase').
	self addHighlightMethodEvent: highlightMethod on: canvas ofColor: (dictColor at: 'highlightMethod').
	border := self borderOfSize: (infoMethodShape width) @ (contributionShape height) andColor: (dictColor at: 'border').
	RSLocation new top middle offset: ((contributionShape width - (contributionShape width * 0.45))@0); 
		move: border on: canvas shapes.
	canvas addShape: border.
	widthShape := 800.
	evolutionShape := self evolutionShapeWith: ys ofColor: dictColor fitnessSeed: fitnessSeed andSize: widthShape @shapeHeight negated.
	RSLocation new top right offset: ((evolutionShape width + 50)@0); move: evolutionShape on: canvas shapes.
	"add evolutionShape on canvas"
	canvas addShape: evolutionShape.
	border := self borderOfSize: ((widthShape + 100) @ contributionShape height) andColor: (dictColor at: 'border').
	RSLocation new top right move: border on: canvas shapes.
	canvas addShape: border.
	"add descriptive text on canvasa"
	self addDescriptiveTextOn: canvas with: fitnessSeed ofColor: (dictColor at: 'font') and: (Array with: ((infoMethodShape width / 10) negated ) with: -200).
	canvas @ RSCanvasController.
	^ canvas
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> infoMethodShapesOn: canvas ofColor: dictColor highlight: highlights and: fitnessSeed [
	| generationGroup filteredList memo shapeHeights scaleColorBlock set |
	generationGroup := RSGroup new.
	filteredList := OrderedCollection new.
	set := Set new.
	logs first population do: [ :tC | self addSurvivorTestCase: tC on: filteredList using: set and: logs size ].
	filteredList sort: [ :tC1 :tC2 | (tC1 generationNumber < tC2 generationNumber) or: [ (tC1 generationNumber = tC2 generationNumber) and: [  tC1 children size < tC2 children size ] ] ].
	memo := SMemo new.
	shapeHeights := OrderedCollection new.
	scaleColorBlock := self scaleColorBlock: (self methodColorDictionary: (dictColor at: 'rangeMethodColor')).
	generationGroup addAll: (
		(filteredList groupedBy: [:tC | tC generationNumber]) collect: [ :testCases | 
			| group |
			group := RSGroup new.
			group addAll: (testCases collect: [ :testCase | 
				(self testCaseShape: testCase 
					ofColor: dictColor 
					using: (Dictionary new at: 'memo' put: memo; at: 'highlight' put: highlights second; at: 'scaleColorBlock' put: scaleColorBlock; yourself) 
					and: fitnessSeed) @ highlights first; yourself.
			]).
			shapeHeights add: (group collect: #height) max.
			RSHorizontalLineLayout new gapSize: 20; on: group.
			group
	]).
	RSVerticalLineLayout new gapSize: 100;  on: generationGroup.
	RSEdgeBuilder verticalBezier  
		shapes: (generationGroup flatCollect: #yourself);
		canvas: canvas;
		width: 5;
		color: (dictColor at: 'edge');
		connectFromAll: [ :testCase | testCase parents ].
	^ Array with: (generationGroup flatCollect: #yourself) with: shapeHeights
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
SGAEngine >> methodShapeGroup: testCase with: dictionary [
	| group memo scaleColorBlock highlight |
	group := RSGroup new.
	memo := dictionary at: 'memo'.
	scaleColorBlock := dictionary at: 'scaleColorBlock'.
	highlight := dictionary at: 'highlight'.
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
SGAEngine >> positionsOf: heightShapes onYAxis: height [
	| sum temp |
	sum := heightShapes allButLast log sum.
	temp := sum.
	^ (Array with: sum), (heightShapes allButLast collect: [ :h | temp := temp - h log ])
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> progressBarFrom: baseValue to: progressValue ofColor: dictColor [ 
	| group groupBox groupData bar difference progressColor |
	group := RSGroup new.
	groupBox := RSGroup new.
	groupData := RSGroup new.
	difference := progressValue - baseValue.
	progressColor := difference > 0 ifTrue: [ dictColor at: 'forwardBar' ] ifFalse: [ dictColor at: 'backwardBar' ].
	groupBox 
		add: (RSBox new height: 10; color: (dictColor at: 'baseBar'); width: (difference < 0 ifTrue: [ baseValue + difference ] ifFalse: [ baseValue ]));
		add: (RSBox new height: 10; color: progressColor; width: difference abs).
	RSHorizontalLineLayout new gapSize: 0; on: groupBox.
	bar := RSComposite new
		shapes: groupBox;
		yourself.
	groupData 
		add: bar;
		add: (RSLabel new text: progressValue asString, '%'; bold; color: (dictColor at: 'fontMethodBox'); fontSize: 8).
	RSHorizontalLineLayout new gapSize: 10; on: groupData.
	group add: (RSComposite new shapes: groupData).
	^ group
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> scaleColorBlock: methodColorDictionary [
	^ [:key | 
		| color |
		color := methodColorDictionary at: key.
		NSScale linear 
		range: (Array with: (color alphaMixed: 0.6 with: Color black) with: color);
		domain: #(0 100)].
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> scaleOf: numbers withDomain: maxDomain andRange: maxRange [
	| scale |
	scale := NSScale linear 
		domain: (Array with: 0 with: maxDomain);
		range: (Array with: 0 with: maxRange).
	^ numbers collect: [ :n | scale scale: n ]
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
				with: [:model | | numClasses difference |
					numClasses := ((block value: model ) collect: [ :assoc | (assoc key splitOn: ' ') first ]) asSet size.
					difference := numClasses - (dictPrevData at: 'classCoverage').
					dictPrevData at: 'classCoverage' put: numClasses.
					difference / totalClasses ] 
				with: [:model | | numberMethods difference |
					numberMethods := (block value: model) size.
					difference := numberMethods - (dictPrevData at: 'methodCoverage').
					dictPrevData at: 'methodCoverage' put: numberMethods.
					difference / totalMethods]
				with: [:model | | coverage difference |
					coverage := model fittestTestCase fitnessByClass values first at: targetClassName.
					difference := coverage - (dictPrevData at: 'branchCoverage').
					dictPrevData at: 'branchCoverage' put: coverage.
					difference / 100  ]);
		sliceColor: [ :shape | (dictColor at: shape index) value ].
		spark scaleTo: size.
		spark build.
		RSComposite new
			shapes: group;
			yourself ] as: RSGroup
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> summaryMethodsOfTargetClass: summaryMethods [
	^ summaryMethods select: [ :summary | (summary executorClass = self targetClassName) or: [ (summary executorClass splitOn: ' ') first = self targetClassName ] ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> testCaseShape: testCase ofColor: dictColor using: dictionary and: fitnessSeed [
	| group higher block progressValue |
	block := [ :tC | [ tC fitnessByClass values first at: self targetClassName ifAbsent: 0 ] on: SubscriptOutOfBounds do: [ 0 ] ].
	progressValue := block value: testCase.
	higher := testCase parents ifEmpty: [ false ] ifNotEmpty: [ testCase parents allSatisfy: [ :tC | (block value: tC) < progressValue ] ].
	group := RSGroup new.
	group 
		add: (self methodShapeGroup: testCase with: dictionary);
		add: (self progressBarFrom: fitnessSeed to: progressValue ofColor: dictColor).
	RSVerticalLineLayout on: group.
	^ RSComposite new 
		shapes: (group flatCollect: #yourself);
		paint: (higher ifTrue: [dictColor at: 'backgroundHigherFitnessTestCase' ] ifFalse: [dictColor at: 'backgroundTestCase' ]);
		model: testCase;
		padding: 10;
		draggable 
]
