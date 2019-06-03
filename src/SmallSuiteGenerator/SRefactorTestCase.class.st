Class {
	#name : #SRefactorTestCase,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #api }
SRefactorTestCase >> clean: aSTestCase [
	| dataStatements varNamesToRemove dictStringStatement referencedVarNames removedVarNames |
	dataStatements := self dataStatements: aSTestCase.
	dictStringStatement := dataStatements first.
	referencedVarNames := dataStatements second.
	varNamesToRemove := OrderedCollection new.
	removedVarNames := OrderedCollection new.
	aSTestCase statements
		do: [ :aStatement | 
			(aStatement
				notReferenced: referencedVarNames
				orIrrelevant: dictStringStatement)
				ifTrue: [ varNamesToRemove add: aStatement varName ] ].
	"^ aSTestCase"
	varNamesToRemove
		do: [ :varName | removedVarNames addAll: (aSTestCase remove: varName) ].
	^ removedVarNames
]

{ #category : #'as yet unclassified' }
SRefactorTestCase >> dataStatements: aSTestCase [
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
			referencedVarNames addAll: (aStatement dependenciesConsidering: varNames) ].
	^ {dictStringBody.
	referencedVarNames asOrderedCollection}
]

{ #category : #transforming }
SRefactorTestCase >> inline: aSTestCase [
	| varNames dictReferences |
	varNames := aSTestCase varNames.
	dictReferences := Dictionary new.
	aSTestCase statements
		do: [ :aStatement | 
			(aStatement dependenciesConsidering: varNames)
				do: [ :varName | 
					dictReferences
						at: varName
						ifPresent: [ :value | value add: aStatement varName ]
						ifAbsentPut: [ OrderedCollection new
								add: aStatement varName;
								yourself ] ] ].
	^ self inline: aSTestCase using: dictReferences
]

{ #category : #transforming }
SRefactorTestCase >> inline: aSTestCase using: dictReferences [
	| removedVarNames varNamesToRemove |
	varNamesToRemove := Set new.
	removedVarNames := OrderedCollection new.
	dictReferences associations
		select: [ :assoc | assoc value size = 1 ]
		thenDo: [ :assoc | 
			varNamesToRemove add: assoc key.
			(aSTestCase statementAt: assoc value first)
				replace: assoc key
				varNameBy: (aSTestCase statementAt: assoc key) ].
	varNamesToRemove
		do: [ :varName | removedVarNames addAll: (aSTestCase remove: varName) ].
	^ removedVarNames
]
