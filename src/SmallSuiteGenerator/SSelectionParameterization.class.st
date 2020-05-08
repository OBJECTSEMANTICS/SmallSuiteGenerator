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
		at: #rankSelection put: [ :testCaseFactory |
			testCaseFactory selectionStrategy: SGARankSelection new ];
		at: #tournamentSelection put: [ :testCaseFactory |
			testCaseFactory selectionStrategy: SGATournamentSelection new ];
		at: #rouleteWheelSelection put: [ :testCaseFactory |
			testCaseFactory selectionStrategy: SGARouletteSelection new ];
		at: #rankSelectionForTestCase put: [ :testCaseFactory |
			testCaseFactory selectionStrategyTestCase: SGARankSelection new ];
		at: #tournamentSelectionForTestCase put: [ :testCaseFactory |
			testCaseFactory selectionStrategyTestCase: SGATournamentSelection new ];
		at: #rouleteWheelSelectionForTestCase put: [ :testCaseFactory |
			testCaseFactory selectionStrategyTestCase: SGARouletteSelection new ];
		yourself
]
