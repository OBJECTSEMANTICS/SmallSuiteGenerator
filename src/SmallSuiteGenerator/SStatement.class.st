Class {
	#name : #SStatement,
	#superclass : #Object,
	#instVars : [
		'id',
		'returnTypeName'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'class initialization' }
SStatement class >> create [
	^ self new.
]

{ #category : #'class initialization' }
SStatement class >> create: id [
	| inst |
	inst := self new.
	inst id: id.
	^ inst
]

{ #category : #'as yet unclassified' }
SStatement >> cleanId [
	id := nil
]

{ #category : #private }
SStatement >> createNewStatement [
	^ self subclassResponsibility
]

{ #category : #copying }
SStatement >> deepCopy [
	| new |
	new := self createNewStatement.
	new id: self id.
	^ new
]

{ #category : #'as yet unclassified' }
SStatement >> dependenciesConsidering: varNames [
	^ self subclassResponsibility
]

{ #category : #accessing }
SStatement >> id [
	^ id
]

{ #category : #accessing }
SStatement >> id: anInteger [
	id:= anInteger.
]

{ #category : #'as yet unclassified' }
SStatement >> insertMethodCallUsing: aTestcase [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SStatement >> insertParameterUsing: aTestcase [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SStatement >> insertParametersOf: aStatement using: aTestCase [
	| args varNames |
	args := aStatement args.
	args ifEmpty: [ ^ nil ].
	varNames := aTestCase varNames.
	args
		withIndexDo: [ :aArg :index | 
			(varNames includes: aArg)
				ifTrue: [ | position newStatement |
					newStatement := (aTestCase statementAt: aArg) createNewStatement.
					position := SAuxiliar
						randomNumberFrom: (aTestCase indexOf: aArg) + 1
						to: (aTestCase indexOf: aStatement varName) - 1.
					(aTestCase addStatement: newStatement at: position)
						ifTrue: [ (aTestCase statementAt: aStatement varName) args
								at: index
								put: newStatement varName.
							^ {newStatement varName} ] ] ].
	^ nil
]

{ #category : #accessing }
SStatement >> insertRandomCallUsing: aTestCase [
	^ self subclassResponsibility
]

{ #category : #accessing }
SStatement >> isConstructor [
	^ false
]

{ #category : #accessing }
SStatement >> isField [
	^ false.
]

{ #category : #accessing }
SStatement >> isMethod [
	^ false.
]

{ #category : #accessing }
SStatement >> isPrimitive [
	^ false
]

{ #category : #'as yet unclassified' }
SStatement >> notReferenced: referencedVarNames orIrrelevant: dictStringStatement [
	^ self subclassResponsibility 
]

{ #category : #printing }
SStatement >> printOn: aStream [
	^ self subclassResponsibility.
]

{ #category : #'as yet unclassified' }
SStatement >> referencesToArgs: varNames [
	self subclassResponsibility 
]

{ #category : #mutation }
SStatement >> repairOn: aTestCase changing: aStatement [
	^ self subclassResponsibility
]

{ #category : #mutation }
SStatement >> repairOn: aTestCase deleting: aStatement [
	^ self subclassResponsibility.
]

{ #category : #accessing }
SStatement >> returnTypeName [
	^ returnTypeName
]

{ #category : #accessing }
SStatement >> returnTypeName: anObject [
	returnTypeName := anObject
]

{ #category : #'as yet unclassified' }
SStatement >> satisfyParameters: aTestCase with: otherTestCase [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SStatement >> stringBody [ 
	^ self subclassResponsibility 
]

{ #category : #accessing }
SStatement >> varName [
	^ self variableKeyword , id asString
]

{ #category : #'as yet unclassified' }
SStatement >> variableKeyword [
	^  '_var'

]
