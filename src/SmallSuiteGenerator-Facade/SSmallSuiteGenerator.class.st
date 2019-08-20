Class {
	#name : #SSmallSuiteGenerator,
	#superclass : #SObject,
	#instVars : [
		'engine',
		'typeInfo'
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
SSmallSuiteGenerator >> classesForRegex: regexExpressions [
	^ ((regexExpressions
		flatCollect: [ :regex | 
			RPackage organizer packages
				select: [ :p | regex match: p name asString ] ]) asSet)
		flatCollect: #definedClasses
]

{ #category : #accessing }
SSmallSuiteGenerator >> engine [ 	
	^ engine
]

{ #category : #accessing }
SSmallSuiteGenerator >> fitnessBlock: aBlock [
	engine fitness: aBlock
]

{ #category : #actions }
SSmallSuiteGenerator >> generateAssertionsUsing: selectedInvariants [
	self
		assert: (engine isNotNil and: [ engine logs isNotEmpty ])
		description: 'Execute ''runGeneration'' before.'.
	engine generateAssertionsUsing: selectedInvariants
]

{ #category : #actions }
SSmallSuiteGenerator >> generateAssertionsUsing: selectedInvariants invariantsAndApplyPrettyCodeWith: kindsRefactoring [
	self
		assert: (engine isNotNil and: [ engine logs isNotEmpty ])
		description: 'Before must execute ''runGeneration''.'.
	engine generateAssertionsUsing: selectedInvariants invariantsAndApplyPrettyCodeWith: kindsRefactoring 
]

{ #category : #actions }
SSmallSuiteGenerator >> generateTestsOf: aBlock blockOnClass: aClass [
	self
		assert: aBlock isNotNil
		description: 'Need to provide a block to generate the tests'.
	self
		assert: aClass isNotNil
		description: 'Need to provide a class to generate the tests'.
	"save the class to evaluate mutants killed or alived"
	engine modelClasses: {aClass}.
	"execute the engine"
	engine
		blockToExecute: aBlock.
	engine typeInfo: (self typeInfoOf: engine blockToExecute onClass: aClass);
		fitness: [ :aTestCase | 
			| fitness |
			fitness := SMethodCoverage new
				profiler:
					(SBProfiler new
						profileInstrumented: engine onClass: aClass;
						yourself).
			fitness run: aTestCase ]
]

{ #category : #actions }
SSmallSuiteGenerator >> generateTestsOf: aBlock blockOnPackagesMatching: regex [
	self
		assert: aBlock isNotNil
		description: 'Need to provide a block to generate the tests'.
	self
		assert: (regex isNotNil and: [ regex isNotEmpty ])
		description: 'Need to provide a valid regex to generate the tests'.
	engine modelClasses: (self classesForRegex: {regex}).
	engine
		blockToExecute: aBlock.
	engine 	typeInfo: (self typeInfoOf: engine blockToExecute  onPackagesMatching: regex );
		fitness: [ :aTestCase | 
			| fitness |
			fitness := SMethodCoverage new
				profiler:
					(SBProfiler new
						profileInstrumented: engine blockToExecute
							onPackagesMatching: regex;
						yourself).
			fitness run: aTestCase ].
	^ engine
]

{ #category : #initialization }
SSmallSuiteGenerator >> initialize [
	engine := SGAEngine new
		populationSize: 30;
		numberOfStatements: 30;
		endForMaxNumberOfGeneration: 15;
		yourself
]

{ #category : #accessing }
SSmallSuiteGenerator >> numberOfGenerations: aInt [
	engine endForMaxNumberOfGeneration: aInt
]

{ #category : #accessing }
SSmallSuiteGenerator >> numberOfStatements: aInt [
	engine numberOfStatements: aInt
]

{ #category : #accessing }
SSmallSuiteGenerator >> populationSize: aInt [
	engine populationSize: aInt
]

{ #category : #run }
SSmallSuiteGenerator >> runGeneration [
	self
		assert: engine typeInfo isNotNil
		description: 'Need to provide typeInfo'.
	self
		assert: engine fitness isNotNil
		description: 'Need to provide a block to calculate the fitness'.
	self
		assert: engine blockToExecute isNotNil
		description: 'Need to provide a block to execute and create the tests'.
	self
		assert: engine numberOfStatements > 0
		description: 'Need to provide a number greater than 0 '.
	^ engine run
]

{ #category : #accessing }
SSmallSuiteGenerator >> typeInfo [ 
	^ typeInfo
]

{ #category : #accessing }
SSmallSuiteGenerator >> typeInfo: aTypeInfo [
	typeInfo := aTypeInfo
]

{ #category : #querying }
SSmallSuiteGenerator >> typeInfoOf: blockToExecute onClass: aClass [
	typeInfo
		ifNil: [ typeInfo := SConfiguration
				defaultGeneratorTypeInfoOf: blockToExecute
				onClass: aClass ].
	^ typeInfo
]

{ #category : #querying }
SSmallSuiteGenerator >> typeInfoOf: blockToExecute onPackagesMatching: regex [
	typeInfo
		ifNil: [ typeInfo := SConfiguration
				defaultGeneratorTypeInfoOf: blockToExecute
				onPackagesMatching: regex ].
	^ typeInfo
]
