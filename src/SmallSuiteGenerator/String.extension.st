Extension { #name : #String }

{ #category : #'*SmallSuiteGenerator' }
String >> mutateToChange [
	| interval |
		"correct bug to some characters form the string correctly, e.g: $-> problem in a string"
			interval := 33 to: 127.
			^ ((Character value: interval atRandom) asString
				, (self copyFrom: 1 to: self size - 1)
				, (Character value: interval atRandom) asString) printString.
]
