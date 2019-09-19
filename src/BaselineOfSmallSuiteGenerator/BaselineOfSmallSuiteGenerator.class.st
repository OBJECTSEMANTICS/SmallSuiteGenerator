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
				baseline: 'NeoCSV'
				with: [ spec repository: 'github://svenvc/NeoCSV/repository' ].
			spec
				package: 'SmallSuiteGenerator-Generator';
				package: 'SmallSuiteGenerator-Info' with: [
					spec requires: 'NeoCSV'
					];
				package: 'SmallSuiteGenerator'
					with: [ spec requires: #('Spy2' 'SmallSuiteGenerator-Generator' 'MuTalk') ];
				package: 'SmallSuiteGenerator-Exception-Management';
				package: 'SmallSuiteGenerator-Fitness'
					with: [ spec
						requires: #('SBTestCoverage' 'SmallSuiteGenerator-Exception-Management') ];
				package: 'SmallSuiteGenerator-GeneticAlgorithm'
					with: [ spec requires: 'SmallSuiteGenerator' ];
				package: 'SmallSuiteGenerator-Assertion';
				package: 'SmallSuiteGenerator-Examples';
				package: 'SmallSuiteGenerator-Examples-Others';
				package: 'SmallSuiteGenerator-Examples-Demo'
					with: [ spec
						requires:
							#('SmallSuiteGenerator' 'SmallSuiteGenerator-Info' 'SmallSuiteGenerator-GeneticAlgorithm' 'SmallSuiteGenerator-Fitness' 'SmallSuiteGenerator-Examples' 'SmallSuiteGenerator-Examples-Others') ];
				package: 'SmallSuiteGenerator-Tests'
					with: [ spec
						requires:
							#('SmallSuiteGenerator' 'SmallSuiteGenerator-Examples' 'SmallSuiteGenerator-Examples-Others' 'SmallSuiteGenerator-Info') ];
				package: 'SmallSuiteGenerator-Tests-Assertion'
					with: [ spec requires: 'SmallSuiteGenerator-Assertion' ];
				package: 'SmallSuiteGenerator-Tests-Fitness'
					with: [ spec
						requires:
							#('SmallSuiteGenerator-Fitness' 'SmallSuiteGenerator-Examples' 'SmallSuiteGenerator') ];
				package: 'SmallSuiteGenerator-Tests-Generator'
					with: [ spec
						requires: #('SmallSuiteGenerator-Generator' 'SmallSuiteGenerator-Tests') ];
				package: 'SmallSuiteGenerator-Tests-GeneticAlgorithm'
					with: [ spec
						requires:
							#('SmallSuiteGenerator-GeneticAlgorithm' 'SmallSuiteGenerator-Examples' 'SmallSuiteGenerator-Examples-Others') ];
				package: 'SmallSuiteGenerator-Tests-Info'
					with: [ spec requires: #('SmallSuiteGenerator-Info' 'SmallSuiteGenerator') ];
				package: 'SmallSuiteGenerator-Tests-Exception-Management'
					with: [ spec requires: 'SmallSuiteGenerator-Exception-Management' ] ]
]
