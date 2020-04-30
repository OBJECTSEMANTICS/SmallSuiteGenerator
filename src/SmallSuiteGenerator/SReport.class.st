Class {
	#name : #SReport,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-Utility'
}

{ #category : #accessing }
SReport class >> exportData: anObject onCSV: aString usingFilter: aSymbol [
	(self fileReference: aString)
		writeStreamDo: [ :stream | 
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: self titles.
			anObject exportDataCSV: neoCSVWriter withFilter: aSymbol.
			neoCSVWriter flush ]
]

{ #category : #accessing }
SReport class >> fileReference: aString [
	| filename |
	filename := aString , '.csv'.
	filename asFileReference ensureDelete.
	^ filename asFileReference
]

{ #category : #accessing }
SReport class >> titles [
	self subclassResponsibility 
]
