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
	^ self at: summaryExecMethod of: testCase ifAbsent: (Array with: [ nil ])
]

{ #category : #accessing }
SMemo >> at: summaryExecMethod of: testCase ifAbsent: absentBlocks [
	^ memo at: (summaryExecMethod executorClass -> summaryExecMethod selector) 
		ifPresent: [ :dict | dict at: testCase generationNumber 
				ifPresent: [ :anotherDict | 
					anotherDict at: testCase idPopulation
						ifAbsent: [(absentBlocks size == 3 ) ifTrue: [absentBlocks third cull: anotherDict ] ifFalse: [ absentBlocks first ] ] ]
				ifAbsent: [ absentBlocks size > 1 ifTrue: [ absentBlocks second cull: dict ] ifFalse: [ absentBlocks first ] ] ]
		ifAbsent: absentBlocks first
]

{ #category : #accessing }
SMemo >> at: summaryExecMethod of: testCase ifPresent: presentBlock ifAbsent: absentBlock [
	^  (self at: summaryExecMethod of: testCase)
		ifNotNil: [ :value | presentBlock cull: value ] 
		ifNil: absentBlock
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
