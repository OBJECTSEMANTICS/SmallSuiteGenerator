Class {
	#name : #SFieldAccessMessage,
	#superclass : #SAbstractMessage,
	#category : #SSGenerator
}

{ #category : #'instance creation' }
SFieldAccessMessage class >> receiver: aReceiver selector: aMethod [
	^ SFieldAccessMessage new
		returnType: aMethod returnType;
		selector: aMethod selector;
		receiver: aReceiver;
		yourself
]
