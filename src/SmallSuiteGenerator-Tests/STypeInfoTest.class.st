Class {
	#name : #STypeInfoTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Info'
}

{ #category : #tests }
STypeInfoTest >> testAccesssMessagesFrom [
	| typeInfo sfooSymbol stringSymbol intSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	typeInfo := STypeInfo new
		type:
			sfooSymbol
				->
					(Array
						with:
							(Array
								with: #returnString -> (Array with: sfooSymbol with: stringSymbol with: #() with: false)
								with: #score -> (Array with: sfooSymbol with: intSymbol with: #() with: true))
						with: #()).
	self
		assertCollection: ((typeInfo accessMessagesFrom: sfooSymbol) collect: #selector)
		hasSameElements: #(#score)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSConferenceOnPackagesMatching [
	| typeInfo messages |
	typeInfo := STypeInfo asTypeInfo: (self aSTypeCollectorClass
		profile: [ SConference price: 95 ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	messages := typeInfo messagesFrom: SConference nameAsSymbol.
	self
		assertCollection: (messages collect: #selector)
		hasSameElements: #(#initialize #price: #price).
	self
		assert:
			((messages flatCollect: [ :aMessage | aMessage receiver types ])
				allSatisfy: [ :aType | (aType = SConference nameAsSymbol) or: [ aType = SEvent nameAsSymbol ] ]).
	self assertCollection: ((typeInfo messagesFrom: SEvent nameAsSymbol) collect: #selector)
		hasSameElements: #(#initialize #price: #price).
	self assertCollection: ((typeInfo messagesFrom: SParty nameAsSymbol)  collect: #selector)
		hasSameElements: #(#initialize #price: #price).
	messages := typeInfo factoryMessagesFrom: SConference nameAsSymbol.
	self
		assertCollection: (messages collect: #selector)
		hasSameElements: #(#price:)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSEventOnPackagesMatching [
	| typeInfo messages methodInfo classNameSEvent classNameSConference classNameSParty 	classNameByteString classNameSmallInteger classNameSStudent elementArray |
	classNameSEvent := SEvent nameAsSymbol.
	classNameSConference := SConference nameAsSymbol.
	classNameSParty := SParty nameAsSymbol.
	classNameByteString := ByteString nameAsSymbol.
	classNameSmallInteger := SmallInteger nameAsSymbol.
	classNameSStudent := SStudent nameAsSymbol.
	typeInfo := STypeInfo asTypeInfo: (self aSTypeCollectorClass
		profile: [ | aConference aPerson |
			aConference := SConference new offerPrice: 95.
			aPerson := SStudent new name: 'Mary'.
			aConference canRegister: aPerson ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	self
		assert: (typeInfo types at: classNameSEvent) methodTypes size
		equals: 4.
	self
		assert: (typeInfo types at: classNameSEvent) classMethodTypes isEmpty.
	self
		assert: (typeInfo types at: classNameSConference) methodTypes size
		equals: 5.
	self
		assert: (typeInfo types at: classNameSConference) classMethodTypes isEmpty.
	self assert: ((typeInfo types at: classNameSParty) methodTypes allSatisfy: #isUnary).
	self
		assert: (typeInfo types at: classNameSParty) classMethodTypes isEmpty.
	messages := typeInfo messagesFrom: classNameSConference.
	self
		assertCollection: (messages collect: #selector)
		hasSameElements: #(#initialize #offerPrice: #canRegister: #price).
	self
		assert:
			((messages flatCollect: [ :aMessage | aMessage receiver types ])
				allSatisfy: [ :aType | aType = classNameSConference or: [ aType = classNameSEvent ] ]).
	methodInfo := messages
		detect: [ :aMessage | aMessage selector = #canRegister: ].
	self
		assertCollection: methodInfo returnType types
		hasSameElements: (Array with: False nameAsSymbol).
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: classNameSStudent).
	self
		assertCollection: methodInfo allReceivers
		hasSameElements: (Array with: classNameSConference).
	elementArray := OrderedCollection new
		add: classNameSmallInteger;
		add: 2.3 class nameAsSymbol;
		yourself.
	self
		assertCollection: typeInfo scalars keys
		hasSameElements: elementArray
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSFoo [
	| profile typeInfo methodInfo classNameSFoo classNameOrderedCollection classNameSmallFloat64 classNameByteString classNameSmallInteger classNameDictionary |
	classNameSFoo := SFoo nameAsSymbol.
	classNameOrderedCollection := OrderedCollection nameAsSymbol.
	classNameSmallFloat64 := SmallFloat64 nameAsSymbol.
	classNameByteString := ByteString nameAsSymbol.
	classNameSmallInteger := SmallInteger nameAsSymbol.
	classNameDictionary := Dictionary nameAsSymbol.
	profile := self aSTypeCollectorClass
		profile: [ SFoo new
				return: Dictionary new;
				return: OrderedCollection new;
				returnFloat;
				returnString;
				returnCollection;
				returnNum;
				score;
				score: 5 ]
		forClassNamed: classNameSFoo.
	typeInfo := STypeInfo asTypeInfo: profile.
	self
		assert: (typeInfo types at: classNameSFoo) methodTypes size
		equals: 8.
	self
		assert: (typeInfo types at: classNameSFoo) classMethodTypes size
		equals: 0.
	self
		assert: (typeInfo methodType: #initialize from: classNameSFoo) returnType type
		equals: classNameSFoo.
	methodInfo := typeInfo methodType: #return: from: classNameSFoo.
	self
		assertCollection: methodInfo returnType types
		hasSameElements: (Array with: classNameOrderedCollection with: classNameDictionary).
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: classNameOrderedCollection with: classNameDictionary).
	self
		assert:
			(typeInfo methodType: #returnFloat from: classNameSFoo) returnType
				type
		equals: classNameSmallFloat64.
	self
		assert:
			(typeInfo methodType: #returnCollection from: classNameSFoo)
				returnType type
		equals: classNameOrderedCollection.
	self
		assert:
			(typeInfo methodType: #returnString from: classNameSFoo) returnType
				type
		equals: classNameByteString.
	self
		assert: (typeInfo methodType: #returnNum from: classNameSFoo) returnType type
		equals: classNameSmallInteger.
	methodInfo := typeInfo methodType: #score: from: classNameSFoo.
	self assert: methodInfo returnType type equals: classNameSFoo.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: classNameSmallInteger).
	self assert: (typeInfo factoryMessagesFrom: classNameSFoo) isEmpty.	"the factoryMessage has not been executed"
	self
		assertCollection: typeInfo scalars keys
		hasSameElements:
			(Array
				with: classNameByteString
				with: classNameSmallInteger
				with: classNameSmallFloat64)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSFooOnClass [
	| profile typeInfo methodInfo classNameSFoo |
	classNameSFoo := SFoo  nameAsSymbol.
	profile := self aSTypeCollectorClass
		profile: [ SFoo new return: OrderedCollection ]
		forClassNamed: classNameSFoo.
	typeInfo := STypeInfo asTypeInfo: profile.
	self
		assert: (typeInfo types at: classNameSFoo) methodTypes size
		equals: 7.
	self
		assert: (typeInfo types at: classNameSFoo) classMethodTypes isEmpty.
	self
		assert: (typeInfo methodType: #initialize from: classNameSFoo) returnType type
		equals: classNameSFoo.
	methodInfo := typeInfo methodType: #return: from: classNameSFoo.
	self
		assertCollection: methodInfo returnType types
		hasSameElements: (Array with: OrderedCollection class nameAsSymbol).
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: OrderedCollection class nameAsSymbol).
	self
		assertCollection: ((typeInfo messagesFrom: classNameSFoo) collect: #selector)
		hasSameElements: #(#returnFloat #returnCollection #initialize #returnNum #returnString #return:)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSFooWithNil [
	| profile typeInfo methodInfo classNameSFoo |
	classNameSFoo := SFoo nameAsSymbol.
	profile := self aSTypeCollectorClass
		profile: [ SFoo new return: nil ]
		forClassNamed: classNameSFoo.
	typeInfo := STypeInfo asTypeInfo: profile.
	self
		assert: (typeInfo types at: classNameSFoo) methodTypes size
		equals: 7.
	self
		assert: (typeInfo types at: classNameSFoo) classMethodTypes isEmpty.
	self
		assert: (typeInfo methodType: #initialize from: classNameSFoo) returnType type
		equals: classNameSFoo.
	methodInfo := typeInfo methodType: #return: from: classNameSFoo.
	self
		assertCollection: methodInfo returnType types
		hasSameElements: (Array with: UndefinedObject nameAsSymbol).
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: UndefinedObject nameAsSymbol).
	self
		assertCollection: ((typeInfo messagesFrom: classNameSFoo) collect: #selector)
		hasSameElements: #(#returnFloat #returnCollection #initialize #returnNum #returnString #return:)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSTeacherOnClass [
	| typeInfo classNameSTeacher |
	classNameSTeacher := SSTeacher nameAsSymbol.
	typeInfo := STypeInfo asTypeInfo: (self aSTypeCollectorClass
		profile: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		forClassNamed: classNameSTeacher).
	self
		assertCollection:
			((typeInfo types at: classNameSTeacher) methodTypes values
				collect: #selector)
		hasSameElements: #(#idTeacher #initialize #nickname #yearsWorkExperience).
	self
		assert: (typeInfo types at: classNameSTeacher) classMethodTypes isEmpty.
	self
		assertCollection: ((typeInfo messagesFrom: classNameSTeacher) collect: #selector)
		hasSameElements: #(#initialize #nickname).
	self
		assertCollection: ((typeInfo accessMessagesFrom: classNameSTeacher) collect: #selector)
		hasSameElements: #(#idTeacher #yearsWorkExperience)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSTeacherOnPackagesMatching [
	| typeInfo |
	typeInfo := STypeInfo asTypeInfo: (self aSTypeCollectorClass
		profile: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	self
		assertCollection:
			((typeInfo types at: SSTeacher nameAsSymbol) methodTypes values
				collect: #selector)
		hasSameElements: #(#idTeacher #initialize #nickname #yearsWorkExperience).
	self
		assertCollection:
			((typeInfo factoryMessagesFrom: SSTeacher nameAsSymbol)
				collect: #selector)
		hasSameElements: #(#name:with:).
	self
		assertCollection: ((typeInfo messagesFrom: SSTeacher nameAsSymbol) collect: #selector)
		hasSameElements: #(#initialize #nickname #identifier #fullIdentifier #id: #nickname: #name:).
	self
		assertCollection:
			((typeInfo accessMessagesFrom: SSTeacher nameAsSymbol)
				collect: #selector)
		hasSameElements: #(#idTeacher #yearsWorkExperience #name #id)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoScalars [
	| typeInfo a b |
	typeInfo := STypeInfo asTypeInfo: (self aSTypeCollectorClass
		profile: [ SConference price: 95 ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	self
		assertCollection: (typeInfo scalars values flatCollect: [ :val | 
			(val isKindOf: SConference) 
				ifTrue: [ ^ #SConference ]
				ifFalse: [ ^ val ] ])
		hasSameElements: (Array with: 95 with: 0 with: 100 with: nil with: (SConference price: 95)).
	typeInfo := STypeInfo asTypeInfo: (self aSTypeCollectorClass
		profile: [ SFoo new
				returnCollection;
				returnFloat;
				returnNum;
				returnString ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	self
		assertCollection: typeInfo scalars associations
		hasSameElements:
			(Array
				with: (SUndefinedObject basicNew) class nameAsSymbol -> (OrderedCollection with: nil)
				with: SmallInteger nameAsSymbol -> (OrderedCollection newFrom: #(0 4))
				with: OrderedCollection nameAsSymbol -> (OrderedCollection with: OrderedCollection new)
				with: ByteString nameAsSymbol -> (OrderedCollection newFrom: #('' 'Hello'))
				with: 2.3 class nameAsSymbol -> (OrderedCollection newFrom: #(2.3))
				with: SFoo nameAsSymbol -> (OrderedCollection newFrom: (SFoo new)))
]

{ #category : #tests }
STypeInfoTest >> testClassMethodTypeFrom [
	| typeInfo sfooSymbol|
	sfooSymbol := #SFoo fullClassNameSymbol.
	typeInfo := STypeInfo new
		type: sfooSymbol -> (Array with: #() with: #()).
	self
		should: [ typeInfo classMethodType: #new from: sfooSymbol ]
		raise: SError.
	typeInfo := STypeInfo new
		type:
			sfooSymbol
				->
					(Array
						with: (Array with: #initialize -> (Array with: sfooSymbol with: sfooSymbol with: #() with: false))
						with: #()).
	self
		shouldnt: [ typeInfo classMethodType: #new from: sfooSymbol ]
		raise: SError
]

{ #category : #tests }
STypeInfoTest >> testEquals [
	| sfooSymbol studentSymbol stringSymbol intSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	studentSymbol := #SStudent fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	self
		assert: (STypeInfo new type: sfooSymbol -> #(#() #()))
		equals: (STypeInfo new type: sfooSymbol -> #(#() #())).
	self
		assert:
			(STypeInfo new
				type:
					studentSymbol
						->
							(Array
								with: (Array with: #name -> (Array with: studentSymbol with: stringSymbol with: #() with: false))
								with: #());
				scalar: stringSymbol with: #('Abi'))
		equals:
			(STypeInfo new
				type:
					studentSymbol
						->
							(Array
								with: (Array with: #name -> (Array with: studentSymbol with: stringSymbol with: #() with: false))
								with: #());
				scalar: stringSymbol with: #('Abi')).
	self
		assert:
			(STypeInfo new
				type:
					sfooSymbol
						->
							(Array
								with: (Array with: #return: -> (Array with: sfooSymbol with: studentSymbol with: (Array with: studentSymbol) with: false))
								with: (Array with: #score: -> (Array with: sfooSymbol with: sfooSymbol with: (Array with: intSymbol) with: false)));
				scalar: intSymbol with: #(1 3 4);
				scalar: studentSymbol with: (Array with: (SStudent name: 'Nilson')))
		equals:
			(STypeInfo new
				type:
					sfooSymbol
						->
							(Array
								with: (Array with: #return: -> (Array with: sfooSymbol with: studentSymbol with: (Array with: studentSymbol) with: false))
								with: (Array with: #score: -> (Array with: sfooSymbol with: sfooSymbol with: (Array with: intSymbol) with: false)));
				scalar: intSymbol with: #(1 3 4);
				scalar: studentSymbol with: (Array with: (SStudent name: 'Nilson')))
]

{ #category : #tests }
STypeInfoTest >> testFactoryMessages [
	| typeInfo classNameStudent studentSymbol confSymbol |
	classNameStudent := SStudent nameAsSymbol.
	studentSymbol :=#SStudent fullClassNameSymbol.
	confSymbol := #SConference fullClassNameSymbol.
	typeInfo := STypeInfo asTypeInfo: (self aSTypeCollectorClass
		profile: [ SStudent name: 'Mary' ]
		forClassNamed: classNameStudent).
	self assert: (typeInfo factoryMessagesFrom: studentSymbol) isEmpty.
	typeInfo := STypeInfo asTypeInfo: (self aSTypeCollectorClass
		profile: [ SStudent name: 'Mary' ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	self
		assertCollection: ((typeInfo factoryMessagesFrom: studentSymbol) collect: #selector)
		hasSameElements: #(#name:).
	typeInfo := STypeInfo asTypeInfo: (self aSTypeCollectorClass
		profile: [ SConference price: 95 ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	self
		assertCollection: ((typeInfo factoryMessagesFrom: confSymbol) collect: #selector)
		hasSameElements: #(#price:)
]

{ #category : #tests }
STypeInfoTest >> testFactoryMessagesFrom [
	"self halt"
]

{ #category : #tests }
STypeInfoTest >> testFromString [
	| typeInfo |
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #returnFloat -> #(#SFoo #SmallFloat64 #() false)
								with: #return: -> #(#SFoo #ByteString #(#ByteString) false))
						with: (Array with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false)));
		scalar: #SmallFloat64 with: #(2.3 4.6);
		scalar: #ByteString with: #('hello' 'Abi').
	self
		assert:
			(STON
				fromString:
					'STypeInfo {
						#types: { 
							#SFoo: STypeClassInfo { 
							#typeName: #SFoo,
							#methodTypes: {
								#returnFloat: STypeMethodInfo {#selector: #returnFloat, #receiver: SMultiTypeInfo [#SFoo], #returnType: SMultiTypeInfo [#SmallFloat64], #argTypes: [], #isQuick: false}, 
								#''return:'': STypeMethodInfo {#selector: #''return:'', #receiver: SMultiTypeInfo [#SFoo], #returnType: SMultiTypeInfo [#ByteString], #argTypes: [SMultiTypeInfo [#ByteString]], #isQuick: false}}, 
							#classMethodTypes: { 
								#''score:'': STypeMethodInfo {#selector: #''score:'', #receiver: SMultiTypeInfo [#SFoo], #returnType: SMultiTypeInfo [#SFoo], #argTypes: [SMultiTypeInfo [#SmallInteger]], #isQuick: false}
							}}
						},
					#scalars: {
						#SmallFloat64: [ 2.3, 4.6 ],
						#ByteString: [ ''hello'', ''Abi'' ]
					}}')
		equals: typeInfo
]

{ #category : #tests }
STypeInfoTest >> testIsAbstracClass [
	| typeInfo personSymbol stringSymbol intSymbol |
	personSymbol := #SSPerson fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	typeInfo := STypeInfo new
		type:
			personSymbol
				->
					(Array
						with:
							(Array
								with: #name -> (Array with: personSymbol
									with: stringSymbol
									with: #()
									with: true)
								with: #id ->  (Array with: personSymbol
									with: intSymbol
									with: #()
									with: false))
						with:
							(Array
								with:
									#name:with:
										->  (Array with: personSymbol
									with: personSymbol
									with: (Array with: stringSymbol with: intSymbol)
									with: false)));
		scalar: intSymbol with: #(50);
		scalar: stringSymbol with: #('Ann').
	self assert: (typeInfo isAbstractClass: personSymbol )
]

{ #category : #tests }
STypeInfoTest >> testJoinWith [
	| typeInfo methodInfo otherTypeInfo sfooSymbol collSymbol intSymbol stringSymbol floatSymbol stackSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol. 
	collSymbol := #OrderedCollection fullClassNameSymbol. 
	intSymbol := #SmallInteger fullClassNameSymbol. 
	stringSymbol := #ByteString fullClassNameSymbol.
	floatSymbol := #SmallFloat64 fullClassNameSymbol.
	stackSymbol := #SStack fullClassNameSymbol.
	typeInfo := STypeInfo new
		type:
			sfooSymbol
				->
					(Array
						with:
							(Array
								with: #return: -> (Array with: sfooSymbol with: collSymbol with: (Array with: collSymbol) with: false)
								with: #score: -> (Array with: sfooSymbol with: sfooSymbol with: (Array with: intSymbol) with: false)
								with: #score -> (Array with: sfooSymbol with: intSymbol with: #() with: false))
						with: (Array with: #score: -> (Array with: sfooSymbol with: sfooSymbol with: (Array with: intSymbol) with: false))).
	otherTypeInfo := STypeInfo new
		type:
			sfooSymbol
				->
					(Array
						with:
							(Array
								with: #returnFloat -> (Array with: sfooSymbol with: floatSymbol with: #() with: false)
								with: #returnString -> (Array with: sfooSymbol  with: stringSymbol with: #() with: false)
								with: #return: -> (Array with: sfooSymbol with: stackSymbol with: (Array with: stackSymbol) with: false))
						with: #()).
	typeInfo joinWith: otherTypeInfo.
	self assert: (typeInfo types at: sfooSymbol) methodTypes size equals: 5.
	self
		assert: (typeInfo types at: sfooSymbol) classMethodTypes size
		equals: 1.
	methodInfo := typeInfo methodType: #return: from: sfooSymbol.
	self assert: methodInfo receiver type equals: sfooSymbol.
	self
		assertCollection: (Array with: collSymbol with: stackSymbol )
		hasSameElements: methodInfo returnType types.
	self
		assertCollection: (Array with: collSymbol with: stackSymbol)
		hasSameElements: (methodInfo argTypes flatCollect: [ :argType | argType types ]).
	self
		assert: (typeInfo methodType: #returnFloat from: sfooSymbol) returnType type
		equals: floatSymbol.
	self
		assert: (typeInfo methodType: #returnString from: sfooSymbol) returnType type
		equals: stringSymbol.
	self
		assert: (typeInfo methodType: #score from: sfooSymbol) returnType type
		equals: intSymbol.
	methodInfo := typeInfo methodType: #score: from: sfooSymbol.
	self assert: methodInfo receiver type equals: sfooSymbol.
	self assert: methodInfo returnType type equals: sfooSymbol.
	self
		assertCollection: (methodInfo argTypes flatCollect: [ :argType | argType types ])
		hasSameElements: (Array with: intSymbol).
	self
		assert: (typeInfo classMethodType: #score: from: sfooSymbol) returnType type
		equals: sfooSymbol
]

{ #category : #tests }
STypeInfoTest >> testMessagesFrom [
	| typeInfo sfooSymbol  intSymbol stringSymbol floatSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol. 
	stringSymbol := #ByteString fullClassNameSymbol.
	floatSymbol := #SmallFloat64 fullClassNameSymbol.
	typeInfo := STypeInfo new
		type:
			sfooSymbol
				->
					(Array
						with:
							(Array
								with: #returnFloat -> (Array with: sfooSymbol with: floatSymbol with:#() with:false)
								with: #returnString ->(Array with: sfooSymbol with: stringSymbol with: #() with: false)
								with: #score -> (Array with: sfooSymbol with: intSymbol with: #() with: true))
						with: (Array with: #score: -> (Array with: sfooSymbol with: sfooSymbol with: (Array with: intSymbol) with: false))).
	self
		assertCollection: ((typeInfo messagesFrom: sfooSymbol) collect: #selector)
		hasSameElements: #(#returnFloat #returnString)
	"self assertCollection: ((typeInfo accessMessagesFrom: #SFoo) collect: #selector) hasSameElements: #(#score)."
]

{ #category : #tests }
STypeInfoTest >> testNoneAbstractClasses [
	| typeInfo personSymbol studentSymbol intSymbol stringSymbol abstractSymbol |
	personSymbol := #SSPerson fullClassNameSymbol. 
	studentSymbol := #SStudent fullClassNameSymbol. 
	intSymbol := #SmallInteger fullClassNameSymbol. 
	stringSymbol := #ByteString fullClassNameSymbol.
	abstractSymbol := #SAbstractClass fullClassNameSymbol.
	typeInfo := STypeInfo new
		type:
			personSymbol
				->
					(Array
						with:
							(Array
								with: #name -> (Array with: personSymbol 
													with: stringSymbol
													with: #()
													with: true)
								with: #id -> (Array with: personSymbol
													with: intSymbol
													with: #()
													with: false))
						with:
							(Array
								with:
									#name:with:
										-> (Array with: personSymbol 
													with: personSymbol
													with: (Array with: stringSymbol with: intSymbol )
													with: false)));
		type:
			abstractSymbol
				->
					(Array
						with: (Array with: #id ->  (Array with: abstractSymbol  
													with: intSymbol
													with: #()
													with: true))
						with: #());
		type:
			studentSymbol
				->
					(Array
						with: (Array with: #scoreStudent ->  (Array with: studentSymbol 
													with: intSymbol
													with: #()
													with: true))
						with: #());
		scalar: intSymbol with: #(50 1);
		scalar: stringSymbol with: #('Ann').
	self
		assertCollection: (typeInfo noneAbstractClasses collect: #nameAsSymbol) asArray
		hasSameElements:( Array with: studentSymbol)
]

{ #category : #tests }
STypeInfoTest >> testScalar [
	| typeInfo |
	typeInfo := STypeInfo new
		scalar: #SmallInteger with: #(1 5 6);
		scalar: #ByteString with: #('hello' 'world');
		scalar: #Dictionary
			with:
			(Array
				with: Dictionary new
				with:
					(Dictionary new
						at: 2 put: 3;
						yourself)).
	self
		assertCollection: typeInfo scalars keys
		hasSameElements: #(#Dictionary #ByteString #SmallInteger).
	self
		assertCollection: (typeInfo scalars at: #ByteString)
		hasSameElements: #('hello' 'world').
	self
		assertCollection: (typeInfo scalars at: #SmallInteger)
		hasSameElements: #(1 5 6).
	self
		assertCollection: ((typeInfo scalars at: #Dictionary) collect: #className)
		hasSameElements: #('Dictionary' 'Dictionary')
]

{ #category : #tests }
STypeInfoTest >> testToString [
	| string typeInfo sfooSymbol intSymbol floatSymbol stringSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol. 
	floatSymbol := #SmallFloat64 fullClassNameSymbol. 
	stringSymbol := #ByteString fullClassNameSymbol.
	typeInfo := STypeInfo new
		type:
			sfooSymbol
				->
					(Array
						with:
							(Array
								with: #returnFloat -> (Array with: sfooSymbol with: floatSymbol with: #() with: false)
								with: #return: -> (Array with: sfooSymbol with: stringSymbol with: (Array with: stringSymbol) with: false))
						with: (Array with: #score: -> (Array with: sfooSymbol with: sfooSymbol with: (Array with: intSymbol) with: false)));
		scalar: floatSymbol with: #(2.3 4.6);
		scalar: stringSymbol with: #('hello' 'Abi').
	string := STON toString: typeInfo.
	self assert: (STON fromString: string) equals: typeInfo
]

{ #category : #tests }
STypeInfoTest >> testToStringComplexScalar [
	| string typeInfo sfooSymbol stringSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	typeInfo := STypeInfo new
		type:
			sfooSymbol
				->
					(Array
						with: (Array with: #return: -> (Array with: sfooSymbol with: stringSymbol with: (Array with: stringSymbol) with: false))
						with: #());
		scalar: #SStudent fullClassNameSymbol with: (Array with: (SStudent name: 'Abi')).
	string := STON toString: typeInfo.
	self assert: (STON fromString: string) equals: typeInfo
]

{ #category : #tests }
STypeInfoTest >> testType [
	| typeInfo methodInfo sfooSymbol collSymbol intSymbol stringSymbol floatSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	collSymbol := #OrderedCollection fullClassNameSymbol. 
	intSymbol := #SmallInteger fullClassNameSymbol. 
	stringSymbol := #ByteString fullClassNameSymbol.
	floatSymbol := #SmallFloat64 fullClassNameSymbol.
	typeInfo := STypeInfo new
		type:
			sfooSymbol
				->
					(Array
						with:
							(Array
								with: #returnFloat -> (Array with: sfooSymbol with: floatSymbol with: #() with: false)
								with: #returnString -> (Array with: sfooSymbol with: stringSymbol with: #() with: false)
								with: #return: -> (Array with: sfooSymbol with: collSymbol with: (Array with: collSymbol) with: false)
								with: #score: -> (Array with: sfooSymbol with: sfooSymbol with: (Array with: intSymbol) with: false)
								with: #score -> (Array with: sfooSymbol with: intSymbol with: #() with: false))
						with: (Array with: #score: -> (Array with: sfooSymbol with: sfooSymbol with: (Array with: intSymbol) with: false))).
	self assert: (typeInfo types at: sfooSymbol) methodTypes size equals: 5.
	self
		assert: (typeInfo types at: sfooSymbol) classMethodTypes size
		equals: 1.
	methodInfo := typeInfo methodType: #return: from: sfooSymbol.
	self assert: methodInfo receiver type equals: sfooSymbol.
	self assert: methodInfo returnType type equals: collSymbol.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: collSymbol).
	self
		assert: (typeInfo methodType: #returnFloat from: sfooSymbol) returnType type
		equals: floatSymbol.
	self
		assert: (typeInfo methodType: #returnString from: sfooSymbol) returnType type
		equals: stringSymbol.
	self
		assert: (typeInfo methodType: #score from: sfooSymbol) returnType type
		equals: intSymbol .
	methodInfo := typeInfo methodType: #score: from: sfooSymbol.
	self assert: methodInfo receiver type equals: sfooSymbol.
	self assert: methodInfo returnType type equals: sfooSymbol.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: intSymbol).
	self
		assert: (typeInfo classMethodType: #score: from: sfooSymbol) returnType type
		equals: sfooSymbol
]
