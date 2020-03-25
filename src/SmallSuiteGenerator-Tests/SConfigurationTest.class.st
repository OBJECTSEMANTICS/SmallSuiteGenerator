Class {
	#name : #SConfigurationTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Core'
}

{ #category : #running }
SConfigurationTest >> tearDown [
	SPlatform clearLog.
	SPlatform cleanAllLogs
]

{ #category : #'as yet unclassified' }
SConfigurationTest >> testFileLogger [
	self
		shouldnt: (SPlatform fileLogger: 'STestLog.log')
		raise: Error
]
