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
	sequence := SPlatform rbParserClass parseExpression: anExpresion.
	^ sequence statements
		collect: [ :assig |
			SAssignment new
				variable: (self variableFor: assig variable name asString);
				value: (self parseMessage: assig value);
				yourself ]
]

{ #category : #parsing }
SExpressionTest >> parseMessage: aRBMessageNode [
	aRBMessageNode isLiteralNode
		ifTrue: [ ^ SLiteral value: aRBMessageNode value ].
	^ SMessage new
		receiver: (self variableFor: aRBMessageNode receiver name);
		selector: aRBMessageNode selector;
		args:
			(aRBMessageNode arguments
				collect: [ :arg | self parseVariableOrValue: arg ]) yourself
]

{ #category : #parsing }
SExpressionTest >> parseVariableOrValue: aRBVariableOrLiteral [
	^ aRBVariableOrLiteral isVariable
		ifTrue: [ self variableFor: aRBVariableOrLiteral name ]
		ifFalse: [ SLiteral value: aRBVariableOrLiteral value ]
]

{ #category : #running }
SExpressionTest >> setUp [
	super setUp.
	utility := SUtilityTypeInfo new.
	SPlatform resetRandomGenerator
]

{ #category : #running }
SExpressionTest >> tearDown [
	SPlatform resetRandomGenerator
]

{ #category : #parsing }
SExpressionTest >> variableFor: name [
	^ (SVariable new 
			varName: (self variableName: name); 
			id: (self variableId: name); 
			yourself)
]

{ #category : #parsing }
SExpressionTest >> variableId: aString [
	^ ('_var*' match: aString) 
			ifTrue:[ (aString copyFrom: 5 to: aString size) asInteger ] 
			ifFalse:[nil].
]

{ #category : #parsing }
SExpressionTest >> variableName: aString [
	^('_var*' match: aString) ifTrue:[ '_var'] ifFalse:[ aString].
]
