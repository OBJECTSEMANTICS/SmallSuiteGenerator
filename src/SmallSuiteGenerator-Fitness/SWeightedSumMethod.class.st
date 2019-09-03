"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- #weightedSum: testCase 	 sum the result of multiply testCase's fitness with function fitness's weights.   
- #is: testCase1 betterThan: testCase2 compare     fitness of testCase1 with testCase2.
- #weights: numbers    It receives a collection of numbers that make reference at each function's weight, these must be sum equal than one and will be used to calculate weightedSum (weights wont be updated within iterations).

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #SWeightedSumMethod,
	#superclass : #SSelectorMethod,
	#classInstVars : [
		'weights'
	],
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #testing }
SWeightedSumMethod class >> is: aTestCase1 betterThan: aTestCase2 [
	| weightedSum1 weightedSum2 |
	weightedSum1 := self weightedSum: aTestCase1.
	weightedSum2 := self weightedSum: aTestCase2.
	"it considers the first comparison operator of functions"
	^ weightedSum1
		perform: functions first comparisonOperator
		with: weightedSum2
]

{ #category : #'as yet unclassified' }
SWeightedSumMethod class >> weightedSum: aTestCase [
	self assert: weights sum = 1 description: 'Verify that all weights must be sum one'.
	^ (aTestCase fitness values * weights) sum
]

{ #category : #accessing }
SWeightedSumMethod class >> weights: collWeight [
	weights := collWeight 
]
