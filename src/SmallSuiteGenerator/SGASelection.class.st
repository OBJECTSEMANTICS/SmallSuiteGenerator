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

{ #category : #actions }
SGASelection >> fitnessFor: aTestCase [

	^ aTestCase fitness at: fitness functionName
]

{ #category : #initialization }
SGASelection >> initialize [
]

{ #category : #selection }
SGASelection >> selectJustOneOf: aCollection with: probabilities [

	^ self subclassResponsibility 
]

{ #category : #selection }
SGASelection >> selectOf: collection [

	^ self subclassResponsibility 
]
