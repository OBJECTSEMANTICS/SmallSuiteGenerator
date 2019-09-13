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
					(Array
						with:
							(Array
								with:
									#returnFloat -> #(#SFoo #SmallFloat64 #() false)
								with: #returnString -> #(#SFoo #ByteString #() false)
								with:
									#return: -> #(#SFoo #OrderedCollection #(#OrderedCollection) false)
								with:
									#score: -> #(#SFoo #SFoo #(#SmallInteger) false)
								with: #score -> #(#SFoo #SmallInteger #() true))
						with:
							(Array with:
								#score: -> #(#SFoo #SFoo #(#SmallInteger) false))).
	classInfo typeMethod: #returnNum -> #(#SFoo #SmallInteger #() false).
	self assert: classInfo methodTypes size equals: 6.
	self assert: classInfo classMethodTypes size equals: 1.
	methodInfo := classInfo methodTypes at: #return:.
	self assert: methodInfo receiver type equals: #SFoo.
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
	self assert: methodInfo receiver type equals: #SFoo.
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
