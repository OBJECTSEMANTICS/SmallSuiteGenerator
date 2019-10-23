Class {
	#name : #SConfiguration,
	#superclass : #Object,
	#classInstVars : [
		'level'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SConfiguration class >> classAssertsGenerationTest [
	SSTestFactoryToDelete
		createCompilerClass: 'SSAssertionGeneratorTest'
]

{ #category : #'as yet unclassified' }
SConfiguration class >> defaultEvaluationStrategy [
	^ AllTestsMethodsRunningMutantEvaluationStrategy new
]

{ #category : #'as yet unclassified' }
SConfiguration class >> defaultGeneratorTypeInfoOf: blockToExecute onClass: aClass [
	^ (SSTypeCollector profile: blockToExecute onClass: aClass) asTypeInfo
]

{ #category : #'as yet unclassified' }
SConfiguration class >> defaultGeneratorTypeInfoOf: blockToExecute
				onPackagesMatching: regex [
^ (SSTypeCollector profile: blockToExecute onPackagesMatching: regex)
				asTypeInfo
]

{ #category : #'as yet unclassified' }
SConfiguration class >> defaultMutantOperators [
	^ MutantOperator contents
]

{ #category : #'as yet unclassified' }
SConfiguration class >> initLevelToPrint [ 	
	level := 10
]

{ #category : #accessing }
SConfiguration class >> levelToPrint [
	^ level
]

{ #category : #'as yet unclassified' }
SConfiguration class >> reduceLevel [
	level ifNil: [ self initLevelToPrint  ].
	level := level - 1
]
