Class {
	#name : #SMemoTest,
	#superclass : #TestCase,
	#instVars : [
		'memo'
	],
	#category : #'SmallSuiteGenerator-Visualization'
}

{ #category : #running }
SMemoTest >> setUp [ 
	memo := SMemo new
]

{ #category : #tests }
SMemoTest >> testAtOf [
	| summaryExecMethod generationNumber |
	generationNumber := 1.
	summaryExecMethod := SLSummaryExecutionMethod new 	
		executed: true;
		executorClass: #SSTeacher.
	self assert: (memo at: summaryExecMethod of: generationNumber) isNil.
]

{ #category : #tests }
SMemoTest >> testAtOfIfPresentIfAbsent [
	| summaryExecMethod generationNumber result |
	generationNumber := 1.
	summaryExecMethod := SLSummaryExecutionMethod new 	
		executed: true;
		executorClass: #SSTeacher.
	result := memo at: summaryExecMethod of: generationNumber ifPresent: [:value | value > 0 ] ifAbsent: [ false ].
	self deny: result.
	memo at: summaryExecMethod of: generationNumber put: 50.
	result := memo at: summaryExecMethod of: generationNumber ifPresent: [:value | value > 0 ] ifAbsent: [ false ].
	self assert: result
]

{ #category : #tests }
SMemoTest >> testAtOfPut [
	| summaryExecMethod generationNumber |
	generationNumber := 1.
	summaryExecMethod := SLSummaryExecutionMethod new 	
		executed: true;
		selector: #idTeacher;
		executorClass: #SSTeacher.
	memo at: summaryExecMethod of: generationNumber put: 50.
	self assert: (memo at: summaryExecMethod of: generationNumber) equals: 50.
]
