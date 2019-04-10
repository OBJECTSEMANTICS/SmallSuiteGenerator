Class {
	#name : #SSGenerator,
	#superclass : #S2Profiler,
	#instVars : [
		'instrumentedClasses',
		'scalars',
		'regexPackages',
		'packagesToInstrument'
	],
	#category : #'SmallSuiteGenerator-Profiler'
}

{ #category : #hooks }
SSGenerator class >> spyClassForPackage [
	 ^ SSGeneratorPackage
]

{ #category : #initialization }
SSGenerator >> addScalar: anObject [
	| value |
	value := scalars
		at: anObject class name
		ifAbsentPut: [ Set new ].
	value add: anObject storeString.
]

{ #category : #initialization }
SSGenerator >> initialize [
	super initialize.
	instrumentedClasses := Dictionary new.
	scalars := Dictionary new.
]

{ #category : #initialization }
SSGenerator >> isScalar: anObject [
	self allClassesAsDictionary
		at: anObject class name
		ifAbsent: [ ^ true ].
	^ false
]

{ #category : #accessing }
SSGenerator >> packages [
	regexPackages ifNil: [ ^ super packages ].
	packagesToInstrument ifNil: [ packagesToInstrument := packages values
		reject: [ :p | 
			(p classes
				select: [ :c | (c methods reject: #isNotMethodExtension) isNotEmpty ])
				isNotEmpty and: [ (regexPackages match: p packageName) not ] ] ].
	^ packagesToInstrument 
]

{ #category : #profiling }
SSGenerator >> profile: aBlock onPackagesMatching: regex [
	super profile: aBlock onPackagesMatching: regex.
	regexPackages := regex
]

{ #category : #initialization }
SSGenerator >> scalars [
	^ scalars.
]
