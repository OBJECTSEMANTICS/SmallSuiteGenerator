Class {
	#name : #SConfiguration,
	#superclass : #SObject,
	#classInstVars : [
		'level'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'default configuration' }
SConfiguration class >> classAssertsGenerationTest [
	^ SSAssertionGeneratorTest 
]

{ #category : #'default configuration' }
SConfiguration class >> defaultEvaluationStrategy [
	^ AllTestsMethodsRunningMutantEvaluationStrategy new
]

{ #category : #'default configuration' }
SConfiguration class >> defaultGeneratorTypeInfoOf: blockToExecute onClass: aClass [
	^ (SSGenerator profile: blockToExecute onClass: aClass) asTypeInfo
]

{ #category : #'default configuration' }
SConfiguration class >> defaultGeneratorTypeInfoOf: blockToExecute
				onPackagesMatching: regex [
^ (SSGenerator profile: blockToExecute onPackagesMatching: regex)
				asTypeInfo
]

{ #category : #'default configuration' }
SConfiguration class >> defaultMutantOperators [
	^ MutantOperator contents
]

{ #category : #'default configuration' }
SConfiguration class >> initLevelToPrint [ 	
	level := 10
]

{ #category : #accessing }
SConfiguration class >> levelToPrint [
	^ level
]

{ #category : #'modifier state' }
SConfiguration class >> reduceLevel [
	level := level - 1
]
