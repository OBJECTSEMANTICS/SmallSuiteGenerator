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
		'tearDownMethod'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'SmallSuiteGenerator-Core'
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
	^ SGAEngine new
		populationSize: 30;
		numberOfStatements: 30;
		numberOfGenerations: 15;
		yourself
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
	| class |
	class := self getClassOf: ('GA' , self targetClassName , 'Test').
	self moveClass: class.
	[ aTestCase generateAssertions.
	class
		compile:
			(SConfiguration rbParserClass
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
			self export: test with: 'test' , index printString.
			index := index + 1 ].
	self createConfigurationMethods
]

{ #category : #configuration }
STestCaseFactory >> fitness: aFitness [
	fitness := aFitness
]

{ #category : #visualization }
STestCaseFactory >> fitnessValues [
	| functionNames fitValues |
	self
		assert: (engine isNil not and: [ engine logs isNotEmpty ])
		description: 'Run the generation before'.
	functionNames := (Array with: engine fitness functionName) asSet.
	fitValues := Dictionary new.
		engine logs do: [ :log | 
			functionNames do: [ :functionName | 
			| val |
			val := fitValues
				       at: functionName , '_fittest'
				       ifAbsentPut: [ OrderedCollection new ].
			val add: (log fittestTestCase fitness at: functionName).
			val := fitValues
				       at: functionName , '_average'
				       ifAbsentPut: [ OrderedCollection new ].
			val add: (log averageFit at: functionName).
			val := fitValues
				       at: functionName , '_lowest'
				       ifAbsentPut: [ OrderedCollection new ].
			val add: (log lowestFit at: functionName) ] ].
	^ fitValues
]

{ #category : #actions }
STestCaseFactory >> getClassOf: aString [
	| aClassName class |
	aClassName := aString asSymbol.
	class := SConfiguration lookUpClass: aClassName.
	class
		ifNil: [ class := SConfiguration
				createTestCaseClass: aClassName
				inPackage: self outputPackageName].
	^ class

]

{ #category : #initialization }
STestCaseFactory >> initialize [
	super initialize.
	fitness := SMethodCoverage new.
	numberOfIterations := 20.
	engine := self engineDefault.
	outputPackageName := 'SmallSuiteGenerator-Tests-Generated'
]

{ #category : #actions }
STestCaseFactory >> initializeProfiler [
	self subclassResponsibility 
	
]

{ #category : #configuration }
STestCaseFactory >> lastMessage: aMessage [
	engine lastMessage: aMessage
]

{ #category : #'as yet unclassified' }
STestCaseFactory >> moveClass: aClass [ 
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
	SConfiguration seed: aNumber
]

{ #category : #actions }
STestCaseFactory >> setUp [
	self initializeProfiler.
	fitness profiler: profiler.
	engine fitness: fitness.
	engine numberOfGenerations: numberOfIterations.
	engine typeInfo: self typeInfo.
	engine targetClassName: self targetClassName
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
	targetPackageRegex := anObject
]

{ #category : #actions }
STestCaseFactory >> tearDown [
	self uninstall.
	self exportTests
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
	typeInfo := aTypeInfo
]

{ #category : #actions }
STestCaseFactory >> uninstall [
]

{ #category : #visualization }
STestCaseFactory >> visualize [
	| p g d |
	p := RTPalette c3.
	g := RTGrapher new.
	self fitnessValues associations doWithIndex: [ :association :index | 
		d := RTData new.
		d
			connectColor: (p at: index);
			noDot;
			points: association value;
			label: association key.
		g add: d ].
	g legend addText: 'Fitness evolution'.
	^ g
]
