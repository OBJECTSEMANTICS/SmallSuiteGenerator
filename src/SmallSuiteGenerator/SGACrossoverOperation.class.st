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
SGACrossoverOperation >> checkDependenciesOf: testCase withDescription: aString [
	self
		assert: testCase hasValidDependencies
		description: aString, ' must have valid dependencies'
]

{ #category : #'as yet unclassified' }
SGACrossoverOperation >> checkUniqueStatementsOf: offSpring [
	self
		assert: offSpring hasUniqueStatements
		description: 'offspring must have unique statements'
]

{ #category : #'as yet unclassified' }
SGACrossoverOperation >> crossover: testCaseA with: testCaseB [
	| alpha offSpring1 offSpring2 |
	self checkDependenciesOf: testCaseA withDescription: 'testCase'.
	self checkDependenciesOf: testCaseB withDescription: 'testCase'.
	alpha := self alpha.
	"first alpha(P1) and last (1-alpha)(P2)"
	offSpring1 := self offSpringOf: testCaseA and: testCaseB using: alpha.
	self checkDependenciesOf: offSpring1 withDescription: 'offspring'.
	self checkUniqueStatementsOf: offSpring1.
	"first alpha(P2) and last (1-alpha)(P1)"
	offSpring2 := self offSpringOf: testCaseB and: testCaseA using: alpha.
	self checkDependenciesOf: offSpring2 withDescription: 'offspring'.
	self checkUniqueStatementsOf: offSpring2.
	^ {offSpring1.
	offSpring2}
]

{ #category : #'as yet unclassified' }
SGACrossoverOperation >> offSpringOf: parentA and: parentB using: alpha [
	| sizeA sizeB offSpring limit |
	sizeA := parentA numberOfStatements.
	sizeB := parentB numberOfStatements.
	offSpring := STestCase seed: parentB spyInfo.
	limit := (sizeA * alpha) asInteger.
	offSpring
		addFromParents: (parentA statements copyFrom: 1 to: limit) deepCopy.
	(parentB statements copyFrom: (alpha * sizeB) asInteger + 1 to: sizeB)
		deepCopy
		do: [ :aStm | aStm satisfyParameters: offSpring with: parentB ].
	^ offSpring
]
