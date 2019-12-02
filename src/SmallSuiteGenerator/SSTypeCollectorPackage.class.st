"
SSTypeCollectorPackage is a subclass of Package that collects packages types
"
Class {
	#name : #SSTypeCollectorPackage,
	#superclass : #S2Package,
	#category : #'SmallSuiteGenerator-Profiler'
}

{ #category : #hooks }
SSTypeCollectorPackage class >> spyClassForClass [
	 ^ SSTypeCollectorClass
]
