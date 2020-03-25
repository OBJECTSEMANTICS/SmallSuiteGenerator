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
	SConfiguration randomGenerator: SConfiguration newRandomGenerator .
	SConfiguration fileLogger: 'STestShifterTestLogger.log'
]

{ #category : #running }
SSTestShifterTest >> tearDown [ 
	SConfiguration randomGenerator: SConfiguration newRandomGenerator .
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
		hasSameElements: #('_var0 := 4.' '_var1 := SFoo score: _var0.').
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
			#('_var0 := 4.' '_var1 := SFoo score: _var0.' '_var2 := #(1 3 2 ).' '_var3 := SStack newStack: _var2.')
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
		hasSameElements: #('_var0 := SFoo new.')
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
		hasSameElements: #('_var0 := 4.' '_var1 := SFoo score: _var0.')
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
			(#('_var2 := SSTeacher name: _var0 with: _var1.' '_var2 := SSTeacher name: _var1 with: _var0.')
				includes: expression printString).
	self
		shouldnt: [ expression := testCase addFactoryMessage: #SConference ]
		raise: SError.
	self
		assert: expression printString
		equals: '_var3 := SConference new.'
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
		equals: '_var1 := _var0 idTeacher.'.
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
		equals: '_var2 := _var1 score.'
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
		equals: '_var2 := _var1 score.'
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
				with: '_var0 := ''World''.'
				with:
					'_var1 := '
						,
							(OrderedCollection new
								add: 1;
								add: 4;
								yourself) storeString , '.'
				with: '_var2 := 2.'
				with: '_var3 := ' , SStudent new storeString , '.')
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
				with: '_var0 := SFoo new.'
				with: '_var1 := ' , (OrderedCollection newFrom: #(1 4 5)) storeString , '.'
				with: '_var2 := _var0 return: _var1.')
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
				with: '_var0 := 4.'
				with: '_var1 := SFoo score: _var0.'
				with: '_var2 := _var1 returnFloat.').
	self
		assert: (testCase addMessage: #returnNum from: #SFoo) printString
		equals: '_var3 := _var1 returnNum.'.
	self
		assert:
			(#('_var4 := _var1 score: _var0.' '_var4 := _var1 score: _var3.' '_var5 := _var1 score: _var3.' '_var5 := _var1 score: _var4.')
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
				with: '_var0 := SConference new.'
				with: '_var1 := ' , (SStudent new name: 'Mary') storeString , '.'
				with: '_var2 := _var0 canRegister: _var1.')
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
		equals: '_var1 := _var0 return: _var0.'
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
				add: '_var0 := SFoo new.';
				add: '_var1 := ((Dictionary new) add: (1->((SStack new) add: (SStudent basicNew yourself); add: (SStudent basicNew yourself); yourself)); add: (2->((OrderedCollection new) add: (SStudent basicNew yourself); yourself)); yourself).';
				add: '_var2 := _var0 return: _var1.';
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
			(
					(Array
						with:
							(OrderedCollection new
								add: '_var0 := SStack new.';
								add: '_var1 := ((OrderedCollection new) add: (SStudent basicNew yourself); add: (SStudent basicNew yourself); yourself).';
								add: '_var2 := _var0 push: _var1.';
								yourself)
						with:
							(OrderedCollection new
								add: '_var0 := SStack new.';
								add: '_var1 := ((OrderedCollection new) add: (SStudent basicNew yourself); yourself).';
								add: '_var2 := _var0 push: _var1.';
								yourself)) includes: (testCase statements collect: #printString))
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
		equals: '_var1 := SEvent price: _var0.'.
	expression := testCase
		addStatementOfType: #SmallInteger
		before: expression.
	self assert: expression printString equals: '_var2 := 8.'.	"change the form to select randomly"
	self
		assert:
			(#(#('_var0 := 8.' '_var2 := 8.' '_var1 := SEvent price: _var0.') #('_var2 := 8.' '_var0 := 8.' '_var1 := SEvent price: _var0.'))
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
			#('_var0 := 8.' '_var2 := 8.' '_var3 := SEvent price: _var2.' '_var1 := SEvent price: _var0.')
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
			(#('_var2 := SSTeacher name: _var0 with: _var1.' '_var2 := SSTeacher name: _var1 with: _var0.')
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
		hasSameElements: #('_var1 := 8.' '_var0 := 8.')
]

{ #category : #tests }
SSTestShifterTest >> testNewFactoryMessageBefore [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSEvent1.
	testCase addTargetClassName: #SEvent.
	expression := testCase addLiteral.
	self
		assert: (testCase newFactoryMessage: #SEvent before: expression) printString
		equals: 'SEvent price: _var1'.
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
		equals: 'SEvent price: _var1'.
	self assertCollection: testCase printStatements  hasSameElements: #('_var1 := 8.' '_var0 := 8.')
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
		equals: '_var2 score'.
	self
		assertCollection: testCase printStatements
		hasSameElements: #('_var1 := 7.3.' '_var2 := SFoo score: _var1.' '_var0 := 5.')
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
		equals: '_var2 returnNum'.
	self
		assertCollection: testCase printStatements
		hasSameElements: #('_var1 := 7.3.' '_var2 := SFoo score: _var1.' '_var0 := 5.')
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
		hasSameElements: #('_var0 := 8.').
	expression := testCase newStatementOfType: #SEvent before: expression.
	self assert: expression printString equals: 'SEvent price: _var1'.
	expression := testCase newAssignment: expression.
	testCase
		addStatement: expression
		before: (testCase statementOfVarName: '_var0').
	self
		assertCollection: testCase printStatements
		hasSameElements: #('_var1 := 8.' '_var2 := SEvent price: _var1.' '_var0 := 8.')
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
		hasSameElements: #('_var0')
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
	self assert: testCase pickAnObjectVariable printString equals: '_var0'
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
		hasSameElements: #('_var0 := 95.' '_var1 := SConference price: _var0.')
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
		equals: '_var0'.
	self assertCollection: (testCase statements collect: #printString) hasSameElements: #('_var0 := SFoo new.').
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
		hasSameElements: #('_var0 := 8.').
	expression := testCase addMessage: #discount: from: #SEvent.
	self
		assertCollection:
			((testCase subStatementsFrom: 1 toPrevIndexOf: expression)
				collect: #printString)
		hasSameElements: #('_var0 := 8.' '_var1 := SEvent price: _var0.' '_var2 := 8.').
	expression := testCase addFieldAccessMessage: #price from: #SEvent.
	self
		assertCollection:
			((testCase subStatementsFrom: 1 toPrevIndexOf: expression)
				collect: #printString)
		hasSameElements: #('_var0 := 8.' '_var1 := SEvent price: _var0.' '_var2 := 8.' '_var3 := _var1 discount: _var0.').
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
