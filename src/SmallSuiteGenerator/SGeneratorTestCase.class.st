Class {
	#name : #SGeneratorTestCase,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Generator'
}

{ #category : #'as yet unclassified' }
SGeneratorTestCase >> methodsWithMutationFrom: testClasses mutating: classes using: operators with: evaluationStrategy [
	| analysis |
	analysis := MutationTestingAnalysis
		testCasesFrom: testClasses
		mutating:
			classes
		using: operators
		with: evaluationStrategy .
	analysis run.
	^ analysis mutations
]

{ #category : #'as yet unclassified' }
SGeneratorTestCase >> mutatedMethodsFrom: testClasses mutating: classes using: operators with: evaluationStrategy [
	| analysis |
	analysis := MutationTestingAnalysis
		testCasesFrom: testClasses
		mutating: classes
		using: operators
		with: evaluationStrategy.
	analysis run.
	^ analysis mutations
]

{ #category : #'as yet unclassified' }
SGeneratorTestCase >> profileMutatedMethodsFrom: methods using: profile [
	| newProfile data |
	newProfile := SSGenerator new.
	data := SAuxiliar
		packagesClassesAndMethodsOf: profile
		filterBy: methods.
	self
		assert: data size = 3
		description: 'Data must contain: packages, classes and methods'.
	newProfile
		addPackagesToProfile: data first asOrderedCollection;
		addClassesToProfile: data second asOrderedCollection;
		addMethodsToProfile: data third asOrderedCollection.
	^ newProfile
]
