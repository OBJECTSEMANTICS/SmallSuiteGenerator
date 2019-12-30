Class {
	#name : #STypeInfoTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Info'
}

{ #category : #tests }
STypeInfoTest >> nameOf: aClass [
	^ aClass name
]

{ #category : #tests }
STypeInfoTest >> testAccesssMessagesFrom [
	| typeInfo |
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #returnString -> #(#SFoo #ByteString #() false)
								with: #score -> #(#SFoo #SmallInteger #() true))
						with: #()).
	self
		assertCollection: ((typeInfo accessMessagesFrom: #SFoo) collect: #selector)
		hasSameElements: #(#score)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSConferenceOnPackagesMatching [
	| typeInfo messages |
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
		profile: [ SConference price: 95 ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	messages := typeInfo messagesFrom: (self nameOf: SConference).
	self
		assertCollection: (messages collect: #selector)
		hasSameElements: #(#initialize #price:).
	self
		assert:
			((messages flatCollect: [ :aMessage | aMessage receiver types ])
				allSatisfy: [ :aType | aType = (self nameOf: SConference) ]).
	self assert: (typeInfo messagesFrom: (self nameOf: SEvent)) isEmpty.
	self assert: (typeInfo messagesFrom: (self nameOf: SParty)) isEmpty.
	messages := typeInfo factoryMessagesFrom: (self nameOf:  SConference).
	self
		assertCollection: (messages collect: #selector)
		hasSameElements: #(#price:)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSEventOnPackagesMatching [
	| typeInfo messages methodInfo classNameSEvent classNameSConference classNameSParty classNameByteString classNameSmallInteger classNameSStudent |
	classNameSEvent := self nameOf: SEvent.
	classNameSConference := self nameOf: SConference.
	classNameSParty := self nameOf: SParty.
	classNameByteString := self nameOf: ByteString.
	classNameSmallInteger := self nameOf: SmallInteger.
	classNameSStudent := self nameOf: SStudent.
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
		profile: [ | aConference aPerson |
			aConference := SConference new offerPrice: 95.
			aPerson := SStudent new name: 'Mary'.
			aConference canRegister: aPerson ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	self
		assert: (typeInfo types at: classNameSEvent) methodTypes size
		equals: 2.
	self
		assert: (typeInfo types at: classNameSEvent) classMethodTypes isEmpty.
	self
		assert: (typeInfo types at: classNameSConference) methodTypes size
		equals: 3.
	self
		assert: (typeInfo types at: classNameSConference) classMethodTypes isEmpty.
	self assert: (typeInfo types at: classNameSParty) methodTypes isEmpty.
	self
		assert: (typeInfo types at: classNameSParty) classMethodTypes isEmpty.
	messages := typeInfo messagesFrom: classNameSConference.
	self
		assertCollection: (messages collect: #selector)
		hasSameElements: #(#initialize #offerPrice: #canRegister: #price).
	self
		assert:
			((messages flatCollect: [ :aMessage | aMessage receiver types ])
				allSatisfy: [ :aType | aType = classNameSConference ]).
	methodInfo := messages
		detect: [ :aMessage | aMessage selector = #canRegister: ].
	self
		assertCollection: methodInfo returnType types
		hasSameElements: (Array with: (self nameOf: False)).
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: classNameSStudent).
	self
		assertCollection: methodInfo allReceivers
		hasSameElements: (Array with: classNameSConference).
	self
		assertCollection: typeInfo scalars keys
		hasSameElements:
			(Array
				with: classNameSStudent
				with: classNameSmallInteger
				with: (self nameOf: False)
				with: classNameByteString
				with: (self nameOf: 2.3 class))
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSFoo [
	| profile typeInfo methodInfo classNameSFoo classNameOrderedCollection classNameSmallFloat64 classNameByteString classNameSmallInteger classNameDictionary |
	classNameSFoo := self nameOf: SFoo.
	classNameOrderedCollection := self nameOf: OrderedCollection.
	classNameSmallFloat64 := self nameOf: SmallFloat64.
	classNameByteString := self nameOf: ByteString.
	classNameSmallInteger := self nameOf: SmallInteger.
	classNameDictionary := self nameOf: Dictionary.
	profile := SSTypeCollector
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
	self
		assert: (typeInfo methodType: #score from: classNameSFoo) returnType type
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
				with: classNameOrderedCollection
				with: classNameDictionary
				with: classNameByteString
				with: classNameSmallInteger
				with: classNameSmallFloat64)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSFooOnClass [
	| profile typeInfo methodInfo classNameSFoo |
	classNameSFoo := self nameOf: SFoo.
	profile := SSTypeCollector
		profile: [ SFoo new return: OrderedCollection ]
		forClassNamed: classNameSFoo.
	typeInfo := STypeInfo asTypeInfo: profile.
	self
		assert: (typeInfo types at: classNameSFoo) methodTypes size
		equals: 2.
	self
		assert: (typeInfo types at: classNameSFoo) classMethodTypes isEmpty.
	self
		assert: (typeInfo methodType: #initialize from: classNameSFoo) returnType type
		equals: classNameSFoo.
	methodInfo := typeInfo methodType: #return: from: classNameSFoo.
	self
		assertCollection: methodInfo returnType types
		hasSameElements: (Array with: (self nameOf: OrderedCollection class)).
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: (self nameOf: OrderedCollection class)).
	self
		assertCollection: ((typeInfo messagesFrom: classNameSFoo) collect: #selector)
		hasSameElements: #(#initialize #return:)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSFooWithNil [
	| profile typeInfo methodInfo classNameSFoo |
	classNameSFoo := self nameOf: SFoo.
	profile := SSTypeCollector
		profile: [ SFoo new return: nil ]
		forClassNamed: classNameSFoo.
	typeInfo := STypeInfo asTypeInfo: profile.
	self
		assert: (typeInfo types at: classNameSFoo) methodTypes size
		equals: 2.
	self
		assert: (typeInfo types at: classNameSFoo) classMethodTypes isEmpty.
	self
		assert: (typeInfo methodType: #initialize from: classNameSFoo) returnType type
		equals: classNameSFoo.
	methodInfo := typeInfo methodType: #return: from: classNameSFoo.
	self
		assertCollection: methodInfo returnType types
		hasSameElements: (Array with: (self nameOf: UndefinedObject)).
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: (self nameOf: UndefinedObject)).
	self
		assertCollection: ((typeInfo messagesFrom: classNameSFoo) collect: #selector)
		hasSameElements: #(#initialize #return:)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSTeacherOnClass [
	| typeInfo classNameSTeacher |
	classNameSTeacher := self nameOf: SSTeacher.
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
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
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
		profile: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	self
		assertCollection:
			((typeInfo types at: (self nameOf: SSTeacher)) methodTypes values
				collect: #selector)
		hasSameElements: #(#idTeacher #initialize #nickname #yearsWorkExperience).
	self
		assertCollection:
			((typeInfo factoryMessagesFrom: (self nameOf: SSTeacher))
				collect: #selector)
		hasSameElements: #(#name:with:).
	self
		assertCollection: ((typeInfo messagesFrom: (self nameOf: SSTeacher)) collect: #selector)
		hasSameElements: #(#initialize #nickname #id: #nickname: #name:).
	self
		assertCollection:
			((typeInfo accessMessagesFrom: (self nameOf: SSTeacher))
				collect: #selector)
		hasSameElements: #(#idTeacher #yearsWorkExperience #name #id)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoScalars [
	| typeInfo |
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
		profile: [ SConference price: 95 ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	self
		assertCollection: (typeInfo scalars values flatCollect: [ :val | val ])
		hasSameElements: #(95 0 100).
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
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
				with: (self nameOf: SmallInteger) -> #(0 4)
				with: (self nameOf: OrderedCollection) -> (Array with: OrderedCollection new)
				with: (self nameOf: ByteString) -> #('Hello')
				with: (self nameOf: 2.3 class) -> #(2.3))
]

{ #category : #tests }
STypeInfoTest >> testClassMethodTypeFrom [
	| typeInfo |
	typeInfo := STypeInfo new
		type: #SFoo -> (Array with: #() with: #()).
	self
		should: [ typeInfo classMethodType: #new from: #SFoo ]
		raise: SError.
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with: (Array with: #initialize -> #(#SFoo #SFoo #() false))
						with: #()).
	self
		shouldnt: [ typeInfo classMethodType: #new from: #SFoo ]
		raise: SError
]

{ #category : #tests }
STypeInfoTest >> testEquals [
	self
		assert: (STypeInfo new type: #SFoo -> #(#() #()))
		equals: (STypeInfo new type: #SFoo -> #(#() #())).
	self
		assert:
			(STypeInfo new
				type:
					#SStudent
						->
							(Array
								with: (Array with: #name -> #(#SStudent #ByteString #() false))
								with: #());
				scalar: #ByteString with: #('Abi'))
		equals:
			(STypeInfo new
				type:
					#SStudent
						->
							(Array
								with: (Array with: #name -> #(#SStudent #ByteString #() false))
								with: #());
				scalar: #ByteString with: #('Abi')).
	self
		assert:
			(STypeInfo new
				type:
					#SFoo
						->
							(Array
								with: (Array with: #return: -> #(#SFoo #SStudent #(#SStudent) false))
								with: (Array with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false)));
				scalar: #SmallInteger with: #(1 3 4);
				scalar: #SStudent with: (Array with: (SStudent name: 'Nilson')))
		equals:
			(STypeInfo new
				type:
					#SFoo
						->
							(Array
								with: (Array with: #return: -> #(#SFoo #SStudent #(#SStudent) false))
								with: (Array with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false)));
				scalar: #SmallInteger with: #(1 3 4);
				scalar: #SStudent with: (Array with: (SStudent name: 'Nilson')))
]

{ #category : #tests }
STypeInfoTest >> testFactoryMessages [
	| typeInfo classNameStudent |
	classNameStudent := self nameOf: SStudent.
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
		profile: [ SStudent name: 'Mary' ]
		forClassNamed: classNameStudent).
	self assert: (typeInfo factoryMessagesFrom: #SStudent) isEmpty.
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
		profile: [ SStudent name: 'Mary' ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	self
		assertCollection: ((typeInfo factoryMessagesFrom: #SStudent) collect: #selector)
		hasSameElements: #(#name:).
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
		profile: [ SConference price: 95 ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	self
		assertCollection: ((typeInfo factoryMessagesFrom: #SConference) collect: #selector)
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
	| typeInfo |
	typeInfo := STypeInfo new
		type:
			#SSPerson
				->
					(Array
						with:
							(Array
								with: #name -> #(#SSPerson #ByteString #() true)
								with: #id -> #(#SSPerson #SmallInteger #() false))
						with:
							(Array
								with:
									#name:with:
										-> #(#SSPerson #SSPerson #(#ByteString #SmallInteger) false)));
		scalar: #SmallInteger with: #(50);
		scalar: #ByteString with: #('Ann').
	self assert: (typeInfo isAbstractClass: #SSPerson)
]

{ #category : #tests }
STypeInfoTest >> testJoinWith [
	| typeInfo methodInfo otherTypeInfo |
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #return: -> #(#SFoo #OrderedCollection #(#OrderedCollection) false)
								with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false)
								with: #score -> #(#SFoo #SmallInteger #() true))
						with: (Array with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false))).
	otherTypeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #returnFloat -> #(#SFoo #SmallFloat64 #() false)
								with: #returnString -> #(#SFoo #ByteString #() false)
								with: #return: -> #(#SFoo #Stack #(#Stack) false))
						with: #()).
	typeInfo joinWith: otherTypeInfo.
	self assert: (typeInfo types at: #SFoo) methodTypes size equals: 5.
	self
		assert: (typeInfo types at: #SFoo) classMethodTypes size
		equals: 1.
	methodInfo := typeInfo methodType: #return: from: #SFoo.
	self assert: methodInfo receiver type equals: #SFoo.
	self
		assertCollection: #(#OrderedCollection #Stack)
		hasSameElements: methodInfo returnType types.
	self
		assertCollection: #(#OrderedCollection #Stack)
		hasSameElements: (methodInfo argTypes flatCollect: [ :argType | argType types ]).
	self
		assert: (typeInfo methodType: #returnFloat from: #SFoo) returnType type
		equals: #SmallFloat64.
	self
		assert: (typeInfo methodType: #returnString from: #SFoo) returnType type
		equals: #ByteString.
	self
		assert: (typeInfo methodType: #score from: #SFoo) returnType type
		equals: #SmallInteger.
	methodInfo := typeInfo methodType: #score: from: #SFoo.
	self assert: methodInfo receiver type equals: #SFoo.
	self assert: methodInfo returnType type equals: #SFoo.
	self
		assertCollection: (methodInfo argTypes flatCollect: [ :argType | argType types ])
		hasSameElements: #(#SmallInteger).
	self
		assert: (typeInfo classMethodType: #score: from: #SFoo) returnType type
		equals: #SFoo
]

{ #category : #tests }
STypeInfoTest >> testMessagesFrom [
	| typeInfo |
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #returnFloat -> #(#SFoo #SmallFloat64 #() false)
								with: #returnString -> #(#SFoo #ByteString #() false)
								with: #score -> #(#SFoo #SmallInteger #() true))
						with: (Array with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false))).
	self
		assertCollection: ((typeInfo messagesFrom: #SFoo) collect: #selector)
		hasSameElements: #(#returnFloat #returnString)
	"self assertCollection: ((typeInfo accessMessagesFrom: #SFoo) collect: #selector) hasSameElements: #(#score)."
]

{ #category : #tests }
STypeInfoTest >> testNoneAbstractClasses [
	| typeInfo |
	typeInfo := STypeInfo new
		type:
			#SSPerson
				->
					(Array
						with:
							(Array
								with: #name -> #(#SSPerson #ByteString #() true)
								with: #id -> #(#SSPerson #SmallInteger #() false))
						with:
							(Array
								with:
									#name:with:
										-> #(#SSPerson #SSPerson #(#ByteString #SmallInteger) false)));
		type:
			#SAbstractClass
				->
					(Array
						with: (Array with: #id -> #(#SAbstractClass #SmallInteger #() true))
						with: #());
		type:
			#SStudent
				->
					(Array
						with: (Array with: #scoreStudent -> #(#SStudent #SmallInteger #() true))
						with: #());
		scalar: #SmallInteger with: #(50 1);
		scalar: #ByteString with: #('Ann').
	self
		assertCollection: (typeInfo noneAbstractClasses collect: #name)
		hasSameElements: #(#SStudent)
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
	| string typeInfo |
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
	string := STON toString: typeInfo.
	self assert: (STON fromString: string) equals: typeInfo
]

{ #category : #tests }
STypeInfoTest >> testToStringComplexScalar [
	| string typeInfo |
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with: (Array with: #return: -> #(#SFoo #ByteString #(#ByteString) false))
						with: #());
		scalar: #SStudent with: (Array with: (SStudent name: 'Abi')).
	string := STON toString: typeInfo.
	self assert: (STON fromString: string) equals: typeInfo
]

{ #category : #tests }
STypeInfoTest >> testType [
	| typeInfo methodInfo |
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #returnFloat -> #(#SFoo #SmallFloat64 #() false)
								with: #returnString -> #(#SFoo #ByteString #() false)
								with: #return: -> #(#SFoo #OrderedCollection #(#OrderedCollection) false)
								with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false)
								with: #score -> #(#SFoo #SmallInteger #() true))
						with: (Array with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false))).
	self assert: (typeInfo types at: #SFoo) methodTypes size equals: 5.
	self
		assert: (typeInfo types at: #SFoo) classMethodTypes size
		equals: 1.
	methodInfo := typeInfo methodType: #return: from: #SFoo.
	self assert: methodInfo receiver type equals: #SFoo.
	self assert: methodInfo returnType type equals: #OrderedCollection.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: #(#OrderedCollection).
	self
		assert: (typeInfo methodType: #returnFloat from: #SFoo) returnType type
		equals: #SmallFloat64.
	self
		assert: (typeInfo methodType: #returnString from: #SFoo) returnType type
		equals: #ByteString.
	self
		assert: (typeInfo methodType: #score from: #SFoo) returnType type
		equals: #SmallInteger.
	methodInfo := typeInfo methodType: #score: from: #SFoo.
	self assert: methodInfo receiver type equals: #SFoo.
	self assert: methodInfo returnType type equals: #SFoo.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: #(#SmallInteger).
	self
		assert: (typeInfo classMethodType: #score: from: #SFoo) returnType type
		equals: #SFoo
]
