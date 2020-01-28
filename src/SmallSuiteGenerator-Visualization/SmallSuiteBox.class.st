Class {
	#name : #SmallSuiteBox,
	#superclass : #RTBox,
	#category : #'SmallSuiteGenerator-Visualization'
}

{ #category : #public }
SmallSuiteBox >> elementOn: aModel [
  self color: aModel stmColor.
  ^RTElement new
     model: aModel;
     addShape: self;
     yourself
]

{ #category : #initialization }
SmallSuiteBox >> initialize [
  super initialize.
  height := 1.
]
