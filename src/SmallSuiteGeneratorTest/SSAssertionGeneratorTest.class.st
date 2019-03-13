Class {
	#name : #SSAssertionGeneratorTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Assertion'
}

{ #category : #'as yet unclassified' }
SSAssertionGeneratorTest >> test0 [
		| _var0 |
_var0 := Stack new.
self assert: _var0 isEmpty.
self assert: _var0 equals: Stack new.
self assert: _var0 asString equals: 'a Stack()'
]
