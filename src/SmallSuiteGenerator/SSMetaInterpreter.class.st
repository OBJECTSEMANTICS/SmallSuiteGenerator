Class {
	#name : #SSMetaInterpreter,
	#superclass : #SSVisitor,
	#instVars : [
		'context',
		'type'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #initialization }
SSMetaInterpreter >> accept: aSSVisitor [
	aSSVisitor visitVariable: self.
]

{ #category : #accessing }
SSMetaInterpreter >> clean [
	context removeKey:'self'.
]

{ #category : #accessing }
SSMetaInterpreter >> context [
	^ context
]

{ #category : #accessing }
SSMetaInterpreter >> context: anObject [
	context := anObject
]

{ #category : #initialization }
SSMetaInterpreter >> initialize [
	super initialize.
	context := Dictionary new.
	type := Dictionary new.
	context at:'self' put: SPlatform testCaseClass new.
]

{ #category : #initialization }
SSMetaInterpreter >> visitAbstractMessage: aMessage [
  | object objArgs result|
  object := aMessage receiver accept: self.
  objArgs := aMessage args collect: [:arg |  arg accept: self ].
  result := object perform: aMessage selector withArguments: objArgs asArray.
  aMessage returnType: result class nameAsSymbol.
  ^ result.
]

{ #category : #initialization }
SSMetaInterpreter >> visitAssignment: anAssignmnet [
	|result returnType|
	result := anAssignmnet value accept: self.
	returnType := result class nameAsSymbol.
	context at: anAssignmnet variable fullName put: result.
	anAssignmnet variable returnType: returnType.
	anAssignmnet returnType: returnType.
	type at: anAssignmnet variable id put: returnType.
	^ result.
]

{ #category : #initialization }
SSMetaInterpreter >> visitCascade: aCascade [
	| object objArgs result|
	object := aCascade messages first receiver accept: self.
	aCascade messages do: [ :msj | 
		objArgs := msj args collect: [:arg |  arg accept: self ].
  		result := object perform: msj selector withArguments: objArgs asArray.
  		msj returnType: result class nameAsSymbol.
	].
   ^ result.
]

{ #category : #initialization }
SSMetaInterpreter >> visitLiteral: aLiteral [
	^ aLiteral value.
]

{ #category : #initialization }
SSMetaInterpreter >> visitSelf: aSelf [
	^ context at: 'self'.
]

{ #category : #initialization }
SSMetaInterpreter >> visitSequenceNode: aSequenceNode [
	self visitStatements: aSequenceNode statements
]

{ #category : #initialization }
SSMetaInterpreter >> visitVariable: aVariable [
	aVariable id ifNotNil:[ aVariable returnType: (type at: aVariable id)].
	^ aVariable id 
		ifNil:[Smalltalk at: aVariable varName.]
		ifNotNil:[ context at: aVariable fullName].
]
