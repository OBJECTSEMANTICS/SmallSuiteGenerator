Class {
	#name : #SSTestCaseTest,
	#superclass : #TestCase,
	#instVars : [
		'utility'
	],
	#category : #'SmallSuiteGenerator-Tests-Core'
}

{ #category : #'as yet unclassified' }
SSTestCaseTest class >> typeInfoSFoo [
	| typeInfo |
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #returnNum -> #(#SFoo #SmallInteger #() false)
								with:
									#returnFloat -> #(#SFoo #SmallFloat64 #() false)
								with: #returnString -> #(#SFoo #ByteString #() false)
								with: #score -> #(#SFoo #SmallFloat64 #() true)
								with:
									#return: -> #(#SFoo #ByteString #(#ByteString) false))
						with:
							(Array with:
								#score: -> #(#SFoo #SFoo #(#SmallFloat64) false)));
		scalar: #ByteString with: #('hello');
		scalar: #SmallInteger with: #(5);
		scalar: #SmallFloat64 with: #(7.3).
	^ typeInfo
]

{ #category : #'as yet unclassified' }
SSTestCaseTest class >> typeInfoSFoo2 [
	| typeInfo |
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array with: #return: -> #(#SFoo #SFoo #(#SFoo) false))
						with: #());
		scalar: #ByteString with: #('hello');
		scalar: #SmallInteger with: #(5);
		scalar: #SmallFloat64 with: #(7.3).
	^ typeInfo
]

{ #category : #'as yet unclassified' }
SSTestCaseTest class >> typeInfoSStack [
	| typeInfo |
	typeInfo := STypeInfo new
		type:
			#SStack
				->
					(Array
						with:
							(Array
								with:
									#firstLinkStack -> #(#SStack #SmallInteger #() true)
								with:
									#lastLinkStack -> #(#SStack #SmallInteger #() true)
								with: #pop -> #(#SStack #SmallInteger #() false)
								with:
									#push: -> #(#SStack #SmallInteger #(#SmallInteger) false)
								with: #top -> #(#SStack #SmallInteger #() false))
						with:
							(Array
								with: #newStack -> #(#SStack #SStack #() false)
								with:
									#newStackWith: -> #(#SStack #SStack #(#Array) false)));
		scalar: #SmallInteger with: #(5);
		scalar: #Array with: #(#(1 4 5)).
	^ typeInfo
]

{ #category : #tests }
SSTestCaseTest >> setUp [
	utility := SUtilityTypeInfo new.
]

{ #category : #tests }
SSTestCaseTest >> testAddFactoryMessage [
	| testCase aTypeInfo |
	testCase := SSTestCase new.
	aTypeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array with: #returnString -> #(#SFoo #ByteString #() false))
						with:
							(Array with:
								#score: -> #(#SFoo #SFoo #(#SmallInteger) false))).
	aTypeInfo scalar: #SmallInteger with: #(3).
	testCase typeInfo: aTypeInfo.
	testCase addFactoryMessage.
	self assert: testCase statements size equals: 2.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements: #('_var0 := 3.' '_var1 := SFoo score: _var0.').
	aTypeInfo
		type:
			#SStack
				->
					(Array
						with: (Array with: #top -> #(#SStack nil #() false))
						with:
							(Array with: #newStack: -> #(#SStack #SStack #(#Array) false))).
	aTypeInfo scalar: #Array with: #(#(1 3 2)).
	testCase addFactoryMessage: #SStack.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			#('_var0 := 3.' '_var1 := SFoo score: _var0.' '_var2 := #(1 3 2 ).' '_var3 := SStack newStack: _var2.')
]

{ #category : #tests }
SSTestCaseTest >> testAddLiteral [
	| testCase aTypeInfo |
	testCase := SSTestCase new.
	aTypeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with:
									#return: -> #(#SFoo #OrderedCollection #(#OrderedCollection) false))
						with: #()).
	aTypeInfo
		scalar: #OrderedCollection
		with: (Array with: (OrderedCollection newFrom: #(1 4))).
	aTypeInfo scalar: #ByteString with: #('World').
	aTypeInfo scalar: #SmallInteger with: #(2).
	testCase typeInfo: aTypeInfo.
	testCase
		addLiteral: #ByteString;
		addLiteral: #OrderedCollection;
		addLiteral: #SmallInteger.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			#('_var0 := ''World''.' '_var1 := ((OrderedCollection new) add: 1; add: 4; yourself).' '_var2 := 2.')
]

{ #category : #tests }
SSTestCaseTest >> testAddMessage [
	| testCase aTypeInfo |
	testCase := SSTestCase new.
	aTypeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with:
									#return: -> #(#SFoo #OrderedCollection #(#OrderedCollection) false))
						with: #()).
	aTypeInfo
		scalar: #OrderedCollection
		with: (Array with: (OrderedCollection newFrom: #(1 4))).
	testCase typeInfo: aTypeInfo.
	testCase addMessage.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			#('_var0 := SFoo new.' '_var1 := ((OrderedCollection new) add: 1; add: 4; yourself).' '_var2 := _var0 return: _var1.').
	(aTypeInfo classAt: #SFoo)
		typeMethod: #returnString -> #(#SFoo #ByteString #() false).
	testCase addMessage: #returnString from: #SFoo.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			#('_var0 := SFoo new.' '_var1 := ((OrderedCollection new) add: 1; add: 4; yourself).' '_var2 := _var0 return: _var1.' '_var3 := _var0 returnString.')
]

{ #category : #tests }
SSTestCaseTest >> testAddMessageWithDifferentReceiver [
	| testCase |
	testCase := SSTestCase new.
	testCase typeInfo: utility typeInfosOnPackageExamplesOthers first.
	self
		should: [ testCase addMessage: #canRegister: from: #SEvent ]
		raise: SError.
	testCase addMessage: #canRegister: from: #SConference.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			(Array
				with: '_var0 := SConference new.'
				with: '_var1 := ' , (SStudent new name: 'Mary') storeString , '.'
				with: '_var2 := _var0 canRegister: _var1.')
]

{ #category : #'mutation-change' }
SSTestCaseTest >> testChangeStatementOfFactoryMessageWithAbstractClass [
	| testCase changed |
	testCase := SSTestCase with: utility typeInfoAthensCairo.
	testCase addFactoryMessage.
	testCase addLiteral.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := AthensCairoCanvas new.' '_var1 := ''hello''.' '_var2 := AthensCairoCanvas new.').
	changed := testCase changeStatementOfClassName: #AthensCairoCanvas.
	self assert: changed equals: false.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var1 := ''hello''.')
]

{ #category : #'mutation-change' }
SSTestCaseTest >> testChangeStatementOfFactoryMessageWithMoreThanOneLiteral [
	| testCase expression expressionChanged |
	testCase := SSTestCase with: self typeInfoSFoo.
	testCase
		addLiteral: #SmallFloat64;
		addLiteral: #SmallFloat64.
	expression := testCase addFactoryMessage: #SFoo ofSelector: #score:.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll: #('_var0 := 7.3.' '_var1 := 7.3.').
	self
		assert:
			(#('_var2 := SFoo score: _var0.'  '_var2 := SFoo score: _var1.')
				includes: expression printString).
	expressionChanged := testCase changeStatementOfVarName: '_var2'.
	self
		assert:
			(#('_var2 := SFoo score: _var0.'  '_var2 := SFoo score: _var1.'
			'_var2 := SFoo new.') includes: expressionChanged printString).
	self assert: testCase validReferences
]

{ #category : #'mutation-change' }
SSTestCaseTest >> testChangeStatementOfFactoryMessageWithOneLiteral [
	| testCase expressionChanged |
	testCase := SSTestCase with: self typeInfoSFoo.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.'  '_var1 := SFoo score: _var0.').
	expressionChanged := testCase changeStatementOfVarName: '_var1'.
	self
		assert:
			(#('_var1 := SFoo new.'  '_var1 := SFoo score: _var2.')
				includes: expressionChanged printString).
	self assert: testCase validReferences
]

{ #category : #'mutation-change' }
SSTestCaseTest >> testChangeStatementOfFieldAccessMessage [
	| testCase exprField exprFieldChanged |
	testCase := SSTestCase with: self typeInfoSStack.
	testCase addFactoryMessage: #SStack ofSelector: #newStack.
	exprField := (testCase
		addFieldAccessMessage: #firstLinkStack
		from: #SStack) copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := SStack newStack.'  '_var1 := _var0 firstLinkStack.').
	exprFieldChanged := testCase changeStatement: exprField.
	self
		assert:
			(#('_var1 := _var0 lastLinkStack.'  '_var1 := _var3 firstLinkStack.'
			'_var1 := _var2 firstLinkStack.')
				includes: exprFieldChanged printString).
	self assert: testCase validReferences
]

{ #category : #'mutation-change' }
SSTestCaseTest >> testChangeStatementOfLiteral [
	| testCase exprLiteral exprLiteralChanged |
	testCase := SSTestCase with: self typeInfoSStack.
	exprLiteral := (testCase addLiteral: #SmallInteger) copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 5.').
	exprLiteralChanged := testCase changeStatementOfVarName: '_var0'.
	self deny: exprLiteral equals: exprLiteralChanged.
	self assert: testCase validReferences
]

{ #category : #'mutation-change' }
SSTestCaseTest >> testChangeStatementOfMessage [
	| testCase exprMessage exprLiteralChanged |
	testCase := SSTestCase with: self typeInfoSStack.
	testCase
		addFactoryMessage: #SStack
		withMethod: (testCase typeInfo type: #newStack fromMetaClassName: #SStack).
	exprMessage := (testCase addMessage: #pop from: #SStack) copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := SStack newStack.'  '_var1 := _var0 pop.').
	exprLiteralChanged := testCase changeStatement: exprMessage.
	self
		assert:
			(#('_var1 := _var0 top.'  '_var1 := _var0 push: _var2.'
			'_var1 := _var3 pop.'  '_var1 := _var2 pop.')
				includes: exprLiteralChanged printString).
	self assert: testCase validReferences
]

{ #category : #tests }
SSTestCaseTest >> testCopy [
	| testCase typeInfo otherTestCase |
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with:
									#returnNum -> #(#SFoo #SmallInteger #() false)
								with:
									#returnFloat -> #(#SFoo #SmallFloat64 #() false)
								with:
									#score -> #(#SFoo #SmallInteger #() true)
								with:
									#return: -> #(#SFoo #ByteString #(#ByteString) false))
						with:
							(Array with:
								#score: -> #(#SFoo #SFoo #(#SmallFloat64) false))).
	typeInfo scalar: #ByteString with: #('hello').
	typeInfo scalar: #SmallInteger with: #(5).
	typeInfo scalar: #SmallFloat64 with: #(7.3).
	testCase := SSTestCase with: typeInfo.
	testCase
		addMessage: #returnNum from: #SFoo;
		addFieldAccessMessage: #score from: #SFoo;
		addLiteral: #SmallInteger.
	otherTestCase := testCase copy.
	self assert: testCase numberStatements equals: 5.
	self assert: testCase equals: otherTestCase.
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
	| testCase aTypeInfo |
	testCase := SSTestCase new.
	aTypeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #score -> #(#SFoo #SmallInteger #() true)
								with:
									#score: -> #(#SFoo #SmallInteger #(#SmallInteger) false))
						with:
							(Array with:
								#score: -> #(#SFoo #SFoo #(#SmallInteger) false))).
	aTypeInfo scalar: #SmallInteger with: #(5).
	testCase typeInfo: aTypeInfo.
	testCase addFieldAccessMessage.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			#('_var0 := 5.' '_var1 := SFoo score: _var0.' '_var2 := _var1 score.')
]

{ #category : #tests }
SSTestCaseTest >> testGenerateStatements [
	| testCase typeInfo |
	typeInfo := self class typeInfoSFoo.
	testCase := SSTestCase with: typeInfo.
	testCase numMaxStatements: 30.
	self shouldnt: [ testCase generateStatements ] raise: SError
]

{ #category : #'mutation-insert' }
SSTestCaseTest >> testInsertStatementOfMixingSelectors [
	| testCase fieldAccess message |
	testCase := (SSTestCase with: utility typeInfosSStudent first)
		addLiteral: #SmallInteger;
		addFactoryMessage: #SStudent ofSelector: #new;
		addMessage: #scoreStudent: from: #SStudent;
		addFactoryMessage: #SStudent ofSelector: #new;
		addFieldAccessMessage: #idStudent from: #SStudent;
		yourself.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 1.' '_var1 := SStudent new.' '_var2 := _var1 scoreStudent: _var0.' '_var3 := SStudent new.' '_var4 := _var1 idStudent.').
	fieldAccess := testCase statementOfVarName: '_var4'.
	message := (testCase statementOfVarName: '_var2') value.
	message := testCase insertExpression: message copy after: fieldAccess.
	self
		assert: message printString
		equals: '_var5 := _var1 scoreStudent: _var0.'.
	message := testCase
		perform: #insertAsParameter:using:
		inStatement: fieldAccess.
	self
		assert: message printString
		equals: '_var5 := _var1 scoreStudent: _var4.'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 1.' '_var1 := SStudent new.' '_var2 := _var1 scoreStudent: _var0.' '_var3 := SStudent new.' '_var4 := _var1 idStudent.' '_var5 := _var1 scoreStudent: _var4.')
]

{ #category : #'mutation-insert' }
SSTestCaseTest >> testInsertStatementOfSelectorAsParameterInFactoryMessage [
	| testCase auxExpr expression |
	testCase := SSTestCase with: self class typeInfoSFoo2.
	expression := testCase addFactoryMessage.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := SFoo new.'  '_var1 := SFoo new.').
	auxExpr := testCase addMessage.
	auxExpr value
		receiver: (testCase statementOfVarName: '_var1') variable.
	auxExpr := testCase
		perform: #insertAsParameter:using:
		inStatement: expression.
	self
		assert: auxExpr printString
		equals: '_var2 := _var1 return: _var0.'
]

{ #category : #'mutation-insert' }
SSTestCaseTest >> testInsertStatementOfSelectorAsParameterInFieldMessage [
	| testCase aExpression |
	testCase := SSTestCase with: self class typeInfoSStack.
	testCase addFactoryMessage: #SStack ofSelector: #newStack.
	aExpression := testCase
		addFieldAccessMessage: #lastLinkStack
		from: #SStack.
	testCase addLiteral: #SmallInteger.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := SStack newStack.' '_var1 := _var0 lastLinkStack.'
			'_var2 := 5.').
	testCase addMessage: #push: from: #SStack.
	testCase
		perform: #insertAsParameter:using:
		inStatement: aExpression copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := SStack newStack.'  '_var1 := _var0 lastLinkStack.'
			'_var2 := 5.'  '_var3 := _var0 push: _var1.')
]

{ #category : #'mutation-insert' }
SSTestCaseTest >> testInsertStatementOfSelectorAsParameterInMessage [
	| testCase aExpression |
	testCase := SSTestCase with: self class typeInfoSStack.
	testCase addFactoryMessage: #SStack ofSelector: #newStackWith:.
	aExpression := testCase addMessage: #pop from: #SStack.
	testCase addLiteral: #SmallInteger.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := #(1 4 5 ).' '_var1 := SStack newStackWith: _var0.' '_var2 := _var1 pop.' '_var3 := 5.').
	testCase addMessage: #push: from: #SStack.
	testCase
		perform: #insertAsParameter:using:
		inStatement: aExpression copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := #(1 4 5 ).' '_var1 := SStack newStackWith: _var0.' '_var2 := _var1 pop.' '_var3 := 5.'  '_var4 := _var1 push: _var2.')
]

{ #category : #'mutation-insert' }
SSTestCaseTest >> testInsertStatementOfSelectorMethodMessageInFactoryMessage [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.'  '_var1 := SFoo score: _var0.').
	self
		should: [ testCase insertStatementOfSelector: #insertMethodMessage:using: ]
		raise: SError
]

{ #category : #'mutation-insert' }
SSTestCaseTest >> testInsertStatementOfSelectorMethodMessageInFieldMessage [
	| testCase fieldMessage |
	testCase := SSTestCase with: self class typeInfoSFoo.
	fieldMessage := testCase addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.'  '_var1 := SFoo score: _var0.'
			'_var2 := _var1 score.').
	self
		should: [ testCase
				perform: #insertMethodMessage:using:
				inStatement: fieldMessage copy ]
		raise: SError
]

{ #category : #'mutation-insert' }
SSTestCaseTest >> testInsertStatementOfSelectorMethodMessageInLiteral [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addLiteral: #SmallInteger.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 5.').
	self
		should: [ testCase insertStatementOfSelector: #insertMethodMessage:using: ]
		raise: SError
]

{ #category : #'mutation-insert' }
SSTestCaseTest >> testInsertStatementOfSelectorMethodMessageInMessage [
	| testCase message |
	testCase := SSTestCase with: self class typeInfoSFoo.
	message := testCase addMessage: #returnNum from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.'  '_var1 := SFoo score: _var0.'
			'_var2 := _var1 returnNum.').
	testCase
		perform: #insertMethodMessage:using:
		inStatement: message copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.'  '_var1 := SFoo score: _var0.'
			'_var2 := _var1 returnNum.'  '_var3 := _var1 returnNum.')
]

{ #category : #'mutation-insert' }
SSTestCaseTest >> testInsertStatementOfSelectorRandomMessageInFactoryMessage [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.' '_var1 := SFoo score: _var0.').
	testCase insertStatementOfSelector: #insertRandomMessage:using:.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.'  '_var1 := SFoo score: _var0.'
			'_var2 := SFoo score: _var0.')
]

{ #category : #'mutation-insert' }
SSTestCaseTest >> testInsertStatementOfSelectorRandomMessageInFieldMessage [
	| testCase fieldMessage |
	testCase := SSTestCase with: self class typeInfoSFoo.
	fieldMessage := testCase addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.'  '_var1 := SFoo score: _var0.'
			'_var2 := _var1 score.').
	testCase
		perform: #insertRandomMessage:using:
		inStatement: fieldMessage copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.'
			'_var2 := _var1 score.'  '_var3 := _var1 score.')
]

{ #category : #'mutation-insert' }
SSTestCaseTest >> testInsertStatementOfSelectorRandomMessageInLiteral [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addLiteral: #SmallFloat64.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.').
	self
		should: [ testCase insertStatementOfSelector: #insertRandomMessage:using: ]
		raise: SError
]

{ #category : #'mutation-insert' }
SSTestCaseTest >> testInsertStatementOfSelectorRandomMessageInMessage [
	| testCase message |
	testCase := SSTestCase with: self class typeInfoSFoo.
	message := testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.'
			'_var2 := ''hello''.'  '_var3 := _var1 return: _var2.').
	testCase
		perform: #insertRandomMessage:using:
		inStatement: message copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.'  '_var1 := SFoo score: _var0.'
			'_var2 := ''hello''.'  '_var3 := _var1 return: _var2.'
			'_var4 := _var1 return: _var2.')
]

{ #category : #tests }
SSTestCaseTest >> testPickAccessorsOf [
	| testCase |
	testCase := SSTestCase new.
	testCase typeInfo: utility typeInfosOnPackageExamplesOthers first.
	self assert: (testCase pickAccessorsOf: #SEvent) isEmpty.
	self
		assertCollection: ((testCase pickAccessorsOf: #SConference) collect: #selector)
		hasSameElements: #(#discount #offerPrice)
]

{ #category : #tests }
SSTestCaseTest >> testPickFactoryMessagesFrom [
	| testCase |
	testCase := SSTestCase new.
	testCase typeInfo: utility typeInfosOnPackageExamplesOthers second.
	self
		should: [ testCase addMessage: #price: from: #SEvent ]
		raise: SError.
	testCase addFactoryMessage: #SConference ofSelector: #price:.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 95.' '_var1 := SConference price: _var0.')
]

{ #category : #tests }
SSTestCaseTest >> testPickMessagesOf [
	| testCase |
	testCase := SSTestCase new.
	testCase typeInfo: utility typeInfosOnPackageExamplesOthers first.
	self assert: (testCase pickMessagesOf: #SEvent) isEmpty.
	self
		assertCollection: ((testCase pickMessagesOf: #SConference) collect: #selector)
		hasSameElements: #(#initialize #offerPrice: #canRegister: #price)
]

{ #category : #'mutation-remove' }
SSTestCaseTest >> testRemoveArgsFactoryMessage [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.' '_var1 := SFoo score: _var0.').
	testCase removeStatementOfVarName: '_var0'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var2 := 7.3.' '_var1 := SFoo score: _var2.').
	self assert: testCase validReferences
]

{ #category : #'mutation-remove' }
SSTestCaseTest >> testRemoveArgsMessage [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.'
			'_var2 := ''hello''.'  '_var3 := _var1 return: _var2.').
	testCase removeStatementOfVarName: '_var2'.
	self
		assert:
			(#('_var4 := ''hello''.'  '_var4 := _var1 returnString.')
				includes: (testCase statementOfVarName: '_var4') printString).
	self
		assert: (testCase statementOfVarName: '_var3') printString
		equals: '_var3 := _var1 return: _var4.'.
	self assert: testCase validReferences
]

{ #category : #'mutation-remove' }
SSTestCaseTest >> testRemoveFactoryMessage [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.'  '_var1 := SFoo score: _var0.').
	testCase removeStatementOfVarName: '_var1'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.')
]

{ #category : #'mutation-remove' }
SSTestCaseTest >> testRemoveFieldAccessMessage [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.'
			'_var2 := _var1 score.').
	testCase removeStatementOfVarName: '_var2'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.' '_var1 := SFoo score: _var0.')
]

{ #category : #'mutation-remove' }
SSTestCaseTest >> testRemoveMessage [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.'
			'_var2 := ''hello''.' '_var3 := _var1 return: _var2.').
	testCase removeStatementOfVarName: '_var3'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.'  '_var1 := SFoo score: _var0.'
			'_var2 := ''hello''.')
]

{ #category : #'mutation-remove' }
SSTestCaseTest >> testRemoveReceiverFieldAccessMessage [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.'
			'_var2 := _var1 score.').
	testCase removeStatementOfVarName: '_var1'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.'  '_var3 := SFoo score: _var0.'
			'_var2 := _var3 score.')
]

{ #category : #'mutation-remove' }
SSTestCaseTest >> testRemoveReceiverMessage [
	| testCase |
	testCase := SSTestCase with: self class typeInfoSFoo.
	testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.'
			'_var2 := ''hello''.'  '_var3 := _var1 return: _var2.').
	testCase removeStatementOfVarName: '_var1'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var4 := SFoo score: _var0.'
			'_var2 := ''hello''.' '_var3 := _var4 return: _var2.')
]

{ #category : #'mutation-remove' }
SSTestCaseTest >> testRemoveStatementNoRepairing [
	| testCase statement |
	testCase := SSTestCase with: self class typeInfoSFoo.
	statement := testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.' '_var1 := SFoo score: _var0.').
	testCase removeStatementNoRepairing: statement.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.').
	testCase := SSTestCase with: self class typeInfoSFoo.
	statement := testCase addFactoryMessage.
	testCase addMessage: #returnFloat from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := _var1 returnFloat.').
	testCase removeStatementNoRepairing: statement.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.')
]

{ #category : #'mutation-change' }
SSTestCaseTest >> typeInfoSFoo [
	^ self class typeInfoSFoo
]

{ #category : #'mutation-change' }
SSTestCaseTest >> typeInfoSStack [
	^ self class typeInfoSStack
]