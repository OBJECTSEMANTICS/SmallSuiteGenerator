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
				nextPut: #('ID' 'Avg Tests Size' '% Has Errors' 'BestTest Size' 'BestTest hasErrors' 'Best' 'Average' 'Worst').
			logColl do: [ :aLog | neoCSVWriter nextPut: (Array withAll:
				(OrderedCollection new add: aLog generationNumber;
					add: aLog averageTestSize;
					add: aLog percenteageOftestCasesWithErrors;
					add: aLog fittestTestCase statements size;
					add: aLog fittestTestCase hasErrors;
					add: aLog fittestTestCase fitness values first;
					add: aLog averageFit values first;
					add: aLog lowestFit values first;
					yourself )) ].
			neoCSVWriter flush ]
]

{ #category : #accessing }
SReportSGALog class >> titles [
	^ #('ID' 'Class Name' 'Method Name' 'Is Class Side' 'Was Executed' 'Has TypeInfo' 'Code' 'Args Types' 'Return Type' 'Executed Block' 'Unexecuted Block')
]
