Class {
	#name : #SCleanerStatement,
	#superclass : #SRefactoring,
	#category : #'SmallSuiteGenerator-Refactorization'
}

{ #category : #hook }
SCleanerStatement class >> applyOn: aSTestCase [
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
	varNamesToRemove
		do: [ :varName | removedVarNames addAll: (aSTestCase remove: varName) ].
	^ removedVarNames
]
