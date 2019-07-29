Class {
	#name : #SGeneratorTestCase,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Generators'
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
	newProfile := profile copy.
	data := SAuxiliar
		packagesClassesAndMethodsOf: profile
		filterBy: methods.
	self
		assert: data size = 3
		description: 'Data must contain: packages, classes and methods'.
	newProfile
		packages:
			(profile packagesDictionary associations
				select: [ :assoc | data first includes: assoc key ]) asDictionary;
		classes:
			(profile allClasses
				select: [ :cls | data second includes: cls className ]) asOrderedCollection ;
		methods:
			(profile allMethods
				select:
					[ :meth | data third includes: meth classSpy className -> meth selector ])
				asOrderedCollection.
	^ newProfile
]
