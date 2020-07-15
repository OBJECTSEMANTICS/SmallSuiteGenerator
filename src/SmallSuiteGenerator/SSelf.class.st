"
SSelf is a node which is part of the assertion message.


"
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

{ #category : #actions }
SSelf >> interpret: aExecutionContext [
  ^aExecutionContext at: 'self'
]
