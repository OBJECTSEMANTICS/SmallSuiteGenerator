Extension { #name : #STestCaseFactory }

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory class >> darkColors [
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
STestCaseFactory >> fitnessResultAsDictionary [
	| functionNames dictResult |
	self
		assert: (engine isNil not and: [ engine logs isNotEmpty ])
		description: 'Run the generation before'.
	functionNames := (Array with: engine fitness functionName) asSet.
	dictResult := Dictionary new.
	engine logs doWithIndex: [ :log :index | 
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
STestCaseFactory >> generationEvolutionCanvas [
	^ engine generationVisualization: fitnessSeed ofColor: self class lightColors 
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

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory class >> lightColors [
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
		yourself.
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
STestCaseFactory >> visualizeEvolutionFitness [
	| canvas group legend g d y |
	canvas := RSCanvas new.
	group := RSGroup new.
	legend := RSLegend new 
		title: 'Fitness evolution';
		container: canvas;
		yourself.
	y := (1 to: engine logs size) asArray.
	g := RSChart new.
	g container: group.
	self fitnessResultAsDictionary associations doWithIndex: [ :association :index | 
		d := RSLinePlot new x: (association value collect: #x) y: (association value collect: #y).
		g addPlot: d.
		legend text: association key withBoxColor: (g colors range at: index) ].
	d := RSLinePlot new x: y y: ((OrderedCollection ofSize: engine logs size) atAllPut: fitnessSeed).
	g addPlot: d.
	legend text: 'Fitness seed' withBoxColor: (g colors range at: 4).
	g addDecoration: (RSVerticalTick new).
	g addDecoration: (RSHorizontalTick new). 
	
	g title: 'Fitness Evolution'.
	g xlabel: 'Iterations'.
	g addDecoration: (RSYLabelDecoration new title: 'Fitness'; offset: -15; vertical).
	g build.
	canvas add: group asShape.
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
