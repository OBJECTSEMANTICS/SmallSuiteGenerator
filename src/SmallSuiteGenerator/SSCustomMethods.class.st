Class {
	#name : #SSCustomMethods,
	#superclass : #SSAbstractSettingMethods,
	#category : #'SmallSuiteGenerator-Strategies'
}

{ #category : #removing }
SSCustomMethods class >> removeMethods [ 
	#(#setUp #tearDown) do: [ :symbol | 
		[self removeSelector: symbol ]
		on: Error
		do: [  ] ]
]
