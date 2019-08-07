Class {
	#name : #SGeneratorTestCase,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Mutalk'
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
SGeneratorTestCase >> packagesClassesAndMethodsOf: profile filterBy: mutatedMethods [
	| packages classes methods selectors |
	packages := Set new.
	classes := Set new.
	methods := Set new.
	selectors := (mutatedMethods
		collect: [ :meth | meth originalClass name -> meth originalMethod selector ])
		asSet.
	profile allMethods
		select:
			[ :meth | selectors includes: meth classSpy className -> meth selector ]
		thenDo: [ :meth | 
			| aClass splited |
			aClass := meth classSpy.
			packages add: aClass packageSpy packageName.
			splited := aClass className splitOn: ' '.
			classes
				add:
					(splited size > 1
						ifFalse: [ aClass className ]
						ifTrue: [ splited first asSymbol ]).
			methods add: meth classSpy className -> meth selector ].
	^ Array with: packages with:
	classes with: 
	methods
]

{ #category : #'as yet unclassified' }
SGeneratorTestCase >> packagesClassesAndMethodsOfTypeInfo: typeInfo filterBy: mutatedMethods [
	| packages classes methods assocMutation |
	packages := Set new.
	classes := Set new.
	methods := Set new.
	assocMutation := (mutatedMethods
		collect: [ :meth | meth originalClass name -> meth originalMethod selector ])
		asSet.
	(typeInfo types
		collect:
			[ :assoc | assoc values do: [ :aMethod | assoc key -> aMethod selector ] ]
		thenSelect: [ :assoc | assocMutation includes: assoc ]) asSet
		do: [ :assoc | 
			| aClass splited aClassName |
			aClassName := assoc key.
			aClass := Smalltalk at: aClassName.
			packages add: aClass packageSpy packageName.
			splited := aClassName splitOn: ' '.
			classes
				add:
					(splited size > 1
						ifFalse: [ aClassName ]
						ifTrue: [ splited first asSymbol ]).
			methods add: aClassName -> assoc value ].
	^ Array with: packages with: classes with: methods
]

{ #category : #'as yet unclassified' }
SGeneratorTestCase >> profileMutatedMethodsFrom: methods using: profile [
	| newProfile data |
	newProfile := profile copy.
	data := self
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
				select: [ :cls | data second includes: cls className ])
				asOrderedCollection;
		methods:
			(profile allMethods
				select:
					[ :meth | data third includes: meth classSpy className -> meth selector ])
				asOrderedCollection.
	^ newProfile
]

{ #category : #'as yet unclassified' }
SGeneratorTestCase >> profileMutatedMethodsFrom: methods usingTypeInfo: typeInfo [
	| newTypeInfo data |
	newTypeInfo := typeInfo copy.
	data := self
		packagesClassesAndMethodsOfTypeInfo: typeInfo
		filterBy: methods.
	self
		assert: data size = 3
		description: 'Data must contain: packages, classes and methods'.
	newTypeInfo
		packages:
			(typeInfo packagesDictionary associations
				select: [ :assoc | data first includes: assoc key ]) asDictionary.
	data second do: [ :aClassTypeInfo | newTypeInfo addClassInfo: aClassTypeInfo   ].
		"
			(profile allClasses
				select: [ :cls | data second includes: cls className ])
				asOrderedCollection;
		methods:
			(profile allMethods
				select:
					[ :meth | data third includes: meth classSpy className -> meth selector ])
				asOrderedCollection."
	^ newTypeInfo
]
