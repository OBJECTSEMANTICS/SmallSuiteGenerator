Class {
	#name : #SNumericParameterization,
	#superclass : #SInitialization,
	#category : #'SmallSuiteGenerator-Initialization'
}

{ #category : #'public tree building' }
SNumericParameterization >> newInstances: testCaseFactory [
	| instance |
	"| generationSizes statementSizes populationSizes |
	generationSizes := statementSizes := populationSizes := #(10 20)."
	"generationSizes do: [ :gSize | 
		statementSizes do: [ :stmtSize | 
			populationSizes do: [ :pSize | 
				[" instance := self copy: testCaseFactory.
				instance numberOfGenerations: 10;
				numberOfStatements: 15;
				populationSize: 20;
				createTestCases.
				^ instance
				"SInstanceStore save: instance ] on: Error do: [ nil ]" "]
		]
	]"
	
]

{ #category : #'public tree building' }
SNumericParameterization >> newInstancesM: testCaseFactory [
	| "generationSizes statementSizes"producer1 producer2 populationSizes monitor instances goalReached activeProducers counter  |
	"generationSizes := statementSizes :=" populationSizes := #(10).
	counter := 0.
	goalReached := false.
	activeProducers := 0.
	monitor := Monitor new.
	instances := OrderedCollection new.
	producer1 := [ | instance | 
		monitor critical: [ activeProducers := activeProducers + 1 ].
		[ monitor 
			critical: [ monitor waitUntil: [ counter \\ 5 = 0 ].
				goalReached or: [ 
					instance := self copy: testCaseFactory.
					instance numberOfGenerations: 15;
						numberOfStatements: 15;
						populationSize: 10;
						createTestCases.
					instances add: instance.
					counter := counter +1 ].
				goalReached := instances size = 1.
				monitor signal  ].
			goalReached ] whileFalse.
		monitor critical: [ activeProducers := activeProducers - 1.
			monitor signal: #finish ] ].
	producer2 := [ | instance | 
		monitor critical: [ activeProducers := activeProducers + 1 ].
		[ monitor 
			critical: [ monitor waitWhile: [ counter \\ 5 = 0 ].
				goalReached or: [ 
					instance := self copy: testCaseFactory.
					instance numberOfGenerations: 15;
						numberOfStatements: 15;
						populationSize: 10;
						createTestCases.
					instances add: instance.
					counter := counter +1 ].
				goalReached := instances isNotEmpty.
				monitor signal  ].
			goalReached ] whileFalse.
		monitor critical: [ activeProducers := activeProducers - 1.
			monitor signal: #finish ] ].
	
	producer1 forkAt: Processor userBackgroundPriority.
	producer2 forkAt: Processor userBackgroundPriority.
	
	monitor critical: [ monitor waitUntil: [ activeProducers = 0 & goalReached ] for: #finish ].
	
	^ instances

	
]
