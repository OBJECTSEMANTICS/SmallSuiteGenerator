Class {
	#name : #SReportTypeInfo,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #'as yet unclassified' }
SReportTypeInfo class >> csvWriterCaseStudy: filename [
	| neoCSVWriter |
	(self fileReference: filename) writeStreamDo: [ :stream |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut:
					#('Classes (#)' 'Methods (#)' 'Test (#)' 'Coverage(%)').
		 ].
	^ neoCSVWriter 
	
]

{ #category : #'as yet unclassified' }
SReportTypeInfo class >> csvWriterFrequency: filename [
	| neoCSVWriter |
	(self fileReference: filename)
		writeStreamDo: [ :stream | 
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: #('Patterns') , STypeMethodInfo selectorsFilter sort ].
	^ neoCSVWriter
]

{ #category : #'export as CSV' }
SReportTypeInfo class >> exportData: aTypeInfo onCSV: aString [
	self exportData: aTypeInfo onCSV: aString usingFilter: #all
]

{ #category : #'export as CSV' }
SReportTypeInfo class >> exportData: aTypeInfo onCSV: aString usingFilter: aSymbol [
	(self fileReference: aString)
		writeStreamDo: [ :stream | 
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut:
					#('ClassName' 'MethodName' 'Receivers' 'CommSupcls' 'ArgTypes' 'CommSupcls' 'ReturnTypes' 'CommSupcls').
			aTypeInfo exportDataCSV: neoCSVWriter withFilter: aSymbol.
			neoCSVWriter flush ]
]

{ #category : #'export as CSV' }
SReportTypeInfo class >> exportReportData: projectName [ 
	self exportReportData: projectName withName: projectName
]

{ #category : #'export as CSV' }
SReportTypeInfo class >> exportReportData: projectName usingFilter: aSymbol [
	self exportReportData: projectName withName: projectName usingFilter: aSymbol
]

{ #category : #'export as CSV' }
SReportTypeInfo class >> exportReportData: projectName withName: aString [
	self exportData: (self profilerProject: projectName) onCSV: aString
]

{ #category : #'export as CSV' }
SReportTypeInfo class >> exportReportData: projectName withName: aString usingFilter: aSymbol [
	self exportData: (self profilerProject: projectName) onCSV: aString usingFilter: aSymbol
]

{ #category : #'as yet unclassified' }
SReportTypeInfo class >> exportReportsCaseStudyAndFrequency: nameFiles of: projectsName [
	| csvWriterCaseStudy csvWriterFrequency |
	self
		assert: nameFiles size = 2
		description: 'Set the nameFiles correctly'.
	csvWriterCaseStudy := self csvWriterCaseStudy: nameFiles first.
	csvWriterFrequency := self csvWriterFrequency: nameFiles second.
	projectsName
		do: [ :projectName | 
			| profiler |
			profiler := self profilerProject: projectName.
			self
				writeReport: csvWriterCaseStudy
				ofCaseStudy: profiler
				from: projectName.
			self
				writeReport: csvWriterFrequency
				ofFrequency: profiler asTypeInfo
				from: projectName ].
	csvWriterCaseStudy flush.
	csvWriterFrequency flush
]

{ #category : #'as yet unclassified' }
SReportTypeInfo class >> exportReportsCaseStudyAndFrequencyOf: projectsName [
	self exportReportsCaseStudyAndFrequency: #('CaseStudy' 'Frequency') of: projectsName
]

{ #category : #accessing }
SReportTypeInfo class >> fileReference: aString [
	| filename |
	filename := aString , '.csv'.
	filename asFileReference ensureDelete.
	^ filename asFileReference
]

{ #category : #'as yet unclassified' }
SReportTypeInfo class >> profilerProject: projectName [
			^ SSGenerator
				profile: [ (TestCase withAllSubclasses
						select: [ :t | t category beginsWith: projectName ])
						do: [ :tc | 
							[ tc buildSuite run ]
								on: Exception
								do: [ :e | 
									Transcript
										show: e printString;
										cr ] ]
						displayingProgress: 'working' ]
				onPackagesMatching: projectName , '*' 
]

{ #category : #'as yet unclassified' }
SReportTypeInfo class >> writeReport: csvWriter ofCaseStudy: profiler from: projectName [
	csvWriter
		nextPut:
			(Array
				with: projectName
				with: profiler numberOfClasses
				with: profiler numberOfMethods
				with:
					(profiler allMethods
						collect: #selector
						thenSelect: [ :selector | selector beginsWith: 'test' ]) size
				with:
					(((profiler allMethods count: #wasExecuted) / profiler numberOfMethods)
						asFloat round: 4) * 100)
]

{ #category : #'as yet unclassified' }
SReportTypeInfo class >> writeReport: csvWriter ofFrequency: typeInfo from: projectName [
	csvWriter nextPut: ((Array with:projectName) join: typeInfo reportFrequencyByFilter associations sort values)
]
