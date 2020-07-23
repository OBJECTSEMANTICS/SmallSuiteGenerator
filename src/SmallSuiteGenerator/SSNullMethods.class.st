Class {
	#name : #SSNullMethods,
	#superclass : #SSAbstractSettingMethods,
	#category : #'SmallSuiteGenerator-Strategies'
}

{ #category : #accessing }
SSNullMethods class >> exportMethodsFor: aFactory [
]

{ #category : #accessing }
SSNullMethods class >> on: aTestCase execute: aBlock [
	^ aBlock value: aTestCase
]
