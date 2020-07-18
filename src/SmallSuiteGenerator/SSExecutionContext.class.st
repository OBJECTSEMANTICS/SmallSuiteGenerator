"
SSExecutionContext takes a snapshot of the SSTestRunner's instance context. It saves the tempNames of variables and values as dictionary

Instance Variables
	values:		<Dictionary>
"
Class {
	#name : #SSExecutionContext,
	#superclass : #SObject,
	#instVars : [
		'values'
	],
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #accessing }
SSExecutionContext >> associations [
	^ values associations
]

{ #category : #initialization }
SSExecutionContext >> at: aSymbol [
  ^ values at: aSymbol ifAbsent:[ Smalltalk at: aSymbol]

]

{ #category : #initialization }
SSExecutionContext >> at: aSymbol put: aValue [
	values at: aSymbol put: aValue.
]

{ #category : #initialization }
SSExecutionContext >> initialize [
	super initialize.
	values := OrderedDictionary new
]

{ #category : #initialization }
SSExecutionContext >> keys [
	^ values keys asOrderedCollection 
]

{ #category : #initialization }
SSExecutionContext >> removeKey: key [
	^ values removeKey: key. 
]
