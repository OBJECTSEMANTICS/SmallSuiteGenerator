Class {
	#name : #STypeInfo,
	#superclass : #Object,
	#instVars : [
		'types'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #'as yet unclassified' }
STypeInfo class >> typeInfo: aInstance [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
STypeInfo >> copyFrom: aCoverageAnlysisResult [
	| clone |
	clone := self class new
	"filter data according the other typeInfo of mutalk or othher class, or just analisysOfMutalk to dont depend another project "
]

{ #category : #'as yet unclassified' }
STypeInfo >> filterFrom: aCoverageAnlysisResult [
	
]

{ #category : #initialization }
STypeInfo >> initialize [
	super initialize.
 	types := Dictionary new.
]

{ #category : #'as yet unclassified' }
STypeInfo >> methodsFrom: aClassName [
	^ types at: aClassName ifAbsentPut:[ Dictionary new].
]

{ #category : #'as yet unclassified' }
STypeInfo >> typeOf: aSelector from: aClassName [
	^ [(types at: aClassName) at: aSelector] on: Exception do: [ nil ]
]

{ #category : #accessing }
STypeInfo >> types [ 
	^ types
]
