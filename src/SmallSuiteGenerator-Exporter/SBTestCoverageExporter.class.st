Class {
	#name : #SBTestCoverageExporter,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-Exporter'
}

{ #category : #exporting }
SBTestCoverageExporter >> codeToSort [
	<script: 'self new codeToSort'>
	GTPlayground
		openContents:
			'
"Execute in a Visualworks playground after load the file.st"
| main classes cat pkg |
main := Registry bundleNamed: ''SmallSuiteGenerator''.
classes := main allClasses.
packages := Dictionary new.

classes do: [ :cls |  
	cat := cls myClass category asString.
	(cat startsWith: ''SmallSuiteGenerator'') ifTrue: [
		pkg := packages at: cat ifAbsentPut: [ | p |
			p := Registry packageNamedOrCreate: cat.
			main addItem: p.
			p ].
		XChangeSet current moveWholeClass: cls toPackage: pkg
	] ]'
]

{ #category : #exporting }
SBTestCoverageExporter >> exportPackages [
	<script: 'self new exportPackages'>
	self exporter export
]

{ #category : #'instance creation' }
SBTestCoverageExporter >> exporter [
	| blacklist res packages notNeededPckgs |
	"rename Spy2-Core to Spy2 in order to use externalNamespaces"
	notNeededPckgs := {}.
	packages := RPackage organizer packageNames
		select: [ :pkgname | 'SBTestCoverage*' match: pkgname ].
	packages := packages
		reject: [ :pkgname | '*Roassal*' match: pkgname ].
	blacklist := {}.
	res := Pharo2VW exporter
		namespace: #SBTestCoverage;
		packages: packages without: notNeededPckgs;
		externalNamespaces: #('Spy');
		yourself.
	res methodsBlacklist: blacklist.
	^ res
]
