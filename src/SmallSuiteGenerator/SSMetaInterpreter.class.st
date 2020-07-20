Class {
	#name : #SSMetaInterpreter,
	#superclass : #SSVisitor,
	#instVars : [
		'context'
	],
	#category : #'SmallSuiteGenerator-Core'
}

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
	context at:'self' put: TestCase new.
]

{ #category : #initialization }
SSMetaInterpreter >> visitAbstractMessage: aMessage [
  | object objArgs |
  object := aMessage receiver accept: self.
  objArgs := aMessage args collect: [:arg |  arg accept: self ].
  ^ object perform: aMessage selector withArguments: objArgs asArray.
]

{ #category : #initialization }
SSMetaInterpreter >> visitAssignment: anAssignmnet [
	context at: anAssignmnet variable fullName put: (anAssignmnet value accept: self).
	
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
SSMetaInterpreter >> visitVariable: aVariable [
	^ aVariable id 
		ifNil:[Smalltalk at: aVariable varName.]
		ifNotNil:[ context at: aVariable fullName].
]
