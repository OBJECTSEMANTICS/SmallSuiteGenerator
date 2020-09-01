"
SSGParser is an abstract visitor to convert RBNodes to SNodes
"
Class {
	#name : #SSGParser,
	#superclass : #RBProgramNodeVisitor,
	#category : #'SmallSuiteGenerator-Utility'
}

{ #category : #parsing }
SSGParser class >> parseFrom: aRBNode [
	^ self new parse: aRBNode 
]

{ #category : #parsing }
SSGParser >> parse: aNode [
	^ aNode acceptVisitor: self
]

{ #category : #parsing }
SSGParser >> variableId: aString [
	^ ('_var*' match: aString) 
			ifTrue:[ (aString copyFrom: 5 to: aString size) asInteger ] 
			ifFalse:[nil].
]

{ #category : #parsing }
SSGParser >> variableName: aString [
	^ ('_var*' match: aString) ifTrue:[ '_var'] ifFalse:[ aString].
]

{ #category : #parsing }
SSGParser >> visitAssignmentNode: anAssignmentNode [
	^ SAssignment new
		variable: (self visitNode: anAssignmentNode variable);
		value: (self visitNode: anAssignmentNode value);
		yourself 
]

{ #category : #parsing }
SSGParser >> visitCascadeNode: aCascadeNode [
	| sCascade |
	sCascade := SCascade new.
	aCascadeNode messages do: [ :each | sCascade addMessage: (self visitNode: each) ].
	^ sCascade
]

{ #category : #parsing }
SSGParser >> visitLiteralNode: aLiteralNode [
	^ SLiteral value: aLiteralNode value
]

{ #category : #parsing }
SSGParser >> visitMessageNode: aMessageNode [
	^ SMessage new
		receiver: (self visitNode: aMessageNode receiver);
		selector: aMessageNode selector;
		args: (aMessageNode arguments collect: [ :arg | self visitNode: arg  ])
]

{ #category : #parsing }
SSGParser >> visitSequenceNode: aSequenceNode [
	| seq |
	seq := SSequense new.
	aSequenceNode temporaries do: [ :tmp | seq addTemporarie: (self visitNode: tmp) ].
	aSequenceNode statements do: [ :each | seq addMessage: (self visitNode: each) ].
	^ seq
]

{ #category : #parsing }
SSGParser >> visitVariableNode: aVariableNode [
	^ (SVariable new 
			varName: (self variableName: aVariableNode name); 
			id: (self variableId: aVariableNode name); 
			yourself)
]
