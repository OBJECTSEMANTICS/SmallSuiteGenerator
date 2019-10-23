"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestSmallSuiteGenerator,
	#superclass : #PackageManifest,
	#category : #'SmallSuiteGenerator-Manifest'
}

{ #category : #'code-critics' }
ManifestSmallSuiteGenerator class >> ruleRBModifiesCollectionRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'SComparisonAssertion class' #for: #true)) #'2019-10-08T16:32:31.453793-04:00') )
]

{ #category : #'code-critics' }
ManifestSmallSuiteGenerator class >> ruleRBStringConcatenationRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#STestCaseFactory #tearDown #false)) #'2019-10-22T22:14:33.332959-04:00') )
]

{ #category : #'code-critics' }
ManifestSmallSuiteGenerator class >> ruleRBkeysDoRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'SComparisonAssertion class' #for: #true)) #'2019-10-08T16:32:13.154793-04:00') )
]
