"
SConfigurationVisualWorks is a subclass called when the project environment is running in VisualWorks.
"
Class {
	#name : #SVWPlatform,
	#superclass : #SPlatform,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #accessing }
SVWPlatform class >> classTestCaseFactory [
	^ STestCaseFactoryVisualWorks 
]

{ #category : #logging }
SVWPlatform class >> cleanAllLogs [ 
	
]

{ #category : #logging }
SVWPlatform class >> clearLog [ 
	
]

{ #category : #'instance creation' }
SVWPlatform class >> fileLogger: fileName [
]

{ #category : #logging }
SVWPlatform class >> saveOnLog: string [
]
