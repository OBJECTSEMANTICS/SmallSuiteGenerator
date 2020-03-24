"
SConfiguration is responsible for defining or instantiating some classes or values used in the project.

Furthermore, some configuration parameters are defined depending the environment, it means Pharo or VisualWorks
"
Class {
	#name : #SConfiguration,
	#superclass : #SObject,
	#classInstVars : [
		'level',
		'randomGenerator',
		'seed',
		'configurationClass',
		'logName'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #accessing }
SConfiguration class >> classConfigurationName [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SConfiguration class >> classTestCaseFactory [
	^ self configurationClass classTestCaseFactory 
]

{ #category : #logging }
SConfiguration class >> cleanAllLogs [
	self configurationClass cleanAllLogs 
]

{ #category : #logging }
SConfiguration class >> clearLog [
	self configurationClass clearLog
]

{ #category : #accessing }
SConfiguration class >> configurationClass [
	configurationClass ifNil: [  
	configurationClass := self subclasses
		detect: [ :aClass | 
			[ Smalltalk at: aClass classConfigurationName.
			true ]
				on: Error
				do: [ false ] ]
		ifNone: [ nil ].
	configurationClass ifNil: [ self error: 'Error to look a configurationClass' ]].
	^ configurationClass
]

{ #category : #tests }
SConfiguration class >> createTestCaseClass: aClassName inPackage: aPackageName [
	^ self configurationClass createTestCaseClass: aClassName inPackage: aPackageName 
]

{ #category : #accessing }
SConfiguration class >> defaultLogName [
	^ 'SmallSuiteLogger.log'
]

{ #category : #accessing }
SConfiguration class >> defaultSeed [
	^ 100
]

{ #category : #'instance creation' }
SConfiguration class >> fileLogger: fileName [
	self configurationClass fileLogger: fileName
]

{ #category : #accessing }
SConfiguration class >> implementationType [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SConfiguration class >> initLevelToPrint [ 	
	level := 10
]

{ #category : #accessing }
SConfiguration class >> levelToPrint [
	^ level
]

{ #category : #accessing }
SConfiguration class >> logName [ 
	^ logName ifNil: [ self defaultLogName  ]
]

{ #category : #accessing }
SConfiguration class >> logName: string [
	logName := string
]

{ #category : #'as yet unclassified' }
SConfiguration class >> lookUpClass: aClassName [
	^ Smalltalk at: aClassName ifAbsent: [ nil ]
]

{ #category : #'instance creation' }
SConfiguration class >> newRandomGenerator [
	^ SRandom seed: self seed
]

{ #category : #accessing }
SConfiguration class >> randomGenerator [
	randomGenerator ifNil: [ randomGenerator := self newRandomGenerator ].
	^ randomGenerator 
]

{ #category : #accessing }
SConfiguration class >> randomGenerator: sRandom [
	randomGenerator := sRandom
]

{ #category : #'as yet unclassified' }
SConfiguration class >> rbParserClass [
	^ self configurationClass rbParserClass
]

{ #category : #actions }
SConfiguration class >> reduceLevel [
	level ifNil: [ self initLevelToPrint  ].
	level := level - 1
]

{ #category : #initialization }
SConfiguration class >> resetConfigurationClass [
	configurationClass := nil
]

{ #category : #logging }
SConfiguration class >> saveOnLog: message [
	self configurationClass saveOnLog: message
]

{ #category : #accessing }
SConfiguration class >> seed [ 	
	seed ifNil: [ seed := self defaultSeed.
		 ].
	^ seed
]

{ #category : #'instance creation' }
SConfiguration class >> seed: aNumber [
	seed := aNumber
]

{ #category : #tests }
SConfiguration class >> testCaseClass [
	^ self configurationClass testCaseClass
]
