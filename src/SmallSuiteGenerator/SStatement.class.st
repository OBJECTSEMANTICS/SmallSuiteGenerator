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
SStatement class >> create: id [
	| inst |
	inst := self new.
	inst id: id.
	^ inst
]

{ #category : #'as yet unclassified' }
SStatement >> collectDependencies [
	^ self subclassResponsibility 
]

{ #category : #private }
SStatement >> createNewStatement: aId [
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
	| args |
	args := aStatement args.
	args
		ifNotEmpty: [ | varNames position index newStatement |
			varNames := aTestCase varNames.
			index := 0.
			args
				detect: [ :aArg | 
					index := index + 1.
					(varNames includes: aArg)
						ifTrue: [ 
							newStatement := (aTestCase statementAt: aArg)
								createNewStatement: aTestCase assignedId.
							position := STransformValue
								randomNumberFrom: 1
								to: (aTestCase indexOf: aStatement varName) - 1
								default: 1.
							aTestCase addStatement: newStatement at: position ]
						ifFalse: [ false ] ]
				ifFound: [ (aTestCase statementAt: aStatement varName) args
						at: index
						put: newStatement varName.
					^ {newStatement varName} ]
				ifNone: [ ^ nil ] ].
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

{ #category : #printing }
SStatement >> printOn: aStream [
	^ self subclassResponsibility.
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

{ #category : #accessing }
SStatement >> varName [
	^ self variableKeyword , id asString
]

{ #category : #'as yet unclassified' }
SStatement >> variableKeyword [
	^  '_var'

]
