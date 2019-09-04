Class {
	#name : #STypeInfoTestWithRoassal,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Roassal'
}

{ #category : #running }
STypeInfoTestWithRoassal >> tearDown [
	"S2Lock value: false.
	S2Context value: nil.
	S2Profiler remove"

	
]

{ #category : #tests }
STypeInfoTestWithRoassal >> testAsTypeInfoRTUMLClassBuilder [
	| profile typeInfo argTypes |
	profile := SSGenerator
		profile: [ | someClasses allMethodCategories b n |
			someClasses := RTShape withAllSubclasses.
			allMethodCategories := (someClasses flatCollect: #protocols) asSet
				asArray.
			b := RTUMLClassBuilder new.
			n := RTMultiLinearColorForIdentity new objects: allMethodCategories.
			b methodShape color: [ :m | n rtValue: m protocol ].
			b methodsNames: [ :cls | cls rtmethods sortedAs: #protocol ].
			b addObjects: someClasses.
			b treeLayout.
			b build.
			b view ]
		onClass: RTUMLClassBuilder.
	typeInfo := profile asTypeInfo.
	self
		assert: (typeInfo types at: #RTUMLClassBuilder) methodTypes size
		equals: 53.
	self
		assert:
			(typeInfo scalars keys
				allSatisfy: [ :aName | (aName splitOn: ' ') size = 1 ]).
	argTypes := ((typeInfo types at: #RTUMLClassBuilder) methodTypes
		flatCollect: [ :methType | methType allArgTypes ]) asSet.
	self
		assert: (argTypes allSatisfy: [ :aName | (aName splitOn: ' ') size = 1 ])
]
