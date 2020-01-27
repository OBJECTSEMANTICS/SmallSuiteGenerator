Class {
	#name : #SMessageTest,
	#superclass : #SExpressionTest,
	#category : #'SmallSuiteGenerator-Tests-AST'
}

{ #category : #tests }
SMessageTest >> testCopy [
	| message copy |
	message := SMessage new
		receiver: (SVariable new id: 1; returnType: #SFoo);
		selector: #return:;
		args:
			(Array
				with:
					(SVariable new
						id: 2;
						returnType: #ByteString));
		returnType: #ByteString.
	self assert: message printString equals: '_aSFoo1 return: _aByteString2'.
	copy := message copy.
	copy value args first id: 5.
	self assert: copy printString equals: '_aSFoo1 return: _aByteString5'.
	copy value receiver varName: '_sfoo'.
	copy value receiver id: 4.
	self assert: copy printString equals: '_sfoo4 return: _aByteString5'.
	copy value selector: #returnValue:.
	self assert: copy printString equals: '_sfoo4 returnValue: _aByteString5'.
	self assert: message printString equals: '_aSFoo1 return: _aByteString2'
]

{ #category : #tests }
SMessageTest >> testInsertAsParameterUsing [
	| testCase aExpression insertedExpression |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo; addFactoryMessage: #SFoo; addLiteral: #ByteString.
	aExpression := testCase addMessage: #returnString from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aByteString2 := ''hello''.' '_aByteString3 := _aSFoo1 returnString.').
	testCase addMessage: #return: from: #SFoo.
	insertedExpression := aExpression
		insertAsParameter: aExpression
		using: testCase.
	self
		assert:
			(#('_aByteString4 := _aSFoo1 return: _aByteString3.')
				includes: insertedExpression printString)
]

{ #category : #tests }
SMessageTest >> testInsertMethodMessageUsing [
	| testCase message |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo.
	message := testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aByteString2 := ''hello''.' '_aByteString3 := _aSFoo1 return: _aByteString2.').
	message insertMethodMessage: message using: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aByteString2 := ''hello''.' '_aByteString3 := _aSFoo1 return: _aByteString2.' '_aByteString4 := _aSFoo1 return: _aByteString2.')
]
