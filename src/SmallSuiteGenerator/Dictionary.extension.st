Extension { #name : #Dictionary }

{ #category : #'*SmallSuiteGenerator' }
Dictionary >> sum: aDictionary [ 
	(self keys union: aDictionary keys) do: [ :k |
		self at: k put: (self at: k ifAbsent: [0]) + (aDictionary at: k ifAbsent: [0]).
	 ].
	^ self
]
