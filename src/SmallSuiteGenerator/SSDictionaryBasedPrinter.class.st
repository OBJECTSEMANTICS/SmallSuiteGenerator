Class {
	#name : #SSDictionaryBasedPrinter,
	#superclass : #SSStandardPrinter,
	#instVars : [
		'dictionaryName'
	],
	#category : #'SmallSuiteGenerator-Core'
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
