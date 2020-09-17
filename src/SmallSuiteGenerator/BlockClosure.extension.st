Extension { #name : #BlockClosure }

{ #category : #'*SmallSuiteGenerator' }
BlockClosure >> storeOn: aStream [
	
	(self method hasSourceCode
		or: [ "There is a decompiler"
			self class environment includesKey: #FBDDecompiler ])
				ifTrue: [ aStream nextPutAll: (self sourceNode formattedCode) ]
				ifFalse: [ self error: 'StoreOn error' ]
]
