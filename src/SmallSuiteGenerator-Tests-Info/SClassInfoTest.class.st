Class {
	#name : #SClassInfoTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Info'
}

{ #category : #tests }
SClassInfoTest >> testType [
	| classInfo methodInfo |
	classInfo := STypeClassInfo
		type:
			#SFoo
				->
					(Array with: (Array with: (#returnFloat
						->
							#(#SmallFloat64
							#()
							false)) with:
					(#returnString
						->
							#(#ByteString
							#()
							false)) with:
					(#return:
						->
							#(#OrderedCollection
							#(#OrderedCollection)
							false)) with:
					(#score:
						->
							#(#SFoo
							#(#SmallInteger)
							false)) with:
					(#score
						->
							#(#SmallInteger
							#()
							true))) with: 
					(Array with: (#score:
						->
							#(#SFoo
							#(#SmallInteger)
							false)))).
	classInfo
		typeMethod:
			#returnNum
				->
					#(#SmallInteger
					#()
					false).
	self assert: classInfo methodTypes size equals: 6.
	self assert: classInfo classMethodTypes size equals: 1.
	methodInfo := classInfo methodTypes at: #return:.
	self assert: methodInfo returnType type equals: #OrderedCollection.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: #(#OrderedCollection).
	self
		assert: (classInfo methodTypes at: #returnFloat) returnType type
		equals: #SmallFloat64.
	self
		assert: (classInfo methodTypes at: #returnString) returnType type
		equals: #ByteString.
	self
		assert: (classInfo methodTypes at: #score) returnType type
		equals: #SmallInteger.
	methodInfo := classInfo methodTypes at: #score:.
	self assert: methodInfo returnType type equals: #SFoo.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: #(#SmallInteger).
	self
		assert: (classInfo classMethodTypes at: #score:) returnType type
		equals: #SFoo.
	self
		assert: (classInfo methodTypes at: #returnNum) returnType type
		equals: #SmallInteger
]
