"
SSTypeCollectorPackage is a subclass of Package that collects packages types
"
Class {
	#name : #SSTypeCollectorPackage,
	#superclass : #SLPackage,
	#category : #'SmallSuiteGenerator-Profiler'
}

{ #category : #hooks }
SSTypeCollectorPackage class >> spyClassForClass [
	 ^ SSTypeCollectorClass
]
