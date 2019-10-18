Class {
	#name : #SMethodInfoTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Info'
}

{ #category : #tests }
SMethodInfoTest >> testType [
	| methodInfo |
	methodInfo := STypeMethodInfo
		type: #returnFloat -> #(#SFoo #SmallFloat64 #() false).
	self assert: methodInfo receiver type equals: #SFoo.
	self assert: methodInfo returnType type equals: #SmallFloat64.
	self assert: methodInfo allArgTypes isEmpty.
	self deny: methodInfo isQuick.
	self deny: methodInfo isDeprecated.
	methodInfo := STypeMethodInfo
		type: #returnString -> #(#SFoo #ByteString #() false).
	self assert: methodInfo receiver type equals: #SFoo.
	self assert: methodInfo returnType type equals: #ByteString.
	self assert: methodInfo allArgTypes isEmpty.
	self deny: methodInfo isQuick.
	methodInfo := STypeMethodInfo
		type:
			#return: -> #(#SFoo #OrderedCollection #(#OrderedCollection) false).
	self assert: methodInfo receiver type equals: #SFoo.
	self assert: methodInfo returnType type equals: #OrderedCollection.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: #(#OrderedCollection).
	self deny: methodInfo isQuick.
	methodInfo := STypeMethodInfo
		type: #score: -> #(#SFoo #SFoo #(#SmallInteger) false).
	self assert: methodInfo receiver type equals: #SFoo.
	self assert: methodInfo returnType type equals: #SFoo.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: #(#SmallInteger).
	self deny: methodInfo isQuick.
	methodInfo := STypeMethodInfo
		type: #score -> #(#SFoo #SmallInteger #() true).
	self assert: methodInfo receiver type equals: #SFoo.
	self assert: methodInfo returnType equals: #SmallInteger.
	self assert: methodInfo argTypes isEmpty.
	self assert: methodInfo isQuick
]
