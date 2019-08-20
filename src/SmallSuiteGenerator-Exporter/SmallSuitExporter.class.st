"
I a m a basic exporter to visualworks
"
Class {
	#name : #SmallSuitExporter,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-Exporter'
}

{ #category : #exporting }
SmallSuitExporter >> codeToSort [
	<script: 'self new codeToSort'>
	GTPlayground openContents: '
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
SmallSuitExporter >> exportPackages [
	<script: 'self new exportPackages'>
	self exporter export
]

{ #category : #exporting }
SmallSuitExporter >> exporter [
	| blacklist res packages |
	"rename Spy2-Core to Spy2 in order to use externalNamespaces"
	packages := RPackage organizer packageNames select: [ :pkgname |
		'SmallSuiteGenerator*' match: pkgname ].
	blacklist := {}.
	res := Pharo2VW exporter
		namespace: #SmallSuiteGenerator;
		packages: packages without: {'SmallSuiteGenerator-Exporter'};
		externalNamespaces: #('Spy2');
		yourself.
	
	res methodsBlacklist: blacklist.
	^ res
]
