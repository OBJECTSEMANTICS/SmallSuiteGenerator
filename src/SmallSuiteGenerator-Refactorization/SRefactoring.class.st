Class {
	#name : #SRefactoring,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-Refactorization'
}

{ #category : #'as yet unclassified' }
SRefactoring class >> dataStatements: aSTestCase [
	| dictStringBody referencedVarNames  |
	dictStringBody := Dictionary new.
	referencedVarNames := Set new.
	aSTestCase statements
		do: [ :aStatement | 
			dictStringBody
				at: aStatement printString
				ifPresent: [ :coll | coll add: aStatement varName ]
				ifAbsentPut: [ OrderedCollection new
						add: aStatement varName;
						yourself ].
			referencedVarNames addAll: aStatement variablesWithId ].
	^ Array
		with: dictStringBody
		with: referencedVarNames asOrderedCollection
]

{ #category : #'as yet unclassified' }
SRefactoring class >> dictReferencesOf: aSTestCase [
	| dictReferences  |
	dictReferences := OrderedDictionary new.
	aSTestCase statements
		do: [ :aStatement | 
			(aStatement variablesWithId )
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
