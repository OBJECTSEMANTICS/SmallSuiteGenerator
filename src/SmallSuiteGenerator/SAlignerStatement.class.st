Class {
	#name : #SAlignerStatement,
	#superclass : #SRefactoring,
	#category : #'SmallSuiteGenerator-Refactorization'
}

{ #category : #'as yet unclassified' }
SAlignerStatement class >> align: aSTestCase testCaseUsing: dictReferences [
	| removedVarNames varNamesToRemove |
	varNamesToRemove := Set new.
	removedVarNames := OrderedCollection new.
	dictReferences associations
		select: [ :assoc | 
			| stm |
			stm := aSTestCase statementAt: assoc key.
			assoc value size = 1 and: [ stm isConstructor or: [ stm isPrimitive ] ] ]
		thenDo: [ :assoc | 
			varNamesToRemove add: assoc key.
			(aSTestCase statementAt: assoc value first)
				replace: assoc key
				varNameBy: (aSTestCase statementAt: assoc key) valueInline ].
	varNamesToRemove
		do: [ :varName | removedVarNames addAll: (aSTestCase remove: varName) ].
	^ removedVarNames
]

{ #category : #hook }
SAlignerStatement class >> applyOn: aSTestCase [
	^ self
		align: aSTestCase
		testCaseUsing: (self dictReferencesOf: aSTestCase)
]
