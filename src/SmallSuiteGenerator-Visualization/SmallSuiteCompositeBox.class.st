Class {
	#name : #SmallSuiteCompositeBox,
	#superclass : #RTCompositeShape,
	#category : #'SmallSuiteGenerator-Visualization'
}

{ #category : #initialization }
SmallSuiteCompositeBox >> initialize [ 
	super initialize.
	shapes add: RTBox new;
	add: SmallSuiteBox new.
]
