Class {
	#name : #SReportSTestCaseFactory,
	#superclass : #SReport,
	#instVars : [
		'factoryTestCase'
	],
	#category : #'SmallSuiteGenerator-Utility'
}

{ #category : #'class-factory' }
SReportSTestCaseFactory class >> on: anObject [
	^ self new factoryTestCase: anObject 
]

{ #category : #actions }
SReportSTestCaseFactory >> engine [
	^ factoryTestCase engine
]

{ #category : #actions }
SReportSTestCaseFactory >> evolutionTypeInfo [
	| typeInfos evolution |
	typeInfos := Array with: factoryTestCase typeInfoSeed withAll: (self engine logs collect: #typeInfoGeneration).
	evolution := Dictionary new.
	2 to: typeInfos size do: [ :index | | aTypeInfo1 aTypeInfo2 partialResult |
		aTypeInfo1 := typeInfos at: index - 1.
		aTypeInfo2 := typeInfos at: index.
		partialResult := aTypeInfo1 difference: aTypeInfo2.
		(partialResult notNil and: [partialResult notEmpty]) ifTrue: [ 
			evolution 
				at: ('{1} -> {2}' format:(Array with: (index - 2) with: (index-1))) 
				put: partialResult ]
		 ].
	^ evolution
]

{ #category : #accessing }
SReportSTestCaseFactory >> factoryTestCase: anObject [
	factoryTestCase := anObject 
]

{ #category : #actions }
SReportSTestCaseFactory >> generateReportForAllMethodsOf: aLog [ 
	self generateReportOf: aLog usingFilter: #all
]

{ #category : #actions }
SReportSTestCaseFactory >> generateReportForAllMethodsOfAllLogs [
	self engine logs do: [ :aLog | self generateReportForAllMethodsOf: aLog ]
]

{ #category : #actions }
SReportSTestCaseFactory >> generateReportForUnexecutedMethodsOf: anIndex [
	self generateReportOf: anIndex usingFilter: #notAllBlocksExecuted
]

{ #category : #actions }
SReportSTestCaseFactory >> generateReportForUnexecutedMethodsOfAllLogs [
	self engine logs do: [ :aLog | self generateReportForUnexecutedMethodsOf: aLog ]
]

{ #category : #actions }
SReportSTestCaseFactory >> generateReportOf: aLog usingFilter: aSymbol [ 
	SReportSGALog exportData: aLog 
	onCSV: ('Report_', aLog generationNumber asString,'_', aSymbol asString capitalized, factoryTestCase targetClassName asString) 
	usingFilter: aSymbol
]

{ #category : #actions }
SReportSTestCaseFactory >> generateReportOfAllMethods [
	self generateReportForAllMethodsOf: self engine logs last
]

{ #category : #actions }
SReportSTestCaseFactory >> generateResumeDifferenceOfGeneration [
	SReportSGALog generateReportForDifferencesBtwGenerationsOf: self engine
]

{ #category : #actions }
SReportSTestCaseFactory >> generateResumeReportOfLogs [
	SReportSGALog exportResumeOf: self engine logs 
	onCSV: ('Report_Resume_' , factoryTestCase targetClassName asString)
]
