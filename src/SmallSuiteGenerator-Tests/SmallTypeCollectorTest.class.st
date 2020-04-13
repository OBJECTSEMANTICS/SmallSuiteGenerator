Class {
	#name : #SmallTypeCollectorTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-SmallType'
}

{ #category : #tests }
SmallTypeCollectorTest >> testAnInteger [
	self assert:#Integer equals: (self typeFor:'anInteger').
]

{ #category : #tests }
SmallTypeCollectorTest >> testInteger [
	self assert:#Integer equals: (self typeFor:'integer').
]

{ #category : #tests }
SmallTypeCollectorTest >> typeFor: aName [
	^ SmallTypeCollector new typeFor: aName.
]
