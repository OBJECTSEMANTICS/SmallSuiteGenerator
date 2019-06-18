Class {
	#name : #SConfiguration,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SConfiguration class >> classAssertsGenerationTest [
	^ SSAssertionGeneratorTest 
]

{ #category : #'as yet unclassified' }
SConfiguration class >> defaultEvaluationStrategy [
	^ AllTestsMethodsRunningMutantEvaluationStrategy new
]

{ #category : #'as yet unclassified' }
SConfiguration class >> defaultMutantOperators [
	^ MutantOperator contents
]
