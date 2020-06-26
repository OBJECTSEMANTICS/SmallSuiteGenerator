Extension { #name : #Collection }

{ #category : #'*SmallSuiteGenerator' }
Collection >> asOrderedSet [
	"Answer a OrderedCollection whose elements are the unique elements of the receiver."
	| n |
	n := OrderedCollection new.
	self do: [ :e | (n includes: e) ifFalse: [ n add: e ] ].
	^ n
]

{ #category : #'*SmallSuiteGenerator' }
Collection >> unionOrdered: aCollection [
	"Answer the set theoretic union of two collections."
	"(#(1 2 3) union: #(4 5 6 2)) >>> #(1 2 3 4 5 6)"
	
	| set |
	set := self asOrderedSet addAll: aCollection; yourself.
	^ self species withAll: set asArray
]
