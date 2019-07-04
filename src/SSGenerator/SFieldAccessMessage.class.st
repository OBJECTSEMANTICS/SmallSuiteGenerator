Class {
	#name : #SFieldAccessMessage,
	#superclass : #SAbstractMessage,
	#category : #'SSGenerator-Nodes'
}

{ #category : #'instance creation' }
SFieldAccessMessage class >> receiver: aReceiver selector: aMethod [
	^ SFieldAccessMessage new
		returnType: aMethod returnType;
		selector: aMethod selector;
		receiver: aReceiver;
		yourself
]
