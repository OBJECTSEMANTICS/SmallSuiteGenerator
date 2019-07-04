Class {
	#name : #SMessage,
	#superclass : #SAbstractMessage,
	#category : #'SSGenerator-Nodes'
}

{ #category : #'instance creation' }
SMessage class >> receiver: aReceiver selector: aMethod previousStatements: statements [
	^ SMessage new
		returnType: aMethod returnType;
		selector: aMethod selector;
		receiver: aReceiver;
		args: (self args: aMethod with: statements);
		yourself
]
