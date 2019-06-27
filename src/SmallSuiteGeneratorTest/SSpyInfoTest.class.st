Class {
	#name : #SSpyInfoTest,
	#superclass : #TestCase,
	#instVars : [
		'spyInfo'
	],
	#category : #'SmallSuiteGeneratorTest-Info'
}

{ #category : #tests }
SSpyInfoTest >> testTypeInfo: profile [
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
SSpyInfoTest >> testTypeInfoSBProfiler [
	| profile info |
	profile := SBProfiler
		profile: [ RTElement new hasNestedElements ]
		onClass: RTElement.
	info := self testTypeInfo: profile.
	self
		assertCollection: (info at: 'packages') keys
		hasSameElements: {#'Roassal2-Core' . #Roassal2GT}.
	self
		assertCollection: (info at: 'classes') keys
		hasSameElements: {#RTElement}
]

{ #category : #tests }
SSpyInfoTest >> testTypeInfoSSGenerator [
	| profile typeInfo |
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
	self
		assert: (typeInfo typeOf: #initialize from: #SFoo) returnType
		equals: #SFoo.
	self
		assert: (typeInfo typeOf: #return: from: #SFoo) returnType
		equals: #SequenceableCollection.
	self
		assertCollection: (typeInfo typeOf: #return: from: #SFoo) argTypes
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
	self
		assert: (typeInfo typeOf: #score: from: #SFoo) returnType
		equals: #SFoo.
	self
		assertCollection: (typeInfo typeOf: #score: from: #SFoo) argTypes
		hasSameElements: {#SmallInteger}.
	self
		assert: (typeInfo typeOf: #score: from: #'SFoo class') returnType isNil
]
