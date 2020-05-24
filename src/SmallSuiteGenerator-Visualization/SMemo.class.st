Class {
	#name : #SMemo,
	#superclass : #SObject,
	#instVars : [
		'memo'
	],
	#category : #'SmallSuiteGenerator-Visualization'
}

{ #category : #accessing }
SMemo >> at: summaryExecMethod of: generationNumber [
	^ self at: summaryExecMethod of: generationNumber ifAbsent: [ nil ]
]

{ #category : #accessing }
SMemo >> at: summaryExecMethod of: generationNumber ifAbsent: absentBlock [
	^ memo at: summaryExecMethod executorClass -> summaryExecMethod selector
		ifPresent: [ :dictSummary | dictSummary at: summaryExecMethod 
			ifPresent: [ :dict | dict at: generationNumber ifAbsent: absentBlock ]
			ifAbsent: absentBlock ]
		ifAbsent: absentBlock
]

{ #category : #accessing }
SMemo >> at: summaryExecMethod of: generationNumber ifPresent: presentBlock ifAbsent: absentBlock [
	^  (self at: summaryExecMethod of: generationNumber)
		ifNotNil: [ :value | presentBlock cull: value ] 
		ifNil: absentBlock
]

{ #category : #accessing }
SMemo >> at: summaryExecMethod of: generationNumber put: newCoverage [
	self at: summaryExecMethod of: generationNumber
		ifPresent: [ :value | 
			value < newCoverage ifTrue: [((memo at: summaryExecMethod executorClass -> summaryExecMethod selector) at: summaryExecMethod) at: generationNumber put: newCoverage ]  ]
		ifAbsent: [ memo at: summaryExecMethod executorClass -> summaryExecMethod selector 
			ifPresent: [ :dictSummary | dictSummary at: summaryExecMethod 
				ifPresent: [ :dictGeneration | dictGeneration at: generationNumber put: newCoverage ] 
				ifAbsentPut: [ Dictionary new at: generationNumber put: newCoverage; yourself ] ]
			ifAbsentPut: [ (Dictionary new at: summaryExecMethod 
				put: (Dictionary new at: generationNumber put: newCoverage; yourself); yourself) ]
		]
]

{ #category : #accessing }
SMemo >> at: summaryExecMethod ofPreviousThan: generationNumber ifPresent: presentBlock ifAbsent: absentBlock [
	| max flag |
	max := 0.
	flag := false.
	generationNumber - 1 == 0 ifTrue: [ ^ absentBlock value ].
	(generationNumber - 1 to: 1 by: -1) do: [:generation | | value | 
		value := self at: summaryExecMethod of: generation.
		value ifNotNil: [ flag := true.
			max := max max: value ] ].
	^ flag ifTrue: [ presentBlock value: max ] ifFalse: absentBlock 
]

{ #category : #initialization }
SMemo >> initialize [ 
	memo := Dictionary new
]
