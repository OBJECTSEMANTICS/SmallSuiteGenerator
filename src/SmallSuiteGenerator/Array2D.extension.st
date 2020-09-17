Extension { #name : #Array2D }

{ #category : #'*SmallSuiteGenerator' }
Array2D >> storeOn: aStream [
	(numberOfRows isNil or: [numberOfColumns isNil or: [contents isNil]]) 
	ifFalse: [
		aStream nextPut: $(; nextPutAll: self class name;
			nextPutAll: ' rows: '; store: numberOfRows;
			nextPutAll: ' columns: '; store: numberOfColumns;
			nextPutAll: ' contents: '; store: contents;
			nextPut: $)
	] ifTrue: [ 
		SPlatform reduceLevel.
		aStream nextPut: $(.
		self class isVariable
			ifFalse: [ aStream nextPutAll: self class name , ' basicNew' ].
		SPlatform levelToPrint < 0
			ifFalse: [ 1 to: self class instSize do: [ :i | 
				aStream
					nextPutAll: ' instVarAt: ';
					store: i;
					nextPutAll: ' put: (';
					store: (self instVarAt: i);
					nextPutAll: ');' ] ].
		aStream nextPutAll: ' yourself)'
	]
]
