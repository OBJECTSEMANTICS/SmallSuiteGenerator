Extension { #name : #String }

{ #category : #'*SmallSuiteGenerator-Extensions' }
String >> mutateToChange [
	| interval stringCopy |
		"correct bug to some characters form the string correctly, e.g: $-> problem in a string"
			interval := 41 to: 127.
			stringCopy := self ifEmpty: [ '' ] ifNotEmpty: [ self copyFrom: 1 to: self size - 1 ].
			^ ((Character value: interval atRandom) asString
				, stringCopy
				, (Character value: interval atRandom) asString) printString.
]
