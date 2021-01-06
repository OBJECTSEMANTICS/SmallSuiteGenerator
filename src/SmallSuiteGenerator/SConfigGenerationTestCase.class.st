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

{ #category : #setter }
SConfigGenerationTestCase class >> aClass: aClass [

	self compileMethod: #aClass withReturn: aClass printString
]

{ #category : #settings }
SConfigGenerationTestCase class >> addTypeInfo: aTypeInfo withKey: aString [

	^ self typeInfos at: aString put: aTypeInfo
]

{ #category : #settings }
SConfigGenerationTestCase class >> asDict [

	^ false
]

{ #category : #setter }
SConfigGenerationTestCase class >> asDict: aBoolean [

	self compileMethod: #asDict withReturn: aBoolean asString.
	self compilePrinterClass.
]

{ #category : #settings }
SConfigGenerationTestCase class >> blackList [

	^ #()
]

{ #category : #setter }
SConfigGenerationTestCase class >> blackList: aColl [

	self compileMethod: #blackList withReturn: (self encodeBlackList: aColl) storeString
]

{ #category : #settings }
SConfigGenerationTestCase class >> compileMethod: aSymbol withReturn: aString [

	self class 
		compile: aSymbol asString, String cr, '	^ ', aString 
		classified: 'settings'
]

{ #category : #settings }
SConfigGenerationTestCase class >> compilePrinterClass [
	| aClass |
	
	aClass := self asDict ifTrue: [ SSDictionaryBasedPrinter ] ifFalse: [ SSStandardPrinter ].
	SSTestShifter class compile: 
		'defaultPrinterClass', String cr,'	^ ', aClass printString
]

{ #category : #settings }
SConfigGenerationTestCase class >> crossoverOperator [

	^ SGACrossoverOperation new
]

{ #category : #setter }
SConfigGenerationTestCase class >> crossoverOperator: aClass [

	self compileMethod: #crossoverOperator withReturn: aClass storeString
]

{ #category : #settings }
SConfigGenerationTestCase class >> crossoverStrategy [

	^ SGACrossoverRate new
]

{ #category : #setter }
SConfigGenerationTestCase class >> crossoverStrategy: aClass [

	self compileMethod: #crossoverStrategy withReturn: aClass storeString
]

{ #category : #settings }
SConfigGenerationTestCase class >> decodeBlackList [
	|result|
	
	result := OrderedCollection new.
	self blackList do: [:e | | class |
		[	class := (e at:1) asClass.
			(e at: 3) ifTrue: [ class := class class ].
			result add: (class compiledMethodAt: (e at: 2)) ]
		on: Error 
		do: [ nil ]
	 ].
	 ^ result
]

{ #category : #settings }
SConfigGenerationTestCase class >> defaultTypeInfo [

	defaultTypeInfo ifNil: [
		defaultTypeInfo := STypeInfo 
			asTypeInfo: (SSTypeCollector profile: [] inPackagesMatching: self targetPackageRegex)].
	^ defaultTypeInfo
]

{ #category : #settings }
SConfigGenerationTestCase class >> elitismRate [

	^ 0.1
]

{ #category : #setter }
SConfigGenerationTestCase class >> elitismRate: aNumber [

	self compileMethod: #elitismRate withReturn: aNumber storeString
]

{ #category : #settings }
SConfigGenerationTestCase class >> encodeBlackList: aColl [

	^ aColl collect: [ :compM | Array 
		with: compM origin instanceSide name 
		with: compM selector 
		with: compM origin isMeta ]
]

{ #category : #settings }
SConfigGenerationTestCase class >> factory [

	^ STestCaseFactoryPharo from: self 
]

{ #category : #settings }
SConfigGenerationTestCase class >> fitness [

	^ #statement
]

{ #category : #setter }
SConfigGenerationTestCase class >> fitness: aSymbol [

	self compileMethod: #fitness withReturn: aSymbol printString
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
	"returns the fitness value given a keyword"
	
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

{ #category : #setter }
SConfigGenerationTestCase class >> lastMessage: aString [

	self compileMethod: #lastMessage withReturn: aString storeString
]

{ #category : #settings }
SConfigGenerationTestCase class >> limitToWait [

	^ 1000
]

{ #category : #setter }
SConfigGenerationTestCase class >> limitToWait: aNumber [

	self compileMethod: #limitToWait withReturn: aNumber asString
]

{ #category : #settings }
SConfigGenerationTestCase class >> logClass [

	^ SGANullLog 
]

{ #category : #setter }
SConfigGenerationTestCase class >> logClass: aClass [

	self compileMethod: #logClass withReturn: aClass printString
]

{ #category : #settings }
SConfigGenerationTestCase class >> logs [

	^ false
]

{ #category : #setter }
SConfigGenerationTestCase class >> logs: aBoolean [ 

	self compileMethod: #logs withReturn: aBoolean printString
]

{ #category : #settings }
SConfigGenerationTestCase class >> methodClass [

	^ SSNullMethods
]

{ #category : #setter }
SConfigGenerationTestCase class >> methodClass: aClass [

	self compileMethod: #methodClass withReturn: aClass printString
]

{ #category : #settings }
SConfigGenerationTestCase class >> nsuperclasses [

	^ 0
]

{ #category : #setter }
SConfigGenerationTestCase class >> nsuperclasses: aNumber [

	self compileMethod: #nsuperclasses withReturn: aNumber printString
]

{ #category : #settings }
SConfigGenerationTestCase class >> numberOfGenerations [
	^ 5
]

{ #category : #setter }
SConfigGenerationTestCase class >> numberOfGenerations: aNumber [

	self compileMethod: #numberOfGenerations withReturn: aNumber printString
]

{ #category : #settings }
SConfigGenerationTestCase class >> numberOfStatements [

	^ 30
]

{ #category : #setter }
SConfigGenerationTestCase class >> numberOfStatements: aNumber [

	self compileMethod: #numberOfStatements withReturn: aNumber printString
	
]

{ #category : #settings }
SConfigGenerationTestCase class >> outputPackageName [

	^ 'GeneratedTests'
]

{ #category : #setter }
SConfigGenerationTestCase class >> outputPackageName: aString [

	self category: aString.
	self compileMethod: #outputPackageName withReturn: aString storeString
]

{ #category : #settings }
SConfigGenerationTestCase class >> populationSize [

	^ 30
]

{ #category : #setter }
SConfigGenerationTestCase class >> populationSize: aNumber [

	self compileMethod: #populationSize withReturn: aNumber printString
	
]

{ #category : #settings }
SConfigGenerationTestCase class >> printerClass [

	^ SSDictionaryBasedPrinter
]

{ #category : #setter }
SConfigGenerationTestCase class >> printerClass: aClass [

	self compileMethod: #printerClass withReturn: aClass printString
]

{ #category : #settings }
SConfigGenerationTestCase class >> selectionStrategy [

	^ SGARandomSelection
]

{ #category : #setter }
SConfigGenerationTestCase class >> selectionStrategy: aClass [

	self compileMethod: #selectionStrategy withReturn: aClass printString
]

{ #category : #settings }
SConfigGenerationTestCase class >> selectionStrategyTestCase [

	^ SGARouletteSelection
]

{ #category : #setter }
SConfigGenerationTestCase class >> selectionStrategyTestCase: aClass [

	self compileMethod: #selectionStrategyTestCase withReturn: aClass printString
]

{ #category : #settings }
SConfigGenerationTestCase class >> setUpMethod [

	^ nil
]

{ #category : #setter }
SConfigGenerationTestCase class >> setUpMethod: aString [

	self compileMethod: #setUpMethod withReturn: aString storeString
]

{ #category : #settings }
SConfigGenerationTestCase class >> stopIterations [

	^ 10
]

{ #category : #setter }
SConfigGenerationTestCase class >> stopIterations: aNumber [

	self compileMethod: #stopIterations withReturn: aNumber storeString
]

{ #category : #settings }
SConfigGenerationTestCase class >> targetPackageRegex [

	self subclassResponsibility
]

{ #category : #setter }
SConfigGenerationTestCase class >> targetPackageRegex: aString [

	self compileMethod: #targetPackageRegex withReturn: aString storeString
]

{ #category : #settings }
SConfigGenerationTestCase class >> tearDownMethod [

	^ nil
]

{ #category : #setter }
SConfigGenerationTestCase class >> tearDownMethod: aString [

	self compileMethod: #tearDownMethod withReturn: aString storeString
]

{ #category : #settings }
SConfigGenerationTestCase class >> typeInfo [

	^ 'Default' 
]

{ #category : #setter }
SConfigGenerationTestCase class >> typeInfo: aString [

	self compileMethod: #typeInfo withReturn: aString storeString
]

{ #category : #settings }
SConfigGenerationTestCase class >> typeInfoValue [

	[	|value|
		value := SConfigGenerationTestCase typeInfos at: self typeInfo.
		value ifNil: [ SError signal: 'Default typeInfo'].
		^ value ]
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

{ #category : #setter }
SConfigGenerationTestCase class >> vizClass: aClass [

	self compileMethod: #vizClass withReturn: aClass printString
]
