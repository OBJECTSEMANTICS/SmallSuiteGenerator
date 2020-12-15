Extension { #name : #SGAViz }

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> addDescriptiveTextOn: canvas ofColor: color and: array [
	"Add descriptive text on canvas with color and offsets"
	
  | blockText text y xs texts |
  blockText := [:string |  self createRSLabelWith: string and: color ].
  texts := #('Static similarity' 'Coverage similarity' 'Generation contribution' 'Evolution of Genetic Algorithm' 'Evolution coverage %').
  y := array first.
  xs := array second.
  texts doWithIndex: [:txt :idx | | label x |
		  x := xs nextOrNil.
		  idx == 3 ifTrue: [ 
				(txt splitOn: ' ') with: #(-0.2 -0.15 ) do: [ :t :p | 
					label := blockText value: t.
					label translateTo: x @ (y * p).
					canvas addShape: label
					 ]
		  ] ifFalse: [ 
				label := blockText value: txt.
				label translateTo: (x @ (y * -0.2)).
         		"association value move: label on: canvas shapes."
        		canvas addShape: label ] ].
  text := blockText value: self stringTargetClassInPackage.
  self createTopCenterRSLocationOn: canvas with: text.
  canvas addShape: text
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> addHighlightMethodEvent: highlight on: canvas ofColor: color [
  | interaction |
  interaction := self rshighlightableWith: color.
  highlight
     when: RSHighlightEvent do: [:evt |  | shapes shape index |
        index := 0.
        shape := canvas shapes detect: [:sh |  index := index + 1.
              sh model isNotNil and: [ sh children isNotNil and: [ sh children includes: evt shape ] ] ] ifNone: [ nil ].
        shape ifNotNil: [ shapes := shape model allParents.
              shapes := (canvas shapes first: index - 1) select: [:s |  shapes includes: s model ].
              shapes := (shapes flatCollect: #children) select: [:sh |  [ sh model selector = evt shape model selector ] on: MessageNotUnderstood do: [ false ] ].
              interaction doHighlightShapes: shapes.
              canvas propertyAt: #summaryExecutedMethods put: shapes ] ];
     when: RSUnHighlightEvent do: [:evt |  (canvas propertyAt: #summaryExecutedMethods ifAbsent: [ #() ]) do: [:shape |  interaction restore: shape selector: #color ] ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> addHighlightTestCaseEvent: highlight on: canvas ofColor: color [
	| interaction  |
	interaction := self rshighlightableWith: color.
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
SGAViz >> addLegend: associations on: container withFontColor: color and: blockLocation [
  | legend |
  legend := RSLegend new
     container: container;
     defaultLabel: (self rsLabelWith: color);
     yourself.
  associations do: [:assoc |  | colorBox |
        colorBox := assoc value.
        colorBox isArray ifFalse: [ legend text: assoc key withBoxColor: colorBox ] ifTrue: [ colorBox first isColor ifTrue: [ legend text: assoc key withShape: (legend defaultBox
                             border: (self rsBorderWithColorBox: colorBox);
                             paint: colorBox first) ] ifFalse: [ legend text: assoc key withFadingRamp: colorBox ] ] ].
  legend legendDo: [:l |  l
           padding: 5;
           scaleBy: 2.5 ].
  blockLocation value: legend.
  legend build
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> addLegend: associations on: container withFontColor: color key: string and: blockLocation [
  | legend stack |
  legend := RSLegend new
     container: container;
     defaultLabel: (self rsLabelWith: color);
     yourself.
	stack := Stack new push: 2; push: 4; yourself.
  associations do: [:assoc |  | colorBox |
        colorBox := assoc value.
        colorBox isArray 
			ifFalse: [ string = 'similarity' 
							ifTrue: [ 
								legend text: assoc key withShape: 
								(RSLine new color: assoc value; width: stack pop; yourself; startPoint: 30@0; endPoint: 0@0; yourself) ] 
							ifFalse: [ legend text: assoc key withBoxColor: colorBox ] ] 
			ifTrue: [ colorBox first isColor 
							ifTrue: [ legend text: assoc key withShape: (legend defaultBox
                             border: (self rsBorderWithColorBox: colorBox);
                             paint: colorBox first) ] 
							ifFalse: [ legend text: assoc key withFadingRamp: colorBox ] ] ].
  legend legendDo: [:l |  l
           padding: 5;
           scaleBy: 2.5 ].
  blockLocation value: legend.
  legend build
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> addLegendOn: canvas locations: locations with: dictColor [
	| colors |
	self addLegend: (Array with: 'More-similar' -> (dictColor at: 'edgeSimilarity')
		with: ('Less-similar' -> (dictColor at: 'edgeSimilarity'))) on: canvas withFontColor: (dictColor at: 'font') key: 'similarity' and: [ :legend | legend location below left offset: (500@0) ].
		
	self addLegend: (Array with: 'Class coverage' -> (dictColor at: 'classCoverage')
		with: 'Method coverage' -> (dictColor at: 'methodCoverage')
		with: 'Branch coverage' -> (dictColor at: 'statementCoverage')) on: canvas withFontColor: (dictColor at: 'font') key: 'coverage' and: [:legend | legend location below left "legend translateTo: locations nextOrNil" offset: (1250@100 negated) ].
		
	colors := dictColor at: 'rangeMethodColor'.
	self addLegend: (Array  
			with: 'Testcase (TC)' -> (dictColor at: 'backgroundTestCase') 
			with: 'TC with higher coverage than parents' -> (Array with: (dictColor at: 'backgroundTestCase') with: (dictColor at: 'borderTestCase'))
			with: 'Executed methods' -> (Array with: 0 -> colors first with: 1 -> (colors at: 19))) on: canvas  withFontColor: (dictColor at: 'font') key: 'range' and: [ :legend | legend location below center "legend translateTo: locations nextOrNil " offset: 0@150 negated ].
			
	self addLegend: (Array with: 'Lowest-Fitness' -> (dictColor at: 'lowestCoverage')
		with: ('Average-Fitness' -> (dictColor at: 'averageCoverage'))
		with: ('Fittest-Fitness' -> (dictColor at: 'fittestCoverage'))) on: canvas withFontColor: (dictColor at: 'font') key: 'coverage' and: [:legend | legend location below right " legend translateTo: locations nextOrNil "offset: -700@150 negated ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> addLegendOn: canvas with: dictColor [
	| colors |
	self addLegend: (Array with: 'More-similar' -> (dictColor at: 'edgeSimilarity')
		with: ('Less-similar' -> (dictColor at: 'edgeSimilarity'))) on: canvas withFontColor: (dictColor at: 'font') key: 'similarity' and: [ :legend | legend location below left offset: (450@0) ].
		
	self addLegend: (Array with: 'Class coverage' -> (dictColor at: 'classCoverage')
		with: 'Method coverage' -> (dictColor at: 'methodCoverage')
		with: 'Branch coverage' -> (dictColor at: 'statementCoverage')) on: canvas withFontColor: (dictColor at: 'font') key: 'coverage' and: [:legend | legend location below left offset: (850@100 negated) ].
		
	colors := dictColor at: 'rangeMethodColor'.
	self addLegend: (Array  
			with: 'Testcase (TC)' -> (dictColor at: 'backgroundTestCase') 
			with: 'TC with higher coverage than parents' -> (Array with: (dictColor at: 'backgroundTestCase') with: (dictColor at: 'borderTestCase'))
			with: 'Executed methods' -> (Array with: 0 -> colors first with: 1 -> (colors at: 19))) on: canvas  withFontColor: (dictColor at: 'font') key: 'range' and: [ :legend | legend location below center offset: -100@150 negated ].
			
	self addLegend: (Array with: 'Lowest-Fitness' -> (dictColor at: 'lowestCoverage')
		with: ('Average-Fitness' -> (dictColor at: 'averageCoverage'))
		with: ('Fittest-Fitness' -> (dictColor at: 'fittestCoverage'))) on: canvas withFontColor: (dictColor at: 'font') key: 'coverage' and: [:legend | legend location below right offset: -700@150 negated ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> addSurvivorTestCase: testCase on: collection using: set and: maxNumber [
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
SGAViz >> addTickX: composite withScale: scale color: color y: y and: posMax [
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
SGAViz >> addTickX: composite withScale: scale color: color y: y step: step and: posMax [
	| stepX |
	stepX := posMax x / step.
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
		text: (i round: 1) asString.
		RSLocation new below move: lbl on: aTick.
		composite addShape: lbl.
	].
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> addTickY: composite withScale: xScale xMax: xMax ofColor: color andPositions: ys [
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
SGAViz >> borderOfSize: size andColor: color [
	^ RSBox new 
		color: Color transparent;
		border: (RSBorder new width: 2; color: color; yourself);
		width: size x + 40;
		height: size y;
		yourself.
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> contributionShapeOfHeight: height color: dictColor and: ys [
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
SGAViz >> createRSLabelWith: aString and: aColor [

 	^ RSLabel new
     	text: aString;
     	color: aColor;
     	fontSize: 40;
     	yourself
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> createTopCenterRSLocationOn: canvas with: text [
  RSLocation new top center
     offset: 0 @ 130 negated;
     move: text on: canvas shapes
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> createTopCenterRSLocationWith: offsets [
  ^ RSLocation new top center
     offset: offsets first @ 10 negated;
     yourself
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> createTopLeftNextRSLocation [
  ^ RSLocation new top left
     offset: 420 @ 100 negated;
     yourself
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> createTopLeftRSLocation [
  ^ RSLocation new top left
     "offset: 0 @ 50 negated;"
     yourself
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> createTopRightRSLocationWith: offsets [
  ^RSLocation new top right
     offset: offsets second @ 200 negated;
     yourself
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz class >> darkColors [
	^ Dictionary new 
		at: 'background' put: (Color r: 0.12549019607843137 g: 0.1803921568627451 b: 0.23529411764705882);
		at: 'backgroundTestCase' put: (Color r: 0.1607843137254902 g: 0.3686274509803922 b: 0.4470588235294118);
		at: 'backgroundHigherFitnessTestCase' put:  (Color fromHexString: '1B8D8D' "'0B6969'""'1E7676'");
		at: 'scaleLighter' put: (Color r: 0.5098039215686274 g: 0.9607843137254902 b: 0.7725490196078432);
		at: 'scaleDarker' put: (Color r: 0.30980392156862746 g: 0.6235294117647059 b: 0.49019607843137253);
		at: 'baseBar' put: (Color r: 0.7647058823529411 g: 0.803921568627451 b: 0.788235294117647);
		at: 'forwardBar' put: (Color r: 0.5098039215686274 g: 0.9607843137254902 b: 0.7725490196078432);
		at: 'backwardBar' put: (Color r: 1 g: 0 b: 0.25098039215686274);
		at: 'edge' put: (Color r: 0.7647058823529411 g: 0.803921568627451 b: 0.788235294117647);
		at: 'classCoverage' put: (Color r: 0.5098039215686274 g: 0.7803921568627451 b: 0.9607843137254902);
		at: 'methodCoverage' put: (Color r: 0.9607843137254902 g: 0.5098039215686274 b: 0.7215686274509804);
		at: 'statementCoverage' put: (Color r: 0.5098039215686274 g: 0.9607843137254902 b: 0.7725490196078432);
		at: 'highlightTestCase' put: (Color r: 0.13725490196078433 g: 0.7215686274509804 b: 0.7725490196078432 alpha: 0.8);
		at: 'highlightMethod' put: Color cyan;
		at: 'fontMethodBox' put: Color white;
		at: 'border' put: Color white;
		at: 'axis' put: Color white;
		at: 'fittestCoverage' put: (Color r: 0 g: 1 b: 0.67);
		at: 'averageCoverage' put: (Color r: 0.5063538611925709 g: 0.5259042033235581 b: 0.8357771260997068);
		at: 'lowestCoverage' put: (Color pink);
		at: 'seedCoverage' put: (Color r: 0.9530791788856305 g: 0.5102639296187683 b: 0.43499511241446726);
		at: 'font' put: Color white;
		at: 'rangeMethodColor' put:
			(#('83142C' 'AF0404' 'BB1542' 'ED3833' 'EB5F5D' 'F3826F' 'FFBA92' 'F0DAB1' 'FFF8CD' 'F7FF56' 'DCFFCC' 'DDF796' 'C3F584' 'A3F7BF' '6bffb8' '42E6A4' '4DD599' '71A95A' '007944' '00818A' '216583' '366ED8' '64C4ED' '5EDFFF' 'B2FCFF' 'FFEDFF' 'C6CBEF' '8186D5' '494CA2' '560764' '930077' 'D527B7' 'FF78AE' 'FFA0D2' ) collect: [:c | Color fromHexString: c ]);
		yourself.
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> engine [ 
	^ aTestCaseFactory engine
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> evolutionPoints: ypositions withScale: scale [
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
			with: (log fittestTestCase fitnessByClass values first at: self targetClassName ifAbsent: [0])])
		doWithIndex: [ :array  :index | | y |
			y := ypositions at: index.
			listLowest add: (scale scale: array first) @ y.
			listAverage add: (scale scale: array second) @ y.
			listFittest add: (scale scale: array third) @ y
		].
	^ points
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> evolutionShapeWith: yPositions ofColor: dictColor size: size [
	| composite scale points axis spaceStick xMax yMax |
	composite := RSComposite new 
		color: Color transparent.
	xMax := self logs last fittestTestCase fitnessByClass values first at: self targetClassName.
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
SGAViz >> fitnessOf: summaryExecMethod [
	^ summaryExecMethod summaryStatements 
		ifEmpty: [ 100 ] 
		ifNotEmpty: [ ((summaryExecMethod summaryStatements select: #executed) size / summaryExecMethod summaryStatements size) asFloat * 100 ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> fitnessResultAsDictionary [
	| functionNames dictResult |
	self
		assert: (self engine isNil not and: [ self engine logs isNotEmpty ])
		description: 'Run the generation before'.
	functionNames := (Array with: self engine fitness functionName) asSet.
	dictResult := Dictionary new.
	self engine logs doWithIndex: [ :log :index | 
			functionNames do: [ :functionName | 
			| val |
			val := dictResult
				       at: functionName , '_fittest'
				       ifAbsentPut: [ OrderedCollection new ].
			val add: (index @ (log fittestTestCase fitness at: functionName)).
			val := dictResult
				       at: functionName , '_average'
				       ifAbsentPut: [ OrderedCollection new ].
			val add: (index @ (log averageFit at: functionName)).
			val := dictResult
				       at: functionName , '_lowest'
				       ifAbsentPut: [ OrderedCollection new ].
			val add: (index @ (log lowestFit at: functionName)) ] ].
	^ dictResult
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> generationEvolutionCanvas [
	^ self 
		generationVisualizationWithColor: self class lightColors 
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> generationVisualizationWithColor: dictColor [
	| canvas contributionShape infoMethodShape evolutionShape highlightTestCase highlightMethod ys border widthShape barGroup height similarityCoverageShape similarityShape lines posBorder posLegend xs testIds |
	canvas := RSCanvas new 
		color: (dictColor at: 'background').
	highlightTestCase := RSHighlightable new 
		highlightColor: (dictColor at: 'highlightTestCase');
		yourself.
	highlightMethod := RSHighlightable new 
		highlightColor: (dictColor at: 'highlightMethod');
		yourself.
	infoMethodShape := self infoMethodShapesOn: canvas ofColor: dictColor highlight: (Array with: highlightTestCase with: highlightMethod).
	testIds := infoMethodShape at: 4.
	ys := infoMethodShape at: 3.
	barGroup := infoMethodShape at: 2.
	infoMethodShape := infoMethodShape at: 1.
	height := infoMethodShape height.
	contributionShape := self contributionShapeOfHeight: height color: dictColor and: (ys collect: #key).
	similarityCoverageShape := self similarityCoverageShape: canvas withHeight: height testIds: testIds color: dictColor and: (ys collect: [:ass | ass key + (ass value / 2)]).
	
	"similarity of static methods"
	similarityShape := self similarityShape: canvas withHeight: height testIds: testIds color: dictColor and: (ys collect: [:ass | ass key + (ass value / 2)]).
	lines := similarityShape second.
	similarityShape := similarityShape first.
	similarityShape translateTo: (infoMethodShape encompassingRectangle topLeft x - (similarityShape encompassingRectangle width) - (similarityCoverageShape first encompassingRectangle width) - (contributionShape encompassingRectangle width) - 100) @ similarityShape  position y.
	canvas addShape: similarityShape.
	lines := (lines flatCollect: #yourself) asGroup.
	canvas addAll: lines.
	lines pushBack.
	
	"ys := ys collect: #key."
	lines := similarityCoverageShape second.
	similarityCoverageShape := similarityCoverageShape first.
	barGroup := RSComposite new shapes: (self setPositions: barGroup using: (ys collect: #key)).
	"align the contribution element"
	contributionShape translateTo: infoMethodShape encompassingRectangle topLeft x - (contributionShape encompassingRectangle width) @ contributionShape position y.
	
	similarityCoverageShape translateTo: (infoMethodShape encompassingRectangle topLeft x - (similarityCoverageShape encompassingRectangle width) - (contributionShape encompassingRectangle width) - 50) @ similarityCoverageShape  position y.
	canvas addShape: similarityCoverageShape.
	lines := (lines flatCollect: #yourself) asGroup.
	canvas addAll: lines.
	lines pushBack.
	
	"add contributionShape on canvas"
	contributionShape translateTo: (infoMethodShape encompassingRectangle topLeft x - contributionShape width - 50) @ infoMethodShape position y.
	canvas addShape: contributionShape.
	"add infoMethodShapeGroup on canvas"
	canvas addAll: infoMethodShape.
	"add barGroup on canvas"
	"RSLocation new right offset: ((barGroup width * 1.2)@0); move: barGroup on: canvas shapes."
	barGroup translateTo: (infoMethodShape encompassingRectangle topRight x + (barGroup width * 1.2)) @ infoMethodShape position y.
	canvas addShape: barGroup.
	"addition of highlight"
	self addHighlightTestCaseEvent: highlightTestCase on: canvas ofColor: (dictColor at: 'highlightTestCase').
	self addHighlightMethodEvent: highlightMethod on: canvas ofColor: (dictColor at: 'highlightMethod').
	widthShape := 800.
	evolutionShape := self evolutionShapeWith: (ys collect: #key) ofColor: dictColor size: widthShape @height negated.
	height := (Array with: contributionShape height with: height with: evolutionShape height with: similarityCoverageShape height) max + ((infoMethodShape select: [:e | (e model isKindOf: SSTestCase) and: [ e model generationNumber == (self engine logs size)  ] ] thenCollect: #height) max).
	posLegend := SharedQueue new.
	xs := SharedQueue new.
	
	"addition of similarityShape border"
	posBorder := infoMethodShape encompassingRectangle topLeft x - (contributionShape encompassingRectangle width + similarityShape encompassingRectangle width + similarityCoverageShape encompassingRectangle width + 100).
	border := self borderOfSize: similarityShape width @ (height + 20) andColor: (dictColor at: 'border').
	border translateTo: posBorder @ infoMethodShape position y.
	posLegend nextPut: posBorder @ (height + 30).
	xs nextPut: posBorder.
	canvas addShape: border.
	
	"addition of similarityCoverageShape border"
	posBorder := infoMethodShape encompassingRectangle topLeft x - (contributionShape encompassingRectangle width + similarityCoverageShape encompassingRectangle width + 50).
	border := self borderOfSize: similarityCoverageShape width @ (height + 20) andColor: (dictColor at: 'border').
	border translateTo: posBorder @ infoMethodShape position y.
	posLegend nextPut: posBorder @ (height + 30).
	xs nextPut: posBorder.
	canvas addShape: border.
	
	"addition of contributionShape border"
	posBorder := infoMethodShape encompassingRectangle topLeft x - (contributionShape encompassingRectangle width + 40).
	border := self borderOfSize: contributionShape width @ (height + 20) andColor: (dictColor at: 'border').
	border translateTo: posBorder @ infoMethodShape position y.
	posLegend nextPut: posBorder @ height + 30.
	xs nextPut: posBorder + 40.
	canvas addShape: border.
	
	posBorder := infoMethodShape encompassingRectangle center x + 165 "+ (border width* 0.47)". "infoMethodShape encompassingRectangle center x + border encompassingRectangle corner x + border width."
	"addition of infoMethodShape border"
	border := self borderOfSize: (infoMethodShape width + (barGroup width * 2) + (border width/3)) @ (height+20) andColor: (dictColor at: 'border').
	"RSLocation new middle offset: (similarityShape width)@0; move: border on: canvas shapes. "
	border translateTo: posBorder @ infoMethodShape position y.
	posLegend nextPut: posBorder @ height + 30.
	xs nextPut: posBorder.
	canvas addShape: border.
	"add evolutionShape on canvas"
	evolutionShape translateTo: (barGroup encompassingRectangle topRight x + 550) @ (contributionShape position y + 25).
	canvas addShape: evolutionShape.
	"border of evolutionShape"
	posBorder := infoMethodShape encompassingRectangle topRight x + evolutionShape width + (evolutionShape width * 0.07).
	border := self borderOfSize: ((widthShape * 1.1) @ (height + 20)) andColor: (dictColor at: 'border').
	"RSLocation new top right offset: 0@5 negated; move: border on: canvas shapes."
	border translateTo: posBorder @ infoMethodShape position y.
	posLegend nextPut: posBorder @ height + 30.
	xs nextPut: posBorder.
	canvas addShape: border.
	"add descriptive text on canvas"
	self addDescriptiveTextOn: canvas ofColor: (dictColor at: 'font') and: (Array with: infoMethodShape position y with: xs) "(Array with: ((infoMethodShape width / 10) negated ) with: -200)".
	self addLegendOn: canvas locations: posLegend with: dictColor.
	canvas @ RSCanvasController.
	^ canvas
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> infoMethodShapesOn: canvas ofColor: dictColor highlight: highlights [
	| generationGroup filteredList memo scaleColorBlock set barGroup shapes ys testIds |
	generationGroup := RSGroup new.
	barGroup := RSGroup new.
	filteredList := OrderedCollection new.
	testIds := Dictionary new.
	set := Set new.
	ys := OrderedCollection new.
	self logs first population do: [ :tC | self addSurvivorTestCase: tC on: filteredList using: set and: self logs size ].
	filteredList sort: [ :tC1 :tC2 | (tC1 generationNumber < tC2 generationNumber) or: [ (tC1 generationNumber = tC2 generationNumber) and: [  tC1 children size < tC2 children size ] ] ].
  memo := SMemo new.
	scaleColorBlock := self scaleColorBlock: (self methodColorDictionary: (dictColor at: 'rangeMethodColor')).
	generationGroup addAll: (
		(filteredList groupedBy: [:tC | tC generationNumber]) collect: [ :testCases | 
			| group generationNumber |
			group := RSGroup new.
			group addAll: (testCases collect: [ :testCase | 
				testIds at: testCase generationNumber 
					ifPresent: [ :col | col add: testCase idPopulation ]
					ifAbsentPut: [ OrderedCollection new add: testCase idPopulation; yourself ].
				(self testCaseShape: testCase 
					ofColor: dictColor 
					with: memo
					highlight: highlights second
					scale: scaleColorBlock) @ highlights first; yourself.
			]).
			RSHorizontalLineLayout new gapSize: 20; on: group.
			generationNumber := testCases first generationNumber.
			barGroup add: (self progressBarFrom: testCases size value to: (self logs at: generationNumber) population size ofColor: dictColor).
			group
	]).
	RSVerticalLineLayout new gapSize: 200;  on: generationGroup.
	shapes := generationGroup flatCollect: #yourself.
	ys := (shapes groupedBy: [ :s | s encompassingRectangle origin y ]) associations 
		collect: [:assoc | assoc key -> (assoc value collect: [:comp | comp extent y ]) max ].
	RSEdgeBuilder verticalBezier  
		shapes: shapes;
		canvas: canvas;
		width: 5;
		color: (dictColor at: 'edge');
		connectFromAll: [ :testCase | testCase parents ].
	^ Array with: shapes with: barGroup with: ys with: testIds
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> isCoverage: coverage ofSummaryMethod: summaryMethod in: testCase newOrHigher: memo [
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
SGAViz class >> lightColors [
	^ Dictionary new 
		at: 'background' put: Color white;
		"at: 'backgroundTestCase' put: (Color r: 0.1607843137254902 g: 0.3686274509803922 b: 0.4470588235294118);"
		at: 'backgroundTestCase' put: (Color fromHexString: 'ebecf0');
		"at: 'backgroundHigherFitnessTestCase' put: (Color fromHexString: '1B8D8D' '0B6969' '1E7676');"
		at: 'borderTestCase' put: (Color r: 0.1607843137254902 g: 0.3686274509803922 b: 0.4470588235294118);
		at: 'scaleLighter' put: (Color r: 0 g: 1 b: 0.67);
		at: 'scaleDarker' put: (Color r: 0 g: 0 b: 0 alpha: 0.1)"(Color r: 0.30980392156862746 g: 0.6235294117647059 b: 0.49019607843137253)";
		at: 'baseBar' put: Color white;
		at: 'forwardBar' put: (Color r: 0.611764705882353 g: 0.6431372549019608 b: 0.6274509803921569);
		at: 'backwardBar' put: (Color r: 1 g: 0 b: 0.25098039215686274);
		at: 'edge' put: (Color r: 0.611764705882353 g: 0.6431372549019608 b: 0.6274509803921569);
		at: 'classCoverage' put: (Color r: 0.05 g: 0.75 b: 0.91);
		at: 'methodCoverage' put: (Color r:0.88 g:0.26 b:0.5);
		at: 'statementCoverage' put: (Color r: 0 g: 1 b: 0.67);
		at: 'highlightTestCase' put: (Color r: 0.13725490196078433 g: 0.7215686274509804 b: 0.7725490196078432 alpha: 0.8);
		at: 'highlightMethod' put: Color cyan"(Color r: 111/255 g: 1 b: 233/255)";
		"at: 'fontMethodBox' put: Color white;"
		at: 'fontMethodBox' put: Color black;
		at: 'border' put: (Color r: 0.12549019607843137 g: 0.1803921568627451 b: 0.23529411764705882);
		at: 'axis' put: (Color r: 0.12549019607843137 g: 0.1803921568627451 b: 0.23529411764705882);
		at: 'fittestCoverage' put: (Color r: 0 g: 1 b: 0.67);
		at: 'averageCoverage' put: (Color r: 0.5063538611925709 g: 0.5259042033235581 b: 0.8357771260997068);
		at: 'lowestCoverage' put: (Color pink);
		at: 'seedCoverage' put: (Color r: 0.9530791788856305 g: 0.5102639296187683 b: 0.43499511241446726);
		at: 'font' put: (Color r: 0.12549019607843137 g: 0.1803921568627451 b: 0.23529411764705882);
		at: 'rangeMethodColor' put:
			(#('83142C' 'AF0404' 'BB1542' 'ED3833' 'EB5F5D' 'F3826F' 'FFBA92' 'F0DAB1' 'FFF8CD' 'F7FF56' 'DCFFCC' 'DDF796' 'C3F584' 'A3F7BF' '6bffb8' '42E6A4' '4DD599' '71A95A' '007944' '00818A' '216583' '366ED8' '64C4ED' '5EDFFF' 'B2FCFF' 'FFEDFF' 'C6CBEF' '8186D5' '494CA2' '560764' '930077' 'D527B7' 'FF78AE' 'FFA0D2' ) collect: [:c | Color fromHexString: c ]);
		at: 'edgeSimilarity' put: (Color r: 0.12903225806451613 g: 0.39589442815249265 b: 0.5141739980449658);
		at: 'testcaseNode' put: (Color transparent);
		at: 'markedTestCaseNode' put: (Color r: 0 g: 1 b: 0.67);
		at: 'testcaseFontColor' put: (Color black);
		yourself.
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> logs [
	^ self engine logs
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> methodColorDictionary: rangeColor [
	| typeInfoClass color methodColorList index scale sizeRangeColor |
	typeInfoClass := self typeInfo classAt: self targetClassName.
	methodColorList := OrderedCollection new.
	sizeRangeColor := rangeColor size.
	scale := NSScale linear range: (Array with: 1 with: typeInfoClass allMethods size); domain: (Array with: 1 with: sizeRangeColor).
	color := NSScale linear range: rangeColor; domain: ((1 to: sizeRangeColor) collect: [:n | scale scale: n]).
	index := 0.
	methodColorList addAll: (typeInfoClass methodTypes collect: [:method | 
		index := index + 1.
		(self targetClassName -> method selector) -> (color scale: index)
		]).
	methodColorList addAll: (typeInfoClass classMethodTypes collect: [:method | 
		index := index + 1.
		(self targetClassName, ' class' -> method selector) -> (color scale: index)]).
	^ methodColorList asDictionary 
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> methodShape: summaryExecMethod withGradientFrom: darkColor to: lightColor [
	| gradient group |
	gradient := LinearGradientPaint fromArray: (Array with: 0->darkColor with: 1->lightColor).
	gradient start: -50@0; stop: 50@0.
	group := RSGroup new.
	RSVerticalLineLayout new on: group; gapSize: 0.
	^ RSBox new size: 50;
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
				"shapes: (group collect: #yourself);"
				yourself.
				
	
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> methodShape: summaryExecMethod withGradientFrom: darkColor to: lightColor andShape: shape [
	| gradient group |
	gradient := LinearGradientPaint fromArray: (Array with: 0->darkColor with: 1->lightColor).
	gradient start: -50@0; stop: 50@0.
	group := RSGroup new.
	RSVerticalLineLayout new on: group; gapSize: 0.
	^ shape size: 50;
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
				"shapes: (group collect: #yourself);"
				yourself.
				
	
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> methodShapeGroup: testCase with: memo highlight: highlight scale: scaleColorBlock [
	| group calledSelectors |
	group := RSGroup new.
	calledSelectors := self calledSelectors: self engine targetClassName by: testCase.
	group addAll: ((self summaryMethodsOfTargetClass: testCase summaryExecutionMethods)
		select: [:summary |
			| coverage |
			coverage := self fitnessOf: summary.
			memo at: summary of: testCase generationNumber and: testCase idPopulation put: coverage.
			self isCoverage: coverage ofSummaryMethod: summary in: testCase newOrHigher: memo ]
		thenCollect: [:summary | 
			| scaleColor |
			scaleColor := scaleColorBlock value: summary executorClass -> summary selector.
			(self methodShape: summary withGradientFrom: (scaleColor scale: (self fitnessOf: summary)) to: (scaleColor scale: 100) andShape: ((calledSelectors includes: summary executorClass -> summary selector) ifTrue: [ RSEllipse new ] ifFalse: [ RSBox new ])) @ highlight; yourself.
		]).
	RSGridLayout on: group.
	^ group
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> progressBarFrom: progressValue to: maxValue ofColor: dictColor [
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
SGAViz >> rsBorderWithColorBox: colorBox [
  ^RSBorder new color: colorBox second
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> rsLabelWith: color [
  ^RSLabel new
     color: color;
     yourself
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> rshighlightableWith: color [

	^ RSHighlightable new
     highlightColor: color;
     yourself
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> scaleColorBlock: methodColorDictionary [
	^ [:key | 
		| color |
		color := [ methodColorDictionary at: key] on: KeyNotFound do: [ Color black ].
		NSScale linear 
		range: (Array with: (color alphaMixed: 0.6 with: Color black) with: color);
		domain: #(0 100)].
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> setPositions: barGroup using: ys [
	ys doWithIndex: [ :y :index | 
		(barGroup at: index) translateTo: 0@y ].
	^ barGroup
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> similarityCoverageGroupOfColor: dictColor with: testIds size: size on: canvas [
	^ self engine logs collect: [ :log | 
		self similarityCoverageShape: log population with: testIds ofColor: dictColor size: size on: canvas.
	]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> similarityCoverageShape: population with: testIds ofColor: dictColor size: size on: canvas [
  	| similarityShape lines scale |
	similarityShape := self groupTestCases: population with: testIds ofColor: dictColor and: size.
	"factor := 1.
	jacIndexes := (population flatCollect: [ :tC1 |
			population select: [ :tC2 | tC2 generationNumber ~= tC1 generationNumber 
						or: [ tC2 idPopulation ~= tC1 idPopulation ] ]
				thenCollect: [ :tC2 | self jaccarIndexOf: tC1 and: tC2 ] ]) asSet."
	scale := NSScale linear domain: #(0 1); range: #(0 2).
	lines := OrderedCollection new.
	similarityShape shapes do: [:from |
					lines addAll: (similarityShape shapes select: [ :to | 
						(from model generationNumber ~= to model generationNumber 
						or: [ from model idPopulation ~= to model idPopulation ]) ]
					thenCollect: [ :to | 
					RSLine new 
					model: from model -> to model;
					from: from;
					color: (dictColor at: 'edgeSimilarity');
					to: to;
					width: (scale scale: (self jaccarIndexOf: from model and: to model));
					yourself ] ) ].
		
		"RSNormalizer new
		""from: jacIndexes min * factor 0;
		to: jacIndexes max * factor 1;""
		shapes: lines;
		executeBlock: [ :shape :val | shape width: val ];
		normalize: [ :assoc | self jaccarIndexOf: assoc key and: assoc value ]."
		^ Array with: similarityShape with: lines asGroup
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> similarityCoverageShape: canvas withHeight: height testIds: testIds color: dictColor and: ys [
  	| groupSimilarity element scale x lines |
	scale := NSScale linear
		domain: (Array with: 0 with: ys size);
		range: (Array with: 0 with: height).
	groupSimilarity := self similarityCoverageGroupOfColor: dictColor with: testIds size: (scale scale: 0.8) on: canvas.
	lines := (groupSimilarity collect: #second) asGroup.
	groupSimilarity := (groupSimilarity collect: #first) asGroup.
	x := groupSimilarity first width / 2.0.
	"extent := groupSimilarity first nodes first extent / 2."
	groupSimilarity with: (ys collect: [:y | x @ y ]) do: [ :shape :position | 
		shape translateTo: position "x @ ((extent y - position y) abs)".
		 ].
	element := RSComposite new 
		shapes: groupSimilarity;
		yourself.
	^ Array with: element with: lines
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> similarityGroup: testIds ofColor: dictColor size: size on: canvas [
	^ self engine logs collect: [ :log | 
		self similarityShape: log population with: testIds ofColor: dictColor size: size on: canvas.
	]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> similarityShape: population with: testIds ofColor: dictColor size: size on: canvas [
  	| similarityShape lines scale |
	similarityShape := self groupTestCases: population with: testIds ofColor: dictColor and: size.
	"factor := 1.
	jacIndexes := (population flatCollect: [ :tC1 |
			population select: [ :tC2 | tC2 generationNumber ~= tC1 generationNumber 
						or: [ tC2 idPopulation ~= tC1 idPopulation ] ]
				thenCollect: [ :tC2 | self jaccarIndexOf: tC1 and: tC2 ] ]) asSet."
	scale := NSScale linear range: #(0 2); domain: #(0 1).
	lines := OrderedCollection new.
	similarityShape shapes do: [:from |
					lines addAll: (similarityShape shapes select: [ :to | 
						(from model generationNumber ~= to model generationNumber 
						or: [ from model idPopulation ~= to model idPopulation ]) ]
					thenCollect: [ :to | 
					RSLine new 
					model: from model -> to model;
					from: from;
					color: (dictColor at: 'edgeSimilarity');
					to: to;
					width: (scale scale: (self jaccarIndexStaticOf: from model and: to model));
					yourself ] ) ].
		"RSNormalizer new
		shapes: lines;
		executeBlock: [ :shape :val | shape width: val ];
		normalize: [ :assoc | self jaccarIndexStaticOf: assoc key and: assoc value ]."
		^ Array with: similarityShape with: lines asGroup
	
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> similarityShape: canvas withHeight: height testIds: testIds color: dictColor and: ys [
  	| groupSimilarity element scale x lines |
	scale := NSScale linear
		domain: (Array with: 0 with: ys size);
		range: (Array with: 0 with: height).
	groupSimilarity := self similarityGroup: testIds ofColor: dictColor size: (scale scale: 0.8) on: canvas.
	lines := (groupSimilarity collect: #second) asGroup.
	groupSimilarity := (groupSimilarity collect: #first) asGroup.
	x := groupSimilarity first width / 2.0.
	"extent := groupSimilarity first nodes first extent / 2."
	groupSimilarity with: (ys collect: [:y | x @ y ]) do: [ :shape :position | 
		shape translateTo: position "x @ ((extent y - position y) abs)".
		 ].
	element := RSComposite new 
		shapes: groupSimilarity;
		yourself.
	^ Array with: element with: lines
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> sparkCircleGroupOfColor: dictColor andSize: size [
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
	^ self engine logs collect: [ :log | 
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
SGAViz >> stringTargetClassInPackage [
  ^ 'TargetClass: ' , self targetClassName , ' in package: ' , self targetPackageRegex
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> summaryMethodsOfTargetClass: summaryMethods [
	^ summaryMethods select: [ :summary | 
		(summary executorClass = self targetClassName) or: 
		[ (summary executorClass splitOn: ' ') first = self targetClassName ] ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> targetClassName [
	^ self engine targetClassName
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> targetPackageRegex [
	^ self engine targetPackageRegex
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> testCaseShape: testCase ofColor: dictColor with: memo highlight: highlight scale: scaleColorBlock [

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

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> typeInfo [
	^ self engine typeInfo
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAViz >> visualizeEvolutionFitness [
	| canvas group legend g d y |
	canvas := RSCanvas new.
	group := RSGroup new.
	legend := RSLegend new 
		title: 'Fitness evolution';
		container: canvas;
		yourself.
	y := (1 to: self engine logs size) asArray.
	g := RSChart new.
	g container: group.
	self fitnessResultAsDictionary associations doWithIndex: [ :association :index | 
		d := RSLinePlot new x: (association value collect: #x) y: (association value collect: #y).
		g addPlot: d.
		legend text: association key withBoxColor: (g colors range at: index) ].
	aTestCaseFactory fitnessSeed ifNotNil: [
	d := RSLinePlot new x: y y: ((OrderedCollection ofSize: self engine logs size) atAllPut: aTestCaseFactory fitnessSeed).
	g addPlot: d.
	legend text: 'Fitness seed' withBoxColor: (g colors range at: 4)].
	g addDecoration: (RSVerticalTick new).
	g addDecoration: (RSHorizontalTick new).  
	
	g title: 'Fitness Evolution'.
	g xlabel: 'Iterations'.
	g addDecoration: (RSYLabelDecoration new title: 'Fitness'; offset: -15; vertical).
	g build.
	canvas add: group asShape.
	legend legendDo: [ :l |
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
