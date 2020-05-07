"
STestCaseFactory is an abstract class that represents the project facade. It contains the main methods to run the project
"
Class {
	#name : #STestCaseFactory,
	#superclass : #SObject,
	#instVars : [
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
		'typeInfoOrigin'
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
		at: 'backgroundBoxMethod' put: (Color r: 0.1607843137254902 g: 0.3686274509803922 b: 0.4470588235294118);
		at: 'scaleLighter' put: (Color r: 0.5098039215686274 g: 0.9607843137254902 b: 0.7725490196078432);
		at: 'scaleDarker' put: (Color r: 0.30980392156862746 g: 0.6235294117647059 b: 0.49019607843137253);
		at: 'baseBar' put: (Color r: 0.7647058823529411 g: 0.803921568627451 b: 0.788235294117647);
		at: 'forwardBar' put: (Color r: 0.5098039215686274 g: 0.9607843137254902 b: 0.7725490196078432);
		at: 'backwardBar' put: (Color r: 1 g: 0 b: 0.25098039215686274);
		at: 'edge' put: (Color r: 0.7647058823529411 g: 0.803921568627451 b: 0.788235294117647);
		at: 'classCoverage' put: (Color r: 0.5098039215686274 g: 0.7803921568627451 b: 0.9607843137254902);
		at: 'methodCoverage' put: (Color r: 0.9607843137254902 g: 0.5098039215686274 b: 0.7215686274509804);
		at: 'statementCoverage' put: (Color r: 0.5098039215686274 g: 0.9607843137254902 b: 0.7725490196078432);
		at: 'highlight' put: (Color r: 0.13725490196078433 g: 0.7215686274509804 b: 0.7725490196078432);
		at: 'fontMethodBox' put: Color white;
		at: 'border' put: Color white;
		at: 'axis' put: Color white;
		at: 'font' put: Color white;
		yourself.
]

{ #category : #'settings-colors' }
STestCaseFactory class >> lightColors [
	^ Dictionary new 
		at: 'background' put: Color white;
		at: 'backgroundBoxMethod' put: (Color r: 0.1607843137254902 g: 0.3686274509803922 b: 0.4470588235294118);
		at: 'scaleLighter' put: (Color r: 0 g: 1 b: 0.67);
		at: 'scaleDarker' put: (Color r: 0.30980392156862746 g: 0.6235294117647059 b: 0.49019607843137253);
		at: 'baseBar' put: (Color r: 0.611764705882353 g: 0.6431372549019608 b: 0.6274509803921569);
		at: 'forwardBar' put: (Color r: 0 g: 1 b: 0.67);
		at: 'backwardBar' put: (Color r: 1 g: 0 b: 64/255);
		at: 'edge' put: (Color r: 0.611764705882353 g: 0.6431372549019608 b: 0.6274509803921569);
		at: 'classCoverage' put: (Color r: 0.05 g: 0.75 b: 0.91);
		at: 'methodCoverage' put: (Color r:0.88 g:0.26 b:0.5);
		at: 'statementCoverage' put: (Color r: 0 g: 1 b: 0.67);
		at: 'highlight' put: (Color r: 0.13725490196078433 g: 0.7215686274509804 b: 0.7725490196078432 alpha: 0.8);
		at: 'fontMethodBox' put: Color white;
		at: 'border' put: (Color r: 0.12549019607843137 g: 0.1803921568627451 b: 0.23529411764705882);
		at: 'axis' put: (Color r: 0.12549019607843137 g: 0.1803921568627451 b: 0.23529411764705882);
		at: 'font' put: (Color r: 0.12549019607843137 g: 0.1803921568627451 b: 0.23529411764705882);
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
STestCaseFactory >> evolutionTypeInfo [
	| typeInfos evolution |
	typeInfos := Array with: self typeInfoSeed withAll: (self engine logs collect: #typeInfoGeneration).
	evolution := Dictionary new.
	2 to: typeInfos size do: [ :index | | aTypeInfo1 aTypeInfo2 partialResult |
		aTypeInfo1 := typeInfos at: index - 1.
		aTypeInfo2 := typeInfos at: index.
		partialResult := aTypeInfo1 difference: aTypeInfo2.
		(partialResult notNil and: [partialResult notEmpty]) ifTrue: [ evolution at: ((index - 2) asString, ' -> ',(index-1) asString) put: partialResult ]
		 ].
	^ evolution
]

{ #category : #actions }
STestCaseFactory >> export: aTestCase with: aSelector [
	| class |
	class := self getClassOf: ('GA' , self targetClassName , 'Test').
	[ aTestCase generateAssertions.
	class
		compile:
			(SPlatform rbParserClass
				parseMethod:
					aSelector , aTestCase printDescriptiveComment
						, aTestCase parseTreeWithAssertions body formattedCode)
				formattedCode ]
		on: Error
		do: [ | carReturn |
			carReturn := String with: Character cr.
			class
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
			self export: test with: 'test' , index printString.
			index := index + 1 ].
	self createConfigurationMethods
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

{ #category : #'as yet unclassified' }
STestCaseFactory >> fitnessSeedCalculated: number [ 
	fitnessSeed := number
]

{ #category : #actions }
STestCaseFactory >> generateReportForAllMethodsOf: aLog [ 
	self generateReportOf: aLog UsingFilter: #all
]

{ #category : #actions }
STestCaseFactory >> generateReportForAllMethodsOfAllLogs [
	self engine logs do: [ :aLog | self generateReportForAllMethodsOf: aLog ]
]

{ #category : #actions }
STestCaseFactory >> generateReportForUnexecutedMethodsOf: anIndex [
	self generateReportOf: anIndex UsingFilter: #notAllBlocksExecuted
]

{ #category : #actions }
STestCaseFactory >> generateReportForUnexecutedMethodsOfAllLogs [
	self engine logs do: [ :aLog | self generateReportForUnexecutedMethodsOf: aLog ]
]

{ #category : #actions }
STestCaseFactory >> generateReportOf: aLog UsingFilter: aSymbol [ 
	SReportSGALog exportData: aLog onCSV: ('Report_', aLog generationNumber asString,'_', aSymbol asString capitalized,targetClassName asString) usingFilter: aSymbol
]

{ #category : #actions }
STestCaseFactory >> generateReportOfAllMethods [
	self generateReportForAllMethodsOf: self engine logs last
]

{ #category : #actions }
STestCaseFactory >> generateReportOfUnexecutedMethods [
	self generateReportForUnexecutedMethodsOf: self engine logs last
]

{ #category : #actions }
STestCaseFactory >> generateResumeDifferenceOfGeneration [
	SReportSGALog generateReportForDifferencesBtwGenerationsOf: self engine
]

{ #category : #actions }
STestCaseFactory >> generateResumeReportOfLogs [
	SReportSGALog exportResumeOf: self engine logs onCSV: ('Report_Resume_' ,targetClassName asString)
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
	engine := self engineDefault.
	numberOfIterations := 20.
	fitnessSeed := 0.
	outputPackageName := 'SmallSuiteGenerator-Tests-Generated'.
	initialSeed := 100.
	initialAsDict := false.
]

{ #category : #actions }
STestCaseFactory >> initializeProfiler [
	self subclassResponsibility 
	
]

{ #category : #configuration }
STestCaseFactory >> lastMessage: aMessage [
	lastMessage := aMessage.
	engine lastMessage: aMessage 
]

{ #category : #'as yet unclassified' }
STestCaseFactory >> numberOfGenerations [
	^ numberOfIterations
]

{ #category : #initialization }
STestCaseFactory >> numberOfGenerations: aNumber [
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

{ #category : #actions }
STestCaseFactory >> run [
	engine run.
	
]

{ #category : #'instance creation' }
STestCaseFactory >> seed: aNumber [ 
	initialSeed := aNumber.
	SPlatform seed: aNumber
]

{ #category : #configuration }
STestCaseFactory >> seedBlock: aBlock [ 	
	fitnessSeed := (SLProfilerCoverage profile: aBlock inPackagesMatching:targetPackageRegex) statementCoverageFor: targetClassName.
]

{ #category : #actions }
STestCaseFactory >> selectionStrategy: aSelectionStrategy [
	engine selectionStrategy: aSelectionStrategy 
]

{ #category : #actions }
STestCaseFactory >> setUp [
	SPlatform resetRandomGenerator.
	self initializeProfiler.
	fitness profiler: profiler;
		typeInfo: typeInfo;
		targetClass: self targetClassName.
	engine fitness: fitness;
		numberOfGenerations: numberOfIterations;
		typeInfo: self typeInfo;
		targetClassName: self targetClassName;
		targetPackageRegex: targetPackageRegex.
	typeInfoSeed := (typeInfo classAt: targetClassName) deepCopy 
]

{ #category : #actions }
STestCaseFactory >> setUpMethod: anObject [
	setUpMethod := anObject 
	
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
	SPlatform resetRandomGenerator 
]

{ #category : #actions }
STestCaseFactory >> tearDownMethod: anObject [
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

{ #category : #accessing }
STestCaseFactory >> typeInfoSeed: anObject [
	typeInfoSeed := anObject
]

{ #category : #actions }
STestCaseFactory >> uninstall [
]
