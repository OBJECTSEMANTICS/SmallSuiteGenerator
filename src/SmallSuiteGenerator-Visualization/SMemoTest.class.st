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
	| summaryExecMethod testCase |
	testCase := SSTestCase new idPopulation: 1; generationNumber: 1.
	summaryExecMethod := SLSummaryExecutionMethod new 	
		executed: true;
		executorClass: #SSTeacher.
	self assert: (memo at: summaryExecMethod of: testCase) isNil.
]

{ #category : #tests }
SMemoTest >> testAtOfIfPresentIfAbsent [
	| summaryExecMethod testCase result |
	testCase := SSTestCase new idPopulation: 1; generationNumber: 1.
	summaryExecMethod := SLSummaryExecutionMethod new 	
		executed: true;
		executorClass: #SSTeacher.
	result := memo at: summaryExecMethod of: testCase ifPresent: [:value | value > 0 ] ifAbsent: [ false ].
	self deny: result.
	memo at: summaryExecMethod of: testCase put: 50.
	result := memo at: summaryExecMethod of: testCase ifPresent: [:value | value > 0 ] ifAbsent: [ false ].
	self assert: result
]

{ #category : #tests }
SMemoTest >> testAtOfPut [
	| summaryExecMethod testCase |
	testCase := SSTestCase new idPopulation: 1; generationNumber: 1.
	summaryExecMethod := SLSummaryExecutionMethod new 	
		executed: true;
		selector: #idTeacher;
		executorClass: #SSTeacher.
	memo at: summaryExecMethod of: testCase put: 50.
	self assert: (memo at: summaryExecMethod of: testCase ) equals: 50.
]
