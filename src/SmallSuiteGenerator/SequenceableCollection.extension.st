Extension { #name : #SequenceableCollection }

{ #category : #'*SmallSuiteGenerator' }
SequenceableCollection >> pickAny [
	^ self at: (SPlatform randomGenerator nextInt: self size)
]

{ #category : #'*SmallSuiteGenerator' }
SequenceableCollection >> randomShuffle [
	^ self shuffleBy: SPlatform randomGenerator.
]

{ #category : #'*SmallSuiteGenerator' }
SequenceableCollection >> safelyPickAny: aBlock ifNone: aNoneBlock [

	self shuffle do:[ :each|
		[ ^ aBlock value: each. ] on: Error 
		do:[ false ]. ].
	aNoneBlock value.
]
