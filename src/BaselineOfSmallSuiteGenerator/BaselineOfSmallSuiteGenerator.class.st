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
				with: [ spec repository: 'github://lin777/SpyLite:master/src' ].
				spec
    			baseline: 'RoelTyper'
    			with: [ spec repository: 'github://RMODINRIA/RoelTyper:v1.x.x/src' ].
        spec baseline: 'Roassal3'
				with: [ spec repository: 'github://ObjectProfile/Roassal3' ].
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
				baseline: 'Pharo2VW'
				with: [ spec repository: 'github://lin777/Pharo2VW:FixLoad/src' ].
			spec
				package: 'SmallSuiteGenerator'
					with: [ spec requires: #('RoelTyper' 'SpyLite' 'MuTalk' 'NeoCSV' 'TinyLogger') ];
				package: 'SmallSuiteGenerator-Scenario';
				package: 'SmallSuiteGenerator-Scenario2';
				package: 'SmallSuiteGenerator-Visualization' with: [ spec requires: #('Roassal3') ];
				package: 'SmallSuiteGenerator-Exporter' with: [ spec requires: #('Pharo2VW') ];
				package: 'SmallSuiteGenerator-Tests'
					with: [ spec
						requires:
							#('SmallSuiteGenerator' 'SmallSuiteGenerator-Scenario' 'SmallSuiteGenerator-Scenario2') ].
			spec 
				group: 'default' with: #('SmallSuiteGenerator-Tests');
				group: 'All' with: #('SmallSuiteGenerator-Tests' 'SmallSuiteGenerator-Visualization');
				group: 'Exporter' with: #('SmallSuiteGenerator-Tests' 'SmallSuiteGenerator-Exporter') ]
]
