Extension { #name : #Object }

{ #category : #'*SmallSuiteGenerator' }
Object >> mutateToChange [
	^ self
]

{ #category : #'*SmallSuiteGenerator' }
Object >> smallStoreString [
	| string |
	SPlatform initLevelToPrint.
	string := String
		streamContents: [ :s | 
			self storeOn: s.
			SPlatform levelToPrint < 0
				ifTrue:
					[ "^ s nextPutAll: '(' , self class name , ' new ) '" SError signal: 'error in storeString' ].
			SPlatform initLevelToPrint ].
	^ string
]

{ #category : #'*SmallSuiteGenerator' }
Object >> storeOn: aStream [
	"Append to the argument aStream a sequence of characters that is an 
	expression whose evaluation creates an object similar to the receiver."

	SPlatform reduceLevel.
	aStream nextPut: $(.
	self class isVariable
		ifTrue: [ aStream
				nextPutAll: '(' , self class name , ' basicNew: ';
				store: self basicSize;
				nextPutAll: ') ' ]
		ifFalse: [ aStream nextPutAll: self class name , ' basicNew' ].
	SPlatform levelToPrint < 0
		ifFalse: [ 1 to: self class instSize do: [ :i | 
				aStream
					nextPutAll: ' instVarAt: ';
					store: i;
					nextPutAll: ' put: ';
					store: (self instVarAt: i);
					nextPut: $; ].
			1 to: self basicSize do: [ :i | 
				aStream
					nextPutAll: ' basicAt: ';
					store: i;
					nextPutAll: ' put: ';
					store: (self basicAt: i);
					nextPut: $; ] ].
	aStream nextPutAll: ' yourself)'
]
