Extension { #name : #Object }

{ #category : #'*SmallSuiteGenerator' }
Object >> aVariableNodeClass [
	^ RBVariableNode
]

{ #category : #'*SmallSuiteGenerator' }
Object class >> createMainMethodsFor: aClass [
	aClass aClass: self.
	aClass targetPackageRegex: self package name asString
]

{ #category : #'*SmallSuiteGenerator' }
Object class >> createTestCaseConfig [
	|aClass|
	aClass := self getClassOf: ('GA' , self name , 'Test').
	self createMainMethodsFor: aClass.
	^ aClass
]

{ #category : #'*SmallSuiteGenerator' }
Object class >> createTestCaseConfigWithName: aString [
	|aClass|
	aClass := self getClassOf: aString.
	self createMainMethodsFor: aClass.
	^ aClass
]

{ #category : #'*SmallSuiteGenerator' }
Object class >> getClassOf: aString [
	| aClassName class |
	aClassName := aString asSymbol.
	class := SPlatform lookUpClass: aClassName.
	class
		ifNil: [ class := SPlatform
				createTestCaseClass: aClassName
				inPackage: SPlatform testCaseClass outputPackageName].
	^ class
]

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
Object >> storeContainsOn: aStream [
	"Append to the argument aStream a sequence of characters that is an 
	expression whose evaluation creates an object similar to the receiver."
	SPlatform reduceLevel.
	aStream nextPut: $(.
	SPlatform levelToPrint < 0
		ifFalse: [ 1 to: self class instSize do: [ :i | 
				aStream
					nextPutAll: ' instVarAt: ';
					store: i;
					nextPutAll: ' put: (';
					store: (self instVarAt: i);
					nextPutAll: ');' ].
			1 to: self basicSize do: [ :i | 
				aStream
					nextPutAll: ' basicAt: ';
					store: i;
					nextPutAll: ' put: ';
					store: (self basicAt: i);
					nextPut: $; ] ].
	aStream nextPutAll: ' yourself)'
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
					nextPutAll: ' put: (';
					store: (self instVarAt: i);
					nextPutAll: ');' ].
			1 to: self basicSize do: [ :i | 
				aStream
					nextPutAll: ' basicAt: ';
					store: i;
					nextPutAll: ' put: ';
					store: (self basicAt: i);
					nextPut: $; ] ].
	aStream nextPutAll: ' yourself)'
]
