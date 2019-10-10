Class {
	#name : #SUtil,
	#superclass : #Object,
	#classInstVars : [
		'compilersTests'
	],
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #accessing }
SUtil class >> compilersTestsFrom: symbol [
	^ compilersTests at: symbol ifAbsent: [ nil ]
]

{ #category : #operation }
SUtil class >> createClass: aClassName from: symbol [
	^ self
		createClass: aClassName
		ofPackage: SConfiguration defaultTestPackage
		from: symbol
]

{ #category : #operation }
SUtil class >> createClass: aClassName ofPackage: aPackageName from: symbol [
	| compilerClass |
	compilersTests ifNil: [ compilersTests := Dictionary new ].
	compilerClass := self compiler
		evaluate:
			(self
				stringToCreateNewClass: aClassName
				with: 'TestCase'
				and: aPackageName).
	compilersTests at: symbol 
	ifPresent: [:collection | collection add: compilerClass ]
	ifAbsentPut: [OrderedCollection new add: compilerClass; yourself].
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
SUtil class >> resetAllCreatedClasses [
	compilersTests
		ifNotNil: [ (compilersTests values
				flatCollect: [:collection | collection collect: #name])
				do: [ :aClassName | Smalltalk removeClassNamed: aClassName ] ].
	compilersTests := nil
]

{ #category : #initialization }
SUtil class >> resetCreatedClassesFrom: symbol [
	compilersTests
		ifNotNil: [ compilersTests
				at: symbol
				ifPresent: [ :classes | 
					classes
						collect: #name
						thenDo: [ :aClassName | Smalltalk removeClassNamed: aClassName ].
				 ].
			compilersTests removeKey: symbol ifAbsent: [ ] ]
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
