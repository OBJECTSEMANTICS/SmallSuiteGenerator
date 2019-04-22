Class {
	#name : #SGACrossoverOperation,
	#superclass : #SGAOperation,
	#category : #'SmallSuiteGenerator-GeneticAlgorithm'
}

{ #category : #accessing }
SGACrossoverOperation >> alpha [ 	
	^ (0.1 to: 0.9 by: 0.1) atRandom round: 1
]

{ #category : #'as yet unclassified' }
SGACrossoverOperation >> crossover: testCaseA with: testCaseB [
	| alpha offSpring1 offSpring2 |
	alpha := self alpha.
	"first alpha(P1) and last (1-alpha)(P2)"
	offSpring1 := self offSpringOf: testCaseA and: testCaseB using: alpha.

	"first alpha(P2) and last (1-alpha)(P1)"
	offSpring2 := self offSpringOf: testCaseB and: testCaseA using: alpha.
	^ {offSpring1.
	offSpring2}
]

{ #category : #'as yet unclassified' }
SGACrossoverOperation >> offSpringOf: parentA and: parentB using: alpha [
	| sizeA sizeB offSpring |
	sizeA := parentA numberOfStatements.
	sizeB := parentB numberOfStatements.
	offSpring := STestCase seed: parentB profile.
	(parentA statements copyFrom: 1 to: (sizeA * alpha) asInteger)
		do: [ :aStm | 
			offSpring addStatement: aStm.
			offSpring assignedId ].
	(parentB statements copyFrom: (alpha * sizeB) asInteger + 1 to: sizeB)
		do: [ :aStm | offSpring addStatement: aStm satisfyingParameters: parentB ].
	^ offSpring
]
