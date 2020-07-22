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
		'typeInfoSeed',
		'typeInfoOrigin',
		'firstExecution',
		'generatedClass'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'SmallSuiteGenerator-Builder'
}

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
	class := self generatedClass.
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
	| carReturn |
	carReturn := String cr.
	[
	aTestCase generateAssertions.
	self generatedClass
		compile:
			(aSelector, carReturn, aTestCase printDescriptiveComment,
			carReturn, aTestCase printStringWithAssertions) ]
		on: Error
		do: [ 
			self generatedClass
				compile:
					aSelector , carReturn , 'self should:['
						, aTestCase printStringWithAssertions , carReturn
						, '] raise:Error.' , carReturn ]
]

{ #category : #actions }
STestCaseFactory >> exportTests [
	engine population
		doWithIndex: [ :test :index | 
			test lastMessage: lastMessage.
			self export: test with: ('test', index asString) ].
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

{ #category : #accessing }
STestCaseFactory >> generateLogs [
	SPlatform logClass: SGALog
]

{ #category : #accessing }
STestCaseFactory >> generateViews [
	SPlatform vizClass: SGAViz;
		logClass: SGALog 
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
	SPlatform vizClass: nil.
	fitness := SMethodCoverage new.
	numberOfIterations := 20.
	engine := self engineDefault.
	fitnessSeed := 0.
	outputPackageName := 'SmallSuiteGenerator-Tests-Generated'.
	initialSeed := 100.
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

{ #category : #actions }
STestCaseFactory >> printerClass: aClass [
	SPlatform printerClass: aClass 
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
	SPlatform printerClass: nil;
		logClass: nil;
		resetRandomGenerator.
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
