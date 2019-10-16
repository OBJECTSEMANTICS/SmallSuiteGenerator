Class {
	#name : #SRenameVariable,
	#superclass : #SVisitor,
	#instVars : [
		'targetVarName',
		'newName'
	],
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #accessing }
SRenameVariable >> newName [
	^ newName
]

{ #category : #accessing }
SRenameVariable >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
SRenameVariable >> targetVarName [
	^ targetVarName
]

{ #category : #accessing }
SRenameVariable >> targetVarName: anObject [
	targetVarName := anObject
]

{ #category : #visiting }
SRenameVariable >> visitVariable: aVariable [
	aVariable printString = targetVarName
		ifTrue: [ aVariable varName: newName ]
]
