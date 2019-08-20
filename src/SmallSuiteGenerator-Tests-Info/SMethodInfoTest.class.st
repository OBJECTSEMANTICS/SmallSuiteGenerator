Class {
	#name : #SMethodInfoTest,
	#superclass : #SUnitTestCase,
	#category : #'SmallSuiteGenerator-Tests-Info'
}

{ #category : #tests }
SMethodInfoTest >> testType [
	| methodInfo |
	methodInfo := STypeMethodInfo
		type:
			#returnFloat
				->
					#(#SmallFloat64
					#()
					false).
	self assert: methodInfo returnType type equals: #SmallFloat64.
	self assert: methodInfo allArgTypes isEmpty.
	self deny: methodInfo isQuick.
	methodInfo := STypeMethodInfo
		type:
			#returnString
				->
					#(#ByteString
					#()
					false).
	self assert: methodInfo returnType type equals: #ByteString.
	self assert: methodInfo allArgTypes isEmpty.
	self deny: methodInfo isQuick.
	methodInfo := STypeMethodInfo
		type:
			#return:
				->
					#(#OrderedCollection
					#(#OrderedCollection)
					false).
	self assert: methodInfo returnType type equals: #OrderedCollection.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: #(#OrderedCollection).
	self deny: methodInfo isQuick.
	methodInfo := STypeMethodInfo
		type:
			#score:
				->
					#(#SFoo
					#(#SmallInteger)
					false).
	self assert: methodInfo returnType type equals: #SFoo.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: #(#SmallInteger).
	self deny: methodInfo isQuick.
	methodInfo := STypeMethodInfo
		type:
			#score
				->
					#(#SmallInteger
					#()
					true).
	self assert: methodInfo returnType equals: #SmallInteger.
	self assert: methodInfo argTypes isEmpty.
	self assert: methodInfo isQuick
]
