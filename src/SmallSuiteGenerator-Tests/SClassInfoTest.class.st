Class {
	#name : #SClassInfoTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Info'
}

{ #category : #tests }
SClassInfoTest >> testEquals [
	| sfooSymbol studentSymbol stringSymbol intSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	studentSymbol := #SStudent fullClassNameSymbol.
	stringSymbol :=  #ByteString fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	
	self
		assert: (STypeClassInfo type: sfooSymbol -> #(#() #()))
		equals: (STypeClassInfo type: sfooSymbol -> #(#() #())).
	self
		assert:
			(STypeClassInfo
				type:
					studentSymbol
						->
							(Array
								with: (Array with: #name -> (Array with: studentSymbol with: stringSymbol with: #() with: false))
								with: #()))
		equals:
			(STypeClassInfo
				type:
					studentSymbol
						->
							(Array
								with: (Array with: #name -> (Array with: studentSymbol with: stringSymbol with: #() with: false))
								with: #())).
	self
		assert:
			(STypeClassInfo
				type:
					sfooSymbol
						->
							(Array
								with: (Array with: #score -> (Array with: sfooSymbol with: intSymbol with: #() with: false))
								with: (Array with: #score: -> (Array with: sfooSymbol with: sfooSymbol with: (Array with:intSymbol) with: false))))
		equals:
			(STypeClassInfo
				type:
					sfooSymbol
						->
							(Array
								with: (Array with: #score -> (Array with: sfooSymbol with: intSymbol with: #() with: false))
								with: (Array with: #score: -> (Array with: sfooSymbol with: sfooSymbol with:(Array with: intSymbol) with: false))))
]

{ #category : #tests }
SClassInfoTest >> testFromString [
	| typeClass |
	typeClass := STypeClassInfo
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #returnFloat -> #(#SFoo #SmallFloat64 #() false)
								with: #return: -> #(#SFoo #ByteString #(#ByteString) false))
						with: (Array with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false))).
	self
		assert:
			(STON
				fromString:
					'STypeClassInfo {
						#typeName: #SFoo,
						#methodTypes: {
							#returnFloat: STypeMethodInfo {#selector: #returnFloat, #receiver: SMultiTypeInfo [#SFoo], #returnType: SMultiTypeInfo [#SmallFloat64], #argTypes: [], #isQuick: false}, 
							#''return:'': STypeMethodInfo {#selector: #''return:'', #receiver: SMultiTypeInfo [#SFoo], #returnType: SMultiTypeInfo [#ByteString], #argTypes: [SMultiTypeInfo [#ByteString]], #isQuick: false}}, 
						#classMethodTypes: { 
							#''score:'': STypeMethodInfo {#selector: #''score:'', #receiver: SMultiTypeInfo [#SFoo], #returnType: SMultiTypeInfo [#SFoo], #argTypes: [SMultiTypeInfo [#SmallInteger]], #isQuick: false}
				}}')
		equals: typeClass
]

{ #category : #tests }
SClassInfoTest >> testToString [
	| string |
	string := STON toString: (STypeClassInfo
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #returnFloat -> #(#SFoo #SmallFloat64 #() false)
								with: #return: -> #(#SFoo #ByteString #(#ByteString) false))
						with: (Array with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false)))).
	self
		assert: (STON fromString: string) equals: (STypeClassInfo
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #returnFloat -> #(#SFoo #SmallFloat64 #() false)
								with: #return: -> #(#SFoo #ByteString #(#ByteString) false))
						with: (Array with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false))))
]

{ #category : #tests }
SClassInfoTest >> testType [
	| classInfo methodInfo sfooSymbol floatSymbol stringSymbol collSymbol intSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	floatSymbol := #SmallFloat64 fullClassNameSymbol.
	stringSymbol := #ByteSymbol fullClassNameSymbol.
	collSymbol := #OrderedCollection fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	classInfo := STypeClassInfo
		type:
			sfooSymbol
				->
					(Array
						with:
							(Array
								with:
									#returnFloat -> (Array with: sfooSymbol with: floatSymbol with: #() with: false)
								with: #returnString -> (Array with: sfooSymbol with:stringSymbol with: #() with: false)
								with:
									#return: -> (Array with: sfooSymbol with: collSymbol with: (Array with: collSymbol) with: false)
								with:
									#score: -> (Array with: sfooSymbol with: sfooSymbol with: (Array with: intSymbol) with: false)
								with: #score -> (Array with: sfooSymbol with: intSymbol with: #() with: true))
						with:
							(Array with:
								#score: -> (Array with: sfooSymbol with: sfooSymbol with:(Array with: intSymbol) with: false))).
	classInfo typeMethod: #returnNum -> (Array with: sfooSymbol with: intSymbol with: #() with: false).
	self assert: classInfo methodTypes size equals: 6.
	self assert: classInfo classMethodTypes size equals: 1.
	methodInfo := classInfo methodTypes at: #return:.
	self assert: methodInfo receiver type equals: sfooSymbol.
	self assert: methodInfo returnType type equals: collSymbol.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: collSymbol).
	self
		assert: (classInfo methodTypes at: #returnFloat) returnType type
		equals: floatSymbol.
	self
		assert: (classInfo methodTypes at: #returnString) returnType type
		equals: stringSymbol.
	self
		assert: (classInfo methodTypes at: #score) returnType type
		equals: intSymbol.
	methodInfo := classInfo methodTypes at: #score:.
	self assert: methodInfo receiver type equals: sfooSymbol.
	self assert: methodInfo returnType type equals: sfooSymbol.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: intSymbol).
	self
		assert: (classInfo classMethodTypes at: #score:) returnType type
		equals: sfooSymbol.
	self
		assert: (classInfo methodTypes at: #returnNum) returnType type
		equals: intSymbol
]
