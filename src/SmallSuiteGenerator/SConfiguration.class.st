Class {
	#name : #SConfiguration,
	#superclass : #Object,
	#classInstVars : [
		'level'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SConfiguration class >> defaultGeneratorTypeInfoOf: blockToExecute onClass: aClass [
	^ (SSGenerator profile: blockToExecute onClass: aClass) asTypeInfo
]

{ #category : #'as yet unclassified' }
SConfiguration class >> defaultGeneratorTypeInfoOf: blockToExecute
				onPackagesMatching: regex [
^ (SSGenerator profile: blockToExecute onPackagesMatching: regex)
				asTypeInfo
]

{ #category : #'as yet unclassified' }
SConfiguration class >> defaultTestPackage [
	^ 'SmallSuiteGenerator-Tests-Generated'
]

{ #category : #'as yet unclassified' }
SConfiguration class >> initLevelToPrint [ 	
	level := 10
]

{ #category : #accessing }
SConfiguration class >> levelToPrint [
	^ level
]

{ #category : #'as yet unclassified' }
SConfiguration class >> reduceLevel [
	level := level - 1
]
