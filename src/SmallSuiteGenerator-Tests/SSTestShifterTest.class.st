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
	self assert: expression printString equals: '_var0 := 3'.
	expression := testCase
		addAssignment:
			(SMessage new
				receiver: (SVariable new id: 0);
				selector: #foo;
				yourself).
	self assert: expression printString equals: '_var1 := _var0 foo'
]

{ #category : #tests }
SSTestShifterTest >> testAddFactoryMessage [
	| testCase aTypeInfo targetClass stackSymbol arraySymbol|
	targetClass := #SFoo fullClassNameSymbol.
	stackSymbol := #SStack fullClassNameSymbol.
	arraySymbol := #Array fullClassNameSymbol.
	aTypeInfo := utility typeInfoSFoo3.
	testCase := SSTestCase with: aTypeInfo.
	testCase
		targetClassName: targetClass;
		addFactoryMessage: targetClass.
	self assert: testCase statements size equals: 2.
	self
		assertCollection: (testCase statements collect: #printString) asArray
		hasSameElements: (Array with: '_var0 := 4'
									with: '_var1 := ', targetClass asString,' score: _var0 ').
	self should: [ testCase addFactoryMessage: stackSymbol ] raise: SError.
	aTypeInfo
		type:
			stackSymbol
				->
					(Array
						with: (Array with: #top -> (Array
																with: stackSymbol
																with: nil 
																with: #()
																with: false))
						with: (Array with: #newStack: -> (Array
																with: stackSymbol
																with: stackSymbol
																with: (Array with: arraySymbol)
																with: false)));
		scalar: arraySymbol with: #(#(1 3 2)).
	testCase
		targetClassName: stackSymbol;
		addFactoryMessage: stackSymbol.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array with: '_var0 := 4'
					with: '_var1 := ', targetClass asString,' score: _var0 '
					with: '_var2 := #(1 3 2 )'
					with: '_var3 := ', stackSymbol asString,' newStack: _var2 ')
]

{ #category : #tests }
SSTestShifterTest >> testAddFactoryMessageOfInexistentSelector [
	| testCase targetClass typeInfo|
	
	targetClass := 'SFoo' fullClassName.
	typeInfo := utility typeInfoSFoo2.
	testCase := SSTestCase with: typeInfo.
	testCase targetClassName: targetClass asSymbol.
	self should:[ testCase addFactoryMessage: targetClass asSymbol usingSelector: #score:.] 
			raise: SError.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #()
]

{ #category : #tests }
SSTestShifterTest >> testAddFactoryMessageOfSelector [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo3.
	testCase
		targetClassName: 'SFoo' fullClassNameSymbol;
		addFactoryMessage: 'SFoo' fullClassNameSymbol usingSelector: #score:.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: { '_var0 := 4'.
								'_var1 := ', 'SFoo' fullClassName,' score: _var0 '}
]

{ #category : #tests }
SSTestShifterTest >> testAddFactoryMessageOnPackage [
	| testCase expression targetClass targetClassName|
	targetClass := 'SSTeacher' fullClassNameSymbol.
	targetClassName := 'SSTeacher' fullClassName.
	testCase := SSTestCase with: utility typeInfoOnPackage3.
	testCase targetClassName:  targetClass.
	expression := testCase addFactoryMessage:  targetClass .
	self assert: '_var2 := ',targetClassName,' name: _var0 with: _var1 ' equals: expression printString.
	self
		shouldnt: [ expression := testCase addFactoryMessage: (#SConference fullClassNameSymbol ) ]
		raise: SError.
	self
		assert: expression printString
		equals: '_var3 := ', 'SConference' fullClassName,' new'
]

{ #category : #tests }
SSTestShifterTest >> testAddFactoryMessageWithAbstractClasses [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSSPerson1.
	self should: [ testCase addFactoryMessage ] raise: SError.
	self should: [ testCase addFactoryMessage: #SSPerson fullClassName ] raise: SError.
	testCase := SSTestCase with: utility typeInfoSAbstractClass.
	self should: [ testCase addFactoryMessage ] raise: SError.
	self
		should: [ testCase addFactoryMessage: #SAbstractClass fullClassName ]
		raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessage [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSSTeacher2.
	self
		assert: testCase addFieldAccessMessage printString
		equals: '_var1 := _var0 idTeacher'.
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessageFrom [
	| testCase targetClass |
	targetClass := #SFoo fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo3.
	self
		assert: (testCase addFieldAccessMessage: #score from: targetClass) printString
		equals: '_var2 := _var1 score'
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessageFromWithError [
	| testCase targetClass |
	targetClass := #SFoo fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo2.
	self
		should: [ testCase addFieldAccessMessage: #score from: targetClass ]
		raise: SError.
	testCase targetClassName: targetClass.
	self
		should: [testCase addFieldAccessMessage: #score from: targetClass]
		raise: SError.
	self
		should: [ testCase addFieldAccessMessage: #return: from: targetClass ]
		raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessageFromWithInvalidClassName [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo4.
	testCase targetClassName: #SFoo fullClassNameSymbol.
	self
		should: [ testCase addFieldAccessMessage: #score from: #SStudent fullClassNameSymbol ]
		raise: SError.
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessageWithLackTypeInfo [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSSTeacher3.
	self should: [ testCase addFieldAccessMessage ] raise: SError.
	testCase targetClassName: #SSTeacher fullClassNameSymbol.
	self should: [testCase addFieldAccessMessage] raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testAddFieldAccessMessageWithReceiver [
	| testCase typeInfo receiver targetClass |
	targetClass := #SFoo fullClassNameSymbol.
	typeInfo := utility typeInfoSFoo1.
	testCase := (SSTestCase with: typeInfo) targetClassName: targetClass.
	receiver := testCase addFactoryMessage variable.
	self
		assert:
			(testCase
				addFieldAccessMessage: (typeInfo accessMessagesFrom: targetClass) first
				withReceiver: receiver) printString
		equals: '_var2 := _var1 score'
]

{ #category : #tests }
SSTestShifterTest >> testAddInvalidAssignment [
	| testCase |
	testCase := SSTestCase new.
	self should: [ testCase addAssignment: 3 ] raise: Error.
	self should: [ testCase addAssignment: 'hello' ] raise: Error.
	self should: [ testCase addAssignment: #name ] raise: Error.
	self should: [ testCase addAssignment: 3.4 ] raise: Error.
	self should: [ testCase addAssignment: #() ] raise: Error.
]

{ #category : #tests }
SSTestShifterTest >> testAddLiteral [
	| testCase aTypeInfo collSymbol stringSymbol intSymbol studentSymbol |
	collSymbol := #OrderedCollection fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	studentSymbol := #SStudent fullClassNameSymbol.
	aTypeInfo := STypeInfo new.
	aTypeInfo
		scalar: collSymbol
			with: (Array with: (OrderedCollection newFrom: #(1 4)));
		scalar: stringSymbol with: #('World');
		scalar: intSymbol with: #(2);
		scalar: studentSymbol with: (Array with: SStudent new).
	testCase := SSTestCase with: aTypeInfo.
	testCase
		addLiteral: stringSymbol;
		addLiteral: collSymbol;
		addLiteral: intSymbol;
		addLiteral: studentSymbol.
	self assert: testCase statements size equals: 4.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_var0 := ''World'''
				with:
					'_var1 := '
						,
							(OrderedCollection new
								add: 1;
								add: 4;
								yourself) storeString , ''
				with: '_var2 := 2'
				with: '_var3 := ' , SStudent new storeString , '')
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
	aTypeInfo scalar: #SmallInteger fullClassNameSymbol with: #(2).
	testCase := SSTestCase with: aTypeInfo.
	self should: [ testCase addLiteral: #ByteString fullClassNameSymbol ] raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testAddMessage [
	| testCase targetClass |
	targetClass := #SFoo fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo5.
	testCase
		targetClassName: targetClass;
		addMessage.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_var0 := ', targetClass asString,' new'
				with: '_var1 := ' , (OrderedCollection newFrom: #(1 4 5)) storeString , ''
				with: '_var2 := _var0 return: _var1 ')
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageFrom [
	| testCase targetClass|
	targetClass := #SFoo fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo3.
	testCase
		targetClassName: targetClass;
		addMessage: #returnFloat from: targetClass.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_var0 := 4'
				with: '_var1 := ',targetClass asString,' score: _var0 '
				with: '_var2 := _var1 returnFloat').
	self
		assert: (testCase addMessage: #returnNum from: targetClass) printString
		equals: '_var3 := _var1 returnNum'.
	self
		assert:
			(#('_var4 := _var1 score: _var0 ' '_var4 := _var1 score: _var3 ' '_var5 := _var1 score: _var3' '_var5 := _var1 score: _var4')
				includes: (testCase addMessage: #score: from: targetClass) printString)
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageFromDifferentReceiver [
	| testCase eventSymbol confSymbol |
	eventSymbol := #SEvent fullClassNameSymbol.
	confSymbol := #SConference fullClassNameSymbol.
	testCase := (SSTestCase
		with: utility typeInfoOnPackage1)
		targetClassName: eventSymbol.
	testCase targetClassName: confSymbol.
	testCase addMessage: #canRegister: from: confSymbol.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_var0 := ',confSymbol asString,' new'
				with: '_var1 := ' , (SStudent new name: 'Mary') storeString , ''
				with: '_var2 := _var0 canRegister: _var1 ')
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageWithEmptyTypeMethodInfo [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFooEmpty.
	testCase targetClassName: #SFoo fullClassNameSymbol.
	self should: [ testCase addMessage ] raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageWithReceiver [
	| testCase typeInfo receiver targetClass|
	targetClass := #SFoo fullClassNameSymbol.
	typeInfo := utility typeInfoSFoo2.
	testCase := (SSTestCase with: typeInfo) targetClassName: targetClass.
	receiver := testCase addFactoryMessage variable.
	self
		assert:
			(testCase
				addMessage: (typeInfo messagesFrom: targetClass) first
				withReceiver: receiver) printString
		equals: '_var2 := _var0 return: _var1 '
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageWithTwoDeepScalarSFoo [
	" This feature is not covered yet
	
	| testCase targetClass |
	targetClass := #SFoo fullClassNameSymbol.
	testCase := SSTestCase
		with: utility typeInfoSFooOnPackage3.
	testCase
		targetClassName: targetClass;
		addMessage: #return: from: targetClass.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(OrderedCollection new
				add: '_var0 := ', targetClass asString,' new.';
				add: '_var1 := ' , (SStudent name: 'Lian' with: 1) storeString , '.';
				add: '_var2 := ', 'SStack' fullClassName,' new.';
				add: '_var3 := _var2 push: _var1.';
				add: '_var4 := ' , (SStudent name: 'Josh' with: 2) storeString , '.';
				add: '_var5 := _var2 push: _var4.';
				add: '_var6 := ' , (SStudent name: 'Mery' with: 5) storeString , '.';
				add: '_var7 := ((OrderedCollection new) add: _var6; yourself).';
				add: '_var8 := ((Dictionary new) add: (1->_var5); add: (2->_var7); yourself).';
				add: '_var9 := _var0 return: _var8.';
				yourself)"
]

{ #category : #tests }
SSTestShifterTest >> testAddMessageWithTwoDeepScalarSStack [
	"This feature is not covered yet
	
	| testCase targetClass |
	targetClass := #SStack fullClassNameSymbol.
	testCase := SSTestCase
		with: utility typeInfoSStackOnPackage2.
	testCase
		targetClassName: targetClass;
		addMessage: #push: from: targetClass.
	self assert: testCase statements size equals: 3.
	self
		assert:
			((testCase statements collect: #printString)
				includesAny:
					(Array
						with:
							(OrderedCollection new
								add: '_var0 := ', targetClass asString,' new';
								add: '_var1 := ' , (SStudent name: 'Lian' with: 1) storeString , ' ';
								add: '_var2 := ' , (SStudent name: 'Josh' with: 2) storeString , ' ';
								add: '_var3 := ((OrderedCollection new) add: _var1; add: _var2; yourself)';
								add: '_var4 := _var0 push: _var3 ';
								yourself)
						with:
							(OrderedCollection new
								add: '_var0 := ', targetClass asString,' new';
								add: '_var1 := ' , (SStudent name: 'Mery' with: 5) storeString , ' ';
								add: '_var2 := ((OrderedCollection new) add: _var1; yourself)';
								add: '_var3 := _var0 push: _var2 ';
								yourself)))"
]

{ #category : #tests }
SSTestShifterTest >> testAddTargetClassName [
	| testCase expression eventSymbol teacherSymbol |
	eventSymbol := #SEvent fullClassNameSymbol.
	teacherSymbol := #SSTeacher fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoOnPackage3.
	self should: [testCase targetClassName: eventSymbol] raise: SError.
	self shouldnt: [testCase targetClassName: teacherSymbol] raise: SError.
	expression := testCase addFactoryMessage: teacherSymbol.
	self
		assert: expression printString equals: '_var2 := ',teacherSymbol asString,' name: _var0 with: _var1 '. 
]

{ #category : #tests }
SSTestShifterTest >> testNewFactoryMessageUsingAnd [
	| testCase factory targetClass method typeInfo|
	targetClass := 'SEvent' fullClassNameSymbol.
	typeInfo := utility typeInfoSEvent1.
	testCase := SSTestCase with: typeInfo.
	
	testCase targetClassName:  targetClass.
	testCase addLiteral.
	method :=  typeInfo classMethodType: #price: from: #SEvent fullClassNameSymbol .
	factory := testCase newFactoryMessage: method from: #SEvent fullClassNameSymbol.
	self
		assert: factory printString
		equals: targetClass,' price: _var0 '.
	self assertCollection: testCase printStatements  hasSameElements: #('_var0 := 8')
]

{ #category : #tests }
SSTestShifterTest >> testObjectVariables [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSSTeacher3.
	self assert: testCase objectVariables isEmpty.
	testCase
		targetClassName: #SSTeacher fullClassNameSymbol;
		addFactoryMessage.
	self
		assertCollection: (testCase objectVariables collect: #printString)
		hasSameElements: #('_var0')
]

{ #category : #tests }
SSTestShifterTest >> testPickAccessorsOf [
	| testCase targetClass |
	targetClass := #SSTeacher fullClassNameSymbol.
	testCase := (SSTestCase with: utility typeInfoSSTeacher4)
		targetClassName: targetClass.
	self
		assertCollection: ((testCase pickAccessorsOf: targetClass) collect: #selector)
		hasSameElements: #(#yearsWorkExperience #idTeacher).
	testCase := (SSTestCase with: utility typeInfoSSTeacher3)
		targetClassName: targetClass.
	self assert: (testCase pickAccessorsOf: targetClass) isEmpty.
	
]

{ #category : #tests }
SSTestShifterTest >> testPickAccessorsOfWithInvalidClassName [
	| testCase |
	testCase := (SSTestCase with: utility typeInfoSSTeacher4)
		targetClassName: #SSTeacher fullClassNameSymbol.
	self assert: (testCase pickAccessorsOf: #SStudent fullClassNameSymbol) isEmpty
]

{ #category : #tests }
SSTestShifterTest >> testPickAnObjectVariable [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSSTeacher3.
	testCase targetClassName: 'SSTeacher' fullClassNameSymbol.
	testCase addFactoryMessage: 'SSTeacher' fullClassNameSymbol.
	self assert: testCase pickAnObjectVariable printString equals: '_var0'
]

{ #category : #tests }
SSTestShifterTest >> testPickFactoryMessagesFrom [
	| testCase targetClass |
	targetClass := #SConference fullClassNameSymbol.
	testCase := SSTestCase new.
	testCase typeInfo: utility typeInfoOnPackage2.
	testCase targetClassName: targetClass.
	testCase addFactoryMessage: targetClass usingSelector: #price:.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array with: '_var0 := 95'
		with: '_var1 := ',targetClass asString,' price: _var0 ')
]

{ #category : #tests }
SSTestShifterTest >> testPickMessagesOf [
	| testCase |
	testCase := SSTestCase with: utility typeInfoOnPackage2.
	self
		assertCollection: ((testCase pickMessagesOf: #SEvent fullClassNameSymbol) collect: #selector)
		hasSameElements: #(#price:).
	self
		assertCollection: ((testCase pickMessagesOf: #SConference fullClassNameSymbol) collect: #selector)
		hasSameElements: #(#price: #initialize).
	testCase := SSTestCase with: utility typeInfoOnPackage3.
	self
		assertCollection: ((testCase pickMessagesOf: #SSTeacher fullClassNameSymbol) collect: #selector)
		hasSameElements: #(#name: #id: #nickname: #initialize #nickname)
]

{ #category : #tests }
SSTestShifterTest >> testPickMessagesOfWrongClassName [
	| testCase |
	testCase := SSTestCase with: utility typeInfoOnPackage2.
	self assert: (testCase pickMessagesOf: #SSTeacher fullClassNameSymbol) isEmpty.
	testCase := SSTestCase with: utility typeInfoOnPackage3.
	self assert: (testCase pickMessagesOf: #SSPerson fullClassNameSymbol) isEmpty.
	self assert: (testCase pickMessagesOf: #SStudent fullClassNameSymbol) isEmpty
]

{ #category : #tests }
SSTestShifterTest >> testPickOrCreateObjectVariableOf [
	| testCase targetClass |
	targetClass := #SFoo fullClassNameSymbol.
	testCase := (SSTestCase with: utility typeInfoSFoo2)
		targetClassName: targetClass.
	self assert: testCase statements isEmpty.
	self
		assert: (testCase pickOrCreateObjectVariableOf: targetClass) printString
		equals: '_var0'.
	self assertCollection: (testCase statements collect: #printString) hasSameElements: (Array with: '_var0 := ',targetClass asString,' new').
	testCase pickOrCreateObjectVariableOf: targetClass.
	self assert: testCase statements size equals: 1
]

{ #category : #tests }
SSTestShifterTest >> testPickOrCreateObjectVariableOfWrongClassName [
	| testCase |
	testCase := (SSTestCase with: utility typeInfoSFoo2)
		targetClassName: #SFoo fullClassNameSymbol.
	self
		should: [ testCase pickOrCreateObjectVariableOf: #SSTeacher fullClassNameSymbol ]
		raise: SError
]

{ #category : #tests }
SSTestShifterTest >> testRandomLiteralClassName [
	| testCase |
	testCase := SSTestCase
		with: (STypeInfo new scalar: #SmallInteger fullClassNameSymbol with: #(1 3 4)).
	self assert: testCase randomLiteralClassName equals: #SmallInteger fullClassNameSymbol.
	testCase := SSTestCase
		with:
			(STypeInfo new
				scalar: #ByteString fullClassNameSymbol with: #('hello');
				scalar: #SmallInteger fullClassNameSymbol with: #(1 5 6)).
	self
		assert:
			((Array with: #ByteString fullClassNameSymbol with: #SmallInteger fullClassNameSymbol)
				includes: testCase randomLiteralClassName)
]

{ #category : #tests }
SSTestShifterTest >> testRandomLiteralClassNameWithEmptyScalars [
	| testCase |
	testCase := SSTestCase with: STypeInfo new.
	self should: [ testCase randomLiteralClassName ] raise: SError
]
