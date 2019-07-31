Class {
	#name : #SRefactoring,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Refactorization'
}

{ #category : #'as yet unclassified' }
SRefactoring class >> dataStatements: aSTestCase [
	| dictStringBody referencedVarNames varNames |
	varNames := aSTestCase varNames.
	dictStringBody := Dictionary new.
	referencedVarNames := Set new.
	aSTestCase statements
		do: [ :aStatement | 
			dictStringBody
				at: aStatement stringBody
				ifPresent: [ :coll | coll add: aStatement varName ]
				ifAbsentPut: [ OrderedCollection new
						add: aStatement varName;
						yourself ].
			referencedVarNames
				addAll: (aStatement dependenciesConsidering: varNames) ].
	^ {dictStringBody.
	referencedVarNames asOrderedCollection}
]

{ #category : #'as yet unclassified' }
SRefactoring class >> dictReferencesOf: aSTestCase [
	| dictReferences varNames |
	dictReferences := OrderedDictionary new.
	varNames := aSTestCase allVarNames.
	aSTestCase statements
		do: [ :aStatement | 
			(aStatement dependenciesConsidering: varNames)
				do: [ :varName | 
					dictReferences
						at: varName
						ifPresent: [ :value | value add: aStatement varName ]
						ifAbsent: [ dictReferences
								at: varName
								put:
									(OrderedCollection new
										add: aStatement varName;
										yourself) ] ] ].
	^ dictReferences
]
