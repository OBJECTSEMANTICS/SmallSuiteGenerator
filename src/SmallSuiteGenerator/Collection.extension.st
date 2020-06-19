Extension { #name : #Collection }

{ #category : #'*SmallSuiteGenerator' }
Collection >> asOrderedSet [
	"Answer a OrderedCollection whose elements are the unique elements of the receiver."
	| n |
	n := OrderedCollection new.
	self do: [ :e | (n includes: e) ifFalse: [ n add: e ] ].
	^ n
]
