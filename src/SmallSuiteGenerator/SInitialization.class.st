"
SInitialization is abstract class to create an instance taking some considerations
"
Class {
	#name : #SInitialization,
	#superclass : #SObject,
	#instVars : [
		'configurationDict'
	],
	#category : #'SmallSuiteGenerator-Initialization'
}

{ #category : #copying }
SInitialization >> copy: testCaseFactory [
	^ testCaseFactory class new 
		typeInfo: testCaseFactory typeInfoOrigin copy;
		fitness: testCaseFactory fitness class new;
		targetClassName: testCaseFactory targetClassName;
		targetPackageRegex: testCaseFactory targetPackageRegex;
		outputPackageName: testCaseFactory outputPackageName;
		asDict: testCaseFactory initialAsDict;
		seed: testCaseFactory initialSeed;
		fitnessSeedCalculated: testCaseFactory fitnessSeed;
		numberOfGenerations: testCaseFactory numberOfGenerations;
		numberOfStatements: testCaseFactory engine numberOfStatements;
		populationSize: testCaseFactory engine populationSize;
		yourself
]

{ #category : #initialization }
SInitialization >> initialize [ 	
	configurationDict := self initializeDictionary
]

{ #category : #initialization }
SInitialization >> initializeDictionary [
	^ self subclassResponsibility 
]

{ #category : #'public tree building' }
SInitialization >> newInstance: testCaseFactory with: key [
	| instance |
	instance := self copy: testCaseFactory.
	(configurationDict at: key) value: instance.
	instance createTestCases.
	^ instance
	
]
