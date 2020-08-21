Class {
	#name : #SIndependentFitnessFunction,
	#superclass : #SSimpleFitnessFunction,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SIndependentFitnessFunction >> fitnessByClass [
	self subclassResponsibility
]

{ #category : #actions }
SIndependentFitnessFunction >> isIndependent [
	^ true
]

{ #category : #actions }
SIndependentFitnessFunction >> run: testCaseCollection [
	testCaseCollection
		do: [ :testCase | 
			testCase length > 0 ifTrue: [
				profiler cleanBlocksOfMethods.
				testCase runWithoutAssertionsAndLastStatement.
				SGAEngine logClass summaryExecutionMethodsOf: testCase with: profiler.
				self fitnessOf: testCase. ]
			ifFalse: [ testCase fitness at: self functionName put: 0 ] ]
]

{ #category : #actions }
SIndependentFitnessFunction >> run: aTestCase comparingWithAll: aColl [
	self run: aTestCase 
]
