Class {
	#name : #SSmallSuiteGenerator,
	#superclass : #Object,
	#instVars : [
		'engine',
		'typeInfo',
		'dataFitnessCoverage',
		'ofClass'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'SmallSuiteGenerator-Facade'
}

{ #category : #accessing }
SSmallSuiteGenerator class >> instance [
	^ instance
]

{ #category : #accessing }
SSmallSuiteGenerator class >> newInstance [
	instance ifNil: [ instance := self new ].
	^ instance
]

{ #category : #initialization }
SSmallSuiteGenerator class >> resetInstance [
	instance := nil
]

{ #category : #'as yet unclassified' }
SSmallSuiteGenerator >> classesForRegex: regexExpressions [
	^ ((regexExpressions
		flatCollect: [ :regex | 
			RPackage organizer packages
				select: [ :p | regex match: p name asString ] ]) asSet)
		flatCollect: #definedClasses
]

{ #category : #accessing }
SSmallSuiteGenerator >> dataFitnessCoverage [
	^ dataFitnessCoverage
]

{ #category : #accessing }
SSmallSuiteGenerator >> engine [ 	
	^ engine
]

{ #category : #initialization }
SSmallSuiteGenerator >> engineDefault [
	^ SGAEngine new
		populationSize: 30;
		numberOfStatements: 30;
		endForMaxNumberOfGeneration: 15;
		yourself.
]

{ #category : #accessing }
SSmallSuiteGenerator >> fitness: aClassFitness [
	engine fitness: aClassFitness
]

{ #category : #accessing }
SSmallSuiteGenerator >> fitnessValues [
	| nameFunctions |
	self
		assert: (engine isNotNil and: [ engine logs isNotEmpty ])
		description: 'Run the generation before'.
	nameFunctions := engine fitness allFitnessFunction collect: #name.
	^ nameFunctions
		collect: [ :nameFunction | 
			nameFunction
				->
					(engine logs
						withIndexCollect: [ :log :index | log fittestTestCase fitness at: nameFunction ]) ]
]

{ #category : #'as yet unclassified' }
SSmallSuiteGenerator >> generateTestWith: selectedInvariants andPrettyCodeUsing: kindsRefactoring [
	self
		assert: (engine isNotNil and: [ engine logs isNotEmpty ])
		description: 'Before must execute ''runGeneration''.'.
	engine generateTestWith: selectedInvariants andPrettyCodeUsing: kindsRefactoring 
]

{ #category : #'as yet unclassified' }
SSmallSuiteGenerator >> generateTestsWith: selectedInvariants [
	self
		assert: (engine isNotNil and: [ engine logs isNotEmpty ])
		description: 'Execute ''runGeneration'' before.'.
	engine generateTestsWith: selectedInvariants
]

{ #category : #initialization }
SSmallSuiteGenerator >> initialize [
	engine := self engineDefault.
	dataFitnessCoverage := #().
	ofClass := false
]

{ #category : #'as yet unclassified' }
SSmallSuiteGenerator >> numberOfGenerations: aInt [
	engine endForMaxNumberOfGeneration: aInt
]

{ #category : #accessing }
SSmallSuiteGenerator >> numberOfStatements: aInt [
	engine numberOfStatements: aInt
]

{ #category : #accessing }
SSmallSuiteGenerator >> ofClass [
	^ ofClass
]

{ #category : #accessing }
SSmallSuiteGenerator >> populationSize: aInt [
	engine populationSize: aInt
]

{ #category : #'as yet unclassified' }
SSmallSuiteGenerator >> run [
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

{ #category : #'as yet unclassified' }
SSmallSuiteGenerator >> seed: aBlock onClass: aClass [
	self
		assert: aBlock isNotNil
		description: 'Need to provide a block to generate the tests'.
	self
		assert: aClass isNotNil
		description: 'Need to provide a class to generate the tests'.
	ofClass := true.
	"save data of fitness coverage"
	dataFitnessCoverage := Array with: aBlock with: aClass.
	"save the class to evaluate mutants killed or alived"
	engine modelClasses: (Array with: aClass).
	"execute the engine"
	engine blockToExecute: aBlock.
	engine
		typeInfo: (self typeInfoOf: engine blockToExecute onClass: aClass).
	"fitness: (aClassFitness coverageOf: aBlock onClass: aClass)"
	^ engine
]

{ #category : #'as yet unclassified' }
SSmallSuiteGenerator >> seed: aBlock onPackagesMatching: regex [
	self
		assert: aBlock isNotNil
		description: 'Need to provide a block to generate the tests'.
	self
		assert: (regex isNotNil and: [ regex isNotEmpty ])
		description: 'Need to provide a valid regex to generate the tests'.
	dataFitnessCoverage := Array with: aBlock with: regex.
	engine modelClasses: (self classesForRegex: (Array with: regex));
	blockToExecute: aBlock.
	engine
		typeInfo: (self typeInfoOf: engine blockToExecute onPackagesMatching: regex).
	"fitness: (aClassFitness coverageOf: aBlock onPackagesMatching: regex)"
	^ engine
]

{ #category : #accessing }
SSmallSuiteGenerator >> typeInfo [ 
	^ typeInfo
]

{ #category : #accessing }
SSmallSuiteGenerator >> typeInfo: aTypeInfo [
	typeInfo := aTypeInfo
]

{ #category : #'as yet unclassified' }
SSmallSuiteGenerator >> typeInfoOf: blockToExecute onClass: aClass [
	typeInfo
		ifNil: [ typeInfo := SConfiguration
				defaultGeneratorTypeInfoOf: blockToExecute
				onClass: aClass ].
	^ typeInfo
]

{ #category : #'as yet unclassified' }
SSmallSuiteGenerator >> typeInfoOf: blockToExecute onPackagesMatching: regex [
	typeInfo
		ifNil: [ typeInfo := SConfiguration
				defaultGeneratorTypeInfoOf: blockToExecute
				onPackagesMatching: regex ].
	^ typeInfo
]

{ #category : #visualization }
SSmallSuiteGenerator >> visualize [
	| p g d |
	p := RTPalette c3.
	g := RTGrapher new.
	self fitnessValues
		doWithIndex: [ :assocation :index | 
			d := RTData new.
			d connectColor: (p at: index).
			d noDot.
			d points: assocation value.
			d label: assocation key asString.
			d y: #yourself.
			g add: d ].
	g legend addText: 'Fitness evolution'.
	^ g
]
