Class {
	#name : #SSStandardPrinter,
	#superclass : #SSVisitor,
	#instVars : [
		'stream'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'instance creation' }
SSStandardPrinter class >> on: aStream [
	^ self new stream: aStream; yourself.
]

{ #category : #'instance creation' }
SSStandardPrinter class >> printTempVariables: aTestCase on: aStream [
	aStream tab;nextPut:$|; space.
	aTestCase assignedIds do:[:id| aStream nextPutAll:'_var'; nextPutAll: id asString; space.].
	aStream space;nextPut:$|;cr.
	
]

{ #category : #accessing }
SSStandardPrinter >> contents [
	^ stream contents.
]

{ #category : #accessing }
SSStandardPrinter >> stream [
	^ stream
]

{ #category : #accessing }
SSStandardPrinter >> stream: anObject [
	stream := anObject
]

{ #category : #'visiting-core' }
SSStandardPrinter >> visitAbstractMessage: aMessage [
	
	"this only propagate the visit"
	
	aMessage receiver accept: self.
	stream space.
	aMessage selector isKeyword
		ifTrue:[
			aMessage selector keywords with: aMessage args do:[ :key : arg|
				stream nextPutAll: key; space.
				arg accept: self.
				stream space. ].
		] ifFalse:[
			stream nextPutAll: aMessage selector.
		].
]

{ #category : #'visiting-core' }
SSStandardPrinter >> visitAssignment: anAssignmnet [
	anAssignmnet variable accept: self.
	stream nextPutAll: ' := '.
	anAssignmnet value accept: self.
	
]

{ #category : #'visiting-core' }
SSStandardPrinter >> visitLiteral: aLiteral [
	|val|
	val := aLiteral value.
	(val isNumber or:[ val isBlock])
		ifTrue: [ val printOn: stream.]
		ifFalse: [val storeOn: stream.].
]

{ #category : #'visiting-core' }
SSStandardPrinter >> visitSelf: aSelf [
	stream nextPutAll:'self'
]

{ #category : #'visiting-core' }
SSStandardPrinter >> visitStatements: expresions [
	expresions do:[ :exp | 
			stream tab.
			exp accept: self. 
			stream nextPut:$.;
			cr].
]

{ #category : #'visiting-core' }
SSStandardPrinter >> visitVariable: aVariable [
	stream nextPutAll: aVariable varName.
	"when the id is nil, it meas that is a class, no the best solution I know"
	aVariable id ifNotNil:[ aVariable id printOn: stream. ].
	
]
