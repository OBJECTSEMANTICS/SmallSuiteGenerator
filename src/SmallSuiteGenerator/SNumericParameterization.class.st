"
SNumericParametrization creates instances changing values like: 	
	- numberOfStatements 
	- numberOfPopulation
	- numberOfGenerations
"
Class {
	#name : #SNumericParameterization,
	#superclass : #SInitialization,
	#category : #'SmallSuiteGenerator-Initialization'
}

{ #category : #initialization }
SNumericParameterization >> initializeDictionary [
	^ Dictionary new 
			at: #largePopulationNumber put: [ :testCaseFactory | 
				testCaseFactory engine populationSize < 30 
					ifTrue: [ testCaseFactory populationSize: 30 ] ];
			at: #largeGenerationNumber put: [ :testCaseFactory | 
				testCaseFactory numberOfGenerations < 50 
					ifTrue: [ testCaseFactory numberOfGenerations: 50 ] ];
			at: #largeStatementNumber put: [ :testCaseFactory |
				testCaseFactory engine numberOfStatements < 50 ifTrue: [ 
					testCaseFactory numberOfStatements: 50 ] ];
			at: #smallPopulationNumber put: [ :testCaseFactory | 
				testCaseFactory engine populationSize > 5 
					ifTrue: [ testCaseFactory populationSize: 5 ] ];
			at: #smallGenerationNumber put: [ :testCaseFactory | 
				testCaseFactory numberOfGenerations > 3 
					ifTrue: [ testCaseFactory numberOfGenerations: 3 ] ];
			at: #smallStatementNumber put: [ :testCaseFactory |
				testCaseFactory engine numberOfStatements > 3 ifTrue: [ 
					testCaseFactory numberOfStatements: 3 ] ];
			yourself
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
