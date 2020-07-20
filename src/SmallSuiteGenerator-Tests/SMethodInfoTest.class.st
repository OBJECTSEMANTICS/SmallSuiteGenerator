Class {
	#name : #SMethodInfoTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Info'
}

{ #category : #tests }
SMethodInfoTest >> testEquals [
	| studentSymbol sfooSymbol stringSymbol |
	studentSymbol := #SStudent fullClassNameSymbol.
	sfooSymbol := #SFoo fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	self
		assert: (STypeMethodInfo type: #name -> (Array with: studentSymbol with: stringSymbol with: #() with: false))
		equals: (STypeMethodInfo type: #name -> (Array with: studentSymbol with: stringSymbol with: #() with: false)).
	self assert: (STypeMethodInfo
		type: #return: -> (Array with: sfooSymbol with: stringSymbol with: (Array with: stringSymbol) with: false)) equals: (STypeMethodInfo
		type: #return: -> (Array with: sfooSymbol with: stringSymbol with: (Array with: stringSymbol) with: false))
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
	| methodInfo sfooSymbol floatSymbol stringSymbol collSymbol intSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	floatSymbol := #SmallFloat64 fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	collSymbol := #OrderedCollection fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	methodInfo := STypeMethodInfo
		type: #returnFloat -> (Array with: sfooSymbol with: floatSymbol with: #() with: false).
	self assert: methodInfo receiver type equals: sfooSymbol.
	self assert: methodInfo returnType type equals: floatSymbol.
	self assert: methodInfo allArgTypes isEmpty.
	self deny: methodInfo isQuick.
	self deny: methodInfo isDeprecated.
	methodInfo := STypeMethodInfo
		type: #returnString -> (Array with: sfooSymbol with: stringSymbol with: #() with: false).
	self assert: methodInfo receiver type equals: sfooSymbol.
	self assert: methodInfo returnType type equals: stringSymbol.
	self assert: methodInfo allArgTypes isEmpty.
	self deny: methodInfo isQuick.
	methodInfo := STypeMethodInfo
		type: #return: -> (Array with: sfooSymbol with: collSymbol with:(Array with: collSymbol) with: false).
	self assert: methodInfo receiver type equals: sfooSymbol.
	self assert: methodInfo returnType type equals: collSymbol.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: collSymbol).
	self deny: methodInfo isQuick.
	methodInfo := STypeMethodInfo
		type: #score: -> (Array with: sfooSymbol with: sfooSymbol with: (Array with: intSymbol) with: false).
	self assert: methodInfo receiver type equals: sfooSymbol.
	self assert: methodInfo returnType type equals: sfooSymbol.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: intSymbol).
	self deny: methodInfo isQuick.
	methodInfo := STypeMethodInfo
		type: #score -> (Array with: sfooSymbol with: intSymbol with: #() with: true).
	self assert: methodInfo receiver type equals: sfooSymbol.
	self assert: methodInfo returnType type equals: intSymbol.
	self assert: methodInfo argTypes isEmpty.
	self assert: methodInfo isQuick
]
