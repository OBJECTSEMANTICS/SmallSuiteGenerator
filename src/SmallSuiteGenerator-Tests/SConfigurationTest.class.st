Class {
	#name : #SConfigurationTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Core'
}

{ #category : #running }
SConfigurationTest >> tearDown [
	SConfiguration clearLog.
	SConfiguration cleanAllLogs
]

{ #category : #'as yet unclassified' }
SConfigurationTest >> testFileLogger [
	self
		shouldnt: (SConfiguration fileLogger: 'STestLog.log')
		raise: NotFound
]
