Class {
	#name : #SExpressionPatternTest,
	#superclass : #TestCase,
	#instVars : [
		'utility',
		'expressionPattern'
	],
	#category : #'SmallSuiteGenerator-Tests-ExpressionPattern'
}

{ #category : #running }
SExpressionPatternTest >> setUp [ 
	utility := SUtilityTypeInfo new
]

{ #category : #tests }
SExpressionPatternTest >> testArgumentTypesNotRelated [
	|block|
	block := [  ]
]

{ #category : #tests }
SExpressionPatternTest >> testBlockClosureSymbol [
	"p4"
	|block|
	block := [ #(1 5 7 3) select: #odd.
		#(1 5 7 3) select: [ :n | n odd ] ]
]

{ #category : #tests }
SExpressionPatternTest >> testReceiverDependent [
	"pattern 2"
	| block |
	block := [ (SStudent name: 'Pedro') scoreStudent: 4.
	(SSTeacher name: 'Jenny') yearsWorkExperience: 3; yearsWorkExperience ]
]

{ #category : #tests }
SExpressionPatternTest >> testReceiverInheritanceRelation [
	"p3"
	|block|
	block := [ GLMTabulator new color. GLMAccumulator new color ].
	block := [ GLMFastTreeTablePresentation new addRawSelectionTransmissionTo: #selection.
		GLMTextPresentation new addRawSelectionTransmissionTo: #selection ]
]

{ #category : #tests }
SExpressionPatternTest >> testSelectExpression [
	"| typeInfo expression |
	typeInfo := utility typeInfoSimpletype.
	expression := self selectExpression: #returnFloat from: #SFoo"	"SSelectorExpression"
	"self
		assert: expression printString
		equals: '_var2 := _var1 returnFloat.'.
	expression := testCase addMessage: #returnNum from: #SFoo.
	self
		assert: expression printString
		equals: '_var3 := _var1 returnNum.'.
	expression := testCase addFactoryMessage: #SFoo ofSelector: #score:.
	self
		assert: expression printString
		equals: '_var4 := SFoo score: _var2.'"
]

{ #category : #tests }
SExpressionPatternTest >> testSimpleType [
	"pattern 1"
	| block |
	block := [ SFoo new returnFloat.
	SFoo score: 3 ]
]
