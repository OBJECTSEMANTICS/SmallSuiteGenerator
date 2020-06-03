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
SMemoTest >> testAtOfAnd [
	| summaryExecMethod |
	summaryExecMethod := SLSummaryExecutionMethod new 	
		executed: true;
		executorClass: #SSTeacher.
	self assert: (memo at: summaryExecMethod of: 1 and: 1) isNil.
]

{ #category : #tests }
SMemoTest >> testAtOfAndIfPresentIfAbsent [
	| summaryExecMethod generationNumber idPopulation result |
	generationNumber := 1.
	idPopulation := 1.
	summaryExecMethod := SLSummaryExecutionMethod new 	
		executed: true;
		executorClass: #SSTeacher.
	result := memo at: summaryExecMethod of: generationNumber and: idPopulation ifPresent: [:value | value > 0 ] ifAbsent: [ false ].
	self deny: result.
	memo at: summaryExecMethod of: generationNumber and: idPopulation put: 50.
	result := memo at: summaryExecMethod of: generationNumber and: idPopulation ifPresent: [:value | value > 0 ] ifAbsent: [ false ].
	self assert: result
]

{ #category : #tests }
SMemoTest >> testAtOfAndPut [
	| summaryExecMethod generationNumber idPopulation |
	generationNumber := 1.
	idPopulation := 1.
	summaryExecMethod := SLSummaryExecutionMethod new 	
		executed: true;
		selector: #idTeacher;
		executorClass: #SSTeacher.
	memo at: summaryExecMethod of: generationNumber and: idPopulation put: 50.
	self assert: (memo at: summaryExecMethod of: generationNumber and: idPopulation) equals: 50.
]
