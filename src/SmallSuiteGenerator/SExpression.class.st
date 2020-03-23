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
		'randomGenerator',
		'mutated',
		'parent',
		'identifier'
	],
	#classInstVars : [
		'nextId'
	],
	#category : #'SmallSuiteGenerator-AST'
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

{ #category : #accessing }
SExpression >> allParents [
	"I return my self with all my parents"
	^ parent ifNil: #() ifNotNil: [ 
		Set new add: parent;
	 	addAll: parent allParents; 
		yourself ]
]

{ #category : #copying }
SExpression >> copy [
	^ self class new
		id: self id;
		returnType: self returnType;
		mutated: self mutated;
		parent: self         
]

{ #category : #'error handling' }
SExpression >> error: aString [
	"It throws an error signal with the string passed as argument, it is important to distinguish parsing error with others"
	^ SError signal: aString
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

{ #category : #accessing }
SExpression >> identifier [
	^ identifier
]

{ #category : #initialization }
SExpression >> initialize [
	super initialize.
   randomGenerator := SPlatform randomGenerator.
	mutated := false.
	identifier := self class nextIdentifier 
]

{ #category : #mutation }
SExpression >> insertAsParameter: aExpression using: aTestCase [
	
	^ aTestCase insertAsParameter: self copy after: aExpression
]

{ #category : #mutation }
SExpression >> insertMethodMessage: expression using: aTestCase [
	self error: 'cannot be inserted the methodMessage: ', expression printString
]

{ #category : #mutation }
SExpression >> insertOn: aTestCase [
	
]

{ #category : #mutation }
SExpression >> insertRandomMessage: expression using: aTestCase [
	self error: 'cannot be inserted the randomMessage: ', expression printString
]

{ #category : #testing }
SExpression >> isFactoryMessage [
	^ false
]

{ #category : #comparing }
SExpression >> isPrimitive: anObject [
	^ (anObject isKindOf: Number) or: [ (anObject isKindOf: Boolean)
		or: [ anObject isKindOf: String ]]
]

{ #category : #accessing }
SExpression >> mutantColor [
  ^ self mutated ifTrue: [ Color r: 0.9726295210166178 g: 0.0 b: 0.0
	"Color r: 0.7038123167155426 g: 0.3841642228739003 b: 0.4310850439882698" "Color r: 0.40762463343108507 g: 0.0039100684261974585 b: 0.20234604105571846" ] ifFalse: [ Color gray ]
]

{ #category : #accessing }
SExpression >> mutated [ 
	^ mutated
]

{ #category : #accessing }
SExpression >> mutated: aBoolean [
	mutated := aBoolean
]

{ #category : #accessing }
SExpression >> parent [
	^ parent
]

{ #category : #accessing }
SExpression >> parent: anObject [
	parent := anObject
]

{ #category : #mutation }
SExpression >> pickUpReferences: aExpression [
	^ #()
]

{ #category : #accessing }
SExpression >> randomGenerator: anObject [
	randomGenerator := anObject
]

{ #category : #accessing }
SExpression >> reference [
	^ self
]

{ #category : #accessing }
SExpression >> referenceTo: aClassName [
	^ false
]

{ #category : #mutation }
SExpression >> repairOn: aTestCase changing: aExpression [
	
]

{ #category : #mutation }
SExpression >> replaceArgBy: expression [
	self error: 'cannot be inserted: ', expression printString, ' as parameter'
]

{ #category : #actions }
SExpression >> replaceBy: otherExpression [
	self subclassResponsibility 
]

{ #category : #actions }
SExpression >> replaceExpression: expression by: newExpression [
	"It replace the references to this expresion to the newExpresion"
	
]

{ #category : #accessing }
SExpression >> returnType [
	^ returnType
]

{ #category : #accessing }
SExpression >> returnType: anObject [
	returnType := anObject
]

{ #category : #mutation }
SExpression >> variablesWithId [
	^ #()
]
