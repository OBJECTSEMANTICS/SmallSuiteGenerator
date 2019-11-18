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
	| generator testCase |
	generator := SRandom seed: 100.
	testCase := SSTestCaseForTest with: utility typeInfoSFoo1.
	testCase
		addTargetClassName: #SFoo;
		addFactoryMessage;
		addMessage: #returnNum from: #SFoo;
		addFieldAccessMessage: #score from: #SFoo.
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
	| generator testCase stringStatements statements |
	generator := SRandom seed: 100.
	testCase := SSTestCaseForTest with: utility typeInfoSFoo1.
	testCase
		addTargetClassName: #SFoo;
		addFactoryMessage;
		addMessage: #returnNum from: #SFoo;
		addFieldAccessMessage: #score from: #SFoo.
	stringStatements := testCase printStatements.
	statements := testCase statements.
	100
		timesRepeat: [ self
				assert:
					(stringStatements
						includes: (generator selectAtRandom: statements) printString) ]
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
