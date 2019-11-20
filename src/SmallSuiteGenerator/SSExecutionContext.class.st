Class {
	#name : #SSExecutionContext,
	#superclass : #SObject,
	#instVars : [
		'values'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #initialization }
SSExecutionContext >> at: aSymbol [
	^ values at: aSymbol.
]

{ #category : #initialization }
SSExecutionContext >> at: aSymbol put: aValue [
	values at: aSymbol put: aValue.
]

{ #category : #initialization }
SSExecutionContext >> initialize [
	super initialize.
	values := Dictionary new.
]

{ #category : #initialization }
SSExecutionContext >> keys [
	^ values keys asOrderedCollection 
]
