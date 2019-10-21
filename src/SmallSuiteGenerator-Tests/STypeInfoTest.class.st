Class {
	#name : #STypeInfoTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Info'
}

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
	
	self assertCollection: ((typeInfo accessMessagesFrom: #SFoo) collect: #selector) hasSameElements: #(#score).
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSConferenceOnPackagesMatching [
	| typeInfo messages |
	typeInfo := (SSGenerator
		profile: [ SConference price: 95 ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario') asTypeInfo.
	messages := typeInfo messagesFrom: #SConference.
	self
		assertCollection: (messages collect: #selector)
		hasSameElements: #(#initialize #price:).
	self
		assert:
			((messages flatCollect: [ :aMessage | aMessage receiver types ])
				allSatisfy: [ :aType | aType = #SConference ]).
	self assert: (typeInfo messagesFrom: #SEvent) isEmpty.
	self assert: (typeInfo messagesFrom: #SParty) isEmpty.
	messages := typeInfo factoryMessagesFrom: #SConference.
	self
		assertCollection: (messages collect: #selector)
		hasSameElements: #(#price:)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSEventOnPackagesMatching [
	| typeInfo messages methodInfo |
	typeInfo := (SSGenerator
		profile: [ | aConference aPerson |
			aConference := SConference new offerPrice: 95.
			aPerson := SStudent new name: 'Mary'.
			aConference canRegister: aPerson ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario') asTypeInfo.
	self assert: (typeInfo types at: #SEvent) methodTypes size equals: 2.
	self assert: (typeInfo types at: #SEvent) classMethodTypes isEmpty.
	self
		assert: (typeInfo types at: #SConference) methodTypes size
		equals: 3.
	self
		assert: (typeInfo types at: #SConference) classMethodTypes isEmpty.
	self assert: (typeInfo types at: #SParty) methodTypes isEmpty.
	self assert: (typeInfo types at: #SParty) classMethodTypes isEmpty.
	messages := typeInfo messagesFrom: #SConference.
	self
		assertCollection: (messages collect: #selector)
		hasSameElements: #(#initialize #offerPrice: #canRegister: #price).
	self
		assert:
			((messages flatCollect: [ :aMessage | aMessage receiver types ])
				allSatisfy: [ :aType | aType = #SConference ]).
	methodInfo := messages
		detect: [ :aMessage | aMessage selector = #canRegister: ].
	self
		assertCollection: methodInfo returnType types
		hasSameElements: (Array with: #False).
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: #SStudent).
	self
		assertCollection: methodInfo allReceivers
		hasSameElements: (Array with: #SConference).
	self
		assertCollection: typeInfo scalars keys
		hasSameElements: #(#SStudent #SmallInteger #False #ByteString)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSFoo [
	| profile typeInfo methodInfo |
	profile := SSGenerator
		profile: [ SFoo new
				return: Stack new;
				return: OrderedCollection new;
				returnFloat;
				returnString;
				returnCollection;
				returnNum;
				score;
				score: 5 ]
		onClass: SFoo.
	typeInfo := profile asTypeInfo.
	self assert: (typeInfo types at: #SFoo) methodTypes size equals: 8.
	self
		assert: (typeInfo types at: #SFoo) classMethodTypes size
		equals: 0.
	self
		assert: (typeInfo type: #initialize from: #SFoo) returnType type
		equals: #SFoo.
	methodInfo := typeInfo type: #return: from: #SFoo.
	self
		assertCollection: methodInfo returnType types
		hasSameElements: {#OrderedCollection . #Stack}.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: {#OrderedCollection . #Stack}.
	self
		assert: (typeInfo type: #returnFloat from: #SFoo) returnType type
		equals: #SmallFloat64.
	self
		assert: (typeInfo type: #returnCollection from: #SFoo) returnType type
		equals: #OrderedCollection.
	self
		assert: (typeInfo type: #returnString from: #SFoo) returnType type
		equals: #ByteString.
	self
		assert: (typeInfo type: #returnNum from: #SFoo) returnType type
		equals: #SmallInteger.
	self
		assert: (typeInfo type: #score from: #SFoo) returnType type
		equals: #SmallInteger.
	methodInfo := typeInfo type: #score: from: #SFoo.
	self assert: methodInfo returnType type equals: #SFoo.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: #(#SmallInteger).
	self
		assert: (typeInfo factoryMessagesFrom: #SFoo) isEmpty. "the factoryMessage has not been executed"
	self
		assertCollection: typeInfo scalars keys
		hasSameElements: #(#OrderedCollection #Stack #ByteString #SmallInteger #SmallFloat64)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSFooOnClass [
	| profile typeInfo methodInfo |
	profile := SSGenerator
		profile: [ SFoo new return: OrderedCollection ]
		onClass: SFoo.
	typeInfo := profile asTypeInfo.
	self assert: (typeInfo types at: #SFoo) methodTypes size equals: 2.
	self
		assert: (typeInfo types at: #SFoo) classMethodTypes isEmpty.
	self
		assert: (typeInfo type: #initialize from: #SFoo) returnType type
		equals: #SFoo.
	methodInfo := typeInfo type: #return: from: #SFoo.
	self
		assertCollection: methodInfo returnType types
		hasSameElements: #(#'OrderedCollection class').
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: #(#'OrderedCollection class').
	self assertCollection: ((typeInfo messagesFrom: #SFoo) collect: #selector) hasSameElements: #(#initialize #return:)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSFooWithNil [
	| profile typeInfo methodInfo |
	profile := SSGenerator
		profile: [ SFoo new return: nil ]
		onClass: SFoo.
	typeInfo := profile asTypeInfo.
	self assert: (typeInfo types at: #SFoo) methodTypes size equals: 2.
	self
		assert: (typeInfo types at: #SFoo) classMethodTypes isEmpty.
	self
		assert: (typeInfo type: #initialize from: #SFoo) returnType type
		equals: #SFoo.
	methodInfo := typeInfo type: #return: from: #SFoo.
	self
		assertCollection: methodInfo returnType types
		hasSameElements: #(#UndefinedObject).
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: #(#UndefinedObject).
	self assertCollection: ((typeInfo messagesFrom: #SFoo) collect: #selector) hasSameElements: #(#initialize #return:).
	
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSTeacherOnClass [
	| typeInfo |
	typeInfo := (SSGenerator
		profile: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		onClass: SSTeacher) asTypeInfo.
	self
		assertCollection: ((typeInfo types at: #SSTeacher) methodTypes collect: #selector)
		hasSameElements:
			#(#idTeacher #initialize #nickname #yearsWorkExperience).
	self assert: (typeInfo types at: #SSTeacher) classMethodTypes isEmpty.
	self
		assertCollection: ((typeInfo messagesFrom: #SSTeacher) collect: #selector)
		hasSameElements: #(#initialize #nickname).
	self
		assertCollection: ((typeInfo accessMessagesFrom: #SSTeacher) collect: #selector)
		hasSameElements: #(#idTeacher #yearsWorkExperience)
]

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSTeacherOnPackagesMatching [
	| typeInfo |
	typeInfo := (SSGenerator
		profile: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario') asTypeInfo.
	self
		assertCollection: ((typeInfo types at: #SSTeacher) methodTypes collect: #selector)
		hasSameElements: #(#idTeacher #initialize #nickname #yearsWorkExperience).
	self
		assertCollection: ((typeInfo factoryMessagesFrom: #SSTeacher) collect: #selector)
		hasSameElements: #(#name:with:).
	self
		assertCollection: ((typeInfo messagesFrom: #SSTeacher) collect: #selector)
		hasSameElements: #(#initialize #nickname #id: #nickname: #name:).
	self
		assertCollection: ((typeInfo accessMessagesFrom: #SSTeacher) collect: #selector)
		hasSameElements: #(#idTeacher #yearsWorkExperience #name #id)
]

{ #category : #tests }
STypeInfoTest >> testFactoryMessages [
	| typeInfo |
	typeInfo := (SSGenerator
		profile: [ SStudent name: 'Mary' ]
		onClass: SStudent) asTypeInfo.
	self assert: (typeInfo factoryMessagesFrom: #SStudent) isEmpty.
	typeInfo := (SSGenerator
		profile: [ SStudent name: 'Mary' ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario') asTypeInfo.
	self
		assertCollection: ((typeInfo factoryMessagesFrom: #SStudent) collect: #selector)
		hasSameElements: #(#name:).
	typeInfo := (SSGenerator
		profile: [ SConference price: 95 ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario')
		asTypeInfo.
	self
		assertCollection: ((typeInfo factoryMessagesFrom: #SConference) collect: #selector)
		hasSameElements: #(#price:)
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
	methodInfo := typeInfo type: #return: from: #SFoo.
	self assert: methodInfo receiver type equals: #SFoo.
	self
		assertCollection: #(#OrderedCollection #Stack)
		hasSameElements: methodInfo returnType types.
	self
		assertCollection: #(#OrderedCollection #Stack)
		hasSameElements: (methodInfo argTypes flatCollect: [ :argType | argType types ]).
	self
		assert: (typeInfo type: #returnFloat from: #SFoo) returnType type
		equals: #SmallFloat64.
	self
		assert: (typeInfo type: #returnString from: #SFoo) returnType type
		equals: #ByteString.
	self
		assert: (typeInfo type: #score from: #SFoo) returnType type
		equals: #SmallInteger.
	methodInfo := typeInfo type: #score: from: #SFoo.
	self assert: methodInfo receiver type equals: #SFoo.
	self assert: methodInfo returnType type equals: #SFoo.
	self
		assertCollection: (methodInfo argTypes flatCollect: [ :argType | argType types ])
		hasSameElements: #(#SmallInteger).
	self
		assert: (typeInfo type: #score: fromMetaClassName: #SFoo) returnType type
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
		self assertCollection: ((typeInfo messagesFrom: #SFoo) collect: #selector) hasSameElements: #(#returnFloat #returnString).
		"self assertCollection: ((typeInfo accessMessagesFrom: #SFoo) collect: #selector) hasSameElements: #(#score)."
]

{ #category : #tests }
STypeInfoTest >> testScalar [
	| typeInfo |
	typeInfo := STypeInfo new
		scalar: #SmallInteger with: #(1 5 6);
		scalar: #ByteString with: #('hello'  'world');
		scalar: #Stack
			with:
			(Array with: Stack new with:
			(Stack newFrom: #(2  5  8))).
	self
		assertCollection: typeInfo scalars keys
		hasSameElements: #(#Stack  #ByteString #SmallInteger).
	self
		assertCollection: (typeInfo scalars at: #ByteString)
		hasSameElements: #('hello'  'world').
	self
		assertCollection: (typeInfo scalars at: #SmallInteger)
		hasSameElements: #(1 5 6).
	self
		assertCollection: ((typeInfo scalars at: #Stack) collect: #className)
		hasSameElements: #(#Stack  #Stack)
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
	self assert: (typeInfo types at: #SFoo) methodTypes size equals: 5.
	self
		assert: (typeInfo types at: #SFoo) classMethodTypes size
		equals: 1.
	methodInfo := typeInfo type: #return: from: #SFoo.
	self assert: methodInfo receiver type equals: #SFoo.
	self assert: methodInfo returnType type equals: #OrderedCollection.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: #(#OrderedCollection).
	self
		assert: (typeInfo type: #returnFloat from: #SFoo) returnType type
		equals: #SmallFloat64.
	self
		assert: (typeInfo type: #returnString from: #SFoo) returnType type
		equals: #ByteString.
	self
		assert: (typeInfo type: #score from: #SFoo) returnType type
		equals: #SmallInteger.
	methodInfo := typeInfo type: #score: from: #SFoo.
	self assert: methodInfo receiver type equals: #SFoo.
	self assert: methodInfo returnType type equals: #SFoo.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: #(#SmallInteger).
	self
		assert: (typeInfo type: #score: fromMetaClassName: #SFoo) returnType type
		equals: #SFoo
]
