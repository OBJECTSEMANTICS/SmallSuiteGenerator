"
Superclass of all nodes for 
	- expressions (they represent nodes which are used to create messages),
	- messages (concerned with: assertion messages, factory messages, access messages and mesasges that modify the behavior of a class)
	
Instance Variables
	id:		               <Integer> 
	randomGenerator:		<SRandom>
	returnType:		      <Symbol>
"
Class {
	#name : #SExpression,
	#superclass : #SObject,
	#instVars : [
		'returnType',
		'id',
		'parent',
		'identifier'
	],
	#classInstVars : [
		'nextId'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'error handling' }
SExpression class >> error: string [
	
	^ SError signal: string 
]

{ #category : #'instance creation' }
SExpression class >> isPrimitive: anObject [
	^ self new isPrimitive: anObject.
]

{ #category : #'as yet unclassified' }
SExpression class >> nextIdentifier [
	nextId ifNil: [ nextId := 0 ].	
	^ nextId := nextId + 1
]

{ #category : #initialization }
SExpression class >> resetId [
	nextId := nil
]

{ #category : #comparing }
SExpression >> = another [
	"I return true if all my attributes are equals than the another"
	^ (self class = another class) 
		and: [ (self id = another id) 
			and: [ returnType = another returnType ] ]
	
]

{ #category : #visitor }
SExpression >> accept: aSSVisitor [
	^ self subclassResponsibility.
]

{ #category : #accessing }
SExpression >> allParents [
	"I return my self with all my parents"
	^ parent ifNil: #() ifNotNil: [ 
		Set new add: parent;
	 	addAll: parent allParents; 
		yourself ]
]

{ #category : #actions }
SExpression >> changeOn: aTestCase [
	^ self subclassResponsibility.
]

{ #category : #querying }
SExpression >> containsVariable: aVariable [
	^ self subclassResponsibility.
]

{ #category : #copying }
SExpression >> copy [
	^ self class new
		id: self id;
		returnType: self returnType;
		parent: self         
]

{ #category : #actions }
SExpression >> fix [
]

{ #category : #comparing }
SExpression >> hash [
	^ self id hash bitXor: self returnType hash
]

{ #category : #accessing }
SExpression >> id [
	^ id
]

{ #category : #accessing }
SExpression >> id: anObject [
	id := anObject
]

{ #category : #initialization }
SExpression >> initialize [
	super initialize .
	identifier := self class nextIdentifier.
]

{ #category : #actions }
SExpression >> insertOn: aTestCase [
	
]

{ #category : #testing }
SExpression >> isFactoryMessage [
	^ false
]

{ #category : #testing }
SExpression >> isMessage [
	^ false.
]

{ #category : #querying }
SExpression >> isPrimitive: anObject [
	^ (anObject isKindOf: Number) or: [ (anObject isKindOf: Boolean)
		or: [ anObject isKindOf: String ]]
]

{ #category : #querying }
SExpression >> isThereEnoughArgumentsToBuild: aTestCase [
	^ true
]

{ #category : #accessing }
SExpression >> parent [
	^ parent
]

{ #category : #accessing }
SExpression >> parent: anObject [
	parent := anObject
]

{ #category : #querying }
SExpression >> pickUpReferences: aExpression [
	^ #()
]

{ #category : #printing }
SExpression >> printOn: aStream [
	self accept: (SSStandardPrinter on: aStream)
]

{ #category : #accessing }
SExpression >> reference [
	^ self
]

{ #category : #accessing }
SExpression >> referenceTo: aClassName [
	^ false
]

{ #category : #accessing }
SExpression >> returnType [
	^ returnType
]

{ #category : #accessing }
SExpression >> returnType: anObject [
	returnType := anObject
]

{ #category : #'error handling' }
SExpression >> serror: aString [
	"It throws an error signal with the string passed as argument, it is important to distinguish parsing error with others"
	^ SError signal: aString
]

{ #category : #querying }
SExpression >> variablesWithId [
	^ #()
]
