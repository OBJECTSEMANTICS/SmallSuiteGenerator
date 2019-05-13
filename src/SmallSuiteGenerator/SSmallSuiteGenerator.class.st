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
SSmallSuiteGenerator >> generateInvariants [
	engine generateInvariantsFittest
]

{ #category : #'as yet unclassified' }
SSmallSuiteGenerator >> generateTestsOf: aBlock blockOnClass: aClass [
	^ engine
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
		numberOfStatements: 50;
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
	engine run
]
