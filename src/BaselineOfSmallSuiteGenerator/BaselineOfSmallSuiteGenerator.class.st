Class {
	#name : #BaselineOfSmallSuiteGenerator,
	#superclass : #BaselineOf,
	#category : #BaselineOfSmallSuiteGenerator
}

{ #category : #baselines }
BaselineOfSmallSuiteGenerator >> baseline: spec [
	<baseline>
	spec for: #common 
	do: [ 
		spec baseline: 'Spy2'
		with: [ spec repository: 'github://ObjectProfile/Spy2/src' ].
		
		spec 
		package: 'SmallSuiteGenerator' with: [ spec requires: 'Spy2' ];
		package: 'SmallSuiteGeneratorAssert' with: [ spec requires: 'SmallSuiteGenerator' ];
		package: 'SmallSuiteGeneratorTest' with: [ spec requires: #('SmallSuiteGenerator' 'SmallSuiteGeneratorAssert') ]
	]
]
