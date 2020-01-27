Class {
	#name : #SSTestShifterTest,
	#superclass : #TestCase,
	#instVars : [
		'utility'
	],
	#category : #'SmallSuiteGenerator-Tests-Core'
}

{ #category : #running }
SSTestShifterTest >> setUp [
	utility := SUtilityTypeInfo new.
	SConfiguration fileLogger: 'STestShifterTestLogger.log'
]

{ #category : #tests }
SSTestShifterTest >> testAddAssignment [
	| testCase expression |
	testCase := SSTestCase new.
	expression := testCase addAssignment: (SLiteral new value: 3).
	self assert: expression printString equals: '_var0 := 3.'.
	expression := testCase
		addAssignment:
			(SMessage new
				receiver: (SVariable new id: 0);
				selector: #foo;
				yourself).
	self assert: expression printString equals: '_var1 := _var0 foo.'
]

{ #category : #tests }
SSTestShifterTest >> testAddFactoryMessage [
	| testCase aTypeInfo |
	aTypeInfo := utility typeInfoSFoo3.
	testCase := SSTestCase with: aTypeInfo.
	testCase
		addTargetClassName: #SFoo;
		addFactoryMessage: #SFoo.
	self assert: testCase statements size equals: 2.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSmallInteger0 := 4.' '_aSFoo1 := SFoo score: _aSmallInteger0.').
	self should: [ testCase addFactoryMessage: #SStack ] raise: SError.
	aTypeInfo
		type:
			#SStack
				->
					(Array
						with: (Array with: #top -> #(#SStack nil #() false))
						with: (Array with: #newStack: -> #(#SStack #SStack #(#Array) false)));
		scalar: #Array with: #(#(1 3 2)).
	testCase
		addTargetClassName: #SStack;
		addFactoryMessage: #SStack.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallInteger0 := 4.' '_aSFoo1 := SFoo score: _aSmallInteger0.' '_anArray2 := #(1 3 2 ).' '_aSStack3 := SStack newStack: _anArray2.')
]

{ #category : #tests }
SSTestShifterTest >> testAddFactoryMessageOfInexistentSelector [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo2.
	testCase
		addTargetClassName: #SFoo;
		addFactoryMessage: #SFoo ofSelector: #score:.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSFoo0 := SFoo new.')
]

{ #category : #tests }
SSTestShifterTest >> testAddFactoryMessageOfSelector [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo3.
	testCase
		addTargetClassName: #SFoo;
		addFactoryMessage: #SFoo ofSelector: #score:.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSmallInteger0 := 4.' '_aSFoo1 := SFoo score: _aSmallInteger0.')
]

{ #category : #tests }
SSTestShifterTest >> testAddFactoryMessageOnPackage [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoOnPackage3.
	self should: [ testCase addFactoryMessage: #SSTeacher ] raise: SError.
	testCase addTargetClassName: #SSTeacher.
	expression := testCase addFactoryMessage: #SSTeacher.
	self
		assert:
			(#('_aSSTeacher2 := SSTeacher name: _aByteString0 with: _aSmallInteger1.' '_aSSTeacher2 := SSTeacher name: _aByteString1 with: _aSmallInteger0.')
				includes: expression printString).
	self
		shouldnt: [ expression := testCase addFactoryMessage: #SConference ]
		raise: SError.
	self
		assert: expression printString
		equals: '_aSConference3 := SConference new.'
]

{ #category : #tests }
SSTestShifterTest >> testAddFactoryMessageWithAbstractClasses [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSSPerson1.
	self should: [ testCase addFactoryMessage ] raise: SError.
	self should: [ testCase addFactoryMessage: #SSPerson ] raise: SError.
	testCase := SSTestCase with: utility typeInfoSAbstractClass.
	self should: [ testCase addFactoryMessage ] raise: SError.
	self
		should: [ testCase addFactoryMessage: #SAbstractClass ]
		raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessage [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSSTeacher2.
	self should: [ testCase addFieldAccessMessage ] raise: SError.
	testCase addTargetClassName: #SSTeacher.
	self
		assert: testCase addFieldAccessMessage printString
		equals: '_aSmallInteger1 := _aSSTeacher0 idTeacher.'.
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessageFrom [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo3.
	self
		should: [ testCase addFieldAccessMessage: #score from: #SFoo ]
		raise: SError.
	testCase addTargetClassName: #SFoo.
	self
		assert: (testCase addFieldAccessMessage: #score from: #SFoo) printString
		equals: '_aSmallInteger2 := _aSFoo1 score.'
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessageFromWithError [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo2.
	self
		should: [ testCase addFieldAccessMessage: #score from: #SFoo ]
		raise: SError.
	testCase addTargetClassName: #SFoo.
	self
		should: [testCase addFieldAccessMessage: #score from: #SFoo]
		raise: SError.
	self
		should: [ testCase addFieldAccessMessage: #return: from: #SFoo ]
		raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessageFromWithInvalidClassName [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo4.
	testCase addTargetClassName: #SFoo.
	self
		should: [ testCase addFieldAccessMessage: #score from: #SStudent ]
		raise: SError.
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessageWithLackTypeInfo [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSSTeacher3.
	self should: [ testCase addFieldAccessMessage ] raise: SError.
	testCase addTargetClassName: #SSTeacher.
	self should: [testCase addFieldAccessMessage] raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessageWithReceiver [
	| testCase typeInfo receiver |
	typeInfo := utility typeInfoSFoo1.
	testCase := (SSTestCase with: typeInfo) addTargetClassName: #SFoo.
	receiver := testCase addFactoryMessage variable.
	self
		assert:
			(testCase
				addFieldAccessMessage: (typeInfo accessMessagesFrom: #SFoo) first
				withReceiver: receiver) printString
		equals: '_aSmallFloat642 := _aSFoo1 score.'
]

{ #category : #tests }
SSTestShifterTest >> testAddInvalidAssignment [
	| testCase |
	testCase := SSTestCase new.
	self should: [ testCase addAssignment: 3 ] raise: SError.
	self should: [ testCase addAssignment: 'hello' ] raise: SError.
	self should: [ testCase addAssignment: #name ] raise: SError.
	self should: [ testCase addAssignment: 3.4 ] raise: SError.
	self should: [ testCase addAssignment: #() ] raise: SError.
]

{ #category : #tests }
SSTestShifterTest >> testAddLiteral [
	| testCase aTypeInfo |
	aTypeInfo := STypeInfo new.
	aTypeInfo
		scalar: #OrderedCollection
			with: (Array with: (OrderedCollection newFrom: #(1 4)));
		scalar: #ByteString with: #('World');
		scalar: #SmallInteger with: #(2);
		scalar: #SStudent with: (Array with: SStudent new).
	testCase := SSTestCase with: aTypeInfo.
	testCase
		addLiteral: #ByteString;
		addLiteral: #OrderedCollection;
		addLiteral: #SmallInteger;
		addLiteral: #SStudent.
	self assert: testCase statements size equals: 4.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_aByteString0 := ''World''.'
				with:
					'_anOrderedCollection1 := '
						,
							(OrderedCollection new
								add: 1;
								add: 4;
								yourself) storeString , '.'
				with: '_aSmallInteger2 := 2.'
				with: '_aSStudent3 := ' , SStudent new storeString , '.')
]

{ #category : #tests }
SSTestShifterTest >> testAddLiteralWithError [
	| testCase |
	testCase := SSTestCase with: STypeInfo new.
	self should: [ testCase addLiteral ] raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testAddLiteralWithWrongClassName [
	| testCase aTypeInfo |
	aTypeInfo := STypeInfo new.
	aTypeInfo scalar: #SmallInteger with: #(2).
	testCase := SSTestCase with: aTypeInfo.
	self should: [ testCase addLiteral: #ByteString ] raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testAddMessage [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo5.
	testCase
		addTargetClassName: #SFoo;
		addMessage.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_aSFoo0 := SFoo new.'
				with: '_anOrderedCollection1 := ' , (OrderedCollection newFrom: #(1 4 5)) storeString , '.'
				with: '_anOrderedCollection2 := _aSFoo0 return: _anOrderedCollection1.')
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageFrom [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo3.
	testCase
		addTargetClassName: #SFoo;
		addMessage: #returnFloat from: #SFoo.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_aSmallInteger0 := 4.'
				with: '_aSFoo1 := SFoo score: _aSmallInteger0.'
				with: '_aSmallFloat642 := _aSFoo1 returnFloat.').
	self
		assert: (testCase addMessage: #returnNum from: #SFoo) printString
		equals: '_aSmallInteger3 := _aSFoo1 returnNum.'.
	self
		assert:
			(#('_aSFoo4 := _aSFoo1 score: _aSmallInteger0.' '_aSFoo4 := _aSFoo1 score: _aSmallInteger3.')
				includes: (testCase addMessage: #score: from: #SFoo) printString)
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageFromDifferentReceiver [
	| testCase |
	testCase := (SSTestCase
		with: utility typeInfoOnPackage1)
		addTargetClassName: #SEvent.
	self
		should: [ testCase addMessage: #canRegister: from: #SEvent ]
		raise: SError.
	testCase addTargetClassName: #SConference.
	testCase addMessage: #canRegister: from: #SConference.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_aSConference0 := SConference new.'
				with: '_aSStudent1 := ' , (SStudent new name: 'Mary') storeString , '.'
				with: '_aFalse2 := _aSConference0 canRegister: _aSStudent1.')
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageWithEmptyTypeMethodInfo [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFooEmpty.
	testCase addTargetClassName: #SFoo.
	self should: [ testCase addMessage ] raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageWithReceiver [
	| testCase typeInfo receiver |
	typeInfo := utility typeInfoSFoo2.
	testCase := (SSTestCase with: typeInfo) addTargetClassName: #SFoo.
	receiver := testCase addFactoryMessage variable.
	self
		assert:
			(testCase
				addMessage: (typeInfo messagesFrom: #SFoo) first
				withReceiver: receiver) printString
		equals: '_aSFoo1 := _aSFoo0 return: _aSFoo0.'
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageWithTwoDeepScalarSFoo [
	| testCase |
	testCase := SSTestCase
		with: utility typeInfoSFooOnPackage3."(STON fromString: utility typeInfoStringSFoo6)."
	testCase
		addTargetClassName: #SFoo;
		addMessage: #return: from: #SFoo.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(OrderedCollection new
				add: '_aSFoo0 := SFoo new.';
				add: '_aSStudent1 := ' , (SStudent name: 'Lian' with: 1) storeString , '.';
				add: '_aSStack2 := SStack new.';
				add: '_aSStudent3 := _aSStack2 push: _aSStudent1.';
				add: '_aSStudent4 := ' , (SStudent name: 'Josh' with: 2) storeString , '.';
				add: '_aSStudent5 := _aSStack2 push: _aSStudent4.';
				add: '_aSStudent6 := ' , (SStudent name: 'Mery' with: 5) storeString , '.';
				add: '_anOrderedCollection7 := ((OrderedCollection new) add: _aSStudent6; yourself).';
				add:
					'_aDictionary8 := ((Dictionary new) add: (1->_aSStudent5); add: (2->_anOrderedCollection7); yourself).';
				add: '_aDictionary9 := _aSFoo0 return: _aDictionary8.';
				yourself)
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageWithTwoDeepScalarSStack [
	| testCase |
	testCase := SSTestCase
		with: utility typeInfoSStackOnPackage2."(STON fromString: utility typeInfoStringSStack1)".
	testCase
		addTargetClassName: #SStack;
		addMessage: #push: from: #SStack.
	self assert: testCase statements size equals: 3.
	self
		assert:
			((testCase statements collect: #printString)
				includesAny:
					(Array
						with:
							(OrderedCollection new
								add: '_aSStack0 := SStack new.';
								add: '_aSStudent1 := ' , (SStudent name: 'Lian' with: 1) storeString , '.';
								add: '_aSStudent2 := ' , (SStudent name: 'Josh' with: 2) storeString , '.';
								add: '_anOrderedCollection3 := ((OrderedCollection new) add: _aSStudent1; add: _aSStudent2; yourself).';
								add: '_anOrderedCollection4 := _aSStack0 push: _anOrderedCollection3.';
								yourself)
						with:
							(OrderedCollection new
								add: '_aSStack0 := SStack new.';
								add: '_aSStudent1 := ' , (SStudent name: 'Mery' with: 5) storeString , '.';
								add: '_anOrderedCollection2 := ((OrderedCollection new) add: _aSStudent1; yourself).';
								add: '_anOrderedCollection3 := _aSStack0 push: _anOrderedCollection2.';
								yourself)))
]

{ #category : #tests }
SSTestShifterTest >> testAddStatementAfter [
	| testCase expression1 expression2 |
	testCase := SSTestCase with: utility typeInfoSSTeacher1.
	expression1 := SAssignment
		name: (SVariable new id: 0)
		value: ((SLiteral value: 2) returnType: #SmallInteger).
	self
		assert: (testCase addStatement: expression1 after: nil) printString
		equals: '_var0 := 2.'.
	expression2 := SAssignment
		name: (SVariable new id: 1)
		value: (SFactoryMessage default: #SSTeacher).
	self
		assert: (testCase addStatement: expression2 after: expression1) printString
		equals: '_var1 := SSTeacher new.'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 2.' '_var1 := SSTeacher new.').
	expression1 := expression2.
	expression2 := SAssignment
		name: (SVariable new id: 2)
		value:
			(SMessage new
				selector: #yearsWorkExperience;
				receiver: expression1 variable;
				yourself).
	testCase addStatement: expression2 after: expression1.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 2.' '_var1 := SSTeacher new.' '_var2 := _var1 yearsWorkExperience.').
	expression2 := SAssignment
		name: (SVariable new id: 3)
		value: (SLiteral value: 4).
	testCase addStatement: expression2 after: expression1.
	self
		assert:
			((Array
				with:
					#('_var0 := 2.' '_var1 := SSTeacher new.' '_var2 := _var1 yearsWorkExperience.' '_var3 := 4.')
				with:
					#('_var0 := 2.' '_var1 := SSTeacher new.' '_var3 := 4.' '_var2 := _var1 yearsWorkExperience.'))
				includes: (testCase statements collect: #printString) asArray)
]

{ #category : #tests }
SSTestShifterTest >> testAddStatementBefore [
	| testCase expression1 expression2 |
	testCase := SSTestCase new.
	expression1 := SAssignment
		name: (SVariable new id: 0)
		value: ((SLiteral value: 2) returnType: #SmallInteger).
	testCase addStatement: expression1 before: nil.
	expression2 := SAssignment
		name: (SVariable new id: 1)
		value: (SFactoryMessage default: #SSTeacher).
	testCase addStatement: expression2 before: expression1.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var1 := SSTeacher new.' '_var0 := 2.').
	expression1 := expression2.
	expression2 := SAssignment
		name: (SVariable new id: 2)
		value: ((SLiteral value: 100) returnType: #SmallInteger).
	testCase addStatement: expression2 before: expression1.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var2 := 100.' '_var1 := SSTeacher new.' '_var0 := 2.').
	expression1 := testCase statements last.	"_var0"
	expression2 := SAssignment
		name: (SVariable new id: 3)
		value:
			(SMessage new
				selector: #yearsWorkExperience;
				receiver: testCase statements second variable;
				yourself).
	testCase addStatement: expression2 before: expression1.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var2 := 100.' '_var1 := SSTeacher new.' '_var3 := _var1 yearsWorkExperience.' '_var0 := 2.')
]

{ #category : #tests }
SSTestShifterTest >> testAddStatetementOfTypeBefore [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSEvent1.
	testCase addTargetClassName: #SEvent.
	expression := testCase addStatementOfType: #SEvent before: nil.
	self
		assert: expression printString
		equals: '_aSEvent1 := SEvent price: _aSmallInteger0.'.
	expression := testCase
		addStatementOfType: #SmallInteger
		before: expression.
	self assert: expression printString equals: '_aSmallInteger2 := 8.'.	"change the form to select randomly"
	self
		assert:
			(#(#('_aSmallInteger0 := 8.' '_aSmallInteger2 := 8.' '_aSEvent1 := SEvent price: _aSmallInteger0.') #('_aSmallInteger2 := 8.' '_aSmallInteger0 := 8.' '_aSEvent1 := SEvent price: _aSmallInteger0.'))
				includes: (testCase statements collect: #printString) asArray)
]

{ #category : #tests }
SSTestShifterTest >> testAddStatetementOfTypeBeforeFactoryMessage [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSEvent1.
	testCase addTargetClassName: #SEvent.
	expression := testCase addFactoryMessage.
	expression := testCase addStatementOfType: #SEvent before: expression.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallInteger0 := 8.' '_aSEvent2 := SEvent price: _aSmallInteger0.' '_aSEvent1 := SEvent price: _aSmallInteger0.')
]

{ #category : #tests }
SSTestShifterTest >> testAddTargetClassName [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoOnPackage3.
	self should: [testCase addTargetClassName: #SEvent] raise: SError.
	self shouldnt: [testCase addTargetClassName: #SSTeacher] raise: SError.
	expression := testCase addFactoryMessage: #SSTeacher.
	self
		assert:
			(#('_aSSTeacher2 := SSTeacher name: _aByteString0 with: _aSmallInteger1.' '_aSSTeacher2 := SSTeacher name: _aByteString1 with: _aSmallInteger0.')
				includes: expression printString).
]

{ #category : #tests }
SSTestShifterTest >> testBuildArgsBefore [
	| testCase typeInfo expression |
	typeInfo := utility typeInfoSEvent1.
	testCase := SSTestCase with: typeInfo.
	testCase addTargetClassName: #SEvent.
	expression := testCase addLiteral.
	testCase buildArgs: ((typeInfo factoryMessagesFrom: #SEvent) first argTypes)  before: expression.
	self
		assertCollection: (testCase printStatements )
		hasSameElements: #('_aSmallInteger1 := 8.' '_aSmallInteger0 := 8.')
]

{ #category : #tests }
SSTestShifterTest >> testNewFactoryMessageBefore [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSEvent1.
	testCase addTargetClassName: #SEvent.
	expression := testCase addLiteral.
	self
		assert: (testCase newFactoryMessage: #SEvent before: expression) printString
		equals: 'SEvent price: _aSmallInteger1'.
	"default factoryMessage"
	testCase := SSTestCase with: utility typeInfoSFoo5.
	testCase addTargetClassName: #SFoo.
	self
		assert: (testCase newFactoryMessage: #SFoo before: nil) printString
		equals: 'SFoo new'
]

{ #category : #tests }
SSTestShifterTest >> testNewFactoryMessageUsingAnd [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSEvent1.
	testCase addTargetClassName: #SEvent.
	expression := testCase addLiteral.
	self
		assert: (testCase newFactoryMessageUsing: #SEvent and: expression) printString
		equals: 'SEvent price: _aSmallInteger1'.
	self assertCollection: testCase printStatements  hasSameElements: #('_aSmallInteger1 := 8.' '_aSmallInteger0 := 8.')
]

{ #category : #tests }
SSTestShifterTest >> testNewFieldAccessMessageOfTypeBefore [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo.
	expression := testCase addLiteral: #SmallInteger.
	self
		should: [ testCase newFieldAccessMessageOfType: #SmallInteger before: expression ]
		raise: SError.
	testCase
		addStatement:
			(testCase
				newAssignment: (testCase newFactoryMessage: #SFoo before: expression))
		before: expression.
	self
		assert:
			(testCase newFieldAccessMessageOfType: #SmallFloat64 before: expression)
				printString
		equals: '_aSFoo2 score'.
	self
		assertCollection: testCase printStatements
		hasSameElements: #('_aSmallFloat641 := 7.3.' '_aSFoo2 := SFoo score: _aSmallFloat641.' '_aSmallInteger0 := 5.')
]

{ #category : #tests }
SSTestShifterTest >> testNewMessageOfTypeBefore [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo.
	expression := testCase addLiteral: #SmallInteger.
	self
		should: [ testCase newMessageOfType: #SmallInteger before: expression ]
		raise: SError.
	testCase
		addStatement:
			(testCase
				newAssignment: (testCase newFactoryMessage: #SFoo before: expression))
		before: expression.
	self
		assert:
			(testCase newMessageOfType: #SmallInteger before: expression)
				printString
		equals: '_aSFoo2 returnNum'.
	self
		assertCollection: testCase printStatements
		hasSameElements: #('_aSmallFloat641 := 7.3.' '_aSFoo2 := SFoo score: _aSmallFloat641.' '_aSmallInteger0 := 5.')
]

{ #category : #tests }
SSTestShifterTest >> testNewStatementOfTypeBefore [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSEvent1.
	testCase addTargetClassName: #SEvent.
	expression := testCase
		newAssignment: (testCase newStatementOfType: #SmallInteger before: nil).
	testCase addStatement: expression before: nil.
	self
		assertCollection: testCase printStatements
		hasSameElements: #('_aSmallInteger0 := 8.').
	expression := testCase newStatementOfType: #SEvent before: expression.
	self assert: expression printString equals: 'SEvent price: _aSmallInteger1'.
	expression := testCase newAssignment: expression.
	testCase
		addStatement: expression
		before: (testCase statementOfVarName: '_aSmallInteger0').
	self
		assertCollection: testCase printStatements
		hasSameElements: #('_aSmallInteger1 := 8.' '_aSEvent2 := SEvent price: _aSmallInteger1.' '_aSmallInteger0 := 8.')
]

{ #category : #tests }
SSTestShifterTest >> testObjectVariables [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSSTeacher3.
	self assert: testCase objectVariables isEmpty.
	testCase
		addTargetClassName: #SSTeacher;
		addFactoryMessage.
	self
		assertCollection: (testCase objectVariables collect: #printString)
		hasSameElements: #('_aSSTeacher0')
]

{ #category : #tests }
SSTestShifterTest >> testPickAccessorsOf [
	| testCase |
	testCase := (SSTestCase with: utility typeInfoSSTeacher4)
		addTargetClassName: #SSTeacher.
	self
		assertCollection: ((testCase pickAccessorsOf: #SSTeacher) collect: #selector)
		hasSameElements: #(#yearsWorkExperience #idTeacher).
	testCase := (SSTestCase with: utility typeInfoSSTeacher3)
		addTargetClassName: #SSTeacher.
	self assert: (testCase pickAccessorsOf: #SSTeacher) isEmpty.
	
]

{ #category : #tests }
SSTestShifterTest >> testPickAccessorsOfWithInvalidClassName [
	| testCase |
	testCase := (SSTestCase with: utility typeInfoSSTeacher4)
		addTargetClassName: #SSTeacher.
	self assert: (testCase pickAccessorsOf: #SStudent) isEmpty
]

{ #category : #tests }
SSTestShifterTest >> testPickAnObjectVariable [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSSTeacher3.
	self should: [testCase  pickAnObjectVariable ] raise: SError.
	testCase addTargetClassName: #SSTeacher.
	self assert: testCase pickAnObjectVariable printString equals: '_aSSTeacher0'
]

{ #category : #tests }
SSTestShifterTest >> testPickFactoryMessagesFrom [
	| testCase |
	testCase := SSTestCase new.
	testCase typeInfo: utility typeInfoOnPackage2 .
	self
		should: [ testCase addMessage: #price: from: #SEvent ]
		raise: SError.
	testCase addFactoryMessage: #SConference ofSelector: #price:.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSmallInteger0 := 95.' '_aSConference1 := SConference price: _aSmallInteger0.')
]

{ #category : #tests }
SSTestShifterTest >> testPickMessagesOf [
	| testCase |
	testCase := SSTestCase with: utility typeInfoOnPackage2.
	self
		assert: ((testCase pickMessagesOf: #SEvent) collect: #selector) isEmpty.
	self
		assertCollection: ((testCase pickMessagesOf: #SConference) collect: #selector)
		hasSameElements: #(#price: #initialize).
	testCase := SSTestCase with: utility typeInfoOnPackage3.
	self
		assertCollection: ((testCase pickMessagesOf: #SSTeacher) collect: #selector)
		hasSameElements: #(#name: #id: #nickname: #initialize #nickname)
]

{ #category : #tests }
SSTestShifterTest >> testPickMessagesOfWrongClassName [
	| testCase |
	testCase := SSTestCase with: utility typeInfoOnPackage2.
	self assert: (testCase pickMessagesOf: #SSTeacher) isEmpty.
	testCase := SSTestCase with: utility typeInfoOnPackage3.
	self assert: (testCase pickMessagesOf: #SPerson) isEmpty.
	self assert: (testCase pickMessagesOf: #SStudent) isEmpty
]

{ #category : #tests }
SSTestShifterTest >> testPickOrCreateObjectVariableOf [
	| testCase |
	testCase := (SSTestCase with: utility typeInfoSFoo2)
		addTargetClassName: #SFoo.
	self assert: testCase statements isEmpty.
	self
		assert: (testCase pickOrCreateObjectVariableOf: #SFoo) printString
		equals: '_aSFoo0'.
	self assertCollection: (testCase statements collect: #printString) hasSameElements: #('_aSFoo0 := SFoo new.').
	testCase pickOrCreateObjectVariableOf: #SFoo.
	self assert: testCase statements size equals: 1
]

{ #category : #tests }
SSTestShifterTest >> testPickOrCreateObjectVariableOfWrongClassName [
	| testCase |
	testCase := (SSTestCase with: utility typeInfoSFoo2)
		addTargetClassName: #SFoo.
	self
		should: [ testCase pickOrCreateObjectVariableOf: #SSTeacher ]
		raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testRandomLiteralClassName [
	| testCase |
	testCase := SSTestCase
		with: (STypeInfo new scalar: #SmallInteger with: #(1 3 4)).
	self assert: testCase randomLiteralClassName equals: #SmallInteger.
	testCase := SSTestCase
		with:
			(STypeInfo new
				scalar: #ByteString with: #('hello');
				scalar: #SmallInteger with: #(1 5 6)).
	self
		assert:
			(#(#ByteString #SmallInteger)
				includes: testCase randomLiteralClassName)
]

{ #category : #tests }
SSTestShifterTest >> testRandomLiteralClassNameWithEmptyScalars [
	| testCase |
	testCase := SSTestCase with: STypeInfo new.
	self should: [ testCase randomLiteralClassName ] raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testSubStatementsFromToPrevIndexOf [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSEvent1.
	testCase addTargetClassName: #SEvent.
	self
		assert: (testCase subStatementsFrom: 1 toPrevIndexOf: nil) isEmpty.
	expression := testCase addLiteral.
	self
		assert: (testCase subStatementsFrom: 1 toPrevIndexOf: expression) isEmpty.
	expression := testCase addFactoryMessage.
	self
		assertCollection:
			((testCase subStatementsFrom: 1 toPrevIndexOf: expression)
				collect: #printString)
		hasSameElements: #('_aSmallInteger0 := 8.').
	expression := testCase addMessage: #discount: from: #SEvent.
	self
		assertCollection:
			((testCase subStatementsFrom: 1 toPrevIndexOf: expression)
				collect: #printString)
		hasSameElements: #('_aSmallInteger0 := 8.' '_aSEvent1 := SEvent price: _aSmallInteger0.').
	expression := testCase addFieldAccessMessage: #price from: #SEvent.
	self
		assertCollection:
			((testCase subStatementsFrom: 1 toPrevIndexOf: expression)
				collect: #printString)
		hasSameElements: #('_aSmallInteger0 := 8.' '_aSEvent1 := SEvent price: _aSmallInteger0.' '_aSEvent2 := _aSEvent1 discount: _aSmallInteger0.').
]

{ #category : #tests }
SSTestShifterTest >> testValidTargetClassName [
	| testCase |
	testCase := SSTestCase with: utility typeInfoOnPackage1.
	self should: [ testCase validTargetClassName: #SEvent ] raise: SError.
	testCase addTargetClassName: #SEvent.
	self
		shouldnt: [ testCase validTargetClassName: #SEvent ]
		raise: SError.
	self
		shouldnt: [ testCase validTargetClassName: #SConference ]
		raise: SError.
	self should: [ testCase validTargetClassName: #SStudent ] raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testValidTargetClassNameWithLackTypeInfo [
	| testCase |
	testCase := SSTestCase with: utility typeInfoOnPackage4.
	self should: [ testCase validTargetClassName: #SEvent ] raise: SError.
	testCase addTargetClassName: #SEvent.
	self
		shouldnt: [ testCase validTargetClassName: #SEvent ]
		raise: SError.
	self
		shouldnt: [ testCase validTargetClassName: #SConference ]
		raise: SError.
	self
		should: [ testCase validTargetClassName: #SParty ]
		raise: SError.
]
