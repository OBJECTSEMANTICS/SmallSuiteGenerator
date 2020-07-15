"
STestCaseFactory is an abstract class that represents the project facade. It contains the main methods to run the project
"
Class {
	#name : #STestCaseFactory,
	#superclass : #SObject,
	#instVars : [
		'reportClass',
		'engine',
		'typeInfo',
		'targetClassName',
		'targetPackageRegex',
		'outputPackageName',
		'fitness',
		'numberOfIterations',
		'profiler',
		'setUpMethod',
		'tearDownMethod',
		'lastMessage',
		'asDict',
		'fitnessSeed',
		'initialSeed',
		'initialAsDict',
		'typeInfoSeed',
		'typeInfoOrigin',
		'firstExecution',
		'generatedClass'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'settings-colors' }
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

{ #category : #'settings-colors' }
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

{ #category : #actions }
STestCaseFactory >> asDict: aBoolean [
	initialAsDict := aBoolean.
	SPlatform asDict: aBoolean
]

{ #category : #actions }
STestCaseFactory >> checkInvariants [
	self assert: typeInfo isNil not description: 'Please provide type information of the target project'.
	self assert: targetPackageRegex isNil not description: 'Please provide a regex that match the packages under analysis'
]

{ #category : #accessing }
STestCaseFactory >> classesForRegex: regexExpressions [
	^ (regexExpressions
		flatCollect: [ :regex | 
			RPackage organizer packages
				select: [ :p | regex match: p name printString ] ]) asSet
		flatCollect: #definedClasses
]

{ #category : #actions }
STestCaseFactory >> createConfigurationMethods [
	| class |
	class := self getClassOf: ('GA' , self targetClassName , 'Test').
	setUpMethod ifNotNil: [ class compile: setUpMethod  ].
	tearDownMethod ifNotNil: [ class compile: tearDownMethod ]
]

{ #category : #actions }
STestCaseFactory >> createTestCases [
	self checkInvariants.
	self setUp.
	self run.
	self tearDown.
]

{ #category : #accessing }
STestCaseFactory >> crossoverRate: aNumber [
	engine crossoverRate: aNumber
]

{ #category : #accessing }
STestCaseFactory >> elitismRate: aNumber [
	engine elitismRate: aNumber
]

{ #category : #accessing }
STestCaseFactory >> engine [
	^ engine
]

{ #category : #accessing }
STestCaseFactory >> engineDefault [
	^ SGAEngine new
		fitness: fitness;
		numberOfStatements: 30;
		numberOfGenerations: numberOfIterations;
		yourself.
]

{ #category : #actions }
STestCaseFactory >> export: aTestCase with: aSelector [
	[ aTestCase generateAssertions.
	self generatedClass
		compile:
			(aSelector, String lf, aTestCase printDescriptiveComment,
			String lf, aTestCase parseTreeWithAssertions body formattedCode) ]
		on: Error
		do: [ | carReturn |
			carReturn := String with: Character cr.
			self generatedClass
				compile:
					aSelector , carReturn , 'self should:'
						, aTestCase parseTree formattedCode , carReturn
						, ' raise:Error.' , carReturn ]
]

{ #category : #actions }
STestCaseFactory >> exportTests [
	| index |
	index := 1.
	engine population
		do: [ :test | 
			test lastMessage: lastMessage.
			self export: test with: ('test{1}' format: {index}).
			index := index + 1 ].
	self createConfigurationMethods
]

{ #category : #accessing }
STestCaseFactory >> firstExecution [
	^ firstExecution ifNil: [ firstExecution := true ] ifNotNil: [ false ]
]

{ #category : #configuration }
STestCaseFactory >> fitness [
	^ fitness
]

{ #category : #configuration }
STestCaseFactory >> fitness: aFitness [
	fitness := aFitness
]

{ #category : #accessing }
STestCaseFactory >> fitnessSeed [
	^ fitnessSeed 
]

{ #category : #accessing }
STestCaseFactory >> fitnessSeedCalculated: number [ 
	fitnessSeed := number
]

{ #category : #actions }
STestCaseFactory >> generatedClass [
	generatedClass ifNil: [ generatedClass := self getClassOf: ('GA' , self targetClassName , 'Test').
		"Move class to package"].
	^ generatedClass
	
]

{ #category : #configuration }
STestCaseFactory >> generatedClass: anObject [
	generatedClass := anObject
]

{ #category : #actions }
STestCaseFactory >> getClassOf: aString [
	| aClassName class |
	aClassName := aString asSymbol.
	class := SPlatform lookUpClass: aClassName.
	class
		ifNil: [ class := SPlatform
				createTestCaseClass: aClassName
				inPackage: self outputPackageName].
	^ class

]

{ #category : #accessing }
STestCaseFactory >> initialAsDict [
	^ initialAsDict 
]

{ #category : #accessing }
STestCaseFactory >> initialSeed [
	^ initialSeed 
]

{ #category : #initialization }
STestCaseFactory >> initialize [
	SPlatform resetRandomGenerator.
	super initialize.
	fitness := SMethodCoverage new.
	numberOfIterations := 20.
	engine := self engineDefault.
	fitnessSeed := 0.
	outputPackageName := 'SmallSuiteGenerator-Tests-Generated'.
	initialSeed := 100.
	initialAsDict := false.
]

{ #category : #actions }
STestCaseFactory >> initializeProfiler [
	self subclassResponsibility 
	
]

{ #category : #actions }
STestCaseFactory >> lastMessage: aMessage [
	(aMessage isNotNil and: [aMessage isNotEmpty]) ifFalse: [ ^ self ].
	lastMessage := aMessage.
	engine lastMessage: aMessage
	
]

{ #category : #accessing }
STestCaseFactory >> numberOfGenerations [
	^ numberOfIterations
]

{ #category : #initialization }
STestCaseFactory >> numberOfGenerations: aNumber [
	engine numberOfGenerations: aNumber.
	numberOfIterations := aNumber.
]

{ #category : #configuration }
STestCaseFactory >> numberOfStatements: aInt [
	engine numberOfStatements: aInt
]

{ #category : #accessing }
STestCaseFactory >> outputPackageName [
	^ outputPackageName
]

{ #category : #accessing }
STestCaseFactory >> outputPackageName: anObject [
	outputPackageName := anObject
]

{ #category : #configuration }
STestCaseFactory >> populationSize: int [
	engine populationSize: int
]

{ #category : #accessing }
STestCaseFactory >> reportClass [
	reportClass ifNil: [ reportClass := SReportSTestCaseFactory on: self ].
	^ reportClass 
]

{ #category : #actions }
STestCaseFactory >> run [
	engine run.
	
]

{ #category : #running }
STestCaseFactory >> run: aNumber [
	numberOfIterations := aNumber.
	self createTestCases
]

{ #category : #'instance creation' }
STestCaseFactory >> seed: aNumber [ 
	initialSeed := aNumber.
	SPlatform seed: aNumber
]

{ #category : #configuration }
STestCaseFactory >> seedBlock: aBlock [ 	
	fitnessSeed := (self aSLProfilerCoverage profile: aBlock inPackagesMatching:targetPackageRegex) statementCoverageFor: targetClassName.
]

{ #category : #actions }
STestCaseFactory >> selectionStrategy: aSelectionStrategy [
	engine selectionStrategy: aSelectionStrategy 
]

{ #category : #actions }
STestCaseFactory >> selectionStrategyTestCase: aSelectionStrategy [
	engine selectionStrategyTestCase: aSelectionStrategy 
]

{ #category : #actions }
STestCaseFactory >> setUp [
	
	self initializeProfiler.
	self firstExecution ifTrue: [
	SPlatform resetRandomGenerator.
	fitness profiler: profiler;
		typeInfo: typeInfo;
		targetClass: self targetClassName.
	engine fitness: fitness;
		numberOfGenerations: numberOfIterations;
		typeInfo: self typeInfo;
		targetClassName: self targetClassName;
		targetPackageRegex: targetPackageRegex.
	typeInfoSeed := (typeInfo classAt: targetClassName) deepCopy]
ifFalse: [ engine fitness profiler: profiler.
	engine numberOfGenerations: numberOfIterations ]
]

{ #category : #actions }
STestCaseFactory >> setUpMethod: anObject [
	(anObject isNotNil and: [anObject isNotEmpty]) ifFalse: [ ^ self ].
	setUpMethod := anObject
]

{ #category : #configuration }
STestCaseFactory >> stopIterations: anInteger [
	engine stopIterations: anInteger
]

{ #category : #accessing }
STestCaseFactory >> targetClassName [
	^ targetClassName 
]

{ #category : #accessing }
STestCaseFactory >> targetClassName: aSymbol [
	targetClassName := aSymbol.

]

{ #category : #accessing }
STestCaseFactory >> targetPackageRegex [
	^ targetPackageRegex
]

{ #category : #accessing }
STestCaseFactory >> targetPackageRegex: anObject [
	targetPackageRegex := anObject.
	engine packageRegex: anObject 
]

{ #category : #actions }
STestCaseFactory >> tearDown [
	self uninstall.
	self exportTests.
	SPlatform asDict: false.
	SPlatform resetRandomGenerator.
	SmallTypeCollector resetClassDict 
]

{ #category : #actions }
STestCaseFactory >> tearDownMethod: anObject [
	(anObject isNotNil and: [anObject isNotEmpty]) ifFalse: [ ^ self ].
	tearDownMethod := anObject
]

{ #category : #accessing }
STestCaseFactory >> typeInfo [ 
	^ typeInfo
]

{ #category : #accessing }
STestCaseFactory >> typeInfo: aTypeInfo [
	typeInfoOrigin := aTypeInfo copy.
	typeInfo := aTypeInfo
]

{ #category : #accessing }
STestCaseFactory >> typeInfoOrigin [
	^ typeInfoOrigin 
]

{ #category : #accessing }
STestCaseFactory >> typeInfoSeed [
	^ typeInfoSeed
]

{ #category : #actions }
STestCaseFactory >> uninstall [
]
