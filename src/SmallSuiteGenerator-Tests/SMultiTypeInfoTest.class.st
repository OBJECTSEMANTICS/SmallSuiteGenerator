Class {
	#name : #SMultiTypeInfoTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Info'
}

{ #category : #tests }
SMultiTypeInfoTest >> testEqual [
	|stringSymbol|
	stringSymbol := #ByteString fullClassNameSymbol.
	self assert: (SMultiTypeInfo new type: stringSymbol) equals: (SMultiTypeInfo new type: stringSymbol)
]

{ #category : #tests }
SMultiTypeInfoTest >> testFromSton [
	| multiTypeInfo |
	multiTypeInfo := SMultiTypeInfo new type: #ByteString.
	self
		assert: (STON fromString: 'SMultiTypeInfo [#ByteString]')
		equals: multiTypeInfo.
	multiTypeInfo := SMultiTypeInfo new
		type: #ByteString;
		type: #SmallInteger.
	self
		assert: (STON fromString: 'SMultiTypeInfo [#ByteString, #SmallInteger]')
		equals: multiTypeInfo.
	multiTypeInfo := SMultiTypeInfo new
		type: #ByteString;
		type: #SmallInteger;
		type: #SStudent.
	self
		assert:
			(STON
				fromString: 'SMultiTypeInfo [#ByteString, #SmallInteger, #SStudent, #ByteString]')
		equals: multiTypeInfo
]

{ #category : #tests }
SMultiTypeInfoTest >> testToString [
	| string multiType |
	multiType :=  (SMultiTypeInfo new type: #ByteString).
	string := STON toString: multiType.
	self assert: (STON fromString:string) equals: multiType.
	
	multiType := 
			(SMultiTypeInfo new
				type: #ByteString;
				type: #SmallInteger).
	string := STON toString: multiType.
	self
		assert: (STON fromString: string)
		equals: multiType.
	multiType := (SMultiTypeInfo new
				type: #ByteString;
				type: #SmallInteger;
				type: #SStudent).
	string := STON
		toString:
			multiType.
	self
		assert: (STON fromString: string)
		equals: multiType
]
