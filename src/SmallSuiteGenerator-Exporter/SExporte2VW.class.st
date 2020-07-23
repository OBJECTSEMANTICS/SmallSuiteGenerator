Class {
	#name : #SExporte2VW,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Exporter'
}

{ #category : #public }
SExporte2VW class >> export [
	^ self new export
]

{ #category : #'black-list' }
SExporte2VW >> blackList [
	| result |
	result := OrderedCollection new.
	SExporte2VW selectors do: [ :sel | 
		(('blackList*' match: sel asString ) and: [ (sel = #blackList) not ])
			 ifTrue: [ result addAll: (self perform: sel) ]  ].
	^ result 
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSAssertionTest [
	^ {SAssertionTest >> #testAssertString.
	SAssertionTest >> #testAssertComparison2.
	SAssertionTest >> #testAssertComparison}
]

{ #category : #'bl-core' }
SExporte2VW >> blackListSAssignment [
	^ {SAssignment >> #mutantColor .
	SAssignment >> #stmColor }
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSChangeTest [
	^ {SChangeTest >> #testSelectorChange}
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSClassInfoTest [
	^ {SClassInfoTest >> #testToString .
	SClassInfoTest >> #testFromString}
]

{ #category : #'bl-core' }
SExporte2VW >> blackListSError [
	^ {SError >> #signal:}
]

{ #category : #'bl-core' }
SExporte2VW >> blackListSExpression [
	^ {SExpression >> #mutantColor .
	SExpression >> #stmColor }
]

{ #category : #'bl-core' }
SExporte2VW >> blackListSFactoryMessage [
	^ {SFactoryMessage >> #stmColor }
]

{ #category : #'bl-core' }
SExporte2VW >> blackListSFieldAccessMessage [
	^ {SFieldAccessMessage >> #stmColor }
]

{ #category : #'bl-ga' }
SExporte2VW >> blackListSGAEngine [
	^ {"SGAEngine >> #exportFitnessLog ."
 "VisualizationPackage"
SGAEngine >> #updateTypeInfoWith:. "<------ review if is important use Pharo version"
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

{ #category : #'bl-examples' }
SExporte2VW >> blackListSGAEngineExample [
	^ {SGAEngineExample >> #runOnClass:withBlock:andFitness: .
	SGAEngineExample >> #runOnPackagesMatching:withBlock:andFitness:}
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSGAEngineTest [
	^ {SGAEngineTest >> #profilerOf:.
SGAEngineTest >> #tearDown}
]

{ #category : #'bl-core' }
SExporte2VW >> blackListSInspectorAssertion [
	^ {SInspectorAssertion class >> #inspectorAssertionOf:}
]

{ #category : #'bl-core' }
SExporte2VW >> blackListSLiteral [
	^ {SLiteral >> #stmColor }
]

{ #category : #'bl-core' }
SExporte2VW >> blackListSMessage [
	^ {SMessage >> #stmColor }
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSMethodInfoTest [
	^ {SMethodInfoTest >> #testToString.
	SMethodInfoTest >> #testFromSton}
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSMultiTypeInfoTest [
	^ {SMultiTypeInfoTest >> #testToString.
	SMultiTypeInfoTest >> #testFromSton}
]

{ #category : #'bl-initialization' }
SExporte2VW >> blackListSNumericParameterization [
	^ {SNumericParameterization >> #newInstancesM:}
]

{ #category : #'bl-core' }
SExporte2VW >> blackListSObject [
	^ {"SObject >> #classOf:."
"SObject >> #findClass:."
SObject >> #fullNameOfClass:.
SObject >> #fullSymbolOf:".
SObject >> #initialize"}
]

{ #category : #'bl-builder' }
SExporte2VW >> blackListSPlatformPharo [
	^ {SPlatformPharo class >> #classLogger.
	SPlatformPharo class >> #implementationType .
	SPlatformPharo class >> #rbParserClass .
	SPlatformPharo class >> #testCaseClass }
]

{ #category : #'bl-builder' }
SExporte2VW >> blackListSPlatformVisualWorks [
	^ {"SPlatformVisualWorks class >> #classConfigurationName."
"SPlatformVisualWorks class >> #createTestCaseClass:inPackage:."
"SPlatformVisualWorks class >> #implementationType."
"SPlatformVisualWorks class >> #rbParserClass."
"SPlatformVisualWorks class >> #testCaseClass"}
]

{ #category : #'bl-utility' }
SExporte2VW >> blackListSReport [
	^ {SReport class >> #exportData:onCSV:usingFilter:}
]

{ #category : #'bl-utility' }
SExporte2VW >> blackListSReportSGALog [
	^ {SReportSGALog class >> #exportResumeOf:onCSV: .
	SReportSGALog >> #generateReportForDifferencesBtwGenerations}
]

{ #category : #'bl-utility' }
SExporte2VW >> blackListSReportTypeInfo [
	^ {SReportTypeInfo class >> #writeReport:ofCaseStudy: .
	SReportTypeInfo class >> #writeReport:ofFrequency:}
]

{ #category : #'bl-initialization' }
SExporte2VW >> blackListSSelectionParameterization [
	^ {SSelectionParameterization class >> #setting:}
]

{ #category : #'bl-scenario' }
SExporte2VW >> blackListSStack [
	^ {"SStack >> #+."
"SStack >> #addFirst:."
"SStack >> #addLast:."
"SStack >> #hasEqualElements:."
"SStack >> #removeFirst."
"SStack >> #removeLast"}
]

{ #category : #'bl-core' }
SExporte2VW >> blackListSTestCase [
	^ {"SSTestCase >> #setUp .
SSTestCase >> #tearDown"}
]

{ #category : #'bl-builder' }
SExporte2VW >> blackListSTestCaseFactory [
	^ {"STestCaseFactory >> #createConfigurationMethods ."
"STestCaseFactory >> #exportFitnessLog ."
"STestCaseFactory >> #moveClass: ."
"STestCaseFactory class >> #from:"
STestCaseFactory >> #tearDown .
STestCaseFactory >> #export:with: .
STestCaseFactory >> #exportTests .
STestCaseFactory >> #fitnessResultAsDictionary .
STestCaseFactory >> #generationEvolutionCanvas .
STestCaseFactory >> #gtInspectorCanvasIn: .
STestCaseFactory >> #gtInspectorViewIn: .
STestCaseFactory >> #visualizeEvolutionFitness .
STestCaseFactory >> #generatedClass .
STestCaseFactory class >> #darkColors .
STestCaseFactory class >> #lightColors .
STestCaseFactory >> #classesForRegex: }
]

{ #category : #'bl-examples' }
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

{ #category : #'bl-builder' }
SExporte2VW >> blackListSTestCaseFactoryVisualWorks [
	^ {"STestCaseFactoryVisualWorks >> #cleanInstrumentation."
"STestCaseFactoryVisualWorks >> #initializeProfiler."
"STestCaseFactoryVisualWorks >> #uninstall"}
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSTestCaseTest [
	^ {SSTestCaseTest >> #typeInfo}
]

{ #category : #'bl-core' }
SExporte2VW >> blackListSTestShifter [
	^ {SSTestShifter>> #canAddStatement.
	"SSTestShifter>>#analyze."
	"SSTestShifter>>#runWithoutAssertions."
	"SSTestShifter>>#run."
	"SSTestShifter>>#setUp.
	SSTestShifter>>#tearDown"}
]

{ #category : #'bl-info' }
SExporte2VW >> blackListSTypeClassInfo [
	^ {STypeClassInfo >> #differenceWith:usingSelector:}
]

{ #category : #'bl-info' }
SExporte2VW >> blackListSTypeInfo [
	^ {"STypeInfo >> #asTypeInfo:methodsBlacklist:."
STypeInfo >> #completeTypeInfo.
STypeInfo >> #updateArgsOf: .
STypeInfo >> #deleteBlackListMethods.
STypeInfo >> #blackList .
STypeInfo >> #blackList: }
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSTypeInfoTest [
	^ {"STypeInfoTest >> #testAsTypeInfoScalars.
STypeInfoTest >> #testAsTypeInfoSConferenceOnPackagesMatching.
STypeInfoTest >> #testAsTypeInfoSEventOnPackagesMatching.
STypeInfoTest >> #testAsTypeInfoSFoo.
STypeInfoTest >> #testAsTypeInfoSFooOnClass.
STypeInfoTest >> #testAsTypeInfoSFooWithNil.
STypeInfoTest >> #testAsTypeInfoSTeacherOnClass.
STypeInfoTest >> #testAsTypeInfoSTeacherOnPackagesMatching.
STypeInfoTest >> #testFactoryMessages.
"STypeInfoTest >> #testFromString.
STypeInfoTest >> #testToStringComplexScalar.
STypeInfoTest >> #testToString}
]

{ #category : #'bl-utility' }
SExporte2VW >> blackListSUtilityTypeInfo [
	^ {SUtilityTypeInfo >> #typeInfoSFoo1.
SUtilityTypeInfo >> #typeInfoSFoo3.
SUtilityTypeInfo >> #typeInfoSFooOnPackage2.
SUtilityTypeInfo >> #typeInfoSFoo100 }
]

{ #category : #'bl-smallTypeColl' }
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

{ #category : #actions }
SExporte2VW >> export [ 
	Pharo2VW exporter
	directory: FileSystem disk workingDirectory;
	namespace: 'SmallSuiteGenerator';
	externalNamespaces: {'SmallSuiteGenerator'};
	methodsBlacklist: self blackList;
	packages: self packages;
	export.
]

{ #category : #accessing }
SExporte2VW >> packages [ 
	^ #('SmallSuiteGenerator' 'SmallSuiteGenerator-Scenario' 'SmallSuiteGenerator-Scenario2' 'SmallSuiteGenerator-Tests')
]
