Class {
	#name : #SRandomTest,
	#superclass : #TestCase,
	#instVars : [
		'utility'
	],
	#category : #'SmallSuiteGenerator-Tests-Core'
}

{ #category : #running }
SRandomTest >> setUp [
	super setUp.
	utility := SUtilityTypeInfo new
]

{ #category : #tests }
SRandomTest >> testCollectAtRandom [
	| generator array |
	generator := SRandom seed: 100.
	array := (1 to: 10) asArray.
	self assertCollection: (generator collectAtRandom: array) hasSameElements: array
]

{ #category : #tests }
SRandomTest >> testCollectAtRandomOnStatements [
	| generator testCase sfooSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	generator := SRandom seed: 100.
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase
		targetClassName: sfooSymbol;
		addFactoryMessage;
		addMessage: #returnNum from: sfooSymbol;
		addFieldAccessMessage: #score from: sfooSymbol.
	self
		assertCollection: testCase printStatements
		hasSameElements:
			((generator collectAtRandom: testCase statements)
				collect: #printString)
]

{ #category : #tests }
SRandomTest >> testSelectAtRandom [
	|generator array|
	generator := SRandom seed: 100.
	array := (1 to: 10) asArray.
	self assert: ((generator selectAtRandom: array) between: 1 and: 10)
]

{ #category : #tests }
SRandomTest >> testSelectAtRandomOnStatements [
	| generator testCase stringStatements statements sfooSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	generator := SRandom seed: 100.
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase
		targetClassName: sfooSymbol;
		addFactoryMessage;
		addMessage: #returnNum from: sfooSymbol;
		addFieldAccessMessage: #score from: sfooSymbol.
	stringStatements := testCase printStatements.
	statements := testCase statements.
	100 timesRepeat: [
		self
		assert:
			(stringStatements 
				includes: (generator selectAtRandom: statements) printString)]
]

{ #category : #tests }
SRandomTest >> testShuffleCollection [
	| generator array |
	generator := SRandom seed: 100.
	array := (1 to: 10) asArray.
	self
		assertCollection: (generator shuffleCollection: 10)
		hasSameElements: array
]
