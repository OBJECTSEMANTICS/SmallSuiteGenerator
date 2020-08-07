Class {
	#name : #SConfigTestCase,
	#superclass : #TestCase,
	#classVars : [
		'typeInfos'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SConfigTestCase class >> logClass [

	^ SGANullLog 
]

{ #category : #'as yet unclassified' }
SConfigTestCase class >> methodClass [

	^ SSNullMethods
]

{ #category : #'as yet unclassified' }
SConfigTestCase class >> nsuperclasses [
	^ 0
]

{ #category : #'as yet unclassified' }
SConfigTestCase class >> numberOfGenerations [
	^ 10
]

{ #category : #'as yet unclassified' }
SConfigTestCase class >> numberOfStatements [
	^ 30
]

{ #category : #'as yet unclassified' }
SConfigTestCase class >> populationSize [
	^ 30
]

{ #category : #'as yet unclassified' }
SConfigTestCase class >> printerClass [

	^ SSDictionaryBasedPrinter
]

{ #category : #'as yet unclassified' }
SConfigTestCase class >> setUp [

	^ ''
]

{ #category : #'as yet unclassified' }
SConfigTestCase class >> targetClassName [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SConfigTestCase class >> targetPackageName [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SConfigTestCase class >> targetPackageRegex [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SConfigTestCase class >> tearDown [

	^ ''
]

{ #category : #'as yet unclassified' }
SConfigTestCase class >> typeInfo [

	^ 'Default'
]

{ #category : #'as yet unclassified' }
SConfigTestCase class >> typeInfos [
	typeInfos ifNotNil: [ ^ typeInfos ].
	typeInfos := Dictionary new.
	^ typeInfos 
]

{ #category : #'as yet unclassified' }
SConfigTestCase class >> vizClass [

	^ SGANullViz 
]
