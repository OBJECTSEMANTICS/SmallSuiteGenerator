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
	SConfiguration fileLogger: 'STestCaseTestLogger.log'
]

{ #category : #running }
SSTestCaseTest >> tearDown [
	"SConfiguration clearFileLog: 'STestCaseTestLogger.log'"
]

{ #category : #tests }
SSTestCaseTest >> testCopy [
	| testCase typeInfo otherTestCase |
	typeInfo := STypeInfoForTest new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #returnNum -> #(#SFoo #SmallInteger #() false)
								with: #returnFloat -> #(#SFoo #SmallFloat64 #() false)
								with: #score -> #(#SFoo #SmallInteger #() true)
								with: #return: -> #(#SFoo #ByteString #(#ByteString) false))
						with: (Array with: #score: -> #(#SFoo #SFoo #(#SmallFloat64) false))).
	typeInfo scalar: #ByteString with: #('hello').
	typeInfo scalar: #SmallInteger with: #(5).
	typeInfo scalar: #SmallFloat64 with: #(7.3).
	testCase := SSTestCase with: typeInfo.
	testCase
		addTargetClassName: #SFoo;
		addMessage: #returnNum from: #SFoo;
		addFieldAccessMessage: #score from: #SFoo;
		addLiteral: #SmallInteger.
	otherTestCase := testCase copy.
	self assert: testCase numberStatements equals: 5.
	self assert: testCase equals: otherTestCase.
	self
		assertCollection: testCase targetClassesNames
		hasSameElements: #(#SFoo).
	testCase addLiteral: #ByteString.
	otherTestCase addMessage: #returnFloat from: #SFoo.
	otherTestCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := _var1 returnNum.' '_var3 := _var1 score.' '_var4 := 5.' '_var5 := ''hello''.').
	self
		assertCollection: (otherTestCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := _var1 returnNum.' '_var3 := _var1 score.' '_var4 := 5.' '_var5 := _var1 returnFloat.' '_var6 := ''hello''.' '_var7 := _var1 return: _var6.')
]

{ #category : #tests }
SSTestCaseTest >> testFieldAccessMessage [
	| testCase |
	testCase := SSTestCase
		with:
			(STypeInfoForTest new
				type:
					#SFoo
						->
							(Array
								with:
									(Array
										with: #score -> #(#SFoo #SmallInteger #() true)
										with: #score: -> #(#SFoo #SmallInteger #(#SmallInteger) false))
								with: (Array with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false)));
				scalar: #SmallInteger with: #(5)).
	testCase
		addTargetClassName: #SFoo;
		addFieldAccessMessage.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 5.' '_var1 := SFoo score: _var0.' '_var2 := _var1 score.')
]

{ #category : #tests }
SSTestCaseTest >> testGenerateStatements [
	| testCase  |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo;
	numMaxStatements: 30.
	self shouldnt: [ testCase generateStatements ] raise: SError
]

{ #category : #tests }
SSTestCaseTest >> testPickAccessorsOf [
	| testCase |
	testCase := SSTestCase new.
	testCase typeInfo: utility typeInfoOnPackage1 .
	self assert: (testCase pickAccessorsOf: #SEvent) isEmpty.
	self
		assertCollection: ((testCase pickAccessorsOf: #SConference) collect: #selector)
		hasSameElements: #(#discount #offerPrice)
]

{ #category : #tests }
SSTestCaseTest >> testPickMessagesOf [
	| testCase |
	testCase := SSTestCase new.
	testCase typeInfo: utility typeInfoOnPackage1 .
	self assert: (testCase pickMessagesOf: #SEvent) isEmpty.
	self
		assertCollection: ((testCase pickMessagesOf: #SConference) collect: #selector)
		hasSameElements: #(#initialize #offerPrice: #canRegister: #price)
]
