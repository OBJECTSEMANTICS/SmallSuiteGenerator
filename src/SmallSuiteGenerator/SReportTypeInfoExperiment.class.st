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
				nextPut: #('method' 'classSide' 'args' 'list of detected types' 'return types').
			classInfo := typeInfo classAt: targetClass.
			targetClass asClass methods do: [ :cm | | m types |
				[ m := classInfo methodOf: cm selector.
				 types := (m argTypes collect: [ :a | a types asString ]) asArray.
				neoCSVWriter nextPut: (Array with: m selector with: 'false' with: m argTypes size with: types asString with: m returnType types asString ) ] 
				on: Error
				do: [ neoCSVWriter nextPut: (Array with: cm selector with: 'false' with: '' with: 'no detected' with: 'no detected')  ]
			 ].
		
			targetClass asClass class methods do: [ :cm | | m types |
				[ m := classInfo classMethodOf: cm selector.
				 types := (m argTypes collect: [ :a | a types asString ]) asArray.
				neoCSVWriter nextPut: (Array with: m selector with: 'true' with: m argTypes size with: types asString with: m returnType types asString) ] 
				on: Error
				do: [ neoCSVWriter nextPut: (Array with: cm selector with: 'true' with: '' with: 'no detected' with: 'no detected')  ]
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
