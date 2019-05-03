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

{ #category : #'as yet unclassified' }
SSAssertionGeneratorTest >> test1 [
		| _var0 _var1 |
_var0 := Stack new
	add: 1;
	yourself.
_var1 := 1.
self assert: _var0 size equals: 1.
self
	assert: (_var0 allSatisfy: [ :element | element className = 'SmallInteger' ]).
self
	assert: _var0
	equals:
		(Stack new
			add: 1;
			yourself).
self assert: _var0 top equals: 1.
self assert: _var0 asString equals: 'a Stack(1)'.
self assert: _var1 equals: 1.
self assert: _var1 threeDigitName equals: 'one'.
self assert: _var1 equals: 1.
self assert: _var1 asString equals: '1'
]
