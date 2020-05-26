Class {
	#name : #SMemo,
	#superclass : #SObject,
	#instVars : [
		'memo'
	],
	#category : #'SmallSuiteGenerator-Visualization'
}

{ #category : #accessing }
SMemo >> at: summaryExecMethod of: generationNumber and: idPopulation [
	^ self at: summaryExecMethod of: generationNumber and: idPopulation ifAbsent: [ nil ]
]

{ #category : #accessing }
SMemo >> at: summaryExecMethod of: generationNumber and:idPopulation ifAbsent: absentBlock [
	^ memo at: summaryExecMethod executorClass -> summaryExecMethod selector
		ifPresent: [ :dictSummary | dictSummary at: summaryExecMethod 
			ifPresent: [ :dictGeneration | dictGeneration at: generationNumber 
				ifPresent: [ :dictIdP | dictIdP at: idPopulation ifAbsent: absentBlock  ] 
				ifAbsent: absentBlock ]
			ifAbsent: absentBlock ]
		ifAbsent: absentBlock
]

{ #category : #accessing }
SMemo >> at: summaryExecMethod of: generationNumber and: idPopulation ifPresent: presentBlock ifAbsent: absentBlock [
	^  (self at: summaryExecMethod of: generationNumber and: idPopulation)
		ifNotNil: [ :value | presentBlock cull: value ] 
		ifNil: absentBlock
]

{ #category : #accessing }
SMemo >> at: summaryExecMethod of: generationNumber and: idPopulation put: newCoverage [
	self at: summaryExecMethod of: generationNumber and: idPopulation 
		ifPresent: [ :value | 
			value < newCoverage ifTrue: [(((memo at: summaryExecMethod executorClass -> summaryExecMethod selector) at: summaryExecMethod) at: generationNumber) at: idPopulation put: newCoverage ]  ]
		ifAbsent: [ memo at: summaryExecMethod executorClass -> summaryExecMethod selector 
			ifPresent: [ :dictSummary | dictSummary at: summaryExecMethod 
				ifPresent: [ :dictGeneration | dictGeneration at: generationNumber
					ifPresent: [ :dictPop | dictPop at: idPopulation put: newCoverage ]
					ifAbsentPut: [ Dictionary new at: idPopulation put: newCoverage; yourself ] ] 
				ifAbsentPut: [ Dictionary new at: generationNumber put: (Dictionary new at: idPopulation put: newCoverage; yourself); yourself ] ]
			ifAbsentPut: [ (Dictionary new at: summaryExecMethod 
				put: (Dictionary new at: generationNumber put: (Dictionary new at: idPopulation put: newCoverage; yourself); yourself); yourself) ]
		]
]

{ #category : #initialization }
SMemo >> initialize [ 
	memo := Dictionary new
]
