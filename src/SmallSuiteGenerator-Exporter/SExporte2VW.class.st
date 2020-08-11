"
SExporte2VW
-----------
I am the class to export SmallSuiteGenerator from Pharo to VisualWorks
"
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
	^ {SGAEngine >> #updateTypeInfoWith:. "<------ review if is important use Pharo version"}
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

{ #category : #'bl-ga' }
SExporte2VW >> blackListSGAViz [
	^ {
SGAViz >> #addDescriptiveTextOn:ofColor:and: .
SGAViz >> #addHighlightMethodEvent:on:ofColor:.
SGAViz >> #addHighlightTestCaseEvent:on:ofColor:.
SGAViz >> #addLegend:on:withFontColor:and:.
SGAViz >> #addLegendOn:with:.
SGAViz >> #addSurvivorTestCase:on:using:and:.
SGAViz >> #addTickX:withScale:color:y:and: .
SGAViz >> #addTickY:withScale:xMax:ofColor:andPositions: .
SGAViz >> #borderOfSize:andColor: .
SGAViz >> #contributionShapeOfHeight:color:and:.
SGAViz >> #createRSLabelWith:and:.
SGAViz >> #createTopCenterRSLocationOn:with:.
SGAViz >> #createTopCenterRSLocationWith:.
SGAViz >> #createTopLeftRSLocation.
SGAViz >> #createTopRightRSLocationWith:.
SGAViz >> #evolutionPoints:withScale: .
SGAViz >> #evolutionShapeWith:ofColor:size: .
SGAViz >> #fitnessOf: .
SGAViz >> #fitnessResultAsDictionary.
SGAViz >> #generationDictionaryWith:.
SGAViz >> #generationEvolutionCanvas.
SGAViz >> #generationVisualization:ofColor: .
SGAViz >> #infoMethodShapesOn:ofColor:highlight: .
SGAViz >> #isCoverage:ofSummaryMethod:in:newOrHigher: .
SGAViz >> #methodColorDictionary: .
SGAViz >> #methodShape:withGradientFrom:to: .
SGAViz >> #methodShapeGroup:with:highlight:scale: .
SGAViz >> #progressBarFrom:to:ofColor:.
SGAViz >> #rsBorderWithColorBox:.
SGAViz >> #rshighlightableWith:.
SGAViz >> #rsLabelWith:.
SGAViz >> #scaleColorBlock:.
SGAViz >> #setPositions:using: .
SGAViz >> #sparkCircleGroupOfColor:andSize:.
SGAViz >> #stringTargetClassInPackage.
SGAViz >> #summaryMethodsOfTargetClass:.
SGAViz >> #testCaseShape:ofColor:with:highlight:scale:.
SGAViz >> #generationDictionaryWith: .
SGAViz >> #visualizeEvolutionFitness.
SGAViz class >> #darkColors .
SGAViz class >> #lightColors .}
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSInsertTest [
	^ {SInsertTest >> #testCopyWithANewMethodCallToAnArgumentOfTheTargetClass.
	SInsertTest >> #testCopyWithANewMethodCallToAnyValue}
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
	^ {
SObject >> #fullNameOfClass:.
SObject >> #fullSymbolOf:}
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

{ #category : #'bl-strategies' }
SExporte2VW >> blackListSSAbstractSettingMethods [
	^ { SSAbstractSettingMethods >> #exportMethod:  }
]

{ #category : #'bl-strategies' }
SExporte2VW >> blackListSSMetaInterpreter [
	^ { SSMetaInterpreter >> #visitMessageNode:  }
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
	^ {STestCaseFactory >> #tearDown .
STestCaseFactory >> #exportTests .
STestCaseFactory >> #gtInspectorCanvasIn: .
STestCaseFactory >> #gtInspectorViewIn: .
STestCaseFactory >> #generatedClass .
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
	^ {SSTestShifter>> #canAddStatement.}
]

{ #category : #'bl-info' }
SExporte2VW >> blackListSTypeClassInfo [
	^ {STypeClassInfo >> #differenceWith:usingSelector:}
]

{ #category : #'bl-info' }
SExporte2VW >> blackListSTypeInfo [
	^ {STypeInfo >> #completeTypeInfo.
STypeInfo >> #updateArgsOf: .
STypeInfo >> #deleteBlackListMethods.
STypeInfo >> #blackList .
STypeInfo >> #blackList: }
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSTypeInfoTest [
	^ {STypeInfoTest >> #testFromString.
STypeInfoTest >> #testToStringComplexScalar.
STypeInfoTest >> #testToString.
STypeInfoTest >> #testAsTypeInfoSFoo}
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
	^ {SmallTypeCollector >> #collectTypeFrom:.
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
