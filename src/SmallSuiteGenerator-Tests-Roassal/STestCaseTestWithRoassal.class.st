Class {
	#name : #STestCaseTestWithRoassal,
	#superclass : #TestCase,
	#instVars : [
		'utility'
	],
	#category : #'SmallSuiteGenerator-Tests-Roassal'
}

{ #category : #running }
STestCaseTestWithRoassal >> setUp [ 	
	utility := SUtilityRoassal new
]

{ #category : #tests }
STestCaseTestWithRoassal >> testChangeMessageNotUnderstoodOnRTSVGOnPackage [
	| engine |
	engine := SGAEngineExample new
		runOnPackagesMatching: 'Roassal2-C*'
		withBlock: [ | v |
			v := RTView new.
			v @ RTDraggableView.
			v ]
		andFitness: SStatementCoverage.
	self halt.
	self assert: engine fitness: SStatementCoverage.
	self clean
]

{ #category : #tests }
STestCaseTestWithRoassal >> testOnRTAMItem [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfosRTAMItem first.
	testCase addLiteral: #ByteString.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := ''Bonus Card''.' '_var1 := RTAMItem new.').
	expression := testCase addMessage: #itemName: from: #RTAMItem.
	self
		assert: expression printString
		equals: '_var2 := _var1 itemName: _var0.'
]

{ #category : #tests }
STestCaseTestWithRoassal >> testOnRTBorderAttachPoint [
	| testCase auxExpr expression |
	testCase := SSTestCase with: utility typeInfoRTBorderAttachPoint.
	testCase addLiteral.
	expression := testCase addLiteral.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 5.' '_var1 := 5.' '_var2 := RTBorderAttachPoint new.').
	testCase addMessage: #offset: from: #RTBorderAttachPoint.
	auxExpr := testCase
		perform: #insertAsParameter:using:
		inStatement: expression.
	self
		assert: auxExpr printString
		equals: '_var3 := _var2 offset: _var1.'
]

{ #category : #tests }
STestCaseTestWithRoassal >> testOnRTBox [
	| testCase  |
	testCase := SSTestCase with: utility typeInfoRTBox.
	testCase addFactoryMessage;
	addMessage;
	addLiteral.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := RTBox new.' '_var1 := _var0 borderStyle.' '_var2 := (RTBorderStyle basicNew instVarAt: 1 put: nil; yourself).').
]

{ #category : #tests }
STestCaseTestWithRoassal >> testOnRTDirectedLine [
	| testCase |
	testCase := SSTestCase with: utility typeInfosRTDirectedLine first.
	testCase
		addFactoryMessage;
		addMessage: #offset: from: #RTDirectedLine.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := RTDirectedLine new.' '_var1 := 6.5.' '_var2 := _var0 offset: _var1.').
	testCase := SSTestCase with: utility typeInfosRTDirectedLine second.
	testCase
		addFactoryMessage;
		addMessage: #pointsFrom:To: from: #RTDirectedLine.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := RTDirectedLine new.' '_var1 := ((3@5)).' '_var2 := _var0 pointsFrom: _var1 To: _var1.')
]

{ #category : #tests }
STestCaseTestWithRoassal >> testOnRTLineSegment [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfosRTLineSegment first.
	testCase
		addFactoryMessage;
		addMessage: #c from: #RTLineSegment;
		addMessage: #from from: #RTLineSegment.
	expression := testCase addMessage: #from:to: from: #RTLineSegment.
	self
		assertCollection: (testCase statements collect: #printString) allButLast
		hasSameElements:
			#('_var0 := ((3@4)).' '_var1 := RTLineSegment from: _var0 to: _var0.' '_var2 := _var1 c.' '_var3 := _var1 from.' ).
	self assert: (#('_var4 := _var1 from: _var0 to: _var0.' '_var4 := _var1 from: _var3 to: _var3.' '_var4 := _var1 from: _var0 to: _var3.' '_var4 := _var1 from: _var3 to: _var0.') includes: expression printString)
			
]
