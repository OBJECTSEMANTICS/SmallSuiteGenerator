Class {
	#name : #SInitialization,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-Initialization'
}

{ #category : #copying }
SInitialization >> copy: testCaseFactory [
	^ testCaseFactory class new 
		typeInfo: testCaseFactory typeInfo;
		fitness: testCaseFactory fitness class new;
		targetClassName: testCaseFactory targetClassName;
		targetPackageRegex: testCaseFactory targetPackageRegex;
		outputPackageName: testCaseFactory outputPackageName;
		yourself
]

{ #category : #'public tree building' }
SInitialization >> newInstances: testCaseFactory [
	^ self subclassResponsibility
]
