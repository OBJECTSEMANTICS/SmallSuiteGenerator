"
SSelf is a node which is part of the assertion message.


"
Class {
	#name : #SSelf,
	#superclass : #SVariable,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #querying }
SSelf >> containsVariable: aVariable [
	^ false.
]

{ #category : #initialization }
SSelf >> initialize [
	super initialize.
	varName := 'self'.
]

{ #category : #actions }
SSelf >> interpret: aExecutionContext [
  ^aExecutionContext at: 'self'
]

{ #category : #actions }
SSelf >> negateId [
	"nothing to negate"
]

{ #category : #actions }
SSelf >> rename: aDictionary [
	"nothing to rename"
	
]
