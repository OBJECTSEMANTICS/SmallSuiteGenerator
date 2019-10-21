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
				package: 'SmallSuiteGenerator'
					with: [ spec requires: #('Spy2' 'MuTalk' 'NeoCSV') ];
				package: 'SmallSuiteGenerator-Exception';
				package: 'SmallSuiteGenerator-Scenario';
				package: 'SmallSuiteGenerator-Scenario2';
				package: 'SmallSuiteGenerator-Fitness'
					with: [ spec
						requires: #('SBTestCoverage' 'SmallSuiteGenerator-Exception') ];
				package: 'SmallSuiteGenerator-GeneticAlgorithm'
					with: [ spec requires: #('SmallSuiteGenerator' 'SmallSuiteGenerator-Fitness' 'SmallSuiteGenerator-Scenario') ];
				package: 'SmallSuiteGenerator-Tests'
					with: [ spec
						requires:
							#('SmallSuiteGenerator' 'SmallSuiteGenerator-Scenario') ];
				package: 'SmallSuiteGenerator-Fitness-Tests'
					with: [ spec
						requires:
							#('SmallSuiteGenerator-Fitness' 'SmallSuiteGenerator-Scenario' 'SmallSuiteGenerator') ];
				package: 'SmallSuiteGenerator-GeneticAlgorithm-Tests'
					with: [ spec
						requires:
							#('SmallSuiteGenerator-GeneticAlgorithm' 'SmallSuiteGenerator-Scenario') ] ]
]
