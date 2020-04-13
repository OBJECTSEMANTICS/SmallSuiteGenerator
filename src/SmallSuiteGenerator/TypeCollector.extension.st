Extension { #name : #TypeCollector }

{ #category : #'*SmallSuiteGenerator' }
TypeCollector class >> collectorAfterTypeInstvarsOfClass: aClass [
	"self typeInstvarsOfClass: Point"

	^self new typeInstvarsOfClass: aClass; yourself
]

{ #category : #'*SmallSuiteGenerator' }
TypeCollector >> localTypingResults [
	^ localTypingResults
]

{ #category : #'*SmallSuiteGenerator' }
TypeCollector class >> new [
	"Override new to return either a VWTypeCollector or a SqueakTypeCollector"

	^self newForPlatform
]

{ #category : #'*SmallSuiteGenerator' }
TypeCollector class >> newForPlatform [
	"Return either a VWTypeCollector or a SqueakTypeCollector, depending on the platform used."

	^PharoTypeCollector basicNew
]

{ #category : #'*SmallSuiteGenerator' }
TypeCollector class >> onClass: aClass [
	^self new onClass: aClass
]

{ #category : #'*SmallSuiteGenerator' }
TypeCollector class >> typeInstvar: var ofClass: aClass [
	"self typeInstvar: #x ofClass: Point "

	^(self new typeInstvarsOfClass: aClass) at: var
]

{ #category : #'*SmallSuiteGenerator' }
TypeCollector class >> typeInstvar: var ofClassWithLookup: aClass [ 
	"self typeInstvar: #origin ofClassWithLookup: Quadrangle"
	| theClass |
	theClass := aClass.
	[theClass isNil not
		and: [theClass instVarNames includes: var]]
		whileFalse: [theClass := theClass superclass].
	theClass isNil
		ifTrue: [^ ExtractedType new].
	^ self typeInstvar: var ofClass: theClass
]

{ #category : #'*SmallSuiteGenerator' }
TypeCollector class >> typeInstvarsOfClass: aClass [
	"self typeInstvarsOfClass: Point"

	^self new typeInstvarsOfClass: aClass
]

{ #category : #'*SmallSuiteGenerator' }
TypeCollector class >> typeTmpsIn: aCompiledMethod ofClass: aClass [
	"self typeInstvarsOfClass: Point"

	^self new typeTmpsIn: aCompiledMethod ofClass: aClass
]

{ #category : #'*SmallSuiteGenerator' }
TypeCollector class >> versionString [
	"Take the removal of the standard version method on Smalltalk into account for Squeak :-( "

	^(Smalltalk
		at: #SystemVersion
		ifAbsent: [^Smalltalk version]) current version
]
