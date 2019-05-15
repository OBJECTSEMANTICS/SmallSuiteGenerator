Class {
	#name : #SSmallSuiteGenerator,
	#superclass : #Object,
	#instVars : [
		'engine'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'SmallSuiteGenerator-Facade'
}

{ #category : #accessing }
SSmallSuiteGenerator class >> instance [
	instance
		ifNil: [ instance := SSmallSuiteGenerator new
				 ].
	^ instance
]

{ #category : #initialization }
SSmallSuiteGenerator class >> resetInstance [
	instance := nil
]

{ #category : #accessing }
SSmallSuiteGenerator >> engine [ 	
	^ engine
]

{ #category : #accessing }
SSmallSuiteGenerator >> fitnessBlock: aBlock [
	engine fitnessBlock: aBlock
]

{ #category : #'as yet unclassified' }
SSmallSuiteGenerator >> generateInvariants: selectedInvariants [
	self
		assert: (engine isNotNil and: [ engine logs isNotEmpty ])
		description: 'Before must execute ''runGeneration''.'.
	engine generateInvariantsFittest: selectedInvariants 
]

{ #category : #'as yet unclassified' }
SSmallSuiteGenerator >> generateTestsOf: aBlock blockOnClass: aClass [
	self
		assert: aBlock isNotNil
		description: 'Need to provide a block to generate the tests'.
	self
		assert: aClass isNotNil
		description: 'Need to provide a class to generate the tests'.
	engine
		blockToExecute: aBlock;
		generatorProfiler:
				[ :blockToExecute | SSGenerator profile: blockToExecute onClass: aClass ];
		coverageProfiler: [ :blockToExecute | 
			SBProfiler new
				profileInstrumented: blockToExecute onClass: aClass;
				yourself ];
		fitnessBlock: [ :coverageProfiler | 
			[ :testCase | 
			SCalculatorCoverage
				calculateCoverageOf: testCase
				using: coverageProfiler ] ]
]

{ #category : #'as yet unclassified' }
SSmallSuiteGenerator >> generateTestsOf: aBlock blockOnPackagesMatching: regex [
	self
		assert: aBlock isNotNil
		description: 'Need to provide a block to generate the tests'.
	self
		assert: (regex isNotNil and: [ regex isNotEmpty ])
		description: 'Need to provide a valid regex to generate the tests'.
	^ engine
		blockToExecute: aBlock;
		generatorProfiler:
				[ :blockToExecute | SSGenerator profile: blockToExecute onPackagesMatching: regex ];
		coverageProfiler: [ :blockToExecute | 
			SBProfiler new
				profileInstrumented: blockToExecute onPackagesMatching: regex;
				yourself ];
		fitnessBlock: [ :coverageProfiler | 
			[ :testCase | 
			SCalculatorCoverage
				calculateCoverageOf: testCase
				using: coverageProfiler ] ]
]

{ #category : #initialization }
SSmallSuiteGenerator >> initialize [
	engine := SGAEngine new
		populationSize: 30;
		numberOfStatements: 30;
		endForMaxNumberOfGeneration: 15;
		yourself
]

{ #category : #'as yet unclassified' }
SSmallSuiteGenerator >> numberOfGenerations: aInt [
	engine endForMaxNumberOfGeneration: aInt
]

{ #category : #accessing }
SSmallSuiteGenerator >> numberOfStatements: aInt [
	engine numberOfStatements: aInt
]

{ #category : #'as yet unclassified' }
SSmallSuiteGenerator >> pupulationSize: aInt [
	engine populationSize: aInt
]

{ #category : #'as yet unclassified' }
SSmallSuiteGenerator >> runGeneration [
	self
		assert: engine generatorProfiler isNotNil
		description: 'Need to provide generatorProfiler'.
	self
		assert: engine coverageProfiler isNotNil
		description: 'Need to provide coverageProfiler'.
	self
		assert: engine fitnessBlock isNotNil
		description: 'Need to provide a block to calculate the fitness'.
	self
		assert: engine blockToExecute isNotNil
		description: 'Need to provide a block to execute and create the tests'.
	self
		assert: engine numberOfStatements > 0
		description: 'Need to provide a number greater than 0 '.
	^ engine run
]
