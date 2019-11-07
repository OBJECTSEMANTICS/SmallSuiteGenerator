Extension { #name : #S2Gatherer }

{ #category : #'*SmallSuiteGenerator' }
S2Gatherer >> methodsForClasses: classCollection [
	| nonMetaclasses |
	nonMetaclasses := (classCollection collect: #instanceSide) asSet.
	^ nonMetaclasses , (nonMetaclasses collect: #class)
		flatCollect: #methods
]
