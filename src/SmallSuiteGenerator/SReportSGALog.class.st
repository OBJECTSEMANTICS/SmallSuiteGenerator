Class {
	#name : #SReportSGALog,
	#superclass : #SReport,
	#category : #'SmallSuiteGenerator-Utility'
}

{ #category : #export }
SReportSGALog class >> exportResumeOf: logColl onCSV: aString [
	(self fileReference: aString)
		writeStreamDo: [ :stream | 
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: #('ID' 'Avg Tests Size' '% Has Errors' 'BestTest Size' 'BestTest hasErrors').
			logColl do: [ :aLog | neoCSVWriter nextPut: (Array withAll:
				(OrderedCollection with: aLog generationNumber
					with: aLog averageTestSize 
					with: aLog percenteageOftestCasesWithErrors
					with: aLog fittestTestCase statements size
					with: aLog fittestTestCase hasErrors )) ].
			neoCSVWriter flush ]
]

{ #category : #accessing }
SReportSGALog class >> titles [
	^ #('ID' 'Class Name' 'Method Name' 'Is Class Side' 'Was Executed' 'Has TypeInfo' 'Code' 'Args Types' 'Return Type' 'Executed Block' 'Unexecuted Block')
]
