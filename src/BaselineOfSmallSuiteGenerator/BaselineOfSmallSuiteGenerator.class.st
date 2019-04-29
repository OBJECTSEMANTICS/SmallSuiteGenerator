Class {
	#name : #BaselineOfSmallSuiteGenerator,
	#superclass : #BaselineOf,
	#category : #BaselineOfSmallSuiteGenerator
}

{ #category : #baselines }
BaselineOfSmallSuiteGenerator >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'Spy2'
				with: [ spec repository: 'github://ObjectProfile/Spy2/src' ].
			spec
				baseline: 'SBTestCoverage'
				with: [ spec requires: 'github://OBJECTSEMANTICS/SBTestCoverage' ].
			spec
				package: 'SmallSuiteGenerator'
					with: [ spec requires: #('Spy2' 'SBTestCoverage') ];
				package: 'SmallSuiteGeneratorAssert'
					with: [ spec requires: 'SmallSuiteGenerator' ];
				package: 'SmallSuiteGeneratorTest'
					with:
						[ spec requires: #('SmallSuiteGenerator' 'SmallSuiteGeneratorAssert') ].
			spec package: 'SmallSuiteCompiler'.
			spec package: 'SmallSuiteExamples' ]
]
