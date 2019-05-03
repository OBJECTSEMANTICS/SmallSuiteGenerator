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
	self
		assert: testCaseA hasValidDependencies
		description: 'testCase must have valid dependencies'.
	self
		assert: testCaseB hasValidDependencies
		description: 'testCase must have valid dependencies'.
	alpha := self alpha.
	"first alpha(P1) and last (1-alpha)(P2)"
	offSpring1 := self offSpringOf: testCaseA and: testCaseB using: alpha.
	self
		assert: offSpring1 hasValidDependencies
		description: 'offspring must have valid dependencies'.
	self
		assert: offSpring1 hasUniqueStatements
		description: 'offspring must have unique statements'.
	"first alpha(P2) and last (1-alpha)(P1)"
	offSpring2 := self offSpringOf: testCaseB and: testCaseA using: alpha.
	self
		assert: offSpring2 hasValidDependencies
		description: 'offspring must have valid dependencies'.
	self
		assert: offSpring2 hasUniqueStatements
		description: 'offspring must have unique statements'.
	^ {offSpring1.
	offSpring2}
]

{ #category : #'as yet unclassified' }
SGACrossoverOperation >> offSpringOf: parentA and: parentB using: alpha [
	| sizeA sizeB offSpring limit |
	sizeA := parentA numberOfStatements.
	sizeB := parentB numberOfStatements.
	offSpring := STestCase seed: parentB profile.
	limit := (sizeA * alpha) asInteger.
	offSpring
		addFromParents:
			(parentA statements copyFrom: 1 to: limit)
				deepCopy.
	(parentB statements
		copyFrom: (alpha * sizeB) asInteger + 1
		to: sizeB) deepCopy
		do: [ :aStm | aStm satisfyParameters: offSpring with: parentB ].
	^ offSpring
]
