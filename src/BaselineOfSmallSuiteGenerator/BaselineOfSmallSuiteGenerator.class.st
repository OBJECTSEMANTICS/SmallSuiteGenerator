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
		do: [ 
			
			"spec
				baseline: 'Spy2'
				with: [ spec repository: 'github://ObjectProfile/Spy2:v1.0/src' ]."
			spec
				baseline: 'MuTalk'
				with: [ spec repository: 'github://pavel-krivanek/mutalk/src' ].
			spec
				baseline: 'SBTestCoverage'
				with: [ spec repository: 'github://OBJECTSEMANTICS/SBTestCoverage' ].
			spec
				baseline: 'Pharo2VW'
				with: [ spec repository: 'github://ObjectProfile/Pharo2VW' ].
			spec
				package: 'SmallSuiteGenerator-Extensions';
				package: 'SpyCore';
				package: 'SmallSuiteGenerator-Nodes'
					with: [ spec requires: 'SmallSuiteGenerator-Extensions' ];
				package: 'SmallSuiteGenerator'
					with: [ spec requires: 'SmallSuiteGenerator-Nodes' ];
				package: 'SmallSuiteGenerator-Examples'
					with: [ spec requires: 'SmallSuiteGenerator' ];
				package: 'SmallSuiteGenerator-Exporter'
					with: [ spec requires: #('SpyCore' 'SmallSuiteGenerator' 'Pharo2VW') ];
				package: 'SmallSuiteGenerator-Fitness'
					with: [ spec requires: #('SmallSuiteGenerator' 'SBTestCoverage') ];
				package: 'SmallSuiteGenerator-Info'
					with: [ spec requires: 'SmallSuiteGenerator' ];
				package: 'SmallSuiteGenerator-Profiler'
					with: [ spec requires: 'SpyCore' ];
				package: 'SmallSuiteGenerator-Assertion'
					with: [ spec requires: 'SmallSuiteGenerator' ];
				package: 'SmallSuiteGenerator-GeneticAlgorithm'
					with: [ spec requires: #('SmallSuiteGenerator' 'MuTalk') ];
				package: 'SmallSuiteGenerator-Facade'
					with: [ spec
						requires:
							#('SmallSuiteGenerator' 'SmallSuiteGenerator-GeneticAlgorithm' 'SmallSuiteGenerator-Fitness') ];
				package: 'SmallSuiteGenerator-Invariant'
					with: [ spec
						requires:
							#('SmallSuiteGenerator' 'SmallSuiteGenerator-Fitness' 'SmallSuiteGenerator-Assertion') ];
				package: 'SmallSuiteGenerator-Examples-Demo'
					with: [ spec
						requires:
							#('SmallSuiteGenerator' 'SmallSuiteGenerator-Info' 'SmallSuiteGenerator-GeneticAlgorithm' 'SmallSuiteGenerator-Fitness' 'SmallSuiteGenerator-Examples') ];
				package: 'SmallSuiteGenerator-Tests'
					with: [ spec
						requires:
							#('SmallSuiteGenerator' 'SmallSuiteGenerator-Examples' 'SmallSuiteGenerator-Info') ];
				package: 'SmallSuiteGenerator-Tests-Assertion'
					with: [ spec
						requires:
							#('SmallSuiteGenerator-Assertion' 'SmallSuiteGenerator-Info' 'SmallSuiteGenerator-Invariant') ];
				package: 'SmallSuiteGenerator-Tests-Fitness'
					with: [ spec
						requires:
							#('SmallSuiteGenerator-Fitness' 'SmallSuiteGenerator-Examples' 'SmallSuiteGenerator') ];
				package: 'SmallSuiteGenerator-Tests-Nodes'
					with: [ spec
						requires: #('SmallSuiteGenerator-Nodes' 'SmallSuiteGenerator-Tests') ];
				package: 'SmallSuiteGenerator-Tests-GeneticAlgorithm'
					with: [ spec
						requires:
							#('SmallSuiteGenerator-GeneticAlgorithm' 'SmallSuiteGenerator-Examples') ];
				package: 'SmallSuiteGenerator-Tests-Info'
					with: [ spec requires: #('SmallSuiteGenerator-Info' 'SmallSuiteGenerator') ] ]
]
