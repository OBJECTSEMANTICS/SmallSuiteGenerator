"
Superclass of almost all project classes, between them:

	- AST classes used to create statements and assertions
	- Core classes which configure the environment, manage assertions creation and so.
	- GA classes that are responsible for testCase's fitness increasing. It means coverage augmentation.
	- Info classes which transform the profiler result in nodes that are easier to use in the assertions and statementsncreation.
	- Profiler classes which get classes' info types.
"
Class {
	#name : #SObject,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'instance creation' }
SObject class >> new [
	"Answer a newly created and initialized instance."

	^super new initialize
]
