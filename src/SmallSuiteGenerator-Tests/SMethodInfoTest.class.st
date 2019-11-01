Class {
	#name : #SMethodInfoTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Info'
}

{ #category : #tests }
SMethodInfoTest >> testEquals [
	self
		assert: (STypeMethodInfo type: #name -> #(#SStudent #ByteString #() false))
		equals: (STypeMethodInfo type: #name -> #(#SStudent #ByteString #() false)).
	self assert: (STypeMethodInfo
		type: #return: -> #(#SFoo #ByteString #(#ByteString) false)) equals: (STypeMethodInfo
		type: #return: -> #(#SFoo #ByteString #(#ByteString) false))
]

{ #category : #tests }
SMethodInfoTest >> testFromSton [
	| typeMethod |
	typeMethod := STypeMethodInfo
		type: #name -> #(#SStudent #ByteString #() true).
	self
		assert:
			(STON
				fromString:
					'STypeMethodInfo {#selector: #name, #receiver: SMultiTypeInfo [#SStudent], #returnType: SMultiTypeInfo [#ByteString], #argTypes: [], #isQuick: true}')
		equals: typeMethod.
	typeMethod := STypeMethodInfo
		type: #return: -> #(#SFoo #ByteString #(#ByteString) false).
	self
		assert:
			(STON
				fromString:
					'STypeMethodInfo {#selector: #''return:'', #receiver: SMultiTypeInfo [#SFoo], #returnType: SMultiTypeInfo [#ByteString], #argTypes: [SMultiTypeInfo [#ByteString]], #isQuick: false}')
		equals: typeMethod
]

{ #category : #tests }
SMethodInfoTest >> testToString [
	| string typeMethod |
	typeMethod := STypeMethodInfo type: #name -> #(#SStudent #ByteString #() true).
	string := STON
		toString: typeMethod.
	self
		assert: (STON fromString: string)
		equals:
			typeMethod.
	typeMethod := (STypeMethodInfo
				type: #return: -> #(#SFoo #ByteString #(#ByteString) false)).
	string := STON toString: typeMethod.
	self
		assert: (STON fromString: string)
		equals:
			typeMethod
]

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
		type: #return: -> #(#SFoo #OrderedCollection #(#OrderedCollection) false).
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
	self assert: methodInfo returnType type equals: #SmallInteger.
	self assert: methodInfo argTypes isEmpty.
	self assert: methodInfo isQuick
]
