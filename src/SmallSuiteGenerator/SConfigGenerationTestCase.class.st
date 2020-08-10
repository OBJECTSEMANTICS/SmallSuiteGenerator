Class {
	#name : #SConfigGenerationTestCase,
	#superclass : #TestCase,
	#classVars : [
		'defaultTypeInfo',
		'typeInfos'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #settings }
SConfigGenerationTestCase class >> aClass [

	self subclassResponsibility 
]

{ #category : #settings }
SConfigGenerationTestCase class >> addTypeInfo: aTypeInfo withKey: aString [

	^ self typeInfos at: aString put: aTypeInfo
]

{ #category : #settings }
SConfigGenerationTestCase class >> asDict [
	^ false
]

{ #category : #settings }
SConfigGenerationTestCase class >> blackList [

	^ #()
]

{ #category : #settings }
SConfigGenerationTestCase class >> decodeBlackList [
	|result|
	result := OrderedCollection new.
	self blackList do: [:e | |class finded|
		finded := (e at:1) asClass.
		finded isNotEmpty ifTrue: [
			class := finded first.
			(e at: 3) ifTrue: [class := class class].
			result add: (class compiledMethodAt: (e at: 2))
		]
	 ].
	 ^ result
]

{ #category : #settings }
SConfigGenerationTestCase class >> defaultTypeInfo [
	defaultTypeInfo ifNil: [defaultTypeInfo := STypeInfo asTypeInfo: (SSTypeCollector profile: []
						inPackagesMatching: self targetPackageRegex)].
	^ defaultTypeInfo
]

{ #category : #settings }
SConfigGenerationTestCase class >> factory [
	^ STestCaseFactoryPharo from: self 
]

{ #category : #settings }
SConfigGenerationTestCase class >> fitness [

	^ #statement
]

{ #category : #settings }
SConfigGenerationTestCase class >> fitnessDictionary [

	^ Dictionary new
		at: #statement put: [SStatementCoverage new];
		at: #method put: [SMethodCoverage new];
		at: #multi put: [ SMultiFitnessFunction methodAndStatementCoverage ];
		yourself
]

{ #category : #settings }
SConfigGenerationTestCase class >> fitnessValue [
	^ (self fitnessDictionary 
		at: self fitness 
		ifAbsent: [ self fitnessDictionary at: #statement ]) value
]

{ #category : #settings }
SConfigGenerationTestCase class >> generateTests [
	^ self factory createTestCases; yourself
]

{ #category : #settings }
SConfigGenerationTestCase class >> lastMessage [

	^ ''
]

{ #category : #settings }
SConfigGenerationTestCase class >> limitToWait [
	^ 1000
]

{ #category : #settings }
SConfigGenerationTestCase class >> logClass [

	^ SGANullLog 
]

{ #category : #settings }
SConfigGenerationTestCase class >> logs [
	^ false
]

{ #category : #settings }
SConfigGenerationTestCase class >> methodClass [

	^ SSNullMethods
]

{ #category : #settings }
SConfigGenerationTestCase class >> nsuperclasses [
	^ 0
]

{ #category : #settings }
SConfigGenerationTestCase class >> numberOfGenerations [
	^ 5
]

{ #category : #settings }
SConfigGenerationTestCase class >> numberOfStatements [
	^ 30
]

{ #category : #settings }
SConfigGenerationTestCase class >> outputPackageName [

	^ 'GeneratedTests'
]

{ #category : #settings }
SConfigGenerationTestCase class >> populationSize [
	^ 30
]

{ #category : #settings }
SConfigGenerationTestCase class >> printerClass [

	^ SSDictionaryBasedPrinter
]

{ #category : #settings }
SConfigGenerationTestCase class >> setUpMethod [

	^ ''
]

{ #category : #settings }
SConfigGenerationTestCase class >> stopIterations [

	^ 10
]

{ #category : #settings }
SConfigGenerationTestCase class >> targetPackageRegex [
	self subclassResponsibility
]

{ #category : #settings }
SConfigGenerationTestCase class >> tearDownMethod [

	^ ''
]

{ #category : #settings }
SConfigGenerationTestCase class >> typeInfo [

	^ 'Default'
]

{ #category : #settings }
SConfigGenerationTestCase class >> typeInfoValue [
	[|value|
	value := SConfigGenerationTestCase typeInfos at: self typeInfo.
	value ifNil: [ SError signal: 'Default typeInfo'].
	^ value]
	on: Error
	do: [ ^ self defaultTypeInfo ]
]

{ #category : #settings }
SConfigGenerationTestCase class >> typeInfos [
	typeInfos ifNotNil: [ ^ typeInfos ].
	typeInfos := Dictionary new
		at: 'Default' put: nil;
		yourself.
	^ typeInfos 
]

{ #category : #settings }
SConfigGenerationTestCase class >> vizClass [

	^ SGANullViz 
]
