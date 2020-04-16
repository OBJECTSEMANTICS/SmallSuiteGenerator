Extension { #name : #SGAEngine }

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> addBorderShape: aShape on: canvas ofColor: color andHeightOf: summaryShape [
	| box |
	box := RSBox new 
		color: Color transparent;
		border: (RSBorder new width: 2; color: color; yourself);
		width: aShape width + 40;
		height: summaryShape height;
		yourself.
	RSLocation new top middle offset: ((summaryShape width - (summaryShape width * 0.45))@0); 
		move: box on: canvas shapes.
	canvas addShape: box
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> addDescriptiveTextOn: canvas ofColor: color and: offsets [
	| blockText text dictionary |
	blockText := [:string | RSLabel new 
		text: string;
		color: color;
		fontSize: 30;
		yourself ].
	text := blockText value: 'TargetClass: ', self targetClassName, ' in package: ', self targetPackageRegex.
	RSLocation new top left offset: -60; move: text on: canvas shapes.
	canvas addShape: text.
	dictionary := Dictionary new 
		at: 'Summary of Evolution' put: (RSLocation new bottom left offset: (0@50); yourself);
		at: 'Evolution of Genetic Algorithm' put: (RSLocation new bottom center offset: (offsets first negated@0); yourself);
		at: 'Evolution Coverage %' put: (RSLocation new bottom right offset: (offsets second negated@0); yourself);
		yourself.
	dictionary associationsDo: [ :assoc |
		| label |
		label := blockText value: assoc key. 
		assoc value move: label on: canvas shapes.
		canvas addShape: label
	].
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> addLegend: canvas with: dictionary and: dictColor [
	| legend |
	legend := RSLegend new 
		container: canvas;
		defaultLabel: (RSLabel new color: (dictColor at: 'font'); yourself);
		yourself.
		dictionary valuesDo: [ :assoc | legend text: assoc key withBoxColor: assoc value ].
		legend leyendDo: [ :l |
				l
					draggable;
					scaleBy: 1 ].
		legend layout horizontal.
		legend location below offset: 10.
		legend build
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> addSummaryShapeTo: canvas ofHeight: height andColor: dictColor [
  	| block colorInfo groupSpark element scaleItem |
	block := [ :log | (log population flatCollect: [ :t | 
			(t summaryExecutionMethods collect: [:summary | 
				(summary executorClass -> summary selector)]) asSet ]) asSet ].
	colorInfo := Dictionary new 
		at: 1 put: ('#Classes' -> (dictColor at: 'numberClasses'));
		at: 2 put: ('#Methods' -> (dictColor at: 'numberMethods'));
		at: 3 put: ('Coverage' -> (dictColor at: 'scaleLighter'));
		yourself.
	scaleItem := height / (numberOfGenerations + 1).
	groupSpark := RSGroup new.
	groupSpark addAll: (logs collect: [ :log | 
		| spark group |
		group := RSGroup new.
		spark := RSSparkCircleB new
			objects: log;
			container: group;
			slices: (Array 
				with: [:model | ((block value: model ) collect: [ :assoc | (assoc key splitOn: ' ') first ]) asSet size / self typeInfo classes size] 
				with: [:model | (block value: model) size / (self typeInfo types flatCollect: #allMethods) size ]
				with: [:model | (model fittestTestCase fitnessByClass values first at: targetClassName) /100  ]);
		sliceColor: [ :shape | (colorInfo at: shape index) value ].
		spark defaultSliceShape innerRadius: 3.
		spark scaleTo: scaleItem.
		spark build.
		RSComposite new
			shapes: group;
			yourself ]).
	RSVerticalLineLayout new gapSize: 30; on: groupSpark.
	element := RSComposite new 
		shapes: groupSpark;
		padding: (Margin
				left: 70
				right: 70
				top: 20
				bottom: 70);
		border: (RSBorder new width: 2; color: (dictColor at: 'border'); yourself);
		yourself.
	self addLegend: element with: colorInfo and: dictColor.
	RSLocation new top left offset: ((element width negated * 1.35)@110 negated); move: element on: canvas shapes.
	canvas addShape: element.
	^ element
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> darkColors [
	^ Dictionary new 
		at: 'background' put: (Color r: 0.12549019607843137 g: 0.1803921568627451 b: 0.23529411764705882);
		at: 'backgroundBoxMethod' put: (Color r: 0.1607843137254902 g: 0.3686274509803922 b: 0.4470588235294118);
		at: 'scaleLighter' put: (Color r: 0.5098039215686274 g: 0.9607843137254902 b: 0.7725490196078432);
		at: 'scaleDarker' put: (Color r: 0.30980392156862746 g: 0.6235294117647059 b: 0.49019607843137253);
		at: 'backgroundLighter' put: (Color r: 0.7647058823529411 g: 0.803921568627451 b: 0.788235294117647);
		at: 'numberClasses' put: (Color r: 0.5098039215686274 g: 0.7803921568627451 b: 0.9607843137254902);
		at: 'numberMethods' put: (Color r: 0.9607843137254902 g: 0.5098039215686274 b: 0.7215686274509804);
		at: 'fontMethodBox' put: Color white;
		at: 'border' put: Color white;
		at: 'font' put: Color white;
		yourself.
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> evolutionShape: height ofColor: dictColor [
	| composite startPoint endPoint scale extent points values axis polyLine stepY nice niceY generations numbers |
	composite := RSComposite new 
		color: (dictColor at: 'background');
		border: (RSBorder new color: (dictColor at: 'border'); width: 2; yourself);
		draggable.
	stepY := 30.
	generations := numberOfGenerations + 1.
	startPoint := 0 @ 0.
	endPoint := 0 @ stepY.
	points := OrderedCollection new.
	values := OrderedCollection new.
	(self logs collect: [:log | 
		log fittestTestCase fitnessByClass values first at: targetClassName]) reverse 
		doWithIndex: [ :value :index | 
			| x |
			values add: value.
			x := (value - startPoint x) @ 0.
			startPoint := startPoint + x.
			endPoint := endPoint + x.
			points add: startPoint;
			add: endPoint.
			startPoint := endPoint.
			endPoint := (endPoint x) @ (endPoint y + stepY).
		].
	extent := (height * 0.6)@height.
	scale := NSScale linear 
		domain: (Array with: (values min)@0 with: (values max)@(generations * stepY));
		range: (Array with: 0@0 with: extent x@ extent y negated).
	axis := RSPolyline new 
		color: (dictColor at: 'border');
		width: 10;
		controlPoints: ({(values min - (values min * 0.01))@(generations *stepY). (values min - (values min * 0.01))@0. (values max+ (values max * 0.01))@0} collect: [:p | scale scale: p]);
		yourself.
	polyLine := RSPolyline new 
		controlPoints: (points collect: [:p | scale scale: p]); 
		color: (dictColor at: 'scaleLighter');
		width: 10;
		yourself.
	composite addShape: axis; addShape: polyLine.
	nice := RSLabelGenerator new searchMin: values min max: values max desired: 5. 
	(nice min to: nice max by: nice step) do: [ :i |
		| aTick lbl |
		aTick := RSLine new startPoint: (scale scale: (i@0));
			color: (dictColor at: 'font');
			width: 10;
			endPoint: (scale scale: (i@(-3)));
			yourself.
		composite addShape: aTick.
		lbl := RSLabel new 
		fontSize: (height*0.015);
		color: (dictColor at: 'font');
		text: (i asFloat) asString, '%'.
		RSLocation new below move: lbl on: aTick.
		composite addShape: lbl.
	].
	numbers := 0 to: generations.
	niceY := RSLabelGenerator new searchMin: stepY max: (generations * stepY) desired: generations.
	(niceY max to: niceY min by: (niceY step) * -1) doWithIndex: [ :i :index | 
		| tick lbl |
		tick := RSLine new startPoint: (scale scale: (values min - (values min * 0.01)@i));
			color: (dictColor at: 'font');
			width: 10;
			endPoint: (scale scale: ((values min - (values min * 0.015))@i));
			yourself.
		composite addShape: tick.
		lbl := RSLabel new 	
			fontSize: (height*0.02);
			color: (dictColor at: 'font');
			text: (numbers at: index).
		RSLocation new outer left move: lbl on: tick.
		composite addShape: lbl.
	].
	composite adjustToChildren.
	^ composite
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> fitnessOf: summaryExecMethod [
	^ summaryExecMethod summaryStatements 
		ifEmpty: [ 100 ] 
		ifNotEmpty: [ ((summaryExecMethod summaryStatements select: #executed) size / summaryExecMethod summaryStatements size) asFloat * 100 ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> infoMethodShapes: canvas ofColor: dictColor [
	| generationGroup filteredList generations memo minValue |
	generationGroup := RSGroup new.
	generations := numberOfGenerations + 1.
	filteredList := ((logs flatCollect: #population) select: [:tC | (tC generationNumber = generations or: [ tC allChildren detect: [:tCe |  tCe generationNumber = generations ] ifFound: [ true ] ifNone: [ false ]])]).
	minValue := (filteredList collect: [ :tC | tC fitnessByClass values first at: self targetClassName ]) min.
	memo := SMemo new.
	generationGroup addAll: (
		(filteredList groupedBy: [:tC | tC generationNumber]) collect: [ :testCases | 
			| group |
			group := RSGroup new.
			group addAll: (testCases collect: [ :testCase | 
				self methodShape: testCase ofColor: dictColor using: memo and: minValue.
			]).
			RSHorizontalLineLayout new gapSize: 20; on: group.
			group
	]).
	RSVerticalLineLayout new gapSize: 100;  on: generationGroup.
	RSEdgeBuilder verticalBezier  
		shapes: (generationGroup flatCollect: #yourself);
		canvas: canvas;
		width: 5;
		color: (dictColor at: 'backgroundLighter');
		connectFromAll: [ :testCase | testCase parents ].
	^ generationGroup flatCollect: #yourself
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> isCoverageSummary: summaryMethod of: testCase newOrHigherThan: previous using: memo [
	| prevSummaries currentCoverage |
	prevSummaries := previous select: [:summary | summary selector = summaryMethod selector].
	prevSummaries ifEmpty: [ ^ true ].
	^ ((Array with: summaryMethod) difference: prevSummaries) isNotEmpty or: [ 
		currentCoverage := self fitnessOf: summaryMethod.
		prevSummaries 
		anySatisfy: [ :summary | 
			memo at: summary of: testCase 
			ifPresent: [ :value | value < currentCoverage ]
			ifAbsent: [ false ] ]
		]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> lightColors [
	^ Dictionary new 
		at: 'background' put: Color white"(Color r: 0.9215686274509803 g: 0.9568627450980393 b: 0.9333333333333333 )";
		at: 'backgroundBoxMethod' put: (Color r: 0.1607843137254902 g: 0.3686274509803922 b: 0.4470588235294118);
		at: 'scaleLighter' put: (Color r: 0 g: 1 b: 0.67);
		at: 'scaleDarker' put: (Color r: 0.30980392156862746 g: 0.6235294117647059 b: 0.49019607843137253);
		at: 'backgroundLighter' put: (Color r: 0.611764705882353 g: 0.6431372549019608 b: 0.6274509803921569) "(Color r: 0.7647058823529411 g: 0.803921568627451 b: 0.788235294117647)";
		at: 'numberClasses' put: (Color r: 0.05 g: 0.75 b: 0.91);
		at: 'numberMethods' put: (Color r:0.88 g:0.26 b:0.5);
		at: 'fontMethodBox' put: Color white;
		at: 'border' put: (Color r: 0.12549019607843137 g: 0.1803921568627451 b: 0.23529411764705882);
		at: 'font' put: (Color r: 0.12549019607843137 g: 0.1803921568627451 b: 0.23529411764705882);
		yourself.
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> methodShape: testCase ofColor: dictColor using: memo and: minValue [ 
	| group scaleColor |
	group := RSGroup new.
	scaleColor := NSScale linear.
	scaleColor 
		range: (Array with: (dictColor at: 'scaleDarker') with: (dictColor at: 'scaleLighter'));
		domain: #(0 100).
	group 
		add: (self methodShapes: testCase ofColor: scaleColor and: memo);
		add: (self progressBarFrom: minValue to: (testCase fitnessByClass values first at: targetClassName) ofColor: dictColor).
	RSVerticalLineLayout on: group.
	^ RSComposite new 
		shapes: (group flatCollect: #yourself);
		paint: (dictColor at: 'backgroundBoxMethod');
		model: testCase;
		padding: 10;
		draggable 
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> methodShape: summaryExecMethod withGradientFrom: darkColor to: lightColor [
	| gradient group |
	gradient := LinearGradientPaint fromArray: (Array with: 0->darkColor with: 1->lightColor).
	gradient start: -50@0; stop: 50@0.
	group := RSGroup new.
	group add: (RSLabel new
						text: summaryExecMethod executorClass;
						fontSize: 8);
			add: (RSLabel new
						text: summaryExecMethod selector;
						fontSize: 8).
	RSVerticalLineLayout new on: group; gapSize: 0.
	^ RSComposite new size: 100;
				color: gradient; 
				model: summaryExecMethod;
				shapes: (group collect: #yourself);
				draggable;
				yourself.
				
	
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> methodShapes: testCase ofColor: scaleColor and: memo [
	| group conditionBlock prevSummaryMethods |
	group := RSGroup new.
	conditionBlock := [:summary | (summary executorClass = self targetClassName) 
			or: [ (summary executorClass splitOn: ' ') first = self targetClassName ] ].
	prevSummaryMethods := (testCase parents
		flatCollect: [:tC | tC summaryExecutionMethods select: [ :summary | conditionBlock value: summary ]
			]) asSet.
	group addAll: (testCase summaryExecutionMethods 
		select: [:summary | (conditionBlock value: summary) and: [ 
				self isCoverageSummary: summary of: testCase newOrHigherThan: prevSummaryMethods using: memo ] ]
		thenCollect: [:summary | 
			| valueFitness |
			valueFitness := self fitnessOf: summary.
			memo at: summary of: testCase put: valueFitness.
			self methodShape: summary withGradientFrom: (scaleColor scale: valueFitness) to: (scaleColor scale: 100).
		]).
	RSGridLayout on: group.
	^ group
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> progressBarFrom: minValue to: aValue ofColor: dictColor [ 
	| group groupBox groupData bar |
	group := RSGroup new.
	groupBox := RSGroup new.
	groupData := RSGroup new.
	groupBox 
		add: (RSBox new height: 10; color: (dictColor at: 'backgroundLighter'); width: minValue);
		add: (RSBox new height: 10; color: (dictColor at: 'scaleLighter'); width: aValue - minValue).
	RSHorizontalLineLayout new gapSize: 0; on: groupBox.
	bar := RSComposite new
		shapes: groupBox;
		yourself.
	groupData 
		add: bar;
		add: (RSLabel new text: aValue asString, '%'; bold; color: (dictColor at: 'fontMethodBox'); fontSize: 8).
	RSHorizontalLineLayout new gapSize: 10; on: groupData.
	group add: (RSComposite new shapes: groupData).
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
SGAEngine >> visualizationPaperWith: dictColor [
	| canvas summaryShape infoMethodShape evolutionShape |
	canvas := RSCanvas new 
		color: (dictColor at: 'background').
	infoMethodShape := self infoMethodShapes: canvas ofColor: dictColor.
	summaryShape := self addSummaryShapeTo: canvas ofHeight: infoMethodShape height andColor: dictColor.
	canvas addAll: infoMethodShape.
	self addBorderShape: infoMethodShape on: canvas ofColor: (dictColor at: 'border') andHeightOf: summaryShape.
	evolutionShape := self evolutionShape: infoMethodShape height ofColor: dictColor.
	RSLocation new top right offset: ((evolutionShape width + 20)@0); move: evolutionShape on: canvas shapes.
	canvas addShape: evolutionShape.
	self addDescriptiveTextOn: canvas ofColor: (dictColor at: 'font') and: (Array with: (infoMethodShape width / 4) with: (evolutionShape width / 4)).
	canvas @ RSCanvasController.
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
