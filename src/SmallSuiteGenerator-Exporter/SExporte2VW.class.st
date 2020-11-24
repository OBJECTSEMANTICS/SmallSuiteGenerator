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
	"List of methods that cannot be called directly in VW"

	| result |
	result := OrderedCollection new.
	self class selectors do: [ :sel | 
		(('blackList*' match: sel asString ) and: [ (sel = #blackList) not ])
			 ifTrue: [ result addAll: (self perform: sel) ]  ].
	^ result 
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSChangeTest [
	"Black list of SChangeTest class"	

	^ { SChangeTest >> #testSelectorChange }
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSClassInfoTest [
	"Black list of SClassInfoTest class"

	^ { SClassInfoTest >> #testToString .
			SClassInfoTest >> #testFromString }
]

{ #category : #'bl-scenario' }
SExporte2VW >> blackListSConfigGenerationTestCase [
	"Black list of SConfigGenerationTestCase class"
	
	^ { SConfigGenerationTestCase class >> #fitnessDictionary }
]

{ #category : #'bl-core' }
SExporte2VW >> blackListSError [
	"Black list of SError class"

	^ { SError >> #signal: }
]

{ #category : #'bl-core' }
SExporte2VW >> blackListSFitnessFunction [
	"Black list of SFitnessFunction class"

	^ { SFitnessFunction >> #aClass }
]

{ #category : #'bl-examples' }
SExporte2VW >> blackListSGAEngineExample [
	"Black list of SGAEngineExample class"

	^ { SGAEngineExample >> #runOnClass:withBlock:andFitness: .
			SGAEngineExample >> #runOnPackagesMatching:withBlock:andFitness: }
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSGAEngineTest [
	"Black list of SGAEngineTest class"

	^ { SGAEngineTest >> #profilerOf:.
			SGAEngineTest >> #tearDown }
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSInsertTest [
	"Black list of SInsertTest class"

	^ { SInsertTest >> #testCopyWithANewMethodCallToAnArgumentOfTheTargetClass.
		SInsertTest >> #testCopyWithANewMethodCallToAnyValue }
]

{ #category : #'bl-core' }
SExporte2VW >> blackListSInspectorAssertion [
	"Black list of SInspectorAssertion class"

	^ { SInspectorAssertion class >> #inspectorAssertionOf: }
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSMethodInfoTest [
	"Black list of SMethodInfoTest class"

	^ { SMethodInfoTest >> #testToString.
			SMethodInfoTest >> #testFromSton }
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSMultiTypeInfoTest [
	"Black list of SMultiTypeInfoTest class"
	
	^ { SMultiTypeInfoTest >> #testToString.
	SMultiTypeInfoTest >> #testFromSton }
]

{ #category : #'bl-initialization' }
SExporte2VW >> blackListSNumericParameterization [
	"Black list of SNumericParameterization class"

	^ { SNumericParameterization >> #newInstancesM: }
]

{ #category : #'bl-builder' }
SExporte2VW >> blackListSPlatformPharo [
	"Black list of SPlatformPharo class"
	
	^ { SPlatformPharo class >> #classLogger.
			SPlatformPharo class >> #implementationType .
			SPlatformPharo class >> #rbParserClass .
			SPlatformPharo class >> #testCaseClass }
]

{ #category : #'bl-utility' }
SExporte2VW >> blackListSReport [
	"Black list of SReport class"

	^ { SReport class >> #exportData:onCSV:usingFilter: }
]

{ #category : #'bl-utility' }
SExporte2VW >> blackListSReportSGALog [
	"Black list of SReportSGALog class"
	
	^ { SReportSGALog class >> #exportResumeOf:onCSV: .
			SReportSGALog >> #generateReportForDifferencesBtwGenerations }
]

{ #category : #'bl-utility' }
SExporte2VW >> blackListSReportTypeInfo [
	"Black list of SReportTypeInfo class"
	
	^ { SReportTypeInfo class >> #writeReport:ofCaseStudy: .
			SReportTypeInfo class >> #writeReport:ofFrequency: }
]

{ #category : #'bl-strategies' }
SExporte2VW >> blackListSSAbstractSettingMethods [
	"Black list of SSAbstractSettingMethods class"

	^ { SSAbstractSettingMethods >> #exportMethod: }
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSSGParser [
	"Black list of SSGParser class"
	
	^ { SSGParser  >> #visitAssignmentNode:.
			SSGParser  >> #visitCascadeNode:.
			SSGParser  >> #visitLiteralNode:.
			SSGParser  >> #visitMessageNode:.
			SSGParser  >> #visitSequenceNode:.
			SSGParser  >> #visitVariableNode: }
]

{ #category : #'bl-initialization' }
SExporte2VW >> blackListSSelectionParameterization [
	"Black list of SSelectionParameterization class"

	^ { SSelectionParameterization class >> #setting: }
]

{ #category : #'bl-builder' }
SExporte2VW >> blackListSTestCaseFactory [
	"Black list of STestCaseFactory class"

	^ { STestCaseFactory >> #generatedClass .
			STestCaseFactory >> #openOnGeneratedClass .
			STestCaseFactory >> #tearDown }
]

{ #category : #'bl-examples' }
SExporte2VW >> blackListSTestCaseFactoryExample [
	"Black list of STestCaseFactoryExample class"
		
	^ { STestCaseFactoryExample >> #clean .
			STestCaseFactoryExample >> #exampleEmptyBlockOnPackages .
			STestCaseFactoryExample >> #exampleSSTeacherOnClass .
			STestCaseFactoryExample >> #exampleSSTeacherOnPackages .
			STestCaseFactoryExample >> #exampleSStackOnClass .
			STestCaseFactoryExample >> #exampleSStackOnPackages .
			STestCaseFactoryExample >> #exampleSStudentOnClass .
			STestCaseFactoryExample >> #exampleWithSubclassToRun .
			STestCaseFactoryExample >> #exampleWithWrongClassToRun .
			STestCaseFactoryExample >> #exampleWithWrongRegexToRun }
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSTestCaseTest [
	"Black list of STestCaseTest class"

	^ { SSTestCaseTest >> #typeInfo }
]

{ #category : #'bl-core' }
SExporte2VW >> blackListSTestShifter [
	"Black list of STestShifter class"

	^ { SSTestShifter>> #canAddStatement }
]

{ #category : #'bl-info' }
SExporte2VW >> blackListSTypeClassInfo [
	"Black list of STypeClassInfo class"

	^ { STypeClassInfo >> #differenceWith:usingSelector: .
			STypeClassInfo >> #isAbstract }
]

{ #category : #'bl-info' }
SExporte2VW >> blackListSTypeInfo [
	"Black list of STypeInfo class"

	^ { STypeInfo >> #completeTypeInfo.
			STypeInfo >> #deleteBlackListMethods.
			STypeInfo >> #blackList .
			STypeInfo >> #blackList: .
			STypeInfo >> #allParentClassesInfoFrom: }
]

{ #category : #'bl-tests' }
SExporte2VW >> blackListSTypeInfoTest [
	"Black list of STypeInfoTest class"

	^ { STypeInfoTest >> #testFromString .
			STypeInfoTest >> #testToStringComplexScalar .
			STypeInfoTest >> #testToString .
			STypeInfoTest >> #testAsTypeInfoSFoo }
]

{ #category : #'bl-utility' }
SExporte2VW >> blackListSUtilityTypeInfo [
	"Black list of SUtilityTypeInfo class"
	
	^ { SUtilityTypeInfo >> #typeInfoSFoo1 .
			SUtilityTypeInfo >> #typeInfoSFoo3 .
			SUtilityTypeInfo >> #typeInfoSFooOnPackage2 .
			SUtilityTypeInfo >> #typeInfoSFoo100 }
]

{ #category : #'bl-smallTypeColl' }
SExporte2VW >> blackListSmallTypeCollector [
	"Black list of SmallTypeCollector class"

	^ { SmallTypeCollector >> #collectTypeFrom: .
			SmallTypeCollector >> #methodInfoIn:from: .
			SmallTypeCollector >> #typeFor: }
]

{ #category : #actions }
SExporte2VW >> export [
	"Export SmallSuiteGenerator package to st file for VW"
	
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
	"Packages to export"

	^ #('SmallSuiteGenerator' 'SmallSuiteGenerator-Scenario' 'SmallSuiteGenerator-Scenario2' 'SmallSuiteGenerator-Tests')
]
