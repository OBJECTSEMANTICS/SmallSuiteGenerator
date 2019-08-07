Class {
	#name : #STypeInfoTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Info'
}

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSFoo [
	| profile typeInfo methodInfo |
	profile := SSGenerator profile: [ SFoo new
				return: Stack new;
				return: OrderedCollection new;
				returnFloat;
				returnString;
				returnCollection;
				returnNum;
				score;
				score: 5 ] onClass: SFoo.
	typeInfo := profile asTypeInfo.
	self assert: (typeInfo types at: #SFoo) methodTypes size equals: 8.
	self
		assert: (typeInfo types at: #SFoo) classMethodTypes size
		equals: 1.
	self
		assert: (typeInfo typeOf: #initialize from: #SFoo) returnType type
		equals: #SFoo.
	methodInfo := typeInfo typeOf: #return: from: #SFoo.
	self
		assertCollection: methodInfo returnType types
		hasSameElements: {#OrderedCollection . #Stack}.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: {#OrderedCollection . #Stack}.
	self
		assert: (typeInfo typeOf: #returnFloat from: #SFoo) returnType type
		equals: #SmallFloat64.
	self
		assert: (typeInfo typeOf: #returnCollection from: #SFoo) returnType type
		equals: #OrderedCollection.
	self
		assert: (typeInfo typeOf: #returnString from: #SFoo) returnType type
		equals: #ByteString.
	self
		assert: (typeInfo typeOf: #returnNum from: #SFoo) returnType type
		equals: #SmallInteger.
	self
		assert: (typeInfo typeOf: #score from: #SFoo) returnType type
		equals: #SmallInteger.
	methodInfo := typeInfo typeOf: #score: from: #SFoo.
	self assert: methodInfo returnType type equals: #SFoo.
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: {#SmallInteger}.
	self
		assert:
			(typeInfo typeOf: #score: fromMetaClassName: #SFoo) returnType type
				isNil.
	self
		assertCollection: typeInfo scalars keys
		hasSameElements:
			{#OrderedCollection . #Stack . #ByteString . #SmallInteger.
			#SmallFloat64}
]

{ #category : #tests }
STypeInfoTest >> testJoinWith [
	| typeInfo methodInfo otherTypeInfo |
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					{{(#return:
						->
							{#OrderedCollection.
							{#OrderedCollection}.
							false}).
					(#score:
						->
							{#SFoo.
							{#SmallInteger}.
							false}).
					(#score
						->
							{#SmallInteger.
							{}.
							true})}.
					{(#score:
						->
							{#SFoo.
							{#SmallInteger}.
							false})}}.
	otherTypeInfo := STypeInfo new
		type:
			#SFoo
				->
					{{(#returnFloat
						->
							{#SmallFloat64.
							{}.
							false}).
					(#returnString
						->
							{#ByteString.
							{}.
							false}).
					(#return:
						->
							{#Stack.
							{#Stack}.
							false})}.
					{}}.
	typeInfo joinWith: otherTypeInfo.
	self assert: (typeInfo types at: #SFoo) methodTypes size equals: 5.
	self
		assert: (typeInfo types at: #SFoo) classMethodTypes size
		equals: 1.
	methodInfo := typeInfo typeOf: #return: from: #SFoo.
	self
		assertCollection: {#OrderedCollection . #Stack} hasSameElements: methodInfo returnType types.
	self
		assertCollection: {#OrderedCollection . #Stack} hasSameElements: (methodInfo argTypes flatCollect: [:argType | argType types]) .
	self
		assert: (typeInfo typeOf: #returnFloat from: #SFoo) returnType type
		equals: #SmallFloat64.
	self
		assert: (typeInfo typeOf: #returnString from: #SFoo) returnType type
		equals: #ByteString.
	self
		assert: (typeInfo typeOf: #score from: #SFoo) returnType type
		equals: #SmallInteger.
	methodInfo := typeInfo typeOf: #score: from: #SFoo.
	self assert: methodInfo returnType type equals: #SFoo.
	self
		assertCollection: (methodInfo argTypes flatCollect: [:argType | argType types])
		hasSameElements: {#SmallInteger}.
	self
		assert: (typeInfo typeOf: #score: fromMetaClassName: #SFoo) returnType type
		equals: #SFoo
]

{ #category : #tests }
STypeInfoTest >> testScalar [
	| typeInfo  |
	typeInfo := STypeInfo new
		scalar: #SmallInteger with: #(1 5 6);
		scalar: #ByteString with: {'hello' . 'world'};
		scalar: #Stack
			with:
			{Stack new.
			(Stack newFrom: {2 . 5 . 8})}.
	self
		assertCollection: typeInfo scalars keys
		hasSameElements: {#Stack . #ByteString . #SmallInteger}.
	self assertCollection: (typeInfo scalars at: #ByteString) hasSameElements: { 'hello'. 'world' }.
	self assertCollection: (typeInfo scalars at: #SmallInteger) hasSameElements: #(1 5 6).
	self assertCollection: ((typeInfo scalars at: #Stack) collect: #className) hasSameElements: { #Stack. #Stack }
]

{ #category : #tests }
STypeInfoTest >> testType [
	| typeInfo methodInfo |
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					{{(#returnFloat
						->
							{#SmallFloat64.
							{}.
							false}).
					(#returnString
						->
							{#ByteString.
							{}.
							false}).
					(#return:
						->
							{#OrderedCollection.
							{#OrderedCollection}.
							false}).
					(#score:
						->
							{#SFoo.
							{#SmallInteger}.
							false}).
					(#score
						->
							{#SmallInteger.
							{}.
							true})}.
					{(#score:
						->
							{#SFoo.
							{#SmallInteger}.
							false})}}.
	self assert: (typeInfo types at: #SFoo) methodTypes size equals: 5.
	self
		assert: (typeInfo types at: #SFoo) classMethodTypes size
		equals: 1.
	methodInfo := typeInfo typeOf: #return: from: #SFoo.
	self assert: methodInfo returnType type equals: #OrderedCollection.
	self
		assertCollection: methodInfo allArgTypes 
		hasSameElements: {#OrderedCollection}.
	self
		assert: (typeInfo typeOf: #returnFloat from: #SFoo) returnType type
		equals: #SmallFloat64.
	self
		assert: (typeInfo typeOf: #returnString from: #SFoo) returnType type
		equals: #ByteString.
	self
		assert: (typeInfo typeOf: #score from: #SFoo) returnType type
		equals: #SmallInteger.
	methodInfo := typeInfo typeOf: #score: from: #SFoo.
	self assert: methodInfo returnType type equals: #SFoo.
	self
		assertCollection: methodInfo allArgTypes 
		hasSameElements: {#SmallInteger}.
	self
		assert: (typeInfo typeOf: #score: fromMetaClassName: #SFoo) returnType type
		equals: #SFoo
]
