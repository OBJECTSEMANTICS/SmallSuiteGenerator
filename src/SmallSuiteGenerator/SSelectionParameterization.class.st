Class {
	#name : #SSelectionParameterization,
	#superclass : #SInitialization,
	#category : #'SmallSuiteGenerator-Initialization'
}

{ #category : #'public tree building' }
SSelectionParameterization class >> setting: testCaseFactory [
	testCaseFactory engine 	
		selectionOfGA: self gaSelection;
		selectionOfTestCase: self testCaseSelection;
		yourself
]