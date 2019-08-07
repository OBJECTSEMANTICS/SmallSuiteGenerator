Class {
	#name : #SRenamerVariable,
	#superclass : #SRefactoring,
	#category : #'SmallSuiteGenerator-Refactorization'
}

{ #category : #hook }
SRenamerVariable class >> applyOn: aSTestCase [
	| dictReferences |
	dictReferences := self dictReferencesOf: aSTestCase.
	^ aSTestCase statements
		collect: [ :stm | 
			| newName oldVarName  |
			newName := self nameBasedOnType: stm.
			oldVarName := stm varName.
			stm varKeyword: newName.
			newName := String
										streamContents: [ :stream | 
											stream
												nextPutAll: newName;
												nextPutAll: stm id asString ].
			dictReferences
				at: oldVarName
				ifPresent: [ :varNames | 
					varNames
						do: [ :varName | 
							(aSTestCase statementAt: varName)
								replace: oldVarName
								varNameBy:
									newName ] ].
			oldVarName ]
]

{ #category : #'as yet unclassified' }
SRenamerVariable class >> nameBasedOnType: aStatement [
	| nameType names newName list first |
	nameType := aStatement typeVar asString.
	({'UndefinedObject' . 'nil'} includes: nameType)
		ifTrue: [ ^ '_var' ].
	names := nameType
		copyWithRegex: '[[:upper:]]+'
		matchesTranslatedUsing: [ :each | '.' , each ].
	list := names splitOn: '.'.
	list first ifEmpty: [ list := list allButFirst ].
	first := list first.
	newName := String
		streamContents: [ :stream | 
			stream nextPut: $_.
			list size = 1
				ifTrue: [ stream nextPutAll: first asLowercase ]
				ifFalse:
					[ stream nextPutAll: (self subStringOf: first stringTo: 3) asLowercase.
					list allButFirst
						do: [ :aString | stream nextPutAll: (self subStringOf: aString stringTo: 3) ] ] ].
	^ newName
]

{ #category : #'as yet unclassified' }
SRenamerVariable class >> subStringOf: string stringTo: limit [
	^ [ string copyFrom: 1 to: limit ]
		on: Exception
		do: [ string copyFrom: 1 to: string size ]
]
