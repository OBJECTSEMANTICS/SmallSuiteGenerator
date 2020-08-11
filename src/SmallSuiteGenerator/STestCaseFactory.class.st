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
		'fitnessSeed',
		'initialSeed',
		'typeInfoSeed',
		'typeInfoOrigin',
		'firstExecution',
		'generatedClass',
		'nsuperclasses'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'SmallSuiteGenerator-Builder'
}

{ #category : #'instance creation' }
STestCaseFactory class >> from: configClass [
	| aTypeInfo printerClass lastStm parser|
	aTypeInfo := configClass typeInfoValue copy.
	aTypeInfo blackList: configClass decodeBlackList.
	printerClass := configClass asDict 
		ifTrue: [ SSDictionaryBasedPrinter ] 
		ifFalse: [ SSStandardPrinter ].
	lastStm := configClass lastMessage asString.
	(lastStm notNil and: [ lastStm isNotEmpty ]) ifTrue: [
		parser := RBParser parseExpression: configClass lastMessage asString]
	ifFalse: [parser:= nil].

	^(self new) 
		generatedClass: configClass;
		fitness: configClass fitnessValue; 
		targetClassName: configClass aClass nameAsSymbol; 
		targetPackageRegex: configClass targetPackageRegex; 
		outputPackageName: configClass outputPackageName; 
		numberOfGenerations: configClass numberOfGenerations; 
		numberOfStatements: configClass numberOfStatements; 
		populationSize: configClass populationSize;
		setUpMethod: configClass setUpMethod asString; 
		tearDownMethod: configClass tearDownMethod asString; 
		limitToWait: configClass limitToWait;
		lastMessage: parser; 
		typeInfo: aTypeInfo;
		printerClass: printerClass;
		stopIterations: configClass stopIterations;
		yourself
]

{ #category : #settings }
STestCaseFactory class >> resetToDefaults [
	{ #vizClass -> SGANullViz } do: [ :val |
		STestCaseFactory class compile: val key asString, String cr, '	^ ', val value printString ]
]

{ #category : #settings }
STestCaseFactory class >> vizClass [
	^ SGAViz
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
STestCaseFactory >> compile: aString classified: category [
	^ self generatedClass compile: aString classified: category
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

{ #category : #export }
STestCaseFactory >> export: aTestCase with: aSelector [
	| carReturn |
	carReturn := String cr.
	[
	aTestCase generateAssertions.
	self compile:
			(aSelector, carReturn, aTestCase printDescriptiveComment,
			carReturn, aTestCase printStringWithAssertions)
		  classified: 'tests' ]
		on: Error
		do: [ self compile:
					aSelector , carReturn , 'self should:['
						, aTestCase printStringWithAssertions , carReturn
						, '] raise:Error.' , carReturn
					classified: 'tests' ]
]

{ #category : #export }
STestCaseFactory >> exportSettingMethods [
	SSTestShifter defaultMethodsClass exportMethodsFor: self
]

{ #category : #export }
STestCaseFactory >> exportTests [
	engine population
		doWithIndex: [ :test :index |
			test lastMessage: lastMessage.
			self export: test with: ('test', index asString) ].
	self exportSettingMethods.
	self openOnGeneratedClass
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

{ #category : #accessing }
STestCaseFactory >> generateLogs [
	self logClass: SGALog
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
STestCaseFactory >> initialSeed [
	^ initialSeed 
]

{ #category : #initialization }
STestCaseFactory >> initialize [
	SPlatform resetRandomGenerator.
	super initialize.
	SSCustomMethods removeMethods.
	self class resetToDefaults.
	SSTestShifter resetToDefaults.
	SGAEngine resetToDefaults.
	fitness := SMethodCoverage new.
	numberOfIterations := 20.
	engine := self engineDefault.
	fitnessSeed := 0.
	outputPackageName := 'SmallSuiteGenerator-Tests-Generated'.
	initialSeed := 100.
	nsuperclasses := 0.
	lastMessage := #()
]

{ #category : #actions }
STestCaseFactory >> initializeProfiler [
	self subclassResponsibility 
	
]

{ #category : #actions }
STestCaseFactory >> lastMessage: aMessage [
	(aMessage isNotNil) ifFalse: [ ^ self ].
	lastMessage := (Array with: aMessage).
	engine lastMessage: lastMessage
	
]

{ #category : #'set strategies' }
STestCaseFactory >> limitToWait: anInteger [
	SSTestShifter class compile: 
		'limitToWait', String cr,'	^ ', anInteger printString
]

{ #category : #'set strategies' }
STestCaseFactory >> logClass: aClass [
	SGAEngine class compile: 
		'logClass', String cr,'	^ ', aClass printString
]

{ #category : #initialization }
STestCaseFactory >> nsuperclasses: aNumber [

	nsuperclasses := aNumber.
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

{ #category : #export }
STestCaseFactory >> openOnGeneratedClass [
	Smalltalk tools browser openOnClass: self generatedClass
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

{ #category : #'set strategies' }
STestCaseFactory >> printerClass: aClass [
	SSTestShifter class compile: 
		'defaultPrinterClass', String cr,'	^ ', aClass printString
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
	|copy|
	copy := self fitness copy profiler: (self aSLProfilerCoverage profile: aBlock inPackagesMatching:targetPackageRegex).
	fitnessSeed := copy computeFitness first.
]

{ #category : #actions }
STestCaseFactory >> selectionStrategy: aSelectionStrategy [
	engine selectionStrategy: aSelectionStrategy 
]

{ #category : #actions }
STestCaseFactory >> selectionStrategyTestCase: aSelectionStrategy [
	engine selectionStrategyTestCase: aSelectionStrategy 
]

{ #category : #running }
STestCaseFactory >> setUp [
	
	self initializeProfiler.
	self firstExecution ifTrue: [
	SPlatform resetRandomGenerator.
	fitness profiler: profiler;
		typeInfo: typeInfo;
		targetClass: self targetClassName;
		consideringNSuperclasses: nsuperclasses.
	engine fitness: fitness;
		numberOfGenerations: numberOfIterations;
		typeInfo: self typeInfo;
		targetClassName: self targetClassName;
		targetPackageRegex: targetPackageRegex.
	typeInfoSeed := (typeInfo classAt: targetClassName) deepCopy]
ifFalse: [ engine fitness profiler: profiler.
	engine numberOfGenerations: numberOfIterations ]
]

{ #category : #'set strategies' }
STestCaseFactory >> setUpMethod: aString [
	(aString isNotNil and: [aString isNotEmpty]) ifFalse: [ ^ self ].
	SSCustomMethods compile: aString.
	self settingMethodClass: SSCustomMethods.
]

{ #category : #'set strategies' }
STestCaseFactory >> settingMethodClass: aClass [
	SSTestShifter class compile: 
		'defaultMethodsClass', String cr,'	^ ', aClass printString
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

{ #category : #running }
STestCaseFactory >> tearDown [
	self uninstall.
	self exportTests.
	SSTestShifter resetToDefaults.
	SPlatform resetRandomGenerator.
	SmallTypeCollector resetClassDict
]

{ #category : #'set strategies' }
STestCaseFactory >> tearDownMethod: aString [
	(aString isNotNil and: [aString isNotEmpty]) ifFalse: [ ^ self ].
	SSCustomMethods compile: aString.
	self settingMethodClass: SSCustomMethods.
]

{ #category : #accessing }
STestCaseFactory >> typeInfo [ 
	^ typeInfo
]

{ #category : #accessing }
STestCaseFactory >> typeInfo: aTypeInfo [
	aTypeInfo initializeIsAbstract.
	typeInfoOrigin := aTypeInfo copy.
	typeInfo := aTypeInfo.
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

{ #category : #'set strategies' }
STestCaseFactory >> vizClass: aClass [
	STestCaseFactory class compile: 
		'vizClass', String cr,'	^ ', aClass printString
]
