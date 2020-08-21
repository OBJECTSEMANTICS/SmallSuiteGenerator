"
SFitnessFunction is an abstract class that represents a fitness abstract function used in genetic algorithm evolution to determine how fit a testCase is.




"
Class {
	#name : #SFitnessFunction,
	#superclass : #SGAObject,
	#instVars : [
		'profiler',
		'targetClass',
		'aClass'
	],
	#classInstVars : [
		'operator'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #accessing }
SFitnessFunction >> aClass [
	aClass ifNotNil: [ ^ aClass ].
	aClass := self class environment at: targetClass.
	^ aClass
]

{ #category : #actions }
SFitnessFunction >> compute: testCaseCollection [
	self setUp.
	self run: testCaseCollection.
	self tearDown.
]

{ #category : #actions }
SFitnessFunction >> fitnessOf: aTestCase [ 
	self subclassResponsibility 
]

{ #category : #actions }
SFitnessFunction >> fitnessOfBlock: aBlock [
	
]

{ #category : #accesing }
SFitnessFunction >> functionName [
	^ self subclassResponsibility
]

{ #category : #accesing }
SFitnessFunction >> profiler [
	^ profiler 
]

{ #category : #accesing }
SFitnessFunction >> profiler: aProfiler [
	profiler := aProfiler.
]

{ #category : #actions }
SFitnessFunction >> run: testCaseCollection [
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
SFitnessFunction >> run: testCaseCollection comparingWithAll: aColl [
	testCaseCollection
		do: [ :testCase | 
			testCase length > 0 ifTrue: [
				profiler cleanBlocksOfMethods.
				testCase runWithoutAssertionsAndLastStatement.
				SGAEngine logClass summaryExecutionMethodsOf: testCase with: profiler. ]
			ifFalse: [ testCase fitness at: self functionName put: 0 ] ].
	
]

{ #category : #actions }
SFitnessFunction >> runPopulation: testCaseCollection [
	profiler cleanBlocksOfMethods.
	testCaseCollection
		do: [ :testCase | 
			testCase length > 0 ifTrue: [ testCase runWithoutAssertionsAndLastStatement ] ].
	^ profiler summaryMethodsOf: targetClass  
]

{ #category : #actions }
SFitnessFunction >> setUp [
]

{ #category : #accessing }
SFitnessFunction >> targetClass: anObject [
	targetClass := anObject
]

{ #category : #actions }
SFitnessFunction >> tearDown [
]

{ #category : #accessing }
SFitnessFunction >> typeInfo: anObject [ 
	profiler typeInfo: anObject
]
