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
	| testCase typeInfo otherTestCase sfooSymbol sfooName |
	sfooSymbol := #SFoo fullClassNameSymbol.
	sfooName := 'SFoo' fullClassName.
	typeInfo := self typeInfo.
	testCase := SSTestCase with: typeInfo.
	testCase
		targetClassName: sfooSymbol;
		addMessage: #returnNum from: sfooSymbol;
		addFieldAccessMessage: #score from: sfooSymbol;
		addLiteral:  #SmallInteger fullClassNameSymbol.
	otherTestCase := testCase copy.
	self assert: testCase length equals: 5.
	self assert: testCase equals: otherTestCase.
	self
		assert: testCase targetClassesName
		equals: #SFoo fullClassNameSymbol.
	testCase addLiteral: #ByteString fullClassNameSymbol.
	otherTestCase addMessage: #returnFloat from: sfooSymbol.
	otherTestCase addMessage: #return: from: sfooSymbol.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array
									with: '_var0 := 7.3'
									with: '_var1 := ',sfooName,' score: _var0 '
									with: '_var2 := _var1 returnNum'
									with: '_var3 := _var1 score'
									with: '_var4 := 5'
									with: '_var5 := ''hello''').
	self
		assertCollection: (otherTestCase statements collect: #printString)
		hasSameElements: (OrderedCollection new 
									add: '_var0 := 7.3';
									add: '_var1 := ',sfooName,' score: _var0 ';
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
	| testCase sfooSymbol smallIntegerSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	smallIntegerSymbol := #SmallInteger fullClassNameSymbol.
	testCase := SSTestCase
		with:
			(STypeInfo new
				type:
					sfooSymbol
						->
							(Array
								with:
									(Array
										with: #score -> (Array
																with: sfooSymbol
																with: smallIntegerSymbol
																with: #()
																with: true)
										with: #score: -> (Array
																with: sfooSymbol
																with: smallIntegerSymbol
																with: (Array with: sfooSymbol)
																with: false))
								with: (Array with: #score: -> (Array
																with: sfooSymbol
																with: sfooSymbol
																with: (Array with: smallIntegerSymbol)
																with: false)));
				scalar: smallIntegerSymbol with: #(5)).
	testCase
		targetClassName: sfooSymbol;
		addFieldAccessMessage.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: '_var0 := 5'
									with: '_var1 := ', sfooSymbol asString,' score: _var0 '
									with: '_var2 := _var1 score')
]

{ #category : #tests }
SSTestCaseTest >> testGenerateStatements [
	| testCase  |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase targetClassName: #SFoo fullClassNameSymbol;
	numMaxStatements: 30.
	self shouldnt: [ testCase generateStatements ] raise: SError
]

{ #category : #tests }
SSTestCaseTest >> testPickAccessorsOf [
	| testCase |
	testCase := SSTestCase new.
	testCase typeInfo: utility typeInfoOnPackage1 .
	self assert: (testCase pickAccessorsOf: #SEvent fullClassNameSymbol) isEmpty.
	self
		assertCollection: ((testCase pickAccessorsOf: #SConference fullClassNameSymbol) collect: #selector)
		hasSameElements: #(#discount #offerPrice)
]

{ #category : #tests }
SSTestCaseTest >> testPickMessagesOf [
	| testCase |
	testCase := SSTestCase new.
	testCase typeInfo: utility typeInfoOnPackage1 .
	self assert: (testCase pickMessagesOf: #SEvent fullClassNameSymbol) isEmpty.
	self
		assertCollection: ((testCase pickMessagesOf: #SConference fullClassNameSymbol) collect: #selector)
		hasSameElements: #(#initialize #offerPrice: #canRegister: #price)
]

{ #category : #tests }
SSTestCaseTest >> typeInfo [ 
	|typeInfo sfooSymbol smallIntegerSymbol byteStringSymbol smallFloatSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	smallIntegerSymbol := #SmallInteger fullClassNameSymbol.
	byteStringSymbol := #ByteString fullClassNameSymbol.
	smallFloatSymbol := #SmallFloat64 fullClassNameSymbol .
	typeInfo := STypeInfo new
		type:
			sfooSymbol
				->
					(Array
						with:
							(Array
								with: #returnNum -> (Array
																with: sfooSymbol
																with: smallIntegerSymbol
																with: #()
																with: false)
								with: #returnFloat -> (Array
																with: sfooSymbol
																with: smallFloatSymbol
																with: #()
																with: false)
								with: #score -> (Array
																with: sfooSymbol
																with: smallIntegerSymbol
																with: #()
																with: true)
								with: #return: -> (Array
																with: sfooSymbol
																with: byteStringSymbol
																with: (Array with: byteStringSymbol)
																with: false))
						with: (Array with: #score: -> (Array
																with: sfooSymbol
																with: sfooSymbol
																with: (Array with: smallFloatSymbol)
																with: false))).
	typeInfo scalar: byteStringSymbol with: #('hello').
	typeInfo scalar: smallIntegerSymbol with: #(5).
	typeInfo scalar: smallFloatSymbol with: #(7.3).
	^ typeInfo
]
