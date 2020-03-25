"
SConfigurationVisualWorks is a subclass called when the project environment is running in VisualWorks.
"
Class {
	#name : #SVisualWorksPlatform,
	#superclass : #SPlatform,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #accessing }
SVisualWorksPlatform class >> classTestCaseFactory [
	^ STestCaseFactoryVisualWorks 
]

{ #category : #logging }
SVisualWorksPlatform class >> cleanAllLogs [ 
	
]

{ #category : #logging }
SVisualWorksPlatform class >> clearLog [ 
	
]

{ #category : #'instance creation' }
SVisualWorksPlatform class >> fileLogger: fileName [
]

{ #category : #logging }
SVisualWorksPlatform class >> saveOnLog: string [
]
