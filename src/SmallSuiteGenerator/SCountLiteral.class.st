Class {
	#name : #SCountLiteral,
	#superclass : #SVisitor,
	#instVars : [
		'counter'
	],
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #initalize }
SCountLiteral >> initialize [
	super initialize.
	counter := 0
]

{ #category : #accesing }
SCountLiteral >> visitLiteral: aLiteral [
	counter := counter + 1. 
]
