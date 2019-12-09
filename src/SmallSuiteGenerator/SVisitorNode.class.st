"
Visit any RBProgramNode in the sintax tree and evaluate literal values

    Instance Variables
	literals:		<Dictionary>
"
Class {
	#name : #SVisitorNode,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'literals'
	],
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #initialization }
SVisitorNode >> initialize [ 
	literals := Dictionary new
]

{ #category : #accessing }
SVisitorNode >> literals [
	^ literals
]

{ #category : #visiting }
SVisitorNode >> visitLiteralNode: aLiteralNode [
	| literalValue aValue |
	literalValue := aLiteralNode value.
	aValue := literals at: literalValue class name ifAbsentPut: [ Set new ].
	aValue add: literalValue
]
