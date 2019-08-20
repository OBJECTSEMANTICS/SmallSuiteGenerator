"
I am an exporter for spy2
"
Class {
	#name : #Spy2Exporter,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-Exporter'
}

{ #category : #exporting }
Spy2Exporter >> exportPackages [
	<script: 'self new exportPackages'>
	self exporter export
]

{ #category : #'instance creation' }
Spy2Exporter >> exporter [
	| blacklist res |
	blacklist := {S2Profiler >> #>>> }.
	res := Pharo2VW exporter
		namespace: #'Spy2';
		packagesTags: {(RPackageOrganizer default 
			packageNamed: 'Spy2') classTagNamed: 'Metamodel' };
		yourself.
	
	res methodsBlacklist: blacklist.
	^ res
]
