"
SReportTypeInfo exports data about coverage and patterns frequency of projects in Smalltalk. It exports two kinds of reports:
	
1. Project's coverage covered in the genetic algorithm. It presents 
	- Project -> Project name in Smalltalk.
	- Classes -> Number of classes executed in the project.
	- Methods -> Number of methods executed in the project.
	- Test -> Number of tests that are evaluated in the project.
	- Coverage -> Project coverage percent covered.
	
2. Patterns frequency of type method info. Each type method info is categorized according its receiver, arguments and return type. The report contains:
	- Project name
	- Number of all methods
	- Number of type method infos categorized in each pattern.
"
Class {
	#name : #SReportTypeInfo,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #export }
SReportTypeInfo class >> dataCaseStudy: profiler from: projectName [
		^	(Array
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

{ #category : #export }
SReportTypeInfo class >> dataFrequency: typeInfo from: projectName [
	^ (Array with: projectName)
		, (typeInfo reportFrequencyByFilter associations sort collect: #value)
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
	self
		exportData: (STypeInfo asTypeInfo: (self profilerProject: projectName))
		onCSV: aString
]

{ #category : #'export as CSV' }
SReportTypeInfo class >> exportReportData: projectName withName: aString usingFilter: aSymbol [
	self
		exportData: (STypeInfo asTypeInfo: (self profilerProject: projectName))
		onCSV: aString
		usingFilter: aSymbol
]

{ #category : #export }
SReportTypeInfo class >> exportReportsCaseStudyAndFrequency: fileNames of: projectsName [
	| data |
	self
		assert: fileNames size = 2
		description: 'Set the fileNames correctly'.
	data := projectsName
		collect: [ :projectName | 
			| profiler |
			profiler := self profilerProject: projectName.
			Array
				with: (self dataCaseStudy: profiler from: projectName)
				with: (self dataFrequency: (STypeInfo asTypeInfo: profiler) from: projectName) ].
	self writeReport: fileNames first ofCaseStudy: (data collect: #first).
	self
		writeReport: fileNames second
		ofFrequency: (data collect: #second)
]

{ #category : #export }
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

{ #category : #export }
SReportTypeInfo class >> profilerProject: projectName [
	^ SSTypeCollector
		profile: [ (SConfiguration testCaseClass withAllSubclasses
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

{ #category : #writing }
SReportTypeInfo class >> writeReport: filename ofCaseStudy: data [
	(self fileReference: filename)
		writeStreamDo: [ :stream | 
			(NeoCSVWriter on: stream)
				nextPut: #('Project' 'Classes (#)' 'Methods (#)' 'Test (#)' 'Coverage(%)');
				nextPutAll: data;
				flush ]
]

{ #category : #writing }
SReportTypeInfo class >> writeReport: filename ofFrequency: data [
	(self fileReference: filename)
		writeStreamDo: [ :stream | 
			(NeoCSVWriter on: stream)
				nextPut:
					#('Project')
						, (STypeMethodInfo selectorsFilter , #(#others #all)) sort;
				nextPutAll: data;
				flush ]
]
