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
SGACrossoverOperation >> checkReferencesOf: testCase withDescription: aString [
	self
		assert: testCase validReferences
		description: aString , ' must have valid references'
]

{ #category : #'as yet unclassified' }
SGACrossoverOperation >> crossover: testCaseA with: testCaseB [
	| alpha offSpring1 offSpring2 |
	self checkReferencesOf: testCaseA withDescription: 'testCase'.
	self checkReferencesOf: testCaseB withDescription: 'testCase'.
	"join typeInfo of testCaseA with testCaseB"
	testCaseA typeInfo joinWith: testCaseB typeInfo.
	alpha := self alpha.
	"first alpha(P1) and last (1-alpha)(P2)"
	offSpring1 := self offSpringOf: testCaseA and: testCaseB using: alpha.
	self checkReferencesOf: offSpring1 withDescription: 'offspring'.
	"first alpha(P2) and last (1-alpha)(P1)"
	offSpring2 := self offSpringOf: testCaseB and: testCaseA using: alpha.
	self checkReferencesOf: offSpring2 withDescription: 'offspring'.
	^ Array with: offSpring1 with: offSpring2
]

{ #category : #'as yet unclassified' }
SGACrossoverOperation >> offSpringOf: parentA and: parentB using: alpha [
	| sizeA sizeB offSpring limit |
	
	sizeA := parentA numberStatements.
	sizeB := parentB numberStatements.
	offSpring := SSTestCase with: parentA typeInfo copy.
	offSpring typeInfo joinWith: parentB typeInfo.
	limit := (sizeA * alpha) asInteger.
	offSpring
		addStatements: (parentA statements copyFrom: 1 to: limit) copy.
	(parentB statements copyFrom: (alpha * sizeB) asInteger + 1 to: sizeB)
		do: [ :aStm | aStm insertOn: offSpring ].
	^ offSpring
]
