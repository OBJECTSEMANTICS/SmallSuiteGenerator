Extension { #name : #String }

{ #category : #'*SmallSuiteGenerator' }
String >> fullClassName [
	^ self.
]

{ #category : #'*SmallSuiteGenerator' }
String >> fullClassNameSymbol [
	^ self asSymbol.
]

{ #category : #'*SmallSuiteGenerator' }
String >> mutateToChange [
	| interval stringCopy |
	"correct bug to some characters form the string correctly, e.g: $-> problem in a string"
	interval := (41 to: 127) asArray.
	stringCopy := self
		ifEmpty: [ '' ]
		ifNotEmpty: [ self copyFrom: 1 to: self size - 1 ].
	^ ((Character value: (SPlatform randomGenerator selectAtRandom: interval))
		asString , stringCopy
		,
			(Character value: (SPlatform randomGenerator selectAtRandom: interval)) asString)
		asString
]
