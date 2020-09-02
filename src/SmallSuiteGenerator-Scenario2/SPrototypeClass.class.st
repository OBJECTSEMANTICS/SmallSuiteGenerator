"
SPrototypeClass is a proof to tests generation of tests with different scalars.

- To test this you can run a script like the following:

|typeInfo aBlock generated |
aBlock := [SPrototypeClass new 
	methWithArguments: #(3 4 5 2 7 0 8 15 20);
	methWithDoubleCondition: 10.7;
	methWithDoubleCondition: 5;
	returnStringWithSeparetors: #($, $:);
	c: 'fdsg,dgf,fgd:4t';
	returnStringWithSeparetors: ',';
	yourself. ].

typeInfo := STypeInfo asTypeInfo: (
        SSTypeCollector profile: aBlock onPackagesMatching: 'SmallSuiteGenerator-Scenario2').

generated := SPrototypeClass createTestCaseConfigWithName: 'SPrototypeClassTest'.

generated addTypeInfo: typeInfo withKey: 'art';
	typeInfo: 'art';
	fitness: #statement;
	numberOfGenerations: 30;
	numberOfStatements: 50;
	populationSize: 30;
	stopIterations: 7;
	targetPackageRegex: 'SmallSuiteGenerator-Scenario2';
	outputPackageName: 'Generated';
	lastMessage: 'Transcript show: ''prot'''. 
(STestCaseFactoryPharo from: SPrototypeClassTest )
	generateViews;
    createTestCases;
    yourself.
"
Class {
	#name : #SPrototypeClass,
	#superclass : #SObject,
	#instVars : [
		'a',
		'b',
		'c'
	],
	#category : #'SmallSuiteGenerator-Scenario2'
}

{ #category : #accessing }
SPrototypeClass >> a [
	^ a
]

{ #category : #accessing }
SPrototypeClass >> a: anInteger [
	a := anInteger
]

{ #category : #accessing }
SPrototypeClass >> b [
	^ b ifNil: [ b := 7 ]
]

{ #category : #accessing }
SPrototypeClass >> b: anInteger [
	b := anInteger
]

{ #category : #accessing }
SPrototypeClass >> c [
	^ c
]

{ #category : #accessing }
SPrototypeClass >> c: aString [
	c := aString
]

{ #category : #actions }
SPrototypeClass >> doSomething [
]

{ #category : #accessing }
SPrototypeClass >> initialize [
	super initialize.
	a := 3.
	b := 4.
]

{ #category : #accessing }
SPrototypeClass >> methWithArguments: aList [
	| selectedNumbers |
	selectedNumbers := OrderedCollection new.
	aList detect: [ :aNum | aNum odd ]
	ifFound: [ :aNum | 
		aNum > 10 ifTrue: [ 
			selectedNumbers add: aNum
		] ifFalse: [ 
			selectedNumbers add: aNum * 3
		]
	] ifNone: [  ].
	^ selectedNumbers 
]

{ #category : #accessing }
SPrototypeClass >> methWithComposeBlocks: list [
	|  selectedNumbers |
	selectedNumbers := OrderedCollection new.
	list select: [ :aNum | aNum odd ]
	thenDo: [ :aNum | 
		aNum > 10 ifTrue: [ 
			selectedNumbers add: aNum
		] ].
	^ selectedNumbers 
]

{ #category : #accessing }
SPrototypeClass >> methWithCondition [ 
	^ (a < b) 
		ifTrue: [ a + 3 ]
		ifFalse: [ b + 3 ].
]

{ #category : #accessing }
SPrototypeClass >> methWithDoubleCondition [
	^ a odd
		ifTrue: [ 
			a < 10 
			ifTrue: [ true ] ]
		ifFalse: [ false ]
]

{ #category : #accessing }
SPrototypeClass >> methWithDoubleCondition: aNumber [
	aNumber odd
		ifTrue: [ 
			aNumber < 10 
			ifTrue: [ true ] ]
		ifFalse: [ false ]
]

{ #category : #actions }
SPrototypeClass >> returnMessage [
	| a |
	a := 3.
	^ a
]

{ #category : #accessing }
SPrototypeClass >> returnStringWithSeparetors: aSeparatorColl [
	c 
	 ifNotNil: [ ^ c substrings: aSeparatorColl ].
	^ #()
]

{ #category : #actions }
SPrototypeClass >> voidMessage [
	self doSomething
]
