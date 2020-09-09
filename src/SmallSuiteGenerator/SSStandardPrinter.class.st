Class {
	#name : #SSStandardPrinter,
	#superclass : #SSVisitor,
	#instVars : [
		'stream'
	],
	#category : #'SmallSuiteGenerator-Strategies'
}

{ #category : #testing }
SSStandardPrinter class >> hasLimit [
	^ true	
	
]

{ #category : #testing }
SSStandardPrinter class >> isDictionary [
	^ false
]

{ #category : #'instance creation' }
SSStandardPrinter class >> on: aStream [
	^ self new stream: aStream; yourself.
]

{ #category : #'instance creation' }
SSStandardPrinter class >> printTempVariables: aTestCase on: aStream [
	aStream tab; nextPut:$|; space.
	aTestCase assignedIds do:[:id| aStream nextPutAll:'_var'; nextPutAll: id asString; space.].
	aTestCase lastTemporaries do: [ :tmp | aStream nextPutAll: tmp fullName asString; space. ].
	aStream space; nextPut:$|; cr.
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
	| selector |
	"this only propagate the visit"
	selector := aMessage selector.
	aMessage receiver accept: self.
	stream space.
	(selector isKeyword or: [ selector isBinary ])
		ifTrue:[
			selector keywords with: aMessage args do:[ :key : arg|
				stream nextPutAll: key; space.
				arg accept: self.
				stream space. ].
		] ifFalse:[
			stream nextPutAll: selector.
		].
]

{ #category : #'visiting-core' }
SSStandardPrinter >> visitAssignment: anAssignmnet [
	anAssignmnet variable accept: self.
	stream nextPutAll: ' := '.
	anAssignmnet value accept: self.
	
]

{ #category : #'visiting-core' }
SSStandardPrinter >> visitCascade: aCascade [
	
	stream nextPut:$(.
	aCascade messages first receiver accept: self.
	stream nextPut:$); cr.
	aCascade messages do: [ :msj |
		stream tab.
		msj selector isKeyword
		ifTrue:[
			msj selector keywords with: msj args do:[ :key : arg|
				stream nextPutAll: key; space.
				arg accept: self.
				stream space. ].
		] ifFalse:[
			stream nextPutAll: msj selector.
		]
	] separatedBy: [ stream nextPut: $;; cr ].
	
	
]

{ #category : #'visiting-core' }
SSStandardPrinter >> visitLiteral: aLiteral [
	|val|
	val := aLiteral value.
	(val isNumber or:[ val isBlock])
		ifTrue: [ val printOn: stream.]
		ifFalse: [ SPlatform initLevelToPrint.
			val storeOn: stream.].
]

{ #category : #'visiting-core' }
SSStandardPrinter >> visitSelf: aSelf [
	stream nextPutAll:'self'
]

{ #category : #'visiting-core' }
SSStandardPrinter >> visitSequenceNode: aSequenceNode [
	self visitStatements: aSequenceNode statements
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
