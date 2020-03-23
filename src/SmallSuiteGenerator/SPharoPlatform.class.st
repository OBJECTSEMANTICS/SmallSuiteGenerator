"
SConfigurationPharo is a subclass called when the project environment is running in Pharo. Furthermore, it defines parameters used in Pharo.
"
Class {
	#name : #SPharoPlatform,
	#superclass : #SPlatform,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #accessing }
SPharoPlatform class >> classConfigurationName [
	^ superclass name , self implementationType
]

{ #category : #accessing }
SPharoPlatform class >> classLogger [
	^ TinyLogger
]

{ #category : #accessing }
SPharoPlatform class >> classTestCaseFactory [
	^ STestCaseFactoryPharo 
]

{ #category : #logging }
SPharoPlatform class >> cleanAllLogs [
	self instanceLogger removeAllLoggers
]

{ #category : #actions }
SPharoPlatform class >> clearFileLog: string [
	self instanceLogger fileLoggers
		detect: [ :fileLogger | fileLogger fileName = string ]
		ifFound: [ :fileLogger | fileLogger clearLog ]
]

{ #category : #logging }
SPharoPlatform class >> clearLog [
	self instanceLogger clearLog
]

{ #category : #actions }
SPharoPlatform class >> createFileLogger [
	self instanceLogger ensureFileLoggerNamed: self logName
]

{ #category : #tests }
SPharoPlatform class >> createTestCaseClass: aClassName inPackage: aPackageName [
	^ self testCaseClass
		subclass: aClassName
		instanceVariableNames: ''
		classVariableNames: ''
		package: aPackageName
]

{ #category : #actions }
SPharoPlatform class >> defaultFileLogger [
	self classLogger
		ifNotNil: [ self instanceLogger fileLoggers ifEmpty: [ self createFileLogger ].
			^ self instanceLogger fileLoggers
				detect: [ :fileLogger | fileLogger fileName = self logName ] ]
]

{ #category : #'instance creation' }
SPharoPlatform class >> fileLogger: fileName [
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
SPharoPlatform class >> implementationType [ 
	^ SystemVersion current type
]

{ #category : #accessing }
SPharoPlatform class >> instanceLogger [
	^ self classLogger default
]

{ #category : #'as yet unclassified' }
SPharoPlatform class >> rbParserClass [
	^ RBParser
]

{ #category : #logging }
SPharoPlatform class >> saveOnLog: string [ 
	self defaultFileLogger record: string
]

{ #category : #tests }
SPharoPlatform class >> testCaseClass [
	^ TestCase
]
