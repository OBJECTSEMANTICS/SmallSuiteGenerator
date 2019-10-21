Class {
	#name : #SExpressionTest,
	#superclass : #TestCase,
	#instVars : [
		'utility'
	],
	#category : #'SmallSuiteGenerator-Tests-AST'
}

{ #category : #parsing }
SExpressionTest >> parse: anExpresion [
	| sequence |
	sequence := RBParser parseExpression: anExpresion.
	^ sequence statements
		collect: [ :assig | 
			SAssignment new
				variable: (SVariable name: assig variable name asString);
				value: (self parseMessage: assig value);
				yourself ]
]

{ #category : #parsing }
SExpressionTest >> parseMessage: aRBMessageNode [
	aRBMessageNode isLiteralNode
		ifTrue: [ ^ SLiteral value: aRBMessageNode value ].
	^ SMessage new
		receiver: (SVariable name: aRBMessageNode receiver name);
		selector: aRBMessageNode selector;
		args:
			(aRBMessageNode arguments
				collect: [ :arg | self parseVariableOrValue: arg ]) yourself
]

{ #category : #parsing }
SExpressionTest >> parseVariableOrValue: aRBVariableOrLiteral [
	^ aRBVariableOrLiteral isVariable
		ifTrue: [ SVariable name: aRBVariableOrLiteral name ]
		ifFalse: [ SLiteral value: aRBVariableOrLiteral value ]
]

{ #category : #running }
SExpressionTest >> setUp [
super setUp.
	utility := SUtilityTypeInfo new
]
