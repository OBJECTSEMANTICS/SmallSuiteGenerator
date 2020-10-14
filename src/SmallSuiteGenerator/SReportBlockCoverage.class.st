Class {
	#name : #SReportBlockCoverage,
	#superclass : #SReport,
	#instVars : [
		'targetClass',
		'profiler'
	],
	#category : #'SmallSuiteGenerator-Utility'
}

{ #category : #'as yet unclassified' }
SReportBlockCoverage class >> profiler: aProfiler targetClass: aSymbol [
	^ (self new) profiler: aProfiler; targetClass: aSymbol 
]

{ #category : #accessing }
SReportBlockCoverage >> generateReports [
	
	| classInfo |
	(self fileReference: targetClass asString , '_report_coverage')
		writeStreamDo: [ :stream | 
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: #('Method' 'IsClassSide' 'Code' 'NumberOfStatements' 'Branches' 'BranchStatements' 'Executed' 'ExecutedBranches').
			classInfo := profiler classAt: targetClass.
			targetClass asClass methods do: [ :cm | | m |
				[ m := classInfo localMethodAt: cm selector.
				neoCSVWriter nextPut: (OrderedCollection new add: m selector; add: 'false'; add: m compiledMethod sourceCode; add: (m blocks inject: 0 into: [ :s :e | s + e numberOfStatements ]); add: m blocks size; add: (m blocks collect: [:b | b numberOfStatements]) asArray; add: m blocks first wasExecuted; add: (m blocks collect: [:b | b wasExecuted]) asArray; yourself ) ] 
				on: Error
				do: [ ]
			 ].
		
			targetClass asClass class methods do: [ :cm | | m |
				[ m := classInfo metaclassSpy localMethodAt: cm selector.
				neoCSVWriter nextPut: (OrderedCollection new add: m selector; add: 'true'; add: m compiledMethod sourceCode; add: (m blocks inject: 0 into: [ :s :e | s + e numberOfStatements ]); add: m blocks size; add: (m blocks collect: [:b | b numberOfStatements]) asArray; add: m blocks first wasExecuted; add: (m blocks collect: [:b | b wasExecuted]) asArray; yourself ) ] 
				on: Error
				do: [ ]
			 ].
			neoCSVWriter flush ]
]

{ #category : #accessing }
SReportBlockCoverage >> profiler [
	^ profiler
]

{ #category : #accessing }
SReportBlockCoverage >> profiler: anObject [
	profiler := anObject
]

{ #category : #accessing }
SReportBlockCoverage >> targetClass [
	^ targetClass
]

{ #category : #accessing }
SReportBlockCoverage >> targetClass: anObject [
	targetClass := anObject
]
