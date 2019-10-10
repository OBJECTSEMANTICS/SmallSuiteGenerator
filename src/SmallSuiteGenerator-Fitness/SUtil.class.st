Class {
	#name : #SUtil,
	#superclass : #Object,
	#classInstVars : [
		'compilersTests'
	],
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #accessing }
SUtil class >> compilersTests [ 
	^ compilersTests 
]

{ #category : #operation }
SUtil class >> createClass: aClassName [
	^ self createClass: aClassName ofPackage: SConfiguration defaultTestPackage 
]

{ #category : #operation }
SUtil class >> createClass: aClassName ofPackage: aPackageName [
	| compilerClass |
	compilersTests ifNil: [ compilersTests := OrderedCollection new ].
	compilerClass := self compiler
		evaluate:
			(self
				stringToCreateNewClass: aClassName
				with: 'TestCase'
				and: aPackageName).
	compilersTests add: compilerClass.
	^ compilerClass
]

{ #category : #compiling }
SUtil class >> nodeFormedFrom: testCase [
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

{ #category : #initialization }
SUtil class >> resetCreatedClasses [
	self compilersTests
		ifNotNil: [ self compilersTests
				collect: #name
				thenDo: [ :aClassName | Smalltalk removeClassNamed: aClassName ] ].
		compilersTests := nil
]

{ #category : #'as yet unclassified' }
SUtil class >> stringToCreateNewClass: aClassName with: aSuperClassName and: aPackageName [
	^ aSuperClassName , ' subclass: #' , aClassName
		,
			' 
    instanceVariableNames: ''''
    classVariableNames: ''''
    package: ''' , aPackageName , ''''
]
