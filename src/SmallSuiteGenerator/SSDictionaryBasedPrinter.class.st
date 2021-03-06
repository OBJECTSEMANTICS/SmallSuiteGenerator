"
I am a class that prints the testCases in a dictionary format, this type of printing is useful when you have testCases that have a large number of variables that is not supported by the Pharo compiler.

For example, a result obtained by this class would be like the following:

	| var |
	var := Dictionary new.
	var at: 1 put: (0 ).
	var at: 2 put: (SFoo score: ( var at: 1 )  ).
	var at: 3 put: (( var at: 2 ) returnFloat ).
	self assert: ( var at: 2 ) score equals: 0 .


"
Class {
	#name : #SSDictionaryBasedPrinter,
	#superclass : #SSStandardPrinter,
	#instVars : [
		'dictionaryName'
	],
	#category : #'SmallSuiteGenerator-Strategies'
}

{ #category : #testing }
SSDictionaryBasedPrinter class >> hasLimit [
	^ false
]

{ #category : #testing }
SSDictionaryBasedPrinter class >> isDictionary [
	^ true
]

{ #category : #'instance creation' }
SSDictionaryBasedPrinter class >> printTempVariables: aTestCase on: aStream [
	aStream tab; nextPut:$|; space.
	aStream nextPutAll:'var'.
	aStream space; nextPut:$|;cr.
	aStream tab; nextPutAll:'var := Dictionary new.'; cr.
]

{ #category : #accessing }
SSDictionaryBasedPrinter >> dictionaryName [
	^ dictionaryName
]

{ #category : #accessing }
SSDictionaryBasedPrinter >> dictionaryName: anObject [
	dictionaryName := anObject
]

{ #category : #intialization }
SSDictionaryBasedPrinter >> initialize [
	super initialize.
	dictionaryName := 'var'.
]

{ #category : #'visiting-core' }
SSDictionaryBasedPrinter >> visitAssignment: anAssignmnet [
	stream nextPutAll: dictionaryName.
	stream nextPutAll: ' at: '.
	(anAssignmnet variable id + 1) printOn: stream.
	stream nextPutAll: ' put: ('.
	anAssignmnet value accept: self.
	stream nextPutAll: ' )'.
	
]

{ #category : #'visiting-core' }
SSDictionaryBasedPrinter >> visitVariable: aVariable [
	aVariable id 
		ifNil:[
			stream nextPutAll: aVariable varName.]
		ifNotNil:[ 
			stream nextPutAll: '( '.
			stream nextPutAll: dictionaryName.
			stream nextPutAll: ' at: '.
			(aVariable id+1) printOn: stream.
			stream nextPutAll: ' )'.].
	
]
