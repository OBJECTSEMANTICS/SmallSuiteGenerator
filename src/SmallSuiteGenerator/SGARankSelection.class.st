"
SGARankSelection is responsible for select testCases randomly regardless of fitness
"
Class {
	#name : #SGARankSelection,
	#superclass : #SGASelection,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #selection }
SGARankSelection >> selectOf: aCollection [
	^ self random collectAtRandom: aCollection 
]
