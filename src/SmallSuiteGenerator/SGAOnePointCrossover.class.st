Class {
	#name : #SGAOnePointCrossover,
	#superclass : #SGACrossoverOperation,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #accessing }
SGAOnePointCrossover >> alpha [

	^ (self random selectAtRandom: (0.1 to: 0.9 by: 0.1)) round: 1
]

{ #category : #actions }
SGAOnePointCrossover >> crossover: testCaseA with: testCaseB [

	| alpha offSpring1 offSpring2 |
	self checkReferencesOf: testCaseA withDescription: 'testCase'.
	self checkReferencesOf: testCaseB withDescription: 'testCase'.
	"join typeInfo of testCaseA with testCaseB"
	testCaseA typeInfo joinWith: testCaseB typeInfo.
	alpha := self alpha.
	"first alpha(p1) and last (1-alpha)(p2)"
	offSpring1 := self offSpringOf: testCaseA and: testCaseB using: alpha.
	self checkReferencesOf: offSpring1 withDescription: 'offspring'.
	"first alpha(p2) and last (1-alpha)(p1)"
	offSpring2 := self offSpringOf: testCaseB and: testCaseA using: (alpha).
	self checkReferencesOf: offSpring2 withDescription: 'offspring'.
	^ (Array with: offSpring1 with: offSpring2) do: 
			[ :e | e lastMessage: testCaseA lastMessage]
]

{ #category : #actions }
SGAOnePointCrossover >> offSpringOf: parentA and: parentB using: alpha [
  | sizeA sizeB offSpring limitA limitB|
  sizeA := parentA length.
  sizeB := parentB length.
  offSpring := SSTestCase with: parentA typeInfo copy.
  offSpring targetClassName: parentA targetClassesName.
  limitA := ((sizeA * alpha) asInteger max: 1).
  1 to: limitA do:[ :i |
	|stm|
	stm := parentA statements at:i.
	offSpring addStatement: stm copy.
	offSpring assignId.
	].
	limitB := ((alpha * sizeB) asInteger max: 1) + 1.
	limitB to: sizeB do:[ :i|
		|stm|
		stm := parentB statements at:i.
		[stm insertOn: offSpring.] on:Error do:[ "nothing" nil].
		].
	offSpring
	  generationNumber: parentA generationNumber + 1;
	  clean.
  ^ offSpring
]
