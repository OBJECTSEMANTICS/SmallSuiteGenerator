"
SSimpleFitnessFunction is an abstract class of simple fitness function like: 
	
	- SMethodCoverage -> It calculates the number of class methods executed
	- SStatementCoverage -> It calculates the number of statements executed 
	
Instance Variables
	profiler:		<SSTypeCollector>
	

"
Class {
	#name : #SSimpleFitnessFunction,
	#superclass : #SFitnessFunction,
	#instVars : [
		'profiler'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SSimpleFitnessFunction >> compute: testCaseCollection [
	self setUp.
	self run: testCaseCollection.
	self tearDown.
]

{ #category : #actions }
SSimpleFitnessFunction >> fitnessOf: testCase withKey: string [
	self subclassResponsibility 
]

{ #category : #accesing }
SSimpleFitnessFunction >> functionName [
	^ self subclassResponsibility
]

{ #category : #accesing }
SSimpleFitnessFunction >> profiler [
	^ profiler 
]

{ #category : #accesing }
SSimpleFitnessFunction >> profiler: aProfiler [
	profiler := aProfiler.
]

{ #category : #actions }
SSimpleFitnessFunction >> run: testCaseCollection [
	| string |
	string := self functionName.
	testCaseCollection
		do: [ :testCase | 
			testCase length > 0 ifTrue: [
				profiler cleanBlocksOfMethods.
				testCase runWithoutAssertions.
				SGAEngine logClass summaryExecutionMethodsOf: testCase with: profiler.
				"testCase summaryExecutionMethods: profiler summaryExecutionMethods."
				"self abstractDataOn: testCase."
				self fitnessOf: testCase withKey: string. ]
			ifFalse: [ testCase fitness at: string put: 0 ] ]
	
]

{ #category : #actions }
SSimpleFitnessFunction >> runPopulation: testCaseCollection [
	profiler cleanBlocksOfMethods.
	testCaseCollection
		do: [ :testCase | 
			testCase length > 0 ifTrue: [ testCase runWithoutAssertions ] ].
	^ profiler summaryMethodsOf: targetClass  
]

{ #category : #actions }
SSimpleFitnessFunction >> setUp [
]

{ #category : #actions }
SSimpleFitnessFunction >> tearDown [
]

{ #category : #accessing }
SSimpleFitnessFunction >> typeInfo: anObject [ 
	profiler typeInfo: anObject
]
