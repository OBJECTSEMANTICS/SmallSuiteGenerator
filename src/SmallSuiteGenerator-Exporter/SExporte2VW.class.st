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
		(('blackList*' match: sel asString ) and: [ (sel = #blackList) not ])
			 ifTrue: [ result addAll: (self perform: sel) ]  ].
	^ result 
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSAssertionTest [
	^ {SAssertionTest >> #testAssertString}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSAssignment [
	^ {SAssignment >> #mutantColor .
	SAssignment >> #stmColor }
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSChangeTest [
	^ {SChangeTest >> #testChangeStatementOfFactoryMessageWithMoreThanOneLiteral}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSClassInfoTest [
	^ {SClassInfoTest >> #testToString .
	SClassInfoTest >> #testFromString}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSError [
	^ {SError >> #signal:}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSExpression [
	^ {SExpression >> #mutantColor .
	SExpression >> #stmColor }
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSFactoryMessage [
	^ {SFactoryMessage >> #stmColor }
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSFieldAccessMessage [
	^ {SFieldAccessMessage >> #stmColor }
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSGAEngine [
	^ {"SGAEngine >> #exportFitnessLog ."
SGAEngine >> #updateTypeInfoWith:. "VisualizationPackage"
SGAEngine >> #addDescriptiveTextOn:ofColor:and: .
SGAEngine >> #addHighlightMethodEvent:on:ofColor:.
SGAEngine >> #addHighlightTestCaseEvent:on:ofColor:.
SGAEngine >> #addLegend:on:withFontColor:and:.
SGAEngine >> #addLegendOn:with:.
SGAEngine >> #addSurvivorTestCase:on:using:and:.
SGAEngine >> #addTickX:withScale:color:y:and: .
SGAEngine >> #addTickY:withScale:xMax:ofColor:andPositions: .
SGAEngine >> #borderOfSize:andColor: .
SGAEngine >> #contributionShapeOfHeight:color:and:.
SGAEngine >> #evolutionPoints:withScale: .
SGAEngine >> #evolutionShapeWith:ofColor:size: .
SGAEngine >> #generationVisualization:ofColor: .
SGAEngine >> #infoMethodShapesOn:ofColor:highlight: .
SGAEngine >> #isCoverage:ofSummaryMethod:in:newOrHigher: .
SGAEngine >> #methodColorDictionary: .
SGAEngine >> #methodShape:withGradientFrom:to: .
SGAEngine >> #methodShapeGroup:with:highlight:scale: .
SGAEngine >> #progressBarFrom:to:ofColor:.
SGAEngine >> #scaleColorBlock:.
SGAEngine >> #setPositions:using: .
SGAEngine >> #sparkCircleGroupOfColor:andSize:.
SGAEngine >> #summaryMethodsOfTargetClass:.
SGAEngine >> #testCaseShape:ofColor:with:highlight:scale:}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSGAEngineExample [
	^ {SGAEngineExample >> #runOnClass:withBlock:andFitness: .
	SGAEngineExample >> #runOnPackagesMatching:withBlock:andFitness:}
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
SExporte2VW >> blackListSInspectorAssertion [
	^ {SInspectorAssertion class >> #inspectorAssertionOf:}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSLiteral [
	^ {SLiteral >> #stmColor }
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSMessage [
	^ {SMessage >> #stmColor }
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSMethodInfoTest [
	^ {SMethodInfoTest >> #testToString.
	SMethodInfoTest >> #testFromSton}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSMultiTypeInfoTest [
	^ {SMultiTypeInfoTest >> #testToString.
	SMultiTypeInfoTest >> #testFromSton}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSNumericParameterization [
	^ {SNumericParameterization >> #newInstancesM:}
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
SExporte2VW >> blackListSPlatformPharo [
	^ {SPlatformPharo class >> #classLogger.
	SPlatformPharo class >> #implementationType .
	SPlatformPharo class >> #rbParserClass .
	SPlatformPharo class >> #testCaseClass }
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
SExporte2VW >> blackListSReport [
	^ {SReport class >> #exportData:onCSV:usingFilter:}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSReportSGALog [
	^ {SReportSGALog class >> #exportResumeOf:onCSV: .
	SReportSGALog >> #generateReportForDifferencesBtwGenerations}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSReportTypeInfo [
	^ {SReportTypeInfo class >> #writeReport:ofCaseStudy: .
	SReportTypeInfo class >> #writeReport:ofFrequency:}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSSelectionParameterization [
	^ {SSelectionParameterization class >> #setting:}
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
"STestCaseFactory class >> #from:"
STestCaseFactory >> #fitnessResultAsDictionary .
STestCaseFactory >> #generationEvolutionCanvas .
STestCaseFactory >> #gtInspectorCanvasIn: .
STestCaseFactory >> #gtInspectorViewIn: .
STestCaseFactory >> #visualizeEvolutionFitness .
STestCaseFactory >> #generatedClass}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSTestCaseFactoryExample [
	^ {STestCaseFactoryExample >> #clean .
STestCaseFactoryExample >> #exampleEmptyBlockOnPackages .
STestCaseFactoryExample >> #exampleSSTeacherOnClass .
STestCaseFactoryExample >> #exampleSSTeacherOnPackages .
STestCaseFactoryExample >> #exampleSStackOnClass .
STestCaseFactoryExample >> #exampleSStackOnPackages .
STestCaseFactoryExample >> #exampleSStudentOnClass .
STestCaseFactoryExample >> #exampleWithSubclassToRun .
STestCaseFactoryExample >> #exampleWithWrongClassToRun .
STestCaseFactoryExample >> #exampleWithWrongRegexToRun}
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
SExporte2VW >> blackListSTestShifter [
	^ {SSTestShifter>> #canAddStatement}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSTestShifterTest [
	^ {SSTestShifterTest >> #testNewFieldAccessMessageOfTypeBefore}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSTypeClassInfo [
	^ {STypeClassInfo >> #differenceWith:usingSelector:}
]

{ #category : #'as yet unclassified' }
SExporte2VW >> blackListSTypeInfo [
	^ {"STypeInfo >> #asTypeInfo:methodsBlacklist:."
STypeInfo >> #completeTypeInfo.
STypeInfo >> #isAbstractClass:.
STypeInfo >> #updateArgsOf: .
STypeInfo >> #deleteBlackListMethods}
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
STypeInfoTest >> #testFactoryMessages.
STypeInfoTest >> #testToStringComplexScalar.
STypeInfoTest >> #testToString.
STypeInfoTest >> #testFromString}
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
	^ #('SmallSuiteGenerator' 'SmallSuiteGenerator-Scenario' 'SmallSuiteGenerator-Scenario2' 'SmallSuiteGenerator-Tests')
]