Class {
	#name : #SSCustomMethods,
	#superclass : #SSAbstractSettingMethods,
	#category : #'SmallSuiteGenerator-Strategies'
}

{ #category : #removing }
SSCustomMethods class >> removeMethods [ 
	[ self removeSelector: #setUp.
	self removeSelector: #tearDown.]
	on: Error 
	do: [  ]
]
