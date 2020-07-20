Class {
	#name : #SSTestCaseTest,
	#superclass : #TestCase,
	#instVars : [
		'utility'
	],
	#category : #'SmallSuiteGenerator-Tests-Core'
}

{ #category : #tests }
SSTestCaseTest >> setUp [
	utility := SUtilityTypeInfo new.
	SPlatform resetRandomGenerator.
	SPlatform fileLogger: 'STestCaseTestLogger.log'
]

{ #category : #running }
SSTestCaseTest >> tearDown [
	"SConfiguration clearFileLog: 'STestCaseTestLogger.log'"
	
	SPlatform resetRandomGenerator
]

{ #category : #tests }
SSTestCaseTest >> testCopy [
	| testCase typeInfo otherTestCase |
	typeInfo := self typeInfo.
	testCase := SSTestCase with: typeInfo.
	testCase
		targetClassName: (self fullSymbolOf: #SFoo);
		addMessage: #returnNum from: (self fullSymbolOf: #SFoo);
		addFieldAccessMessage: #score from: (self fullSymbolOf: #SFoo);
		addLiteral: (self fullSymbolOf: #SmallInteger).
	otherTestCase := testCase copy.
	self assert: testCase length equals: 5.
	self assert: testCase equals: otherTestCase.
	self
		assert: testCase targetClassesName
		equals: #SFoo.
	testCase addLiteral: (self fullSymbolOf: #ByteString).
	otherTestCase addMessage: #returnFloat from: (self fullSymbolOf: #SFoo).
	otherTestCase addMessage: #return: from: (self fullSymbolOf: #SFoo).
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array
									with: '_var0 := 7.3'
									with: '_var1 := ',(self fullNameOfClass: 'SFoo')asString,' score: _var0 '
									with: '_var2 := _var1 returnNum'
									with: '_var3 := _var1 score'
									with: '_var4 := 5'
									with: '_var5 := ''hello''').
	self
		assertCollection: (otherTestCase statements collect: #printString)
		hasSameElements: (OrderedCollection new 
									add: '_var0 := 7.3';
									add: '_var1 := ',(self fullNameOfClass: 'SFoo')asString,' score: _var0 ';
									add: '_var2 := _var1 returnNum';
									add: '_var3 := _var1 score';
									add: '_var4 := 5';
									add: '_var5 := _var1 returnFloat';
									add: '_var6 := ''hello''';
									add: '_var7 := _var1 return: _var6 ';
									yourself)
]

{ #category : #tests }
SSTestCaseTest >> testFieldAccessMessage [
	| testCase |
	testCase := SSTestCase
		with:
			(STypeInfo new
				type:
					(self fullSymbolOf: #SFoo)
						->
							(Array
								with:
									(Array
										with: #score -> (Array
																with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #SmallInteger)
																with: #()
																with: true)
										with: #score: -> (Array
																with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #SmallInteger)
																with: (Array with: (self fullSymbolOf: #SFoo))
																with: false))
								with: (Array with: #score: -> (Array
																with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #SFoo)
																with: (Array with: (self fullSymbolOf: #SmallInteger))
																with: false)));
				scalar: (self fullSymbolOf: #SmallInteger) with: #(5)).
	testCase
		targetClassName: (self fullSymbolOf: #SFoo);
		addFieldAccessMessage.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: '_var0 := 5'
									with: '_var1 := ',(self fullNameOfClass: 'SFoo')asString,' score: _var0 '
									with: '_var2 := _var1 score')
]

{ #category : #tests }
SSTestCaseTest >> testGenerateStatements [
	| testCase  |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase targetClassName: (self fullSymbolOf: #SFoo);
	numMaxStatements: 30.
	self shouldnt: [ testCase generateStatements ] raise: SError
]

{ #category : #tests }
SSTestCaseTest >> testPickAccessorsOf [
	| testCase |
	testCase := SSTestCase new.
	testCase typeInfo: utility typeInfoOnPackage1 .
	self assert: (testCase pickAccessorsOf: (self fullSymbolOf: #SEvent)) isEmpty.
	self
		assertCollection: ((testCase pickAccessorsOf: (self fullSymbolOf: #SConference)) collect: #selector)
		hasSameElements: #(#discount #offerPrice)
]

{ #category : #tests }
SSTestCaseTest >> testPickMessagesOf [
	| testCase |
	testCase := SSTestCase new.
	testCase typeInfo: utility typeInfoOnPackage1 .
	self assert: (testCase pickMessagesOf: (self fullSymbolOf: #SEvent)) isEmpty.
	self
		assertCollection: ((testCase pickMessagesOf: (self fullSymbolOf: #SConference)) collect: #selector)
		hasSameElements: #(#initialize #offerPrice: #canRegister: #price)
]

{ #category : #tests }
SSTestCaseTest >> typeInfo [ 
	|typeInfo|
	typeInfo := STypeInfo new
		type:
			(self fullSymbolOf: #SFoo)
				->
					(Array
						with:
							(Array
								with: #returnNum -> (Array
																with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #SmallInteger)
																with: #()
																with: false)
								with: #returnFloat -> (Array
																with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #SmallFloat64)
																with: #()
																with: false)
								with: #score -> (Array
																with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #SmallInteger)
																with: #()
																with: true)
								with: #return: -> (Array
																with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #ByteString)
																with: (Array with: (self fullSymbolOf: #ByteString))
																with: false))
						with: (Array with: #score: -> (Array
																with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #SFoo)
																with: (Array with: (self fullSymbolOf: #SmallFloat64))
																with: false))).
	typeInfo scalar: (self fullSymbolOf: #ByteString) with: #('hello').
	typeInfo scalar: (self fullSymbolOf: #SmallInteger) with: #(5).
	typeInfo scalar: (self fullSymbolOf: #SmallFloat64) with: #(7.3).
	^ typeInfo
]
