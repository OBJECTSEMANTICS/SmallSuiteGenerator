"
Abstract class for strategy selection
"
Class {
	#name : #SGASelection,
	#superclass : #SGAObject,
	#instVars : [
		'fitness'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #accessing }
SGASelection >> fitness: anObject [ 
	fitness := anObject 
]

{ #category : #initialization }
SGASelection >> initialize [
]
