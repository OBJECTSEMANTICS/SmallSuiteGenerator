"
SSelf is a node which is part of the assertion message.


"
Class {
	#name : #SSelf,
	#superclass : #SVariable,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #visitor }
SSelf >> accept: aSSVisitor [
	^ aSSVisitor visitSelf: self.
]

{ #category : #querying }
SSelf >> containsVariable: aVariable [
	^ false.
]

{ #category : #initialization }
SSelf >> initialize [
	super initialize.
	varName := 'self'.
]
