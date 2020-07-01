Class {
	#name : #SExporte2VW,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Exporter'
}

{ #category : #public }
SExporte2VW class >> export [
	^ self new export
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackList [
	| result |
	result := OrderedCollection new.
	SExporte2VW selectors do: [ :sel | 
		(sel match: '#blackList+') ifTrue: [ result addAll: (self perform: sel) ]  ].
	^ result 
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSAssertionTest [
	^ {SAssertionTest >> #testAssertString}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSChangeTest [
	^ {SChangeTest >> #testChangeStatementOfFactoryMessageWithMoreThanOneLiteral}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSError [
	^ {SError >> #signal:}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSGAEngine [
	^ {"SGAEngine >> #exportFitnessLog ."
SGAEngine >> #updateTypeInfoWith:}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSGAEngineExample [
	^ {SGAEngineExample >> #runOnClass:withBlock:andFitness:}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSGAEngineTest [
	^ {SGAEngineTest >> #profilerOf:.
SGAEngineTest >> #tearDown}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSInsertTest [
	^ {SInsertTest >> #testInsertStatementOfSelectorRandomMessageInLiteral}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSObject [
	^ {"SObject >> #classOf:."
"SObject >> #findClass:."
SObject >> #fullNameOfClass:.
SObject >> #fullSymbolOf:.
SObject >> #initialize}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSPlatformVisualWorks [
	^ {"SPlatformVisualWorks class >> #classConfigurationName."
"SPlatformVisualWorks class >> #createTestCaseClass:inPackage:."
"SPlatformVisualWorks class >> #implementationType."
"SPlatformVisualWorks class >> #rbParserClass."
"SPlatformVisualWorks class >> #testCaseClass"}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSStack [
	^ {"SStack >> #+."
"SStack >> #addFirst:."
"SStack >> #addLast:."
"SStack >> #hasEqualElements:."
"SStack >> #removeFirst."
"SStack >> #removeLast"}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSTestCase [
	^ {SSTestCase >> #setUp .
SSTestCase >> #tearDown}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSTestCaseFactory [
	^ {STestCaseFactory >> #createConfigurationMethods .
STestCaseFactory >> #export:with: .
"STestCaseFactory >> #exportFitnessLog ."
STestCaseFactory >> #exportTests .
"STestCaseFactory >> #moveClass: ."
STestCaseFactory >> #tearDown .
"STestCaseFactory class >> #from:"}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSTestCaseFactoryVisualWorks [
	^ {"STestCaseFactoryVisualWorks >> #cleanInstrumentation."
"STestCaseFactoryVisualWorks >> #initializeProfiler."
"STestCaseFactoryVisualWorks >> #uninstall"}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSTestCaseTest [
	^ {SSTestCaseTest >> #typeInfo}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSTestShifterTest [
	^ {SSTestShifterTest >> #testNewFieldAccessMessageOfTypeBefore}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSTypeInfo [
	^ {"STypeInfo >> #asTypeInfo:methodsBlacklist:."
STypeInfo >> #completeTypeInfo.
STypeInfo >> #isAbstractClass:.
STypeInfo >> #updateArgsOf:}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSTypeInfoTest [
	^ {STypeInfoTest >> #nameOf:.
STypeInfoTest >> #testAsTypeInfoScalars.
STypeInfoTest >> #testAsTypeInfoSConferenceOnPackagesMatching.
STypeInfoTest >> #testAsTypeInfoSEventOnPackagesMatching.
STypeInfoTest >> #testAsTypeInfoSFoo.
STypeInfoTest >> #testAsTypeInfoSFooOnClass.
STypeInfoTest >> #testAsTypeInfoSFooWithNil.
STypeInfoTest >> #testAsTypeInfoSTeacherOnClass.
STypeInfoTest >> #testAsTypeInfoSTeacherOnPackagesMatching.
STypeInfoTest >> #testFactoryMessages}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSUtilityTypeInfo [
	^ {SUtilityTypeInfo >> #typeInfoSFoo1.
SUtilityTypeInfo >> #typeInfoSFoo3.
SUtilityTypeInfo >> #typeInfoSFooOnPackage2}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSmallTypeCollector [
	^ {"SmallTypeCollector >> #blackList."
"SmallTypeCollector >> #classesOf:."
"SmallTypeCollector >> #cleanArgName:."
"SmallTypeCollector >> #collectArgTypesOf:."
SmallTypeCollector >> #collectTypeFrom:.
"SmallTypeCollector >> #methodInfoIn:."
SmallTypeCollector >> #methodInfoIn:from:.
SmallTypeCollector >> #typeFor:}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> export [ 
	Pharo2VW exporter
	directory: FileSystem disk workingDirectory;
	namespace: 'SmallSuiteGenerator';
	externalNamespaces: {'SmallSuiteGenerator'};
	methodsBlacklist: self blackList;
	packages: self packages;
	export.
]

{ #category : #'as yet unclassified' }
SExporte2VW >> packages [ 
	^ #('SmallSuiteGenerator' 'SmallSuiteGenerator-Exporter' 'SmallSuiteGenerator-Scenario' 'SmallSuiteGenerator-Scenario2' 'SmallSuiteGenerator-Tests')
]
