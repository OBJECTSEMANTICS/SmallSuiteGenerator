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
				with: [ spec repository: 'github://ObjectProfile/Spy2:v1.0/src' ].
			spec
				baseline: 'MuTalk'
				with: [ spec repository: 'github://pavel-krivanek/mutalk/src' ].
			spec
				baseline: 'SBTestCoverage'
				with: [ spec repository: 'github://OBJECTSEMANTICS/SBTestCoverage' ].
			spec
				package: 'SmallSuiteGenerator'
					with: [ spec requires: #('Spy2' 'SBTestCoverage' 'MuTalk') ];
				package: 'SmallSuiteGenerator-Generator';
				package: 'SmallSuiteGenerator-Assertion';
				package: 'SmallSuiteGenerator-GeneticAlgorithm';
				package: 'SmallSuiteGenerator-Refactorization';
				package: 'SmallSuiteGenerator-Examples';
				package: 'SmallSuiteGenerator-Info'
					with: [ spec requires: #('SmallSuiteGenerator-Generator') ];
				package: 'SmallSuiteGenerator-Examples-Demo'
					with: [ spec
						requires:
							#('SmallSuiteGenerator' 'SmallSuiteGenerator-Info' 'SmallSuiteGenerator-GeneticAlgorithm') ];
				package: 'SmallSuiteGenerator-Tests-Assertion'
					with: [ spec requires: 'SmallSuiteGenerator-Assertion' ];
				package: 'SmallSuiteGenerator-Tests-Generator'
					with: [ spec requires: #('SmallSuiteGenerator-Generator') ];
				package: 'SmallSuiteGenerator-Tests-GeneticAlgorithm'
					with: [ spec requires: #('SmallSuiteGenerator-GeneticAlgorithm') ];
				package: 'SmallSuiteGenerator-Tests-Info'
					with: [ spec requires: #('SmallSuiteGenerator-Info') ];
				package: 'SmallSuiteGenerator-Tests-Refactorization'
					with: [ spec
						requires:
							#('SmallSuiteGenerator' 'SmallSuiteGenerator-Generator' 'SmallSuiteGenerator-Refactorization' 'SmallSuiteGenerator-Examples') ];
				package: 'SmallSuiteGeneratorTest'
					with: [ spec requires: #('SmallSuiteGenerator' 'MuTalk') ] ].
	spec package: 'SmallSuiteGenerator-Tests'
]
