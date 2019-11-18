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
		'profiler'
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
STestCaseFactory >> cleanInstrumentation [
	self subclassResponsibility
]

{ #category : #actions }
STestCaseFactory >> createTestCases [
	self checkInvariants.
	self setUp.
	self run.
	self tearDown.
]

{ #category : #accessing }
STestCaseFactory >> engine [
	^ SGAEngine new
		populationSize: 30;
		numberOfStatements: 30;
		numberOfIterations: 15;
		yourself
]

{ #category : #accessing }
STestCaseFactory >> engineDefault [
	^ SGAEngine new
		populationSize: 30;
		fitness: fitness;
		numberOfStatements: 30;
		numberOfIterations: 20;
		yourself.
]

{ #category : #actions }
STestCaseFactory >> export: aTestCase with: aSelector [
	| className class |
	className := ('GA' , self targetClassName , 'Test') asSymbol.
	class := SConfiguration lookUpClass: className.
	class
		ifNil: [ class := TestCase
				subclass: className
				instanceVariableNames: ''
				classVariableNames: ''
				package: self outputPackageName ].
	[ aTestCase generateAssertions.
	class
		compile:
			(RBParser
				parseMethod:
					aSelector , aTestCase printDescriptiveComment
						, aTestCase parseTreeWithAssertions body formattedCode)
				formattedCode ]
		on: Error
		do: [ class
				compile:
					aSelector , String cr , 'self should:'
						, aTestCase parseTree formattedCode , String cr
						, ' raise:Error.' , String cr ]
]

{ #category : #actions }
STestCaseFactory >> exportTests [
	| index |
	index := 1.
	engine population
		do: [ :test | 
			self export: test with: 'test' , index printString.
			index := index + 1 ]
]

{ #category : #configuration }
STestCaseFactory >> fitness: aFitness [
	fitness := aFitness
]

{ #category : #visualization }
STestCaseFactory >> fitnessValues [
	| nameFunctions |
	self
		assert: (engine isNil not and: [ engine logs isNotEmpty ])
		description: 'Run the generation before'.
	nameFunctions := (Array with: engine fitness functionName).
	^ nameFunctions asSet
		collect: [ :nameFunction | 
			nameFunction
				->
					(engine logs
						withIndexCollect: [ :log :index | log fittestTestCase fitness at: nameFunction ]) ]
]

{ #category : #initialization }
STestCaseFactory >> initialize [
	super initialize.
	targetClassName := nil.
	targetPackageRegex := nil.
	fitness := SMethodCoverage new.
	engine := self engineDefault.
	numberOfIterations :=20.
	outputPackageName := 'SmallSuiteGenerator-Tests-Generated'
]

{ #category : #actions }
STestCaseFactory >> initializeProfiler [
	self subclassResponsibility 
	
]

{ #category : #initialization }
STestCaseFactory >> numberOfIterations: aNumber [
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
	engine numberOfIterations: numberOfIterations.
	engine typeInfo: self typeInfo.
	engine targetClassName: self targetClassName
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
	self cleanInstrumentation.
	self exportTests
]

{ #category : #accessing }
STestCaseFactory >> typeInfo [ 
	^ typeInfo
]

{ #category : #accessing }
STestCaseFactory >> typeInfo: aTypeInfo [
	typeInfo := aTypeInfo
]

{ #category : #visualization }
STestCaseFactory >> visualize [
	| p g d |
	p := RTPalette c3.
	g := RTGrapher new.
	self fitnessValues
		doWithIndex: [ :assocation :index | 
			d := RTData new.
			d connectColor: (p at: index).
			d noDot.
			d points: assocation value.
			d label: assocation key printString.
			d y: #yourself.
			g add: d ].
	g legend addText: 'Fitness evolution'.
	g open
]
