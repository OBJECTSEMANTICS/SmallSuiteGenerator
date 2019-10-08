Class {
	#name : #SCompilerMethod,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #compiling }
SCompilerMethod class >> nodeFormedFrom: testCase [
	| node temporaries |
	node := RBParser parseExpression: '[]'.
	temporaries := testCase allVarNames
		collect: [ :varName | RBParser parseExpression: varName ].
	node body temporaries: temporaries.
	testCase statements
		collect: #printString
		thenDo: [ :aString | node body addNode: (RBParser parseExpression: aString) ].
	^ node
]

{ #category : #'as yet unclassified' }
SCompilerMethod class >> stringToCreateNewClass: aClassName with: aSuperClassName and: aPackageName [
	^ aSuperClassName , ' subclass: #' , aClassName
		,
			' 
    instanceVariableNames: ''''
    classVariableNames: ''''
    package: ''' , aPackageName , ''''
]
