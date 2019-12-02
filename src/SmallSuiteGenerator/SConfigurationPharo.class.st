"
SConfigurationPharo is a subclass called when the project environment is running in Pharo. Furthermore, it defines parameters used in Pharo.
"
Class {
	#name : #SConfigurationPharo,
	#superclass : #SConfiguration,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #accessing }
SConfigurationPharo class >> classConfigurationName [
	^ superclass name , self implementationType
]

{ #category : #accessing }
SConfigurationPharo class >> classLogger [
	^ TinyLogger
]

{ #category : #accessing }
SConfigurationPharo class >> classTestCaseFactory [
	^ STestCaseFactoryPharo 
]

{ #category : #logging }
SConfigurationPharo class >> cleanAllLogs [
	self instanceLogger removeAllLoggers
]

{ #category : #actions }
SConfigurationPharo class >> clearFileLog: string [
	self instanceLogger fileLoggers
		detect: [ :fileLogger | fileLogger fileName = string ]
		ifFound: [ :fileLogger | fileLogger clearLog ]
]

{ #category : #logging }
SConfigurationPharo class >> clearLog [
	self instanceLogger clearLog
]

{ #category : #actions }
SConfigurationPharo class >> createFileLogger [
	self instanceLogger ensureFileLoggerNamed: self logName
]

{ #category : #tests }
SConfigurationPharo class >> createTestCaseClass: aClassName inPackage: aPackageName [
	^ self testCaseClass
		subclass: aClassName
		instanceVariableNames: ''
		classVariableNames: ''
		package: aPackageName
]

{ #category : #actions }
SConfigurationPharo class >> defaultFileLogger [
	self classLogger
		ifNotNil: [ self instanceLogger fileLoggers ifEmpty: [ self createFileLogger ].
			^ self instanceLogger fileLoggers
				detect: [ :fileLogger | fileLogger fileName = self logName ] ]
]

{ #category : #'instance creation' }
SConfigurationPharo class >> fileLogger: fileName [
	self logName: fileName.
	^ self classLogger
		ifNotNil: [ self instanceLogger fileLoggers ifEmpty: [ self createFileLogger ].
			self instanceLogger fileLoggers
				detect: [ :fileLogger | fileLogger fileName = fileName ]
				ifNone: [ self createFileLogger.
					self fileLogger: fileName ] ]
		ifNil: [ nil ]
]

{ #category : #accessing }
SConfigurationPharo class >> implementationType [ 
	^ SystemVersion current type
]

{ #category : #accessing }
SConfigurationPharo class >> instanceLogger [
	^ self classLogger default
]

{ #category : #'as yet unclassified' }
SConfigurationPharo class >> rbParserClass [
	^ RBParser
]

{ #category : #logging }
SConfigurationPharo class >> saveOnLog: string [ 
	self defaultFileLogger record: string
]

{ #category : #tests }
SConfigurationPharo class >> testCaseClass [
	^ TestCase
]
