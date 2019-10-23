Class {
	#name : #SSTypeCollectorPackage,
	#superclass : #S2Package,
	#category : #'SmallSuiteGenerator-Profiler'
}

{ #category : #hooks }
SSTypeCollectorPackage class >> spyClassForClass [
	 ^ SSTypeCollectorClass
]
