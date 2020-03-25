"
SConfigurationVisualWorks is a subclass called when the project environment is running in VisualWorks.
"
Class {
	#name : #SPlatformVisualWorks,
	#superclass : #SPlatform,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #accessing }
SPlatformVisualWorks class >> classTestCaseFactory [
	^ STestCaseFactoryVisualWorks 
]

{ #category : #logging }
SPlatformVisualWorks class >> cleanAllLogs [ 
	
]

{ #category : #logging }
SPlatformVisualWorks class >> clearLog [ 
	
]

{ #category : #'instance creation' }
SPlatformVisualWorks class >> fileLogger: fileName [
]

{ #category : #logging }
SPlatformVisualWorks class >> saveOnLog: string [
]
