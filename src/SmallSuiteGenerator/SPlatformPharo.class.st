"
SConfigurationPharo is a subclass called when the project environment is running in Pharo. Furthermore, it defines parameters used in Pharo.
"
Class {
	#name : #SPlatformPharo,
	#superclass : #SPlatform,
	#category : #'SmallSuiteGenerator-Builder'
}

{ #category : #accessing }
SPlatformPharo class >> classConfigurationName [

	^ superclass name , self implementationType
]

{ #category : #accessing }
SPlatformPharo class >> classLogger [

	^ TinyLogger
]

{ #category : #accessing }
SPlatformPharo class >> classTestCaseFactory [

	^ STestCaseFactoryPharo 
]

{ #category : #logging }
SPlatformPharo class >> cleanAllLogs [

	self instanceLogger removeAllLoggers
]

{ #category : #actions }
SPlatformPharo class >> clearFileLog: string [

	self instanceLogger fileLoggers
		detect: [ :fileLogger | fileLogger fileName = string ]
		ifFound: [ :fileLogger | fileLogger clearLog ]
]

{ #category : #logging }
SPlatformPharo class >> clearLog [

	self instanceLogger clearLog
]

{ #category : #actions }
SPlatformPharo class >> createFileLogger [

	self instanceLogger ensureFileLoggerNamed: self logName
]

{ #category : #tests }
SPlatformPharo class >> createTestCaseClass: aClassName inPackage: aPackageName [

	^ self testCaseClass
		subclass: aClassName
		instanceVariableNames: ''
		classVariableNames: ''
		package: aPackageName
]

{ #category : #actions }
SPlatformPharo class >> defaultFileLogger [

	self classLogger
		ifNotNil: [ self instanceLogger fileLoggers ifEmpty: [ self createFileLogger ].
			^ self instanceLogger fileLoggers
				detect: [ :fileLogger | fileLogger fileName = self logName ] ]
]

{ #category : #'instance creation' }
SPlatformPharo class >> fileLogger: fileName [

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
SPlatformPharo class >> implementationType [ 

	^ SystemVersion current type
]

{ #category : #accessing }
SPlatformPharo class >> instanceLogger [

	^ self classLogger default
]

{ #category : #settings }
SPlatformPharo class >> rbParserClass [

	^ RBParser
]

{ #category : #logging }
SPlatformPharo class >> saveOnLog: string [ 

	self defaultFileLogger record: string
]

{ #category : #tests }
SPlatformPharo class >> testCaseClass [

	^ SConfigGenerationTestCase
]
