Class {
	#name : #SClassInfoTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Info'
}

{ #category : #tests }
SClassInfoTest >> testEquals [
	self
		assert: (STypeClassInfo type: #SFoo -> #(#() #()))
		equals: (STypeClassInfo type: #SFoo -> #(#() #())).
	self
		assert:
			(STypeClassInfo
				type:
					#SStudent
						->
							(Array
								with: (Array with: #name -> #(#SStudent #ByteString #() false))
								with: #()))
		equals:
			(STypeClassInfo
				type:
					#SStudent
						->
							(Array
								with: (Array with: #name -> #(#SStudent #ByteString #() false))
								with: #())).
	self
		assert:
			(STypeClassInfo
				type:
					#SFoo
						->
							(Array
								with: (Array with: #score -> #(#SFoo #SmallInteger #() false))
								with: (Array with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false))))
		equals:
			(STypeClassInfo
				type:
					#SFoo
						->
							(Array
								with: (Array with: #score -> #(#SFoo #SmallInteger #() false))
								with: (Array with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false))))
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
