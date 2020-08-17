Class {
	#name : #SGAMultiPointCrossover,
	#superclass : #SGACrossoverOperation,
	#instVars : [
		'n'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SGAMultiPointCrossover >> crossover: testCaseA with: testCaseB [

	| alpha offSpring1 offSpring2 |
	self checkReferencesOf: testCaseA withDescription: 'testCase'.
	self checkReferencesOf: testCaseB withDescription: 'testCase'.
	"join typeInfo of testCaseA with testCaseB"
	testCaseA typeInfo joinWith: testCaseB typeInfo.
	alpha := self segments.
	"first alpha(p1) and last (1-alpha)(p2)"
	offSpring1 := self offSpringOf: testCaseA and: testCaseB using: alpha.
	self checkReferencesOf: offSpring1 withDescription: 'offspring'.
	"first alpha(p2) and last (1-alpha)(p1)"
	offSpring2 := self offSpringOf: testCaseB and: testCaseA using: (alpha).
	self checkReferencesOf: offSpring2 withDescription: 'offspring'.
	^ (Array with: offSpring1 with: offSpring2) do: 
			[ :e | e lastMessage: testCaseA lastMessage]
]

{ #category : #initialization }
SGAMultiPointCrossover >> initialize [ 
	super initialize.
	n := 2.
]

{ #category : #actions }
SGAMultiPointCrossover >> offSpringOf: parentA and: parentB using: alpha [
  | sizeA sizeB offSpring limitA limitB|
  sizeA := parentA length.
  sizeB := parentB length.
  offSpring := SSTestCase with: parentA typeInfo copy.
  offSpring targetClassName: parentA targetClassesName.
  limitA := ((sizeA * alpha) asInteger max: 1).
  1 to: limitA first do:[ :i |
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

{ #category : #accessing }
SGAMultiPointCrossover >> segments [
	^ (1 to: n) collect: [ :e | self next round: 2 ]
]
