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
	^ SSGParser parseFrom: sequence 
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
