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
				baseline: 'SpyLite'
				with: [ spec repository: 'github://Lin777/SpyLite:BlackList/src' ].
				spec
				baseline: 'Roassal2'
				with: [ spec repository: 'github://ObjectProfile/Roassal2/src' ].
			spec
				baseline: 'MuTalk'
				with: [ spec repository: 'github://pavel-krivanek/mutalk/src' ].
			spec
				baseline: 'NeoCSV'
				with: [ spec repository: 'github://svenvc/NeoCSV/repository' ].
			spec
	baseline: 'TinyLogger'
	with: [ spec repository: 'github://jecisc/TinyLogger:v1.x.x/src' ].
			spec
				package: 'SmallSuiteGenerator'
					with: [ spec requires: #('SpyLite' 'MuTalk' 'NeoCSV' 'TinyLogger') ];
				package: 'SmallSuiteGenerator-Scenario';
				package: 'SmallSuiteGenerator-Scenario2';
				package: 'SmallSuiteGenerator-Visualization' with: [ spec requires: #('Roassal2') ];
				package: 'SmallSuiteGenerator-Tests'
					with: [ spec
						requires:
							#('SmallSuiteGenerator' 'SmallSuiteGenerator-Scenario' 'SmallSuiteGenerator-Scenario2') ].
			spec 
				group: 'default' with: #('SmallSuiteGenerator-Tests');
				group: 'All' with: #('SmallSuiteGenerator-Tests' 'SmallSuiteGenerator-Visualization') ]
					
]
