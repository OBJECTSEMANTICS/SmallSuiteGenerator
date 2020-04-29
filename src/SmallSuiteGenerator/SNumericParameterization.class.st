Class {
	#name : #SNumericParameterization,
	#superclass : #SInitialization,
	#category : #'SmallSuiteGenerator-Initialization'
}

{ #category : #'public tree building' }
SNumericParameterization >> newInstances: testCaseFactory [
	| generationSizes statementSizes populationSizes |
	generationSizes := statementSizes := populationSizes := #(10 30).
	^ generationSizes flatCollect: [ :gSize | 
		statementSizes flatCollect: [ :stmtSize | 
			populationSizes collect: [ :pSize | 
				| instance |
				instance := self copy: testCaseFactory.
				instance numberOfGenerations: gSize;
				numberOfStatements: stmtSize;
				populationSize: pSize;
				createTestCases;
				yourself ] ] 
		 ]
	
]
