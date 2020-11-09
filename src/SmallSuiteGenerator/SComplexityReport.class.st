Class {
	#name : #SComplexityReport,
	#superclass : #SReport,
	#instVars : [
		'maxNumberOfMethods',
		'regex',
		'classesByComplexity',
		'packages',
		'classes'
	],
	#category : #'SmallSuiteGenerator-Utility'
}

{ #category : #'as yet unclassified' }
SComplexityReport class >> generateClassComplexityReportForPackageWithRegex: aString [

	self new
		regex: aString;
		calculateComplexityOfPackages;
		generateReport
]

{ #category : #actions }
SComplexityReport >> calculateComplexityOfPackages [
  | sumOfCyclomatics |
  classes := self getClassesOfPackageWithRegex.
  self removeDuplicatesExternalAndTestCasesOfClasses.
  classes do: [:class |  maxNumberOfMethods := maxNumberOfMethods max: (self quantityOfMethodsOfClass: class) ].
  classes do: [:class |  | avgComplexity factor |
		  sumOfCyclomatics := 0.
        class methods do: [:m |  | cyclomaticNumber |
              cyclomaticNumber := self calculateCyclomaticOf: m.
              sumOfCyclomatics := sumOfCyclomatics + cyclomaticNumber ].
        class class methods do: [:m |  | cyclomaticNumber |
              cyclomaticNumber := self calculateCyclomaticOf: m.
              sumOfCyclomatics := sumOfCyclomatics + cyclomaticNumber ].
        avgComplexity := (self quantityOfMethodsOfClass: class) isZero 
				ifTrue: [ 0 ] 
				ifFalse: [ sumOfCyclomatics / (self quantityOfMethodsOfClass: class) ].
		  factor :=(self quantityOfMethodsOfClass: class) / maxNumberOfMethods.
		  classesByComplexity at: class put: (factor * avgComplexity) ].

]

{ #category : #actions }
SComplexityReport >> calculateCyclomaticOf: m [
  | rbMethodNode |
  rbMethodNode := RBParser parseMethod: m sourceCode asString.
  ^(SLVisitorForCyclomaticMetric for: rbMethodNode) cyclomaticNumber
]

{ #category : #accessing }
SComplexityReport >> classesByComplexity [

	^ classesByComplexity
]

{ #category : #accessing }
SComplexityReport >> classesByComplexity: aDictionary [

	classesByComplexity := aDictionary
]

{ #category : #actions }
SComplexityReport >> generateReport [

	(self fileReference: 'complexity_of_packages')
		writeStreamDo: [ :stream | 
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: #('Classes').
				(((classesByComplexity associations sort: [:x :y | x value > y value]) 
					collect: [:assoc | assoc key asString]) asOrderedCollection) do: [ :class |
						neoCSVWriter nextPut: (Array with: class) ].
			neoCSVWriter flush ]
]

{ #category : #actions }
SComplexityReport >> getClassesOfPackageWithRegex [
  packages := RPackageOrganizer default packages select: [:p |  regex match: p name asString ].
  ^ packages inject: #() into: [:sum :el |  
	sum , (el classes reject: #isTrait) asOrderedCollection ]
]

{ #category : #initialization }
SComplexityReport >> initialize [

	regex := ''.
	maxNumberOfMethods := 0.
	classesByComplexity := Dictionary new.
]

{ #category : #accessing }
SComplexityReport >> maxNumberOfMethods: aNumber [

	maxNumberOfMethods := aNumber
]

{ #category : #actions }
SComplexityReport >> quantityOfMethodsOfClass: class [
  ^class methods size + class class methods size
]

{ #category : #accessing }
SComplexityReport >> regex: aString [

	regex := aString
]

{ #category : #actions }
SComplexityReport >> removeDuplicatesExternalAndTestCasesOfClasses [
  classes := (classes select: [:class |
	(regex match: class package name) and: [ (class isTestCase not)] ]) asOrderedCollection removeDuplicates
]
