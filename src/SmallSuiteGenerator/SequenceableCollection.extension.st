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

	self randomShuffle do:[ :each|
		[ ^ aBlock value: each. ] on: SError 
		do:[ false ]. ].
	aNoneBlock value.
]
