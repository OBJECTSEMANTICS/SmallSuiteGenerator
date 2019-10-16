Class {
	#name : #SSelf,
	#superclass : #SVariable,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #visiting }
SSelf >> accept: visitor [
	visitor visitSelf: self.
]

{ #category : #initialization }
SSelf >> initialize [
	super initialize.
	varName := 'self'.
]
