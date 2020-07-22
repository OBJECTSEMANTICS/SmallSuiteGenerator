"
SConfiguration is responsible for defining or instantiating some classes or values used in the project.

Furthermore, some configuration parameters are defined depending the environment, it means Pharo or VisualWorks
"
Class {
	#name : #SPlatform,
	#superclass : #SObject,
	#classInstVars : [
		'level',
		'randomGenerator',
		'seed',
		'configurationClass',
		'logName',
		'printerClass',
		'logClass',
		'vizClass'
	],
	#category : #'SmallSuiteGenerator-Builder'
}

{ #category : #accessing }
SPlatform class >> classConfigurationName [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SPlatform class >> classTestCaseFactory [
	^ self configurationClass classTestCaseFactory 
]

{ #category : #logging }
SPlatform class >> cleanAllLogs [
	self configurationClass cleanAllLogs 
]

{ #category : #logging }
SPlatform class >> clearLog [
	self configurationClass clearLog
]

{ #category : #accessing }
SPlatform class >> configurationClass [
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
SPlatform class >> createTestCaseClass: aClassName inPackage: aPackageName [
	^ self configurationClass createTestCaseClass: aClassName inPackage: aPackageName 
]

{ #category : #accessing }
SPlatform class >> defaultLogName [
	^ 'SmallSuiteLogger.log'
]

{ #category : #accessing }
SPlatform class >> defaultSeed [
	^ 100
]

{ #category : #'instance creation' }
SPlatform class >> fileLogger: fileName [
	self configurationClass fileLogger: fileName
]

{ #category : #accessing }
SPlatform class >> implementationType [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SPlatform class >> initLevelToPrint [ 	
	level := 10
]

{ #category : #accessing }
SPlatform class >> levelToPrint [
	^ level
]

{ #category : #settings }
SPlatform class >> logClass [
	logClass ifNil: [ logClass := SGANullLog ].
	^ logClass
]

{ #category : #accessing }
SPlatform class >> logClass: aClass [
	logClass := aClass
]

{ #category : #accessing }
SPlatform class >> logName [ 
	^ logName ifNil: [ self defaultLogName  ]
]

{ #category : #accessing }
SPlatform class >> logName: string [
	logName := string
]

{ #category : #accessing }
SPlatform class >> lookUpClass: aClassName [
	^ Smalltalk at: aClassName ifAbsent: [ nil ]
]

{ #category : #'instance creation' }
SPlatform class >> newRandomGenerator [
	^ SRandom seed: self seed
]

{ #category : #accessing }
SPlatform class >> printerClass [
	printerClass ifNil: [ printerClass := SSStandardPrinter ].
	^ printerClass 
]

{ #category : #accessing }
SPlatform class >> printerClass: aClass [ 
	printerClass := aClass.
	SSTestShifter class compile: 
		'defaultPrinterClass', String cr,'	^ ', self printerClass printString
]

{ #category : #accessing }
SPlatform class >> randomGenerator [
	randomGenerator ifNil: [ randomGenerator := self newRandomGenerator ].
	^ randomGenerator 
]

{ #category : #accessing }
SPlatform class >> randomGenerator: sRandom [
	randomGenerator := sRandom
]

{ #category : #settings }
SPlatform class >> rbParserClass [
	^ self configurationClass rbParserClass
]

{ #category : #actions }
SPlatform class >> reduceLevel [
	level ifNil: [ self initLevelToPrint  ].
	level := level - 1
]

{ #category : #initialization }
SPlatform class >> resetConfigurationClass [
	configurationClass := nil
]

{ #category : #accessing }
SPlatform class >> resetRandomGenerator [
	self randomGenerator: self newRandomGenerator 
]

{ #category : #logging }
SPlatform class >> saveOnLog: message [
	self configurationClass saveOnLog: message
]

{ #category : #accessing }
SPlatform class >> seed [ 	
	seed ifNil: [ seed := self defaultSeed].
	^ seed
]

{ #category : #'instance creation' }
SPlatform class >> seed: aNumber [
	seed := aNumber
]

{ #category : #tests }
SPlatform class >> testCaseClass [
	^ self configurationClass testCaseClass
]

{ #category : #settings }
SPlatform class >> vizClass [
	vizClass ifNil: [ vizClass := SGANullViz ].
	^ vizClass
]

{ #category : #accessing }
SPlatform class >> vizClass: aClass [
	vizClass := aClass
]
