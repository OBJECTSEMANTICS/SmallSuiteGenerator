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
	numberToChangeSeed := 0
]

{ #category : #initialization }
SSeedingParameterization >> initializeDictionary [
	^ Dictionary new 
		at: #lowerSeed put: [ :testCaseFactory | 
			testCaseFactory seed: testCaseFactory seed - self numberToChangeSeed ];
		at: #greaterSeed put: [ :testCaseFactory |
			testCaseFactory seed: testCaseFactory seed + self numberToChangeSeed ];
		yourself
]

{ #category : #accessing }
SSeedingParameterization >> numberToChangeSeed [
	numberToChangeSeed == 0 ifTrue: [ numberToChangeSeed := 10 ].
	^ numberToChangeSeed
]
