"
SSeedingParametrization creates instances changing the seed whether adding or reducing a value to the original seed
"
Class {
	#name : #SSeedingParameterization,
	#superclass : #SInitialization,
	#instVars : [
		'numberToChangeSeed'
	],
	#category : #'SmallSuiteGenerator-Initialization'
}

{ #category : #initialization }
SSeedingParameterization >> initialize [ 
	super initialize.
	numberToChangeSeed := 0
]

{ #category : #initialization }
SSeedingParameterization >> initializeDictionary [
	^ Dictionary new 
		at: #lowerSeed put: [ :testCaseFactory | 
			testCaseFactory seed: testCaseFactory initialSeed - self numberToChangeSeed ];
		at: #greaterSeed put: [ :testCaseFactory |
			testCaseFactory seed: testCaseFactory initialSeed + self numberToChangeSeed ];
		yourself
]

{ #category : #accessing }
SSeedingParameterization >> numberToChangeSeed [
	numberToChangeSeed == 0 ifTrue: [ numberToChangeSeed := 10 ].
	^ numberToChangeSeed
]

{ #category : #accessing }
SSeedingParameterization >> numberToChangeSeed: number [
	numberToChangeSeed := number
]
