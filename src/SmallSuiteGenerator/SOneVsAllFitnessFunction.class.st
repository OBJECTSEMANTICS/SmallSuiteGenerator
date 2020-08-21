Class {
	#name : #SOneVsAllFitnessFunction,
	#superclass : #SSimpleFitnessFunction,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SOneVsAllFitnessFunction >> compute: testCaseCollection regardingAll: aCollection [
	self initializeValuesOf: testCaseCollection , aCollection .
	testCaseCollection do: [ :testCase |
		self fitnessOf: testCase comparingWithAll: aCollection .
	]
]

{ #category : #actions }
SOneVsAllFitnessFunction >> computeFitnessByClassOf: testCase regardingAll: aColl [
	self subclassResponsibility
]

{ #category : #actions }
SOneVsAllFitnessFunction >> computeFitnessOf: testCase regardingAll: aColl [
	| fitnessByClass |
	fitnessByClass := self computeFitnessByClassOf: testCase regardingAll: aColl.
	^ Array with: (self computeCoverageWith: fitnessByClass) with: fitnessByClass.
]

{ #category : #actions }
SOneVsAllFitnessFunction >> fitnessOf: testCase comparingWithAll: aColl [
	| fitness |
	fitness := self computeFitnessOf: testCase regardingAll: aColl.
	
	testCase fitness at: self functionName put: fitness first.
	testCase fitnessByClass at: self functionName put: fitness second.
]

{ #category : #actions }
SOneVsAllFitnessFunction >> initializeValuesOf: aColl [
	aColl do: [ :testCase |
		self setUp.
		self saveInformationOf: testCase.
		self tearDown.
		SGAEngine logClass summaryExecutionMethodsOf: testCase with: profiler
	]
]

{ #category : #testing }
SOneVsAllFitnessFunction >> isIndependent [
	^ false
]

{ #category : #actions }
SOneVsAllFitnessFunction >> run: testCaseCollection [
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
SOneVsAllFitnessFunction >> run: aTestCase comparingWithAll: aColl [
  self computeFitnessOf: aTestCase regardingAll: aColl.
]

{ #category : #actions }
SOneVsAllFitnessFunction >> saveInformationOf: testCase [
	self subclassResponsibility 
]
