"
Remove this class with the subbclasses
Just use STypeInfo
"
Class {
	#name : #SSpyInfo,
	#superclass : #STypeInfo,
	#instVars : [
		'packages',
		'classes',
		'methods',
		'scalars'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #'as yet unclassified' }
SSpyInfo class >> typeInfo: aProfiler [
	^ self new typeInfo: aProfiler
]

{ #category : #operations }
SSpyInfo >> >> aSymbol [
	"Fetching a class"

	"we are accessing a method defined in a metaclass"

	(aSymbol includes: $ )
		ifTrue: [ ^ (self >> aSymbol substrings first asSymbol) metaclassSpy ].
	^ self classAt: aSymbol
]

{ #category : #accessing }
SSpyInfo >> allClasses [
	^ classes values asOrderedCollection 
]

{ #category : #'accessing - read only' }
SSpyInfo >> allClassesAsDictionary [ 
	^ classes
]

{ #category : #'private-packages' }
SSpyInfo >> allMethods [
	^ methods
]

{ #category : #accessing }
SSpyInfo >> classAt: aSymbol [
^ self allClassesAsDictionary
		at: aSymbol
		ifAbsent: [ self error: 'Class ' , aSymbol , ' not found' ]
]

{ #category : #accessing }
SSpyInfo >> classAt: aSymbol ifNone: aBlock [
	^ self allClassesAsDictionary at: aSymbol ifAbsent: aBlock
]

{ #category : #accessing }
SSpyInfo >> scalars [
	^ scalars
]

{ #category : #'as yet unclassified' }
SSpyInfo >> typeInfo: aProfiler [
	packages := aProfiler packagesDictionary.
	classes := aProfiler allClassesAsDictionary.
	methods := aProfiler allMethods.
	self updateInfo
]

{ #category : #accessing }
SSpyInfo >> updateInfo [
	info
		at: 'packages' put: packages;
		at: 'classes' put: classes;
		at: 'methods' put: methods
]
