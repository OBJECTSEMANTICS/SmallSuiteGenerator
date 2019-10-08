Class {
	#name : #SSelf,
	#superclass : #SVariable,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #initialization }
SSelf >> initialize [
	super initialize.
	varName := 'self'.
]
