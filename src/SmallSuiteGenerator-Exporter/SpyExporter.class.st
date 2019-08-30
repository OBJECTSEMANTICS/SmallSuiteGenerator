Class {
	#name : #SpyExporter,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Exporter'
}

{ #category : #exporting }
SpyExporter >> exportPackages [
	<script: 'self new exportPackages'>
	self exporter export
]

{ #category : #'instance creation' }
SpyExporter >> exporter [
	| blacklist res |
	blacklist := {}.	"(S2Profiler >> #>>>)"
	res := Pharo2VW exporter
		namespace: #Spy;
		packagesTags:
			{((RPackageOrganizer default packageNamed: 'SpyCore')
				classTagNamed: 'SpyCore')};
		yourself.
	res methodsBlacklist: blacklist.
	^ res
]
