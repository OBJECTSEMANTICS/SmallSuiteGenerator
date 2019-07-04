Class {
	#name : #SClassInfoTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Info'
}

{ #category : #tests }
SClassInfoTest >> testType [
	| classInfo methodInfo |
	classInfo := STypeClassInfo
		type:
			#SFoo
				->
					{{(#returnFloat
						->
							{#SmallFloat64.
							{}.
							false}).
					(#returnString
						->
							{#ByteString.
							{}.
							false}).
					(#return:
						->
							{#OrderedCollection.
							{#OrderedCollection}.
							false}).
					(#score:
						->
							{#SFoo.
							{#SmallInteger}.
							false}).
					(#score
						->
							{#SmallInteger.
							{}.
							true})}.
					{(#score:
						->
							{#SFoo.
							{#SmallInteger}.
							false})}}.
	self assert: classInfo methodTypes size equals: 5.
	self assert: classInfo classMethodTypes size equals: 1.
	methodInfo := classInfo methodTypes at: #return:.
	self assert: methodInfo returnType equals: #OrderedCollection.
	self
		assertCollection: methodInfo argTypes
		hasSameElements: {#OrderedCollection}.
	self
		assert: (classInfo methodTypes at: #returnFloat) returnType
		equals: #SmallFloat64.
	self
		assert: (classInfo methodTypes at: #returnString) returnType
		equals: #ByteString.
	self
		assert: (classInfo methodTypes at: #score) returnType
		equals: #SmallInteger.
	methodInfo := classInfo methodTypes at: #score:.
	self assert: methodInfo returnType equals: #SFoo.
	self
		assertCollection: methodInfo argTypes
		hasSameElements: {#SmallInteger}.
	self
		assert: (classInfo classMethodTypes at: #score:) returnType
		equals: #SFoo
]
