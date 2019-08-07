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
					(Array with: (Array with: (#returnNum
						->
							#(#SmallInteger
							#()
							false)) with: 
					(#returnFloat
						->
							#(#SmallFloat64
							#()
							false)) with: 
					(#returnString
						->
							#(#ByteString
							#()
							false)) with:
					(#score
						->
							#(#SmallFloat64
							#()
							true)) with: 
					(#return:
						->
							#(#ByteString
							#(#ByteString)
							false))) with: 
					(Array with: (#score:
						->
							#(#SFoo
							#(#SmallFloat64)
							false))));
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
					(Array with: (Array with: (#return:
						->
							#(#SFoo
							#(#SFoo)
							false))) with:
					#());
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
					(Array with: (Array with: (#firstLinkStack
						->
							#(#SmallInteger
							#()
							true)) with:
					(#lastLinkStack
						->
							#(#SmallInteger
							#()
							true)) with:
					(#pop
						->
							#(#SmallInteger
							#()
							false)) with:
					(#push:
						->
							#(#SmallInteger
							#(#SmallInteger)
							false)) with:
					(#top
						->
							#(#SmallInteger
							#()
							false))) with: 
					(Array with: (#newStack
						->
							#(#SStack
							#()
							false)) with: 
					(#newStackWith:
						->
							#(#SStack
							#(#Array)
							false))));
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
					(Array with: (Array with: (#returnString
						->
							#(#ByteString
							#()
							false))) with:
					(Array with: (#score:
						->
							#(#SFoo
							#(#SmallInteger)
							false)))).
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
					(Array with: (Array with: (#top
						->
							#(nil
							#()
							false))) with:
					(Array with: (#newStack:
						->
							#(#SStack
							#(#Array)
							false)))).
	aTypeInfo scalar: #Array with: #(#(1 3 2)).
	testCase addFactoryMessage: #SStack.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			#('_var0 := 3.' '_var1 := SFoo score: _var0.'
			'_var2 := #(1 3 2 ).' '_var3 := SStack newStack: _var2.')
]

{ #category : #tests }
SSTestCaseTest >> testAddLiteral [
	| testCase aTypeInfo |
	testCase := SSTestCase new.
	aTypeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array with: (Array with: (#return:
						->
							#(#OrderedCollection
							#(#OrderedCollection)
							false))) with:
					#()).
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
			#('_var0 := ''World''.'  '_var1 := ((OrderedCollection new) add: 1; add: 4; yourself).'
			'_var2 := 2.')
]

{ #category : #tests }
SSTestCaseTest >> testAddMessage [
	| testCase aTypeInfo |
	testCase := SSTestCase new.
	aTypeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array with: (Array with: (#return:
						->
							#(#OrderedCollection
							#(#OrderedCollection)
							false))) with: 
					#()).
	aTypeInfo
		scalar: #OrderedCollection
		with: (Array with: (OrderedCollection newFrom: #(1 4))).
	testCase typeInfo: aTypeInfo.
	testCase addMessage.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			#('_var0 := SFoo new.'  '_var1 := ((OrderedCollection new) add: 1; add: 4; yourself).'
			'_var2 := _var0 return: _var1.').
	(aTypeInfo classAt: #SFoo)
		typeMethod:
			#returnString
				->
					#(#ByteString
					#()
					false).
	testCase addMessage: #returnString from: #SFoo.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			#('_var0 := SFoo new.'  '_var1 := ((OrderedCollection new) add: 1; add: 4; yourself).'
			'_var2 := _var0 return: _var1.' '_var3 := _var0 returnString.')
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
		withMethod: (testCase typeInfo typeOf: #newStack fromMetaClassName: #SStack).
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
							(Array with: (#returnNum
								->
									#(#SmallInteger
									#()
									false)) with: 
							(#returnFloat
								->
									#(#SmallFloat64
									#()
									false)) with: 
							(#score
								->
									#(#SmallInteger
									#()
									true)) with: 
							(#return:
								->
									#(#ByteString
									#(#ByteString)
									false)))
						with:
							(Array with: (#score:
								->
									#(#SFoo
									#(#SmallFloat64)
									false)))).
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
			#('_var0 := 7.3.'  '_var1 := SFoo score: _var0.'
			'_var2 := _var1 returnNum.'  '_var3 := _var1 score.'
			'_var4 := 5.'  '_var5 := ''hello''.').
	self
		assertCollection: (otherTestCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.'  '_var1 := SFoo score: _var0.'
			'_var2 := _var1 returnNum.'  '_var3 := _var1 score.'
			'_var4 := 5.'  '_var5 := _var1 returnFloat.'
			'_var6 := ''hello''.'  '_var7 := _var1 return: _var6.')
]

{ #category : #tests }
SSTestCaseTest >> testFieldAccessMessage [
	| testCase aTypeInfo |
	testCase := SSTestCase new.
	aTypeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array with: (Array with: (#score
						->
							#(#SmallInteger
							#()
							true)) with:
					(#score:
						->
							#(#SmallInteger
							#(#SmallInteger)
							false))) with: 
					(Array with: (#score:
						->
							#(#SFoo
							#(#SmallInteger)
							false)))).
	aTypeInfo scalar: #SmallInteger with: #(5).
	testCase typeInfo: aTypeInfo.
	testCase addFieldAccessMessage.
	self assert: testCase statements size equals: 3.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			#('_var0 := 5.'  '_var1 := SFoo score: _var0.'
			'_var2 := _var1 score.')
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

{ #category : #'mutation-change' }
SSTestCaseTest >> typeInfoSFoo [
	^ self class typeInfoSFoo
]

{ #category : #'mutation-change' }
SSTestCaseTest >> typeInfoSStack [
	^ self class typeInfoSStack
]
