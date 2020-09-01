Extension { #name : #SSTypeCollectorMethod }

{ #category : #'*SmallSuiteGenerator' }
SSTypeCollectorMethod >> checkIfArgIsScalar: arg [
	((self profiler isScalar: arg) or: [ self profiler isASimpleObject: arg ])
		ifTrue: [ self profiler addScalar: arg ]
]
