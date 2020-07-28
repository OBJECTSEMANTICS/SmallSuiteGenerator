Class {
	#name : #SSAbstractSettingMethods,
	#superclass : #SObject,
	#instVars : [
		'testCase',
		'executeBlock',
		'factory'
	],
	#category : #'SmallSuiteGenerator-Strategies'
}

{ #category : #accessing }
SSAbstractSettingMethods class >> exportMethodsFor: aFactory [
	^ self new 
		factory: aFactory;
		exportMethods.
		
]

{ #category : #accessing }
SSAbstractSettingMethods class >> on: aTestCase execute: aBlock [
	^ self new
		testCase: aTestCase;
		executeBlock: aBlock;
		run
]

{ #category : #accessing }
SSAbstractSettingMethods >> executeBlock: aBlock [
	executeBlock := aBlock 
]

{ #category : #accessing }
SSAbstractSettingMethods >> exportMethod: aSelector [
	[|method|
	method := (self class >> aSelector) sourceCode.
	factory compile: method classified: 'running'.]
	on: Error 
	do: [  ]
	
]

{ #category : #accessing }
SSAbstractSettingMethods >> exportMethods [
	self exportMethod: #setUp.
	self exportMethod: #tearDown.
]

{ #category : #accessing }
SSAbstractSettingMethods >> factory: aFactory [ 
	factory  := aFactory  
]

{ #category : #accessing }
SSAbstractSettingMethods >> run [ 
	|context|
	self setUp.
	context := executeBlock value: testCase. 
	self tearDown.
	^ context
]

{ #category : #accessing }
SSAbstractSettingMethods >> setUp [
]

{ #category : #accessing }
SSAbstractSettingMethods >> tearDown [
]

{ #category : #accessing }
SSAbstractSettingMethods >> testCase: aTestCase [
	testCase := aTestCase 
]
