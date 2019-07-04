Class {
	#name : #STypeInfoTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Info'
}

{ #category : #tests }
STypeInfoTest >> testAsTypeInfoSFoo [
	| profile typeInfo methodInfo |
	profile := SSGeneratorTest profileSFoo: 
	[ SFoo new
				return: Stack new;
				return: OrderedCollection new;
				returnFloat;
				returnString;
				returnCollection;
				returnNum;
				score;
				score: 5 ].
	typeInfo := profile asTypeInfo.
	self assert: (typeInfo types at: #SFoo) methodTypes size equals: 8.
	self
		assert: (typeInfo types at: #SFoo) classMethodTypes size
		equals: 1.
	self
		assert: (typeInfo typeOf: #initialize from: #SFoo) returnType
		equals: #SFoo.
	methodInfo := typeInfo typeOf: #return: from: #SFoo.
	self assert: methodInfo returnType equals: #SequenceableCollection.
	self
		assertCollection: methodInfo argTypes
		hasSameElements: {#SequenceableCollection}.
	self
		assert: (typeInfo typeOf: #returnFloat from: #SFoo) returnType
		equals: #SmallFloat64.
	self
		assert: (typeInfo typeOf: #returnCollection from: #SFoo) returnType
		equals: #OrderedCollection.
	self
		assert: (typeInfo typeOf: #returnString from: #SFoo) returnType
		equals: #ByteString.
	self
		assert: (typeInfo typeOf: #returnNum from: #SFoo) returnType
		equals: #SmallInteger.
	self
		assert: (typeInfo typeOf: #score from: #SFoo) returnType
		equals: #SmallInteger.
	methodInfo := typeInfo typeOf: #score: from: #SFoo.
	self assert: methodInfo returnType equals: #SFoo.
	self
		assertCollection: methodInfo argTypes
		hasSameElements: {#SmallInteger}.
	self
		assert: (typeInfo typeOf: #score: fromMetaClassName: #SFoo) returnType isNil.
	self
		assertCollection: typeInfo scalars keys
		hasSameElements:
			{#OrderedCollection . #Stack . #ByteString . #SmallInteger.
			#SmallFloat64}
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
	self assert: methodInfo returnType equals: #OrderedCollection.
	self
		assertCollection: methodInfo argTypes
		hasSameElements: {#OrderedCollection}.
	self
		assert: (typeInfo typeOf: #returnFloat from: #SFoo) returnType
		equals: #SmallFloat64.
	self
		assert: (typeInfo typeOf: #returnString from: #SFoo) returnType
		equals: #ByteString.
	self
		assert: (typeInfo typeOf: #score from: #SFoo) returnType
		equals: #SmallInteger.
	methodInfo := typeInfo typeOf: #score: from: #SFoo.
	self assert: methodInfo returnType equals: #SFoo.
	self
		assertCollection: methodInfo argTypes
		hasSameElements: {#SmallInteger}.
	self
		assert: (typeInfo typeOf: #score: fromMetaClassName: #SFoo) returnType equals: #SFoo
]
