Extension { #name : #Character }

{ #category : #'*SmallSuiteGenerator' }
Character >> mutateToChange [ 
	^ Character value: (STransformValue randomValueCharacter: self)
]
