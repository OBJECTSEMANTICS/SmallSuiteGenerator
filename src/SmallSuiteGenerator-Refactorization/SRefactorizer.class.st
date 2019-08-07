Class {
	#name : #SRefactorizer,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Refactorization'
}

{ #category : #'as yet unclassified' }
SRefactorizer >> defaultKindsRefactoring [
	^ SRefactoring allSubclasses
]

{ #category : #'as yet unclassified' }
SRefactorizer >> prettyCodeOf: aSTestCase testCaseApplying: kindsRefactoring [
	| kindsRefactoringToApply |
	kindsRefactoringToApply := kindsRefactoring.
	(kindsRefactoringToApply isNil
		or: [ kindsRefactoringToApply isEmpty ])
		ifTrue: [ kindsRefactoringToApply := self defaultKindsRefactoring ].
	^ kindsRefactoringToApply
		select: [ :refactor | (refactor applyOn: aSTestCase) isNotEmpty ]
]
