Class {
	#name : #SConfiguration,
	#superclass : #SObject,
	#classInstVars : [
		'level',
		'nameLog',
		'randomGenerator',
		'seed'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SConfiguration class >> cleanAllLogs [
	TinyLogger default removeAllLoggers 
]

{ #category : #logging }
SConfiguration class >> clearFileLog: string [
	TinyLogger default fileLoggers
		detect: [ :fileLogger | fileLogger fileName = string ]
		ifFound: [ :fileLogger | fileLogger clearLog ]
]

{ #category : #logging }
SConfiguration class >> clearLog [
	TinyLogger default clearLog
]

{ #category : #'as yet unclassified' }
SConfiguration class >> createFileLogger [
	TinyLogger default ensureFileLoggerNamed: self nameLog
]

{ #category : #'as yet unclassified' }
SConfiguration class >> defaultFileLogger [
	TinyLogger default fileLoggers
		ifEmpty: [ self createFileLogger ].
	^ TinyLogger default fileLoggers
		detect: [ :fileLogger | fileLogger fileName = self nameLog ]
]

{ #category : #'as yet unclassified' }
SConfiguration class >> defaultGeneratorTypeInfoOf: blockToExecute onClass: aClass [
	^ (SSTypeCollector profile: blockToExecute onClass: aClass) asTypeInfo
]

{ #category : #'as yet unclassified' }
SConfiguration class >> defaultGeneratorTypeInfoOf: blockToExecute
				onPackagesMatching: regex [
^ (SSTypeCollector profile: blockToExecute onPackagesMatching: regex)
				asTypeInfo
]

{ #category : #'as yet unclassified' }
SConfiguration class >> defaultMutantOperators [
	^ MutantOperator contents
]

{ #category : #'as yet unclassified' }
SConfiguration class >> defaultNameLog [
	^ 'SmallSuiteLogger.log'
]

{ #category : #'as yet unclassified' }
SConfiguration class >> defaultSeed [
	^ 100
]

{ #category : #'as yet unclassified' }
SConfiguration class >> fileLogger: fileName [
	self nameLog: fileName.
	TinyLogger default fileLoggers ifEmpty: [ self createFileLogger ].
	^ TinyLogger default fileLoggers
		detect: [ :fileLogger | fileLogger fileName = fileName ] ifNone: [ self createFileLogger.
			self fileLogger: fileName  ]
]

{ #category : #'as yet unclassified' }
SConfiguration class >> initLevelToPrint [ 	
	level := 10
]

{ #category : #accessing }
SConfiguration class >> levelToPrint [
	^ level
]

{ #category : #accessing }
SConfiguration class >> nameLog [ 
	^ nameLog ifNil: [ self defaultNameLog  ]
]

{ #category : #accessing }
SConfiguration class >> nameLog: string [
	nameLog := string
]

{ #category : #'instance creation' }
SConfiguration class >> newRandomGenerator [
	^ SRandom seed: self seed
]

{ #category : #accessing }
SConfiguration class >> randomGenerator [
	randomGenerator ifNil: [ randomGenerator := SRandom seed: self seed ].
	^ randomGenerator 
]

{ #category : #accessing }
SConfiguration class >> randomGenerator: sRandom [
	randomGenerator := sRandom
]

{ #category : #'as yet unclassified' }
SConfiguration class >> reduceLevel [
	level ifNil: [ self initLevelToPrint  ].
	level := level - 1
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
