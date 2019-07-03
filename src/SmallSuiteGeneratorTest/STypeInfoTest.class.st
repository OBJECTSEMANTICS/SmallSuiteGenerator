Class {
	#name : #STypeInfoTest,
	#superclass : #TestCase,
	#instVars : [
		'spyInfo'
	],
	#category : #'SmallSuiteGeneratorTest-Info'
}

{ #category : #tests }
STypeInfoTest >> testTypeInfo: profile [
	| info |
	spyInfo typeInfo: profile.
	info := spyInfo info.
	self assert: info isDictionary.
	self
		assertCollection: info keys
		includesAll: {'packages' . 'classes' . 'methods'}.
	self assert: (info at: 'packages') isDictionary.
	self assert: (info at: 'classes') isDictionary.
	self assert: (info at: 'methods') isCollection.
	self
		assert: spyInfo packagesDictionary
		equals: profile packagesDictionary.
	self assert: spyInfo allClasses equals: profile allClasses.
	self
		assert: spyInfo allClassesAsDictionary
		equals: profile allClassesAsDictionary.
	self assert: spyInfo allMethods equals: profile allMethods.
	^ info
]

{ #category : #tests }
STypeInfoTest >> testTypeInfoSSGenerator [
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
