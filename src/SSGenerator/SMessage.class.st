Class {
	#name : #SMessage,
	#superclass : #SAbstractMessage,
	#category : #'SSGenerator-Nodes'
}

{ #category : #'instance creation' }
SMessage class >> newFromReceiver: aReceiver method: aMethod andPreviousStatements: statements [
	^ SMessage new
		returnType: aMethod returnType;
		selector: aMethod selector;
		receiver: aReceiver;
		args: (self args: aMethod with: statements);
		yourself
]

{ #category : #'as yet unclassified' }
SMessage >> insertMethodMessageWith: aTestCase [
	^ self insertRandomMessageWith: aTestCase
]

{ #category : #'as yet unclassified' }
SMessage >> insertRandomMessageWith: aTestCase [
	^ (aTestCase
		addMessage: self selector
		from: (Smalltalk at: self receiver)) variable
]
