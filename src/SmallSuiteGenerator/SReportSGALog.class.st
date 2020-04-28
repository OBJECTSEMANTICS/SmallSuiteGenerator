Class {
	#name : #SReportSGALog,
	#superclass : #SReport,
	#category : #'SmallSuiteGenerator-Utility'
}

{ #category : #'as yet unclassified' }
SReportSGALog class >> titles [
	^ #('ID' 'Class Name' 'Method Name' 'Is Class Side' 'Was Executed' 'Has TypeInfo' 'Code' 'Args Types' 'Return Type' 'Executed Block' 'Unexecuted Block')
]
