Class {
	#name : #SGreaterThanMethod,
	#superclass : #SSelectorMethod,
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #testing }
SGreaterThanMethod class >> is: aTestCase1 betterThan: aTestCase2 [
	| isBetter |
	isBetter := false.
	functions
		doWithIndex: [ :f :index | 
			isBetter := f is: aTestCase1 betterThan: aTestCase2.
			"isBetter := (aTestCase1 fitness at: index) perform: f comparisonOperator with: (aTestCase2 fitness at: index)."
			isBetter
				ifFalse: [ (aTestCase1 fitness at: f nameFunction)
						= (aTestCase2 fitness at: f nameFunction)
						ifFalse: [ "index" "index" ^ false ] ] ].
	^ isBetter
]
