Class {
	#name : #SRandom,
	#superclass : #Random,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #enumerating }
SRandom >> collectAtRandom: collection [
	| indexes |
	indexes := self shuffleCollection: collection size.
	^ indexes
		inject: OrderedCollection new
		into: [ :result :index | 
			result add: (collection at: index).
			result ]
]

{ #category : #enumerating }
SRandom >> selectAtRandom: collection [
	^ collection at: (self nextInt: collection size)
]

{ #category : #enumerating }
SRandom >> shuffleCollection: stop [
	|numbers|
	numbers := (1 to: stop) asArray.
	stop to: 2 by: -1 do: [ :i | numbers swap: i with: (self nextInt: i) ].
	^ numbers
]
