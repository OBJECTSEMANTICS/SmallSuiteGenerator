Class {
	#name : #SFieldAccessMessage,
	#superclass : #SAbstractMessage,
	#category : #'SSGenerator-Nodes'
}

{ #category : #'instance creation' }
SFieldAccessMessage class >> newFromReceiver: aReceiver andMethod: aMethod [
	^ SFieldAccessMessage new
		returnType: aMethod returnType;
		selector: aMethod selector;
		receiver: aReceiver;
		yourself
]

{ #category : #'as yet unclassified' }
SFieldAccessMessage >> insertRandomMessageWith: aTestCase [
	^ (aTestCase
		addFieldAccessMessage: self selector
		from: (Smalltalk at: self receiver)) variable
]

{ #category : #actions }
SFieldAccessMessage >> replaceArg: expressions by: newExpressions [
]
