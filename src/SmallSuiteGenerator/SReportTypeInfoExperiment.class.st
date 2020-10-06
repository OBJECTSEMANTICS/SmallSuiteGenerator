Class {
	#name : #SReportTypeInfoExperiment,
	#superclass : #SReport,
	#instVars : [
		'typeInfo',
		'targetClass'
	],
	#category : #'SmallSuiteGenerator-Utility'
}

{ #category : #'as yet unclassified' }
SReportTypeInfoExperiment class >> generateReportOf: aTargetClass in: aSTypeInfo [
	^ (self new) typeInfo: aSTypeInfo; targetClass: aTargetClass; generateReportOfTypeInfo
]

{ #category : #'as yet unclassified' }
SReportTypeInfoExperiment >> generateReportOfTypeInfo [
	| classInfo |
	(self fileReference: targetClass asString , '_report_types')
		writeStreamDo: [ :stream | 
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: #('method' 'classSide' 'args' 'list of detected types').
			classInfo := typeInfo classAt: targetClass.
			classInfo methodTypes do: [ :m | |types|
				types := (m argTypes collect: [ :a | a types asString ]) asArray.
				neoCSVWriter nextPut: (Array with: m selector with: 'false' with: m argTypes size with: types asString )
			].
			classInfo classMethodTypes do: [ :m | |types|
				types := (m argTypes collect: [ :a | a types asString ]) asArray.
				neoCSVWriter nextPut: (Array with: m selector with: 'true' with: m argTypes size with: types asString )
			].
			neoCSVWriter flush ]
]

{ #category : #accessing }
SReportTypeInfoExperiment >> targetClass [
	^ targetClass
]

{ #category : #accessing }
SReportTypeInfoExperiment >> targetClass: anObject [
	targetClass := anObject
]

{ #category : #accessing }
SReportTypeInfoExperiment >> typeInfo [
	^ typeInfo
]

{ #category : #accessing }
SReportTypeInfoExperiment >> typeInfo: anObject [
	typeInfo := anObject
]
