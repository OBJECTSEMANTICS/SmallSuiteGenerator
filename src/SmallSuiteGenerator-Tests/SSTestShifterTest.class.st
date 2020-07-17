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
	SPlatform resetRandomGenerator.
	utility := SUtilityTypeInfo new.
	SPlatform fileLogger: 'STestShifterTestLogger.log'
]

{ #category : #running }
SSTestShifterTest >> tearDown [ 
	SPlatform resetRandomGenerator
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
		targetClassName: (self fullSymbolOf: #SFoo);
		addFactoryMessage: (self fullSymbolOf: #SFoo).
	self assert: testCase statements size equals: 2.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array with: '_var0 := 4.'
									with: '_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.').
	self should: [ testCase addFactoryMessage: (self fullSymbolOf: #SStack) ] raise: SError.
	aTypeInfo
		type:
			(self fullSymbolOf: #SStack)
				->
					(Array
						with: (Array with: #top -> (Array
																with: (self fullSymbolOf: #SStack)
																with: nil 
																with: #()
																with: false))
						with: (Array with: #newStack: -> (Array
																with: (self fullSymbolOf: #SStack)
																with: (self fullSymbolOf: #SStack)
																with: (Array with: (self fullSymbolOf: #Array))
																with: false)));
		scalar: (self fullSymbolOf:#Array) with: #(#(1 3 2)).
	testCase
		targetClassName: (self fullSymbolOf:#SStack);
		addFactoryMessage: (self fullSymbolOf:#SStack).
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array with: '_var0 := 4.'
					with: '_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.'
					with: '_var2 := #(1 3 2 ).'
					with: '_var3 := ', (self fullNameOfClass: 'SStack')asString,' newStack: _var2.')
]

{ #category : #tests }
SSTestShifterTest >> testAddFactoryMessageOfInexistentSelector [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo2.
	testCase
		targetClassName: (self fullSymbolOf: #SFoo);
		addFactoryMessage: (self fullSymbolOf: #SFoo) ofSelector: #score:.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array with: '_var0 := ', (self fullNameOfClass: 'SFoo')asString,' new.')
]

{ #category : #tests }
SSTestShifterTest >> testAddFactoryMessageOfSelector [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo3.
	testCase
		targetClassName: (self fullSymbolOf: #SFoo);
		addFactoryMessage: (self fullSymbolOf: #SFoo) ofSelector: #score:.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array with:'_var0 := 4.'
		with: '_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.')
]

{ #category : #tests }
SSTestShifterTest >> testAddFactoryMessageOnPackage [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoOnPackage3.
	self should: [ testCase addFactoryMessage: (self fullSymbolOf: #SSTeacher) ] raise: SError.
	testCase targetClassName:  (self fullSymbolOf: #SSTeacher).
	expression := testCase addFactoryMessage:  (self fullSymbolOf: #SSTeacher).
	self
		assert:
			((Array with: '_var2 := ', (self fullNameOfClass: 'SSTeacher')asString,' name: _var0 with: _var1.'
			with: '_var2 := ', (self fullNameOfClass: 'SSTeacher')asString,' name: _var1 with: _var0.')
				includes: expression printString).
	self
		shouldnt: [ expression := testCase addFactoryMessage: (self fullSymbolOf: #SConference) ]
		raise: SError.
	self
		assert: expression printString
		equals: '_var3 := ', (self fullNameOfClass: 'SConference')asString,' new.'
]

{ #category : #tests }
SSTestShifterTest >> testAddFactoryMessageWithAbstractClasses [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSSPerson1.
	self should: [ testCase addFactoryMessage ] raise: SError.
	self should: [ testCase addFactoryMessage: (self fullNameOfClass: #SSPerson) ] raise: SError.
	testCase := SSTestCase with: utility typeInfoSAbstractClass.
	self should: [ testCase addFactoryMessage ] raise: SError.
	self
		should: [ testCase addFactoryMessage: (self fullNameOfClass: #SAbstractClass) ]
		raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessage [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSSTeacher2.
	self should: [ testCase addFieldAccessMessage ] raise: SError.
	testCase targetClassName: (self fullSymbolOf: #SSTeacher).
	self
		assert: testCase addFieldAccessMessage printString
		equals: '_var1 := _var0 idTeacher.'.
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessageFrom [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo3.
	self
		should: [ testCase addFieldAccessMessage: #score from: (self fullSymbolOf:#SFoo) ]
		raise: SError.
	testCase targetClassName: (self fullSymbolOf:#SFoo).
	self
		assert: (testCase addFieldAccessMessage: #score from: (self fullSymbolOf:#SFoo)) printString
		equals: '_var2 := _var1 score.'
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessageFromWithError [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo2.
	self
		should: [ testCase addFieldAccessMessage: #score from: (self fullSymbolOf:#SFoo) ]
		raise: SError.
	testCase targetClassName: (self fullSymbolOf:#SFoo).
	self
		should: [testCase addFieldAccessMessage: #score from: (self fullSymbolOf:#SFoo)]
		raise: SError.
	self
		should: [ testCase addFieldAccessMessage: #return: from: (self fullSymbolOf:#SFoo) ]
		raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessageFromWithInvalidClassName [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo4.
	testCase targetClassName: (self fullSymbolOf:#SFoo).
	self
		should: [ testCase addFieldAccessMessage: #score from: (self fullSymbolOf:#SStudent) ]
		raise: SError.
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessageWithLackTypeInfo [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSSTeacher3.
	self should: [ testCase addFieldAccessMessage ] raise: SError.
	testCase targetClassName: (self fullSymbolOf:#SSTeacher).
	self should: [testCase addFieldAccessMessage] raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessageWithReceiver [
	| testCase typeInfo receiver |
	typeInfo := utility typeInfoSFoo1.
	testCase := (SSTestCase with: typeInfo) targetClassName: (self fullSymbolOf: #SFoo).
	receiver := testCase addFactoryMessage variable.
	self
		assert:
			(testCase
				addFieldAccessMessage: (typeInfo accessMessagesFrom: (self fullSymbolOf: #SFoo)) first
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
		targetClassName: (self fullSymbolOf: #SFoo);
		addMessage.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_var0 := ',(self fullNameOfClass: 'SFoo')asString,' new.'
				with: '_var1 := ' , (OrderedCollection newFrom: #(1 4 5)) storeString , '.'
				with: '_var2 := _var0 return: _var1.')
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageFrom [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo3.
	testCase
		targetClassName: (self fullSymbolOf: #SFoo);
		addMessage: #returnFloat from: (self fullSymbolOf: #SFoo).
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_var0 := 4.'
				with: '_var1 := ',(self fullNameOfClass: 'SFoo')asString,' score: _var0.'
				with: '_var2 := _var1 returnFloat.').
	self
		assert: (testCase addMessage: #returnNum from: (self fullSymbolOf: #SFoo)) printString
		equals: '_var3 := _var1 returnNum.'.
	self
		assert:
			(#('_var4 := _var1 score: _var0.' '_var4 := _var1 score: _var3.' '_var5 := _var1 score: _var3.' '_var5 := _var1 score: _var4.')
				includes: (testCase addMessage: #score: from:  (self fullSymbolOf: #SFoo)) printString)
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageFromDifferentReceiver [
	| testCase |
	testCase := (SSTestCase
		with: utility typeInfoOnPackage1)
		targetClassName: (self fullSymbolOf: #SEvent).
	self
		should: [ testCase addMessage: #canRegister: from: (self fullSymbolOf: #SEvent) ]
		raise: SError.
	testCase targetClassName: (self fullSymbolOf: #SConference).
	testCase addMessage: #canRegister: from:  (self fullSymbolOf: #SConference).
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_var0 := ',(self fullNameOfClass: 'SConference')asString,' new.'
				with: '_var1 := ' , (SStudent new name: 'Mary') storeString , '.'
				with: '_var2 := _var0 canRegister: _var1.')
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageWithEmptyTypeMethodInfo [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFooEmpty.
	testCase targetClassName: (self fullSymbolOf: #SFoo).
	self should: [ testCase addMessage ] raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageWithReceiver [
	| testCase typeInfo receiver |
	typeInfo := utility typeInfoSFoo2.
	testCase := (SSTestCase with: typeInfo) targetClassName: (self fullSymbolOf: #SFoo).
	receiver := testCase addFactoryMessage variable.
	self
		assert:
			(testCase
				addMessage: (typeInfo messagesFrom: (self fullSymbolOf: #SFoo)) first
				withReceiver: receiver) printString
		equals: '_var1 := _var0 return: _var0.'
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageWithTwoDeepScalarSFoo [
	| testCase |
	testCase := SSTestCase
		with: utility typeInfoSFooOnPackage3."(STON fromString: utility typeInfoStringSFoo6)."
	testCase
		targetClassName: (self fullSymbolOf: #SFoo);
		addMessage: #return: from: (self fullSymbolOf: #SFoo).
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(OrderedCollection new
				add: '_var0 := ', (self fullNameOfClass: 'SFoo')asString,' new.';
				add: '_var1 := ' , (SStudent name: 'Lian' with: 1) storeString , '.';
				add: '_var2 := ', (self fullNameOfClass: 'SStack')asString,' new.';
				add: '_var3 := _var2 push: _var1.';
				add: '_var4 := ' , (SStudent name: 'Josh' with: 2) storeString , '.';
				add: '_var5 := _var2 push: _var4.';
				add: '_var6 := ' , (SStudent name: 'Mery' with: 5) storeString , '.';
				add: '_var7 := ((OrderedCollection new) add: _var6; yourself).';
				add:
					'_var8 := ((Dictionary new) add: (1->_var5); add: (2->_var7); yourself).';
				add: '_var9 := _var0 return: _var8.';
				yourself)
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageWithTwoDeepScalarSStack [
	| testCase |
	testCase := SSTestCase
		with: utility typeInfoSStackOnPackage2."(STON fromString: utility typeInfoStringSStack1)".
	testCase
		targetClassName: (self fullSymbolOf: #SStack);
		addMessage: #push: from: (self fullSymbolOf: #SStack).
	self assert: testCase statements size equals: 3.
	self
		assert:
			((testCase statements collect: #printString)
				includesAny:
					(Array
						with:
							(OrderedCollection new
								add: '_var0 := SStack new.';
								add: '_var1 := ' , (SStudent name: 'Lian' with: 1) storeString , '.';
								add: '_var2 := ' , (SStudent name: 'Josh' with: 2) storeString , '.';
								add: '_var3 := ((OrderedCollection new) add: _var1; add: _var2; yourself).';
								add: '_var4 := _var0 push: _var3.';
								yourself)
						with:
							(OrderedCollection new
								add: '_var0 := SStack new.';
								add: '_var1 := ' , (SStudent name: 'Mery' with: 5) storeString , '.';
								add: '_var2 := ((OrderedCollection new) add: _var1; yourself).';
								add: '_var3 := _var0 push: _var2.';
								yourself)))
]

{ #category : #tests }
SSTestShifterTest >> testAddStatementAfter [
	| testCase expression1 expression2 |
	testCase := SSTestCase with: utility typeInfoSSTeacher1.
	expression1 := SAssignment
		name: (SVariable new id: 0)
		value: ((SLiteral value: 2) returnType: (self fullSymbolOf: #SmallInteger)).
	self
		assert: (testCase addStatement: expression1 after: nil) printString
		equals: '_var0 := 2.'.
	expression2 := SAssignment
		name: (SVariable new id: 1)
		value: (SFactoryMessage default: (self fullSymbolOf: #SSTeacher)).
	self
		assert: (testCase addStatement: expression2 after: expression1) printString
		equals: '_var1 := ',(self fullNameOfClass: 'SSTeacher')asString,' new.'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array with: '_var0 := 2.'
									with: '_var1 := ',(self fullNameOfClass: 'SSTeacher')asString,' new.').
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
		hasSameElements: (Array with: '_var0 := 2.'
									with: '_var1 := ',(self fullNameOfClass: 'SSTeacher')asString,' new.'
									with: '_var2 := _var1 yearsWorkExperience.').
	expression2 := SAssignment
		name: (SVariable new id: 3)
		value: (SLiteral value: 4).
	testCase addStatement: expression2 after: expression1.
	self
		assert:
			((Array
				with:
					(Array with: '_var0 := 2.'
						with: '_var1 := ',(self fullNameOfClass: 'SSTeacher')asString,' new.'
						with: '_var2 := _var1 yearsWorkExperience.'
						with: '_var3 := 4.')
				with:
					(Array with: '_var0 := 2.'
						with: '_var1 := ',(self fullNameOfClass: 'SSTeacher')asString,' new.'
						with: '_var3 := 4.'
						with: '_var2 := _var1 yearsWorkExperience.'))
				includes: (testCase statements collect: #printString) asArray)
]

{ #category : #tests }
SSTestShifterTest >> testAddStatementBefore [
	| testCase expression1 expression2 |
	testCase := SSTestCase new.
	expression1 := SAssignment
		name: (SVariable new id: 0)
		value: ((SLiteral value: 2) returnType:  (self fullSymbolOf:#SmallInteger)).
	testCase addStatement: expression1 before: nil.
	expression2 := SAssignment
		name: (SVariable new id: 1)
		value: (SFactoryMessage default:  (self fullSymbolOf:#SSTeacher)).
	testCase addStatement: expression2 before: expression1.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array with: '_var1 := ',(self fullNameOfClass: 'SSTeacher')asString,' new.'
									with: '_var0 := 2.').
	expression1 := expression2.
	expression2 := SAssignment
		name: (SVariable new id: 2)
		value: ((SLiteral value: 100) returnType:  (self fullSymbolOf:#SmallInteger)).
	testCase addStatement: expression2 before: expression1.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array with: '_var2 := 100.'
									with: '_var1 := ',(self fullNameOfClass: 'SSTeacher')asString,' new.'
									with: '_var0 := 2.').
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
			(Array with: '_var2 := 100.'
				with: '_var1 := ',(self fullNameOfClass: 'SSTeacher')asString,' new.'
				with: '_var3 := _var1 yearsWorkExperience.'
				with: '_var0 := 2.')
]

{ #category : #tests }
SSTestShifterTest >> testAddStatetementOfTypeBefore [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSEvent1.
	testCase targetClassName: (self fullSymbolOf:#SEvent).
	expression := testCase addStatementOfType: (self fullSymbolOf:#SEvent) before: nil.
	self
		assert: expression printString
		equals: '_var1 := ',(self fullNameOfClass: 'SEvent')asString,' price: _var0.'.
	expression := testCase
		addStatementOfType: (self fullSymbolOf:#SmallInteger)
		before: expression.
	self assert: expression printString equals: '_var2 := 8.'.	"change the form to select randomly"
	self
		assert:
			((Array with: (Array with: '_var0 := 8.'
						with: '_var2 := 8.'
						with: '_var1 := ',(self fullNameOfClass: 'SEvent')asString,' price: _var0.') 
					with: (Array with: '_var2 := 8.'
						with: '_var0 := 8.'
						with: '_var1 := ',(self fullNameOfClass: 'SEvent')asString,' price: _var0.'))
				includes: (testCase statements collect: #printString) asArray)
]

{ #category : #tests }
SSTestShifterTest >> testAddStatetementOfTypeBeforeFactoryMessage [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSEvent1.
	testCase targetClassName: (self fullSymbolOf:#SEvent).
	expression := testCase addFactoryMessage.
	expression := testCase addStatementOfType: (self fullSymbolOf:#SEvent) before: expression.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array with: '_var0 := 8.'
				with: '_var2 := ',(self fullNameOfClass: 'SEvent')asString,' price: _var0.'
				with: '_var1 := ',(self fullNameOfClass: 'SEvent')asString,' price: _var0.')
]

{ #category : #tests }
SSTestShifterTest >> testAddTargetClassName [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoOnPackage3.
	self should: [testCase targetClassName: (self fullSymbolOf:#SEvent)] raise: SError.
	self shouldnt: [testCase targetClassName: (self fullSymbolOf:#SSTeacher)] raise: SError.
	expression := testCase addFactoryMessage: (self fullSymbolOf:#SSTeacher).
	self
		assert:
			((Array with:'_var2 := ',(self fullNameOfClass: 'SSTeacher')asString,' name: _var0 with: _var1.'
			with: '_var2 := ',(self fullNameOfClass: 'SSTeacher')asString,' name: _var1 with: _var0.')
				includes: expression printString).
]

{ #category : #tests }
SSTestShifterTest >> testBuildArgsBefore [
	| testCase typeInfo expression |
	typeInfo := utility typeInfoSEvent1.
	testCase := SSTestCase with: typeInfo.
	testCase targetClassName: (self fullSymbolOf:#SEvent).
	expression := testCase addLiteral.
	testCase buildArgs: ((typeInfo factoryMessagesFrom: (self fullSymbolOf:#SEvent)) first argTypes)  before: expression.
	self
		assertCollection: (testCase printStatements )
		hasSameElements: #('_var1 := 8.' '_var0 := 8.')
]

{ #category : #tests }
SSTestShifterTest >> testNewFactoryMessageBefore [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSEvent1.
	testCase targetClassName: (self fullSymbolOf:#SEvent).
	expression := testCase addLiteral.
	self
		assert: (testCase newFactoryMessage: (self fullSymbolOf:#SEvent) before: expression) printString
		equals: (self fullNameOfClass: 'SEvent')asString,' price: _var1'.
	"default factoryMessage"
	testCase := SSTestCase with: utility typeInfoSFoo5.
	testCase targetClassName: (self fullSymbolOf:#SFoo).
	self
		assert: (testCase newFactoryMessage: (self fullSymbolOf:#SFoo) before: nil) printString
		equals: (self fullNameOfClass: 'SFoo')asString,' new'
]

{ #category : #tests }
SSTestShifterTest >> testNewFactoryMessageUsingAnd [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSEvent1.
	testCase targetClassName:  (self fullSymbolOf:#SEvent).
	expression := testCase addLiteral.
	self
		assert: (testCase newFactoryMessageUsing:  (self fullSymbolOf:#SEvent) and: expression) printString
		equals: (self fullNameOfClass: 'SEvent')asString,' price: _var1'.
	self assertCollection: testCase printStatements  hasSameElements: #('_var1 := 8.' '_var0 := 8.')
]

{ #category : #tests }
SSTestShifterTest >> testNewFieldAccessMessageOfTypeBefore [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase targetClassName: (self fullSymbolOf:#SFoo).
	expression := testCase addLiteral:(self fullSymbolOf: #SmallInteger).
	self
		should: [ testCase newFieldAccessMessageOfType: (self fullSymbolOf:#SmallInteger) before: expression ]
		raise: SError.
	testCase
		addStatement:
			(testCase
				newAssignment: (testCase newFactoryMessage: (self fullSymbolOf:#SFoo) before: expression))
		before: expression.
	self
		assert:
			(testCase newFieldAccessMessageOfType: (self fullSymbolOf:#SmallFloat64) before: expression)
				printString
		equals: '_var2 score'.
	self
		assertCollection: testCase printStatements
		hasSameElements: (Array with: '_var1 := 7.3.'
									with: '_var2 := ',(self fullNameOfClass: 'SFoo')asString,' score: _var1.'
									with: '_var0 := 5.')
]

{ #category : #tests }
SSTestShifterTest >> testNewMessageOfTypeBefore [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase targetClassName: (self fullSymbolOf: #SFoo).
	expression := testCase addLiteral: (self fullSymbolOf: #SmallInteger).
	self
		should: [ testCase newMessageOfType: (self fullSymbolOf:#SmallInteger) before: expression ]
		raise: SError.
	testCase
		addStatement:
			(testCase
				newAssignment: (testCase newFactoryMessage: (self fullSymbolOf:#SFoo) before: expression))
		before: expression.
	self
		assert:
			(testCase newMessageOfType: (self fullSymbolOf:#SmallInteger) before: expression)
				printString
		equals: '_var2 returnNum'.
	self
		assertCollection: testCase printStatements
		hasSameElements: (Array with: '_var1 := 7.3.'
									with: '_var2 := ',(self fullNameOfClass: 'SFoo')asString,' score: _var1.'
									with: '_var0 := 5.')
]

{ #category : #tests }
SSTestShifterTest >> testNewStatementOfTypeBefore [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSEvent1.
	testCase targetClassName: (self fullSymbolOf: #SEvent).
	expression := testCase
		newAssignment: (testCase newStatementOfType: (self fullSymbolOf: #SmallInteger) before: nil).
	testCase addStatement: expression before: nil.
	self
		assertCollection: testCase printStatements
		hasSameElements: #('_var0 := 8.').
	expression := testCase newStatementOfType: (self fullSymbolOf: #SEvent) before: expression.
	self assert: expression printString equals: (self fullNameOfClass: 'SEvent')asString,' price: _var1'.
	expression := testCase newAssignment: expression.
	testCase
		addStatement: expression
		before: (testCase statementOfVarName: '_var0').
	self
		assertCollection: testCase printStatements
		hasSameElements: (Array with: '_var1 := 8.'
									with: '_var2 := ',(self fullNameOfClass: 'SEvent')asString,' price: _var1.'
									with: '_var0 := 8.')
]

{ #category : #tests }
SSTestShifterTest >> testObjectVariables [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSSTeacher3.
	self assert: testCase objectVariables isEmpty.
	testCase
		targetClassName: (self fullSymbolOf:#SSTeacher);
		addFactoryMessage.
	self
		assertCollection: (testCase objectVariables collect: #printString)
		hasSameElements: #('_var0')
]

{ #category : #tests }
SSTestShifterTest >> testPickAccessorsOf [
	| testCase |
	testCase := (SSTestCase with: utility typeInfoSSTeacher4)
		targetClassName: (self fullSymbolOf:#SSTeacher).
	self
		assertCollection: ((testCase pickAccessorsOf: (self fullSymbolOf:#SSTeacher)) collect: #selector)
		hasSameElements: #(#yearsWorkExperience #idTeacher).
	testCase := (SSTestCase with: utility typeInfoSSTeacher3)
		targetClassName: (self fullSymbolOf:#SSTeacher).
	self assert: (testCase pickAccessorsOf: (self fullSymbolOf:#SSTeacher)) isEmpty.
	
]

{ #category : #tests }
SSTestShifterTest >> testPickAccessorsOfWithInvalidClassName [
	| testCase |
	testCase := (SSTestCase with: utility typeInfoSSTeacher4)
		targetClassName: (self fullSymbolOf:#SSTeacher).
	self assert: (testCase pickAccessorsOf: (self fullSymbolOf:#SStudent)) isEmpty
]

{ #category : #tests }
SSTestShifterTest >> testPickAnObjectVariable [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSSTeacher3.
	self should: [testCase  pickAnObjectVariable ] raise: SError.
	testCase targetClassName: (self fullSymbolOf:#SSTeacher).
	self assert: testCase pickAnObjectVariable printString equals: '_var0'
]

{ #category : #tests }
SSTestShifterTest >> testPickFactoryMessagesFrom [
	| testCase |
	testCase := SSTestCase new.
	testCase typeInfo: utility typeInfoOnPackage2 .
	self
		should: [ testCase addMessage: #price: from: (self fullSymbolOf:#SEvent) ]
		raise: SError.
	testCase targetClassName: (self fullSymbolOf:#SConference).
	testCase addFactoryMessage: (self fullSymbolOf:#SConference) ofSelector: #price:.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array with: '_var0 := 95.'
		with: '_var1 := ',(self fullNameOfClass: 'SConference')asString,' price: _var0.')
]

{ #category : #tests }
SSTestShifterTest >> testPickMessagesOf [
	| testCase |
	testCase := SSTestCase with: utility typeInfoOnPackage2.
	self
		assert: ((testCase pickMessagesOf: (self fullSymbolOf:#SEvent)) collect: #selector) isEmpty.
	self
		assertCollection: ((testCase pickMessagesOf: (self fullSymbolOf:#SConference)) collect: #selector)
		hasSameElements: #(#price: #initialize).
	testCase := SSTestCase with: utility typeInfoOnPackage3.
	self
		assertCollection: ((testCase pickMessagesOf: (self fullSymbolOf:#SSTeacher)) collect: #selector)
		hasSameElements: #(#name: #id: #nickname: #initialize #nickname)
]

{ #category : #tests }
SSTestShifterTest >> testPickMessagesOfWrongClassName [
	| testCase |
	testCase := SSTestCase with: utility typeInfoOnPackage2.
	self assert: (testCase pickMessagesOf: (self fullSymbolOf:#SSTeacher)) isEmpty.
	testCase := SSTestCase with: utility typeInfoOnPackage3.
	self assert: (testCase pickMessagesOf: (self fullSymbolOf:#SSPerson)) isEmpty.
	self assert: (testCase pickMessagesOf: (self fullSymbolOf:#SStudent)) isEmpty
]

{ #category : #tests }
SSTestShifterTest >> testPickOrCreateObjectVariableOf [
	| testCase |
	testCase := (SSTestCase with: utility typeInfoSFoo2)
		targetClassName: (self fullSymbolOf:#SFoo).
	self assert: testCase statements isEmpty.
	self
		assert: (testCase pickOrCreateObjectVariableOf: (self fullSymbolOf:#SFoo)) printString
		equals: '_var0'.
	self assertCollection: (testCase statements collect: #printString) hasSameElements: (Array with: '_var0 := ',(self fullNameOfClass: 'SFoo')asString,' new.').
	testCase pickOrCreateObjectVariableOf: (self fullSymbolOf:#SFoo).
	self assert: testCase statements size equals: 1
]

{ #category : #tests }
SSTestShifterTest >> testPickOrCreateObjectVariableOfWrongClassName [
	| testCase |
	testCase := (SSTestCase with: utility typeInfoSFoo2)
		targetClassName: (self fullSymbolOf:#SFoo).
	self
		should: [ testCase pickOrCreateObjectVariableOf: (self fullSymbolOf:#SSTeacher) ]
		raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testRandomLiteralClassName [
	| testCase |
	testCase := SSTestCase
		with: (STypeInfo new scalar: (self fullSymbolOf:#SmallInteger) with: #(1 3 4)).
	self assert: testCase randomLiteralClassName equals: (self fullSymbolOf:#SmallInteger).
	testCase := SSTestCase
		with:
			(STypeInfo new
				scalar: (self fullSymbolOf:#ByteString) with: #('hello');
				scalar: (self fullSymbolOf:#SmallInteger) with: #(1 5 6)).
	self
		assert:
			((Array with: (self fullSymbolOf:#ByteString) with: (self fullSymbolOf:#SmallInteger))
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
	testCase targetClassName: (self fullSymbolOf:#SEvent).
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
		hasSameElements: #('_var0 := 8.' '_var1 := 8.').
	expression := testCase addMessage: #discount: from: (self fullSymbolOf:#SEvent).
	self
		assertCollection:
			((testCase subStatementsFrom: 1 toPrevIndexOf: expression)
				collect: #printString)
		hasSameElements: (Array with: '_var0 := 8.'
									with: '_var1 := 8.'
									with: '_var2 := ',(self fullNameOfClass: 'SEvent')asString,' price: _var0.'
									with: '_var3 := 8.').
	expression := testCase addFieldAccessMessage: #price from: (self fullSymbolOf:#SEvent).
	self
		assertCollection:
			((testCase subStatementsFrom: 1 toPrevIndexOf: expression)
				collect: #printString)
		hasSameElements: (OrderedCollection new add: '_var0 := 8.';
									add: '_var1 := 8.';
									add: '_var2 := ',(self fullNameOfClass: 'SEvent')asString,' price: _var0.';
									add: '_var3 := 8.';
									add: '_var4 := _var2 discount: _var1.'; yourself).
]

{ #category : #tests }
SSTestShifterTest >> testValidTargetClassName [
	| testCase |
	testCase := SSTestCase with: utility typeInfoOnPackage1.
	self should: [ testCase validTargetClassName: (self fullSymbolOf:#SEvent) ] raise: SError.
	testCase targetClassName: (self fullSymbolOf:#SEvent).
	self
		shouldnt: [ testCase validTargetClassName: (self fullSymbolOf:#SEvent) ]
		raise: SError.
	self
		shouldnt: [ testCase validTargetClassName: (self fullSymbolOf:#SConference) ]
		raise: SError.
	self shouldnt: [ testCase validTargetClassName: (self fullSymbolOf:#SStudent) ] raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testValidTargetClassNameWithLackTypeInfo [
	| testCase |
	testCase := SSTestCase with: utility typeInfoOnPackage4.
	self should: [ testCase validTargetClassName: (self fullSymbolOf:#SEvent) ] raise: SError.
	testCase targetClassName: (self fullSymbolOf:#SEvent).
	self
		shouldnt: [ testCase validTargetClassName: (self fullSymbolOf:#SEvent) ]
		raise: SError.
	self
		shouldnt: [ testCase validTargetClassName: (self fullSymbolOf:#SConference) ]
		raise: SError.
	self
		should: [ testCase validTargetClassName: (self fullSymbolOf:#SParty) ]
		raise: SError.
]
