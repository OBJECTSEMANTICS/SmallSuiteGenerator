"
SGACrossoverOperation is the operation node that is responsible to create offsprings combining the statements of their parents.

To create a new offspring it gets a random percent of statements of a testCase and the rest of another testCase. Furthermore, it checks the statements references (dependencies) and repairs them if it is necessary.

For example if the parents are:
	Parent1
	_var0 := 1.
	_var1 := 'hello'.
	
	Parent2
	_var0 := SFoo new.
	_var1 := _var0 returnString.
	
The new offspring with a 50% of statements of each parent:
	_var0 := 1.
	_var1 := _var0 returnString.
	
Like it has an inconsistency because '_var0' in the first parent is of type SFoo, it is repaired. Then the new offspring resultant is:
	_var0 := 1.
	_var2 := SFoo new.
	_var1 := _var2 returnString. 
"
Class {
	#name : #SGACrossoverOperation,
	#superclass : #SGAOperation,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #accessing }
SGACrossoverOperation >> alpha [
	^ (randomGenerator selectAtRandom: (0.1 to: 0.9 by: 0.1)) round: 1
]

{ #category : #validation }
SGACrossoverOperation >> checkReferencesOf: testCase withDescription: aString [
	self
		assert: testCase validReferences
		description: aString , ' must have valid references'
]

{ #category : #actions }
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

{ #category : #actions }
SGACrossoverOperation >> offSpringOf: parentA and: parentB using: alpha [
  | sizeA sizeB offSpring limit |
  sizeA := parentA numberStatements.
  sizeB := parentB numberStatements.
  offSpring := SSTestCase with: parentA typeInfo copy.
  offSpring typeInfo joinWith: parentB typeInfo.
  offSpring
     addTargetClassNames: parentA targetClassesNames;
     addTargetClassNames: parentB targetClassesNames.
  limit := (sizeA * alpha) asInteger.
  offSpring addStatements: (parentA statements copyFrom: 1 to: limit) copy.
  (parentB statements copyFrom: (alpha * sizeB) asInteger + 1 to: sizeB) do: [:aStm |  [ aStm insertOn: offSpring ] on: SError do: [  ] ].
	^ (parentA = parentB and: [ offSpring = parentA ]) 
		ifTrue: [ parentA copy ] 
		ifFalse: [ offSpring addParent: parentA;
     addParent: parentB.
		offSpring ].
]
