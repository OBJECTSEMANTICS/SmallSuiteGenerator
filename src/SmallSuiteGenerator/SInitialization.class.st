Class {
	#name : #SInitialization,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-Initialization'
}

{ #category : #copying }
SInitialization >> copy: testCaseFactory [
	^ testCaseFactory class new 
		typeInfo: testCaseFactory typeInfo copy;
		fitness: testCaseFactory fitness class new;
		targetClassName: testCaseFactory targetClassName;
		targetPackageRegex: testCaseFactory targetPackageRegex;
		outputPackageName: testCaseFactory outputPackageName;
		asDict: testCaseFactory initialAsDict;
		seed: testCaseFactory initialSeed;
		fitnessSeedCalculated: testCaseFactory fitnessSeed;
		yourself
]

{ #category : #'public tree building' }
SInitialization >> newInstances: testCaseFactory [
	^ self subclassResponsibility
]
