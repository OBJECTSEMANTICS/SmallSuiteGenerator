Class {
	#name : #SMemo,
	#superclass : #SObject,
	#instVars : [
		'memo'
	],
	#category : #'SmallSuiteGenerator-Visualization'
}

{ #category : #accessing }
SMemo >> at: summaryExecMethod of: testCase [
	^ self at: summaryExecMethod of: testCase ifAbsent: [ nil ]
]

{ #category : #accessing }
SMemo >> at: summaryExecMethod of: testCase ifAbsent: absentBlock [
	^ memo at: (summaryExecMethod executorClass -> summaryExecMethod selector) 
		ifPresent: [ :dict | dict at: testCase generationNumber 
				ifPresent: [ :anotherDict | anotherDict at: testCase idPopulation
					ifAbsent: [ absentBlock value ] ]
				ifAbsent: [ absentBlock value ] ]
		ifAbsent: [ absentBlock value ]
]

{ #category : #accessing }
SMemo >> at: summaryExecMethod of: testCase ifPresent: presentBlock ifAbsent: absentBlock [
	^  (self at: summaryExecMethod of: testCase)
		ifNotNil: [ :value | presentBlock cull: value ] 
		ifNil: [ absentBlock value ]
]

{ #category : #accessing }
SMemo >> at: summaryExecMethod of: testCase put: aValue [
	self at: summaryExecMethod of: testCase 
		ifAbsent: [ memo at: ( summaryExecMethod executorClass -> summaryExecMethod selector) 
				put: ( Dictionary new at: testCase generationNumber 
					put: (Dictionary new at: testCase idPopulation put: aValue; yourself ); yourself ) ]
]

{ #category : #initialization }
SMemo >> initialize [ 
	memo := Dictionary new
]
