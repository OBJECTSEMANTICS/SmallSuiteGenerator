"
SSelectionParametrization creates instances changing selectionStrategy of GA and use: 	
	- SGATournamentSelection 
	- SGARankSelectionModified 
	- SGARouletteSelection 
"
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

{ #category : #initialization }
SSelectionParameterization >> initializeDictionary [
	^ Dictionary new 
		at: #rankSelectionModified put: [ :testCaseFactory |
			testCaseFactory selectionStrategy: SGARankSelectionModified new ];
		at: #tournamentSelection put: [ :testCaseFactory |
			testCaseFactory selectionStrategy: SGATournamentSelection new ];
		at: #rouleteWheelSelection put: [ :testCaseFactory |
			testCaseFactory selectionStrategy: SGARouletteSelection new ];
		yourself
]
