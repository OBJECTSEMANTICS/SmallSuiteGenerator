Class {
	#name : #SReportGenerator,
	#superclass : #SReport,
	#instVars : [
		'targetClass',
		'executionBlock',
		'typeInfo',
		'regex',
		'fitness',
		'resultCollector',
		'collectorTypeString'
	],
	#category : #'SmallSuiteGenerator-Utility'
}

{ #category : #generation }
SReportGenerator class >> generateBranchAndStatementTestCasesOf: aClass withRegex: aString block: aBlock [

	self generateTestCasesAndReportsOf: aClass withRegex: aString block: aBlock fitness: #statement.
	self generateTestCasesAndReportsOf: aClass withRegex: aString block: aBlock fitness: #branch.
]

{ #category : #generation }
SReportGenerator class >> generateSeedReportOfClass: aClass withRegex: aString andBlock: aBlock [

	self new
		regex: aString;
		targetClass: aClass;
		executionBlock: aBlock;
		generateSeedReports.
]

{ #category : #generation }
SReportGenerator class >> generateTestCasesAndReportsOf: aClass withRegex: aString block: aBlock [

	self generateTypeInfoReportOfClass: aClass withRegex: aString andBlock: aBlock.
	self generateSeedReportOfClass: aClass withRegex: aString andBlock: aBlock.
	self new
		targetClass: aClass;
		regex: aString;
		executionBlock: aBlock;
		generateTestCasesWithoutSeed;
		generateTestCasesWithSeed;
		generateTestCasesWithSeedAndCompletingInfo
]

{ #category : #generation }
SReportGenerator class >> generateTestCasesAndReportsOf: aClass withRegex: aString block: aBlock fitness: aSymbol [

	self generateTypeInfoReportOfClass: aClass withRegex: aString andBlock: aBlock.
	self generateSeedReportOfClass: aClass withRegex: aString andBlock: aBlock. 
	self new
		targetClass: aClass;
		regex: aString;
		executionBlock: aBlock;
		fitness: aSymbol;
		generateTestCasesWithoutSeed;
		generateTestCasesWithSeed;
		generateTestCasesWithSeedAndCompletingInfo.
]

{ #category : #generation }
SReportGenerator class >> generateTestCasesWithSeedOf: aClass withRegex: aString block: aBlock [

	self new
		targetClass: aClass;
		regex: aString;
		executionBlock: aBlock;
		generateTestCasesWithSeed;
		generateTestCasesWithSeedAndCompletingInfo
]

{ #category : #generation }
SReportGenerator class >> generateTestCasesWithSeedOf: aClass withRegex: aString block: aBlock fitness: aSymbol [

	self new
		targetClass: aClass;
		regex: aString;
		executionBlock: aBlock;
		fitness: aSymbol;
		generateTestCasesWithSeed;
		generateTestCasesWithSeedAndCompletingInfo
]

{ #category : #generation }
SReportGenerator class >> generateTestCasesWithoutSeedOf: aClass withRegex: aString block: aBlock [

	self new
		targetClass: aClass;
		regex: aString;
		executionBlock: aBlock;
		generateTestCasesWithoutSeed
]

{ #category : #generation }
SReportGenerator class >> generateTestCasesWithoutSeedOf: aClass withRegex: aString block: aBlock fitness: aSymbol [

	self new
		targetClass: aClass;
		regex: aString;
		executionBlock: aBlock;
		fitness: aSymbol;
		generateTestCasesWithoutSeed
]

{ #category : #generation }
SReportGenerator class >> generateTypeInfoReportOfClass: aClass withRegex: aString andBlock: aBlock [

	self generateTypeInfoReportWithSeedOfClass: aClass withRegex: aString andBlock: aBlock.
	self generateTypeInfoReportWithoutSeedOfClass: aClass withRegex: aString
]

{ #category : #generation }
SReportGenerator class >> generateTypeInfoReportWithSeedOfClass: aClass withRegex: aString andBlock: aBlock [

	self new
		regex: aString;
		targetClass: aClass;
		executionBlock: aBlock;
		generateReportOfTypeInformationWithSeed;
		generateReportOfTypeInformationWithSeedAndCompleteInfo.
]

{ #category : #generation }
SReportGenerator class >> generateTypeInfoReportWithoutSeedOfClass: aClass withRegex: aString [

	self new
		regex: aString;
		targetClass: aClass;
		generateReportOfTypeInformationWithoutSeed.
]

{ #category : #accessing }
SReportGenerator >> calculateAndInspectClassInformationOf: anArray [

  ^ (anArray collect: [:e |  e first at: 'block-coverage' ])
]

{ #category : #accessing }
SReportGenerator >> collectorTypes [

	^ #(TypeCollectorWithRoelfTyper TypeCollectorWithLightWeight SmallTypeCollector)
]

{ #category : #accessing }
SReportGenerator >> configuration [
	
	"stopIterations numberOfGenerations numberOfStatements populationSize selectionStrategy"
	
	^ Array with: #(30) with: #(50) with: #(30) with: #(20) with: {SGARandomSelection . 
        "SGARankSelection . 
        SGARouletteSelection . 
        SGATournamentSelection . 
        SGATruncatedSelection"}.
]

{ #category : #accessing }
SReportGenerator >> defaultBlock [

	^ [  ]
]

{ #category : #accessing }
SReportGenerator >> executionBlock [

	^ executionBlock
]

{ #category : #accessing }
SReportGenerator >> executionBlock: aBlock [

	executionBlock := aBlock
]

{ #category : #accessing }
SReportGenerator >> fitness: anObject [
	fitness := anObject
]

{ #category : #accessing }
SReportGenerator >> fitnessCoverageClasses [
  ^#(#SStatementCoverage #SBranchCoverage)
]

{ #category : #generationOfReportWithoutSeed }
SReportGenerator >> generateBlockCoverageReportOf: aTargetClass inPackage: aPackageName andCollector: aTypeCollector [

	| aBlock typeInformation profiler fitnessResult |

	aBlock := [ | exec |
		exec := ClyRunTestsFromClassesCommand new.
			(RPackage organizer packageNamed: aPackageName) classes do: [ :cls |
    			exec runTestCase: cls ] ].

	typeInformation := (STypeInfo new smallCollector: (aTypeCollector asClass)) 
		asTypeInfo: (SSTypeCollector profile: aBlock onPackagesMatching: regex).

	profiler := SLProfilerCoverage profilerForPackagesMatching: regex.
	fitnessResult := self obtainCoverageOption.
	fitnessResult profiler: profiler;
    	typeInfo: typeInformation;
    	targetClass: aTargetClass.
	profiler uninstall.
	profiler beforeProfiling.
	profiler cleanBlocksOfMethods.
	aBlock value.
	profiler uninstall.
	self generateReportOfBlock: (SReportBlockCoverage profiler: profiler targetClass: aTargetClass) ofCollector: aTypeCollector.
]

{ #category : #generationOfReportWithSeedAndInfo }
SReportGenerator >> generateBlockCoverageReportWithSeedAndInfoOf: aTargetClass inPackage: aPackageName [

	| aBlock typeInformation profiler fitnessResult |

	aBlock := [ | exec |
		exec := ClyRunTestsFromClassesCommand new.
			(RPackage organizer packageNamed: aPackageName) classes do: [ :cls |
    			exec runTestCase: cls ] ].

	typeInformation := STypeInfo 
		asTypeInfo: (SSTypeCollector profile: aBlock onPackagesMatching: regex).

	profiler := SLProfilerCoverage profilerForPackagesMatching: regex.
	fitnessResult := self obtainCoverageOption.
	fitnessResult profiler: profiler;
    	typeInfo: typeInformation;
    	targetClass: aTargetClass.
	profiler uninstall.
	profiler beforeProfiling.
	profiler cleanBlocksOfMethods.
	aBlock value.
	profiler uninstall.
	self generateReportOfBlockWithSeedAndInfo: (SReportBlockCoverage profiler: profiler targetClass: aTargetClass).
]

{ #category : #generationOfReportWithSeed }
SReportGenerator >> generateBlockCoverageReportWithSeedOf: aTargetClass inPackage: aPackageName [
  | aBlock typeInformation profiler fitnessResult |
  aBlock := [ | exec |
  exec := ClyRunTestsFromClassesCommand new.
  (RPackage organizer packageNamed: aPackageName) classes do: [:cls |  exec runTestCase: cls ] ].
  typeInformation := STypeInfo asTypeInfo: (SSTypeCollector profile: aBlock onPackagesMatching: regex).
  profiler := SLProfilerCoverage profilerForPackagesMatching: regex.
  fitnessResult := self obtainCoverageOption.
  fitnessResult
     profiler: profiler;
     typeInfo: typeInformation;
     targetClass: aTargetClass.
  profiler uninstall.
  profiler beforeProfiling.
  profiler cleanBlocksOfMethods.
  aBlock value.
  profiler uninstall.
  self generateReportOfBlockWithOnlySeed: (SReportBlockCoverage profiler: profiler targetClass: aTargetClass)
]

{ #category : #generationOfSeedReport }
SReportGenerator >> generateCSVOfSeedReportWithValues: aCollection [

	(self fileReference: targetClass asString , '_seed_coverage_result')
		writeStreamDo: [ :stream | 
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: #('Statement' 'Branch').
			neoCSVWriter nextPut: aCollection.
			neoCSVWriter flush ]
]

{ #category : #accessing }
SReportGenerator >> generateCombinationsForConfig [
  | combinations configList |

  configList := self configuration.
  combinations := (((configList first combinationsWith: configList second) combinationsWith: configList third) combinationsWith: configList fourth) combinationsWith: configList fifth.
	^ combinations
]

{ #category : #packageName }
SReportGenerator >> generatePackageNameForSeedAndInfo [
  ^'Generated_' , fitness asString , '_' , targetClass asString , '_seedPlusInfo'
]

{ #category : #packageName }
SReportGenerator >> generatePackageNameWithCollector: collectorType [
  ^ 'Generated_' , fitness asString , '_' , targetClass asString , '_' , collectorType asClass asString
]

{ #category : #generationOfReportWithoutSeed }
SReportGenerator >> generateReportOf: aTargetClass inPackage: aPackageName andCollector: aTypeCollector [

	| aBlock typeInformation |

	aBlock := [ | exec |
		exec := ClyRunTestsFromClassesCommand new.
			(RPackage organizer packageNamed: aPackageName) classes do: [ :cls |
    			exec runTestCase: cls ] ].

	typeInformation := (STypeInfo new smallCollector: (aTypeCollector asClass)) 
		asTypeInfo: (SSTypeCollector profile: aBlock onPackagesMatching: regex).
	 self generateBlockCoverageReportOf: aTargetClass inPackage: aPackageName andCollector: aTypeCollector.
	self generateReportOfTypeInfoInTestCasesOf: typeInformation andCollector: aTypeCollector.
	self generateReportOfResults.
]

{ #category : #generationOfReportWithoutSeed }
SReportGenerator >> generateReportOfBlock: aBlockCoverage ofCollector: aTypeCollector [
		
	| classInfo instanceMethods classMethods |
	(self fileReference: targetClass asString , '_' , fitness asString , '_report_coverage_', aTypeCollector asString)
		writeStreamDo: [ :stream | 
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: #('Method' 'IsClassSide' 'Code' 'NumberOfStatements' 'Branches' 'BranchStatements' 'Executed' 'ExecutedBranches').
			classInfo := aBlockCoverage profiler classAt: targetClass.
			instanceMethods := targetClass asClass 
				methods sort: [ :method1 :method2 | method1 name < method2 name ].
			instanceMethods do: [ :cm | | m |
				[ m := classInfo localMethodAt: cm selector.
				neoCSVWriter nextPut: (OrderedCollection new add: m selector; add: 'false'; add: m compiledMethod sourceCode; add: (m blocks inject: 0 into: [ :s :e | s + e numberOfStatements ]); add: m blocks size; add: (m blocks collect: [:b | b numberOfStatements]) asArray; add: m blocks first wasExecuted; add: (m blocks collect: [:b | b wasExecuted]) asArray; yourself ) ] 
				on: Error
				do: [ ]
			 ].
		
			classMethods := targetClass asClass class
				methods sort: [ :method1 :method2 | method1 name < method2 name ].
			classMethods do: [ :cm | | m |
				[ m := classInfo metaclassSpy localMethodAt: cm selector.
				neoCSVWriter nextPut: (OrderedCollection new add: m selector; add: 'true'; add: m compiledMethod sourceCode; add: (m blocks inject: 0 into: [ :s :e | s + e numberOfStatements ]); add: m blocks size; add: (m blocks collect: [:b | b numberOfStatements]) asArray; add: m blocks first wasExecuted; add: (m blocks collect: [:b | b wasExecuted]) asArray; yourself ) ] 
				on: Error
				do: [ ]
			 ].
			neoCSVWriter flush ]
]

{ #category : #generationOfReportWithSeed }
SReportGenerator >> generateReportOfBlockWithOnlySeed: aBlockCoverage [
		
	| classInfo instanceMethods classMethods |
	(self fileReference: targetClass asString , '_' , fitness asString , '_report_coverage_with_only_seed')
		writeStreamDo: [ :stream | 
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: #('Method' 'IsClassSide' 'Code' 'NumberOfStatements' 'Branches' 'BranchStatements' 'Executed' 'ExecutedBranches').
			classInfo := aBlockCoverage profiler classAt: targetClass.
			instanceMethods := targetClass asClass 
				methods sort: [ :method1 :method2 | method1 name < method2 name ].
			instanceMethods do: [ :cm | | m |
				[ m := classInfo localMethodAt: cm selector.
				neoCSVWriter nextPut: (OrderedCollection new add: m selector; add: 'false'; add: m compiledMethod sourceCode; add: (m blocks inject: 0 into: [ :s :e | s + e numberOfStatements ]); add: m blocks size; add: (m blocks collect: [:b | b numberOfStatements]) asArray; add: m blocks first wasExecuted; add: (m blocks collect: [:b | b wasExecuted]) asArray; yourself ) ] 
				on: Error
				do: [ ]
			 ].
		
			classMethods := targetClass asClass class
				methods sort: [ :method1 :method2 | method1 name < method2 name ].
			classMethods do: [ :cm | | m |
				[ m := classInfo metaclassSpy localMethodAt: cm selector.
				neoCSVWriter nextPut: (OrderedCollection new add: m selector; add: 'true'; add: m compiledMethod sourceCode; add: (m blocks inject: 0 into: [ :s :e | s + e numberOfStatements ]); add: m blocks size; add: (m blocks collect: [:b | b numberOfStatements]) asArray; add: m blocks first wasExecuted; add: (m blocks collect: [:b | b wasExecuted]) asArray; yourself ) ] 
				on: Error
				do: [ ]
			 ].
			neoCSVWriter flush ]
]

{ #category : #generationOfReportWithSeedAndInfo }
SReportGenerator >> generateReportOfBlockWithSeedAndInfo: aBlockCoverage [
		
	| classInfo instanceMethods classMethods |
	(self fileReference: targetClass asString , '_' , fitness asString , '_report_coverage_with_seed_and_completing_info')
		writeStreamDo: [ :stream | 
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: #('Method' 'IsClassSide' 'Code' 'NumberOfStatements' 'Branches' 'BranchStatements' 'Executed' 'ExecutedBranches').
			classInfo := aBlockCoverage profiler classAt: targetClass.
			instanceMethods := targetClass asClass 
				methods sort: [ :method1 :method2 | method1 name < method2 name ].
			instanceMethods do: [ :cm | | m |
				[ m := classInfo localMethodAt: cm selector.
				neoCSVWriter nextPut: (OrderedCollection new add: m selector; add: 'false'; add: m compiledMethod sourceCode; add: (m blocks inject: 0 into: [ :s :e | s + e numberOfStatements ]); add: m blocks size; add: (m blocks collect: [:b | b numberOfStatements]) asArray; add: m blocks first wasExecuted; add: (m blocks collect: [:b | b wasExecuted]) asArray; yourself ) ] 
				on: Error
				do: [ ]
			 ].
		
			classMethods := targetClass asClass class
				methods sort: [ :method1 :method2 | method1 name < method2 name ].
			classMethods do: [ :cm | | m |
				[ m := classInfo metaclassSpy localMethodAt: cm selector.
				neoCSVWriter nextPut: (OrderedCollection new add: m selector; add: 'true'; add: m compiledMethod sourceCode; add: (m blocks inject: 0 into: [ :s :e | s + e numberOfStatements ]); add: m blocks size; add: (m blocks collect: [:b | b numberOfStatements]) asArray; add: m blocks first wasExecuted; add: (m blocks collect: [:b | b wasExecuted]) asArray; yourself ) ] 
				on: Error
				do: [ ]
			 ].
			neoCSVWriter flush ]
]

{ #category : #generationOfResume }
SReportGenerator >> generateReportOfResults [

	| type |
	(self fileReference: targetClass asString , '_', fitness asString, '_resume_results')
		writeStreamDo: [ :stream | 
			| neoCSVWriter average median best |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: #('type' 'median' 'avg' 'best').
			resultCollector do: [ :row |
				type := row at: 1.
				average := (row at: 2)  average.
				median := (row at: 2)  median.
				best := (row at: 2)  max.
				neoCSVWriter nextPut: (OrderedCollection new 
					add: type;
					add: median; 
					add: average; 
					add: best;
					yourself) ].
			neoCSVWriter flush ].
]

{ #category : #generationOfReportWithoutSeed }
SReportGenerator >> generateReportOfTypeInfoInTestCasesOf: aTypeInformation andCollector: aTypeCollector [
	| classInfo instanceMethods classMethods |
	(self fileReference: targetClass asString , '_' , fitness asString , '_typeInfo_testCases_', aTypeCollector asString)
		writeStreamDo: [ :stream |
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: #('method' 'classSide' 'args' 'list of detected types' 'return types').
			classInfo := aTypeInformation classAt: targetClass.
			instanceMethods := targetClass asClass 
				methods sort: [ :method1 :method2 | method1 name < method2 name ].
			instanceMethods do: [ :cm | | m types |
				[ m := classInfo methodOf: cm selector.
				 types := (m argTypes collect: [ :a | a types asString ]) asArray.
				neoCSVWriter nextPut: (Array with: m selector with: 'false' with: m argTypes size with: types asString with: m returnType types asString ) ] 
				on: Error
				do: [ neoCSVWriter nextPut: (Array with: cm selector with: 'false' with: '' with: 'no detected' with: 'no detected')  ]
			 ].
			classMethods := targetClass asClass class
				methods sort: [ :method1 :method2 | method1 name < method2 name ].
			classMethods do: [ :cm | | m types |
				[ m := classInfo classMethodOf: cm selector.
				 types := (m argTypes collect: [ :a | a types asString ]) asArray.
				neoCSVWriter nextPut: (Array with: m selector with: 'true' with: m argTypes size with: types asString with: m returnType types asString) ] 
				on: Error
				do: [ neoCSVWriter nextPut: (Array with: cm selector with: 'true' with: '' with: 'no detected' with: 'no detected')  ]
			 ].
			neoCSVWriter flush ]
]

{ #category : #generationOfReportWithSeedAndInfo }
SReportGenerator >> generateReportOfTypeInfoInTestCasesWithSeedAndInfoOf: aTypeInformation [
	| classInfo instanceMethods classMethods |
	(self fileReference: targetClass asString , '_' , fitness asString , '_typeInfo_result_with_seed_and_completing_info')
		writeStreamDo: [ :stream |
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: #('method' 'classSide' 'args' 'list of detected types' 'return types').
			classInfo := aTypeInformation classAt: targetClass.
			instanceMethods := targetClass asClass 
				methods sort: [ :method1 :method2 | method1 name < method2 name ].
			instanceMethods do: [ :cm | | m types |
				[ m := classInfo methodOf: cm selector.
				 types := (m argTypes collect: [ :a | a types asString ]) asArray.
				neoCSVWriter nextPut: (Array with: m selector with: 'false' with: m argTypes size with: types asString with: m returnType types asString ) ] 
				on: Error
				do: [ neoCSVWriter nextPut: (Array with: cm selector with: 'false' with: '' with: 'no detected' with: 'no detected')  ]
			 ].
			classMethods := targetClass asClass class
				methods sort: [ :method1 :method2 | method1 name < method2 name ].
			classMethods do: [ :cm | | m types |
				[ m := classInfo classMethodOf: cm selector.
				 types := (m argTypes collect: [ :a | a types asString ]) asArray.
				neoCSVWriter nextPut: (Array with: m selector with: 'true' with: m argTypes size with: types asString with: m returnType types asString) ] 
				on: Error
				do: [ neoCSVWriter nextPut: (Array with: cm selector with: 'true' with: '' with: 'no detected' with: 'no detected')  ]
			 ].
			neoCSVWriter flush ]
]

{ #category : #generationOfReportWithSeed }
SReportGenerator >> generateReportOfTypeInfoInTestCasesWithSeedOf: aTypeInformation [
	| classInfo instanceMethods classMethods |
	(self fileReference: targetClass asString , '_' , fitness asString , '_typeInfo_result_with_only_Seed')
		writeStreamDo: [ :stream |
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: #('method' 'classSide' 'args' 'list of detected types' 'return types').
			classInfo := aTypeInformation classAt: targetClass.
			instanceMethods := targetClass asClass 
				methods sort: [ :method1 :method2 | method1 name < method2 name ].
			instanceMethods do: [ :cm | | m types |
				[ m := classInfo methodOf: cm selector.
				 types := (m argTypes collect: [ :a | a types asString ]) asArray.
				neoCSVWriter nextPut: (Array with: m selector with: 'false' with: m argTypes size with: types asString with: m returnType types asString ) ] 
				on: Error
				do: [ neoCSVWriter nextPut: (Array with: cm selector with: 'false' with: '' with: 'no detected' with: 'no detected')  ]
			 ].
			classMethods := targetClass asClass class
				methods sort: [ :method1 :method2 | method1 name < method2 name ].
			classMethods do: [ :cm | | m types |
				[ m := classInfo classMethodOf: cm selector.
				 types := (m argTypes collect: [ :a | a types asString ]) asArray.
				neoCSVWriter nextPut: (Array with: m selector with: 'true' with: m argTypes size with: types asString with: m returnType types asString) ] 
				on: Error
				do: [ neoCSVWriter nextPut: (Array with: cm selector with: 'true' with: '' with: 'no detected' with: 'no detected')  ]
			 ].
			neoCSVWriter flush ]
]

{ #category : #generateOnlyTypeInformation }
SReportGenerator >> generateReportOfTypeInfoOf: aTypeCollector [
	| classInfo instanceMethods classMethods |
	(self fileReference: targetClass asString ,'_', fitness asString , '_typeInfo_', aTypeCollector name)
		writeStreamDo: [ :stream |
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: #('method' 'classSide' 'args' 'list of detected types' 'return types').
			classInfo := typeInfo classAt: targetClass.
			instanceMethods := targetClass asClass 
				methods sort: [ :method1 :method2 | method1 name < method2 name ].
			instanceMethods do: [ :cm | | m types |
				[ m := classInfo methodOf: cm selector.
				 types := (m argTypes collect: [ :a | a types asString ]) asArray.
				neoCSVWriter nextPut: (Array with: m selector with: 'false' with: m argTypes size with: types asString with: m returnType types asString ) ] 
				on: Error
				do: [ neoCSVWriter nextPut: (Array with: cm selector with: 'false' with: '' with: 'no detected' with: 'no detected')  ]
			 ].
			classMethods := targetClass asClass class
				methods sort: [ :method1 :method2 | method1 name < method2 name ].
			classMethods do: [ :cm | | m types |
				[ m := classInfo classMethodOf: cm selector.
				 types := (m argTypes collect: [ :a | a types asString ]) asArray.
				neoCSVWriter nextPut: (Array with: m selector with: 'true' with: m argTypes size with: types asString with: m returnType types asString) ] 
				on: Error
				do: [ neoCSVWriter nextPut: (Array with: cm selector with: 'true' with: '' with: 'no detected' with: 'no detected')  ]
			 ].
			neoCSVWriter flush ]
]

{ #category : #generateOnlyTypeInformation }
SReportGenerator >> generateReportOfTypeInfoWithOption: aBoolean [
	| classInfo instanceMethods classMethods infoName |

	aBoolean
		ifTrue: [ infoName := 'seed_with_CompleteInfo' ]
		ifFalse: [ infoName := 'only_Seed' ].
	(self fileReference: targetClass asString  ,'_', fitness asString , '_typeInfo_', infoName)
		writeStreamDo: [ :stream |
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: #('method' 'classSide' 'args' 'list of detected types' 'return types').
			classInfo := typeInfo classAt: targetClass.
			instanceMethods := targetClass asClass 
				methods sort: [ :method1 :method2 | method1 name < method2 name ].
			instanceMethods do: [ :cm | | m types |
				[ m := classInfo methodOf: cm selector.
				 types := (m argTypes collect: [ :a | a types asString ]) asArray.
				neoCSVWriter nextPut: (Array with: m selector with: 'false' with: m argTypes size with: types asString with: m returnType types asString ) ] 
				on: Error
				do: [ neoCSVWriter nextPut: (Array with: cm selector with: 'false' with: '' with: 'no detected' with: 'no detected')  ]
			 ].
			classMethods := targetClass asClass class
				methods sort: [ :method1 :method2 | method1 name < method2 name ].
			classMethods do: [ :cm | | m types |
				[ m := classInfo classMethodOf: cm selector.
				 types := (m argTypes collect: [ :a | a types asString ]) asArray.
				neoCSVWriter nextPut: (Array with: m selector with: 'true' with: m argTypes size with: types asString with: m returnType types asString) ] 
				on: Error
				do: [ neoCSVWriter nextPut: (Array with: cm selector with: 'true' with: '' with: 'no detected' with: 'no detected')  ]
			 ].
			neoCSVWriter flush ]
]

{ #category : #generateOnlyTypeInformation }
SReportGenerator >> generateReportOfTypeInformationWithSeed [

	typeInfo := STypeInfo
				asTypeInfo: (SSTypeCollector profile: executionBlock onPackagesMatching: regex).
	self generateReportOfTypeInfoWithOption: false
]

{ #category : #generateOnlyTypeInformation }
SReportGenerator >> generateReportOfTypeInformationWithSeedAndCompleteInfo [

	typeInfo := STypeInfo
				asTypeInfo: (SSTypeCollector profile: executionBlock onPackagesMatching: regex).
	typeInfo completeTypeInfo.
	self generateReportOfTypeInfoWithOption: true
]

{ #category : #generateOnlyTypeInformation }
SReportGenerator >> generateReportOfTypeInformationWithoutSeed [

	| aBlock |
	aBlock := [  ].
	self collectorTypes 
		do: [ :collectorType |		
			typeInfo := (STypeInfo new smallCollector: (collectorType asClass))
				asTypeInfo: (SSTypeCollector profile: aBlock onPackagesMatching: regex).
			typeInfo completeTypeInfo.
			self generateReportOfTypeInfoOf: (collectorType asClass) ]
]

{ #category : #generationOfReportWithSeedAndInfo }
SReportGenerator >> generateReportWithSeedAndInfoOf: aTargetClass inPackage: aPackageName [

	| aBlock typeInformation |

	aBlock := [ | exec |
		exec := ClyRunTestsFromClassesCommand new.
			(RPackage organizer packageNamed: aPackageName) classes do: [ :cls |
    			exec runTestCase: cls ] ].

	typeInformation := STypeInfo 
		asTypeInfo: (SSTypeCollector profile: aBlock onPackagesMatching: regex).
	 self generateBlockCoverageReportWithSeedAndInfoOf: aTargetClass inPackage: aPackageName.
	self generateReportOfTypeInfoInTestCasesWithSeedAndInfoOf: typeInformation.
	self generateReportOfResults.
]

{ #category : #generationOfReportWithSeed }
SReportGenerator >> generateReportWithSeedOf: aTargetClass inPackage: aPackageName [

	| aBlock typeInformation |

	aBlock := [ | exec |
		exec := ClyRunTestsFromClassesCommand new.
			(RPackage organizer packageNamed: aPackageName) classes do: [ :cls |
    			exec runTestCase: cls ] ].

	typeInformation := STypeInfo 
		asTypeInfo: (SSTypeCollector profile: aBlock onPackagesMatching: regex).
	self generateBlockCoverageReportWithSeedOf: aTargetClass inPackage: aPackageName.
	self generateReportOfTypeInfoInTestCasesWithSeedOf: typeInformation.
	self generateReportOfResults.
]

{ #category : #generationOfSeedReport }
SReportGenerator >> generateSeedReports [
  | profiler fitnessResult typeInformation result aBlock resultsCollection |
  aBlock := executionBlock.
  resultsCollection := OrderedCollection new.
  typeInformation := (STypeInfo new smallCollector: TypeCollectorWithRoelfTyper) asTypeInfo: (SSTypeCollector profile: aBlock onPackagesMatching: regex).
  profiler := SLProfilerCoverage profilerForPackagesMatching: regex.
  self fitnessCoverageClasses do: [:coverage |  fitnessResult := coverage asClass new.
        fitnessResult
           profiler: profiler;
           typeInfo: typeInformation;
           targetClass: targetClass.
        profiler uninstall.
        profiler beforeProfiling.
        profiler cleanBlocksOfMethods.
        aBlock value.
        result := fitnessResult computeFitness.
        profiler uninstall.
        resultsCollection add: (result at: 1) ].
  self generateCSVOfSeedReportWithValues: resultsCollection
]

{ #category : #generationOfReportWithSeed }
SReportGenerator >> generateTestCaseForOnlySeedOf: aClass withConfig: combinations withPackageName: aPackageName andBlock: aBlock [
  | coverageArray generated |
	coverageArray := OrderedCollection new.
  combinations doWithIndex: [:c :i |  | factory |
        generated := aClass createTestCaseConfigWithName: aClass name , '_' , i asString , '_' , c first asString , '_' , c second asString , '_' , c third asString , '_' , c fourth asString , '_' , c fifth printString , '_' , aPackageName.
        generated
           addTypeInfo: typeInfo withKey: 'var';
           typeInfo: 'var';
           fitness: fitness;
           stopIterations: c first;
           numberOfGenerations: c second;
           numberOfStatements: c third;
           populationSize: c fourth;
           selectionStrategy: c fifth;
           targetPackageRegex: regex;
           outputPackageName: aPackageName.
        factory := (STestCaseFactoryPharo from: generated)
           seedBlock: aBlock;
           createTestCasesWithSeed;
           yourself.
        coverageArray add: (Array with: factory engine logs last fittestTestCase fitness with: factory engine logs last fittestTestCase fitnessByClass) ].
		^ coverageArray
]

{ #category : #generationOfReportWithSeedAndInfo }
SReportGenerator >> generateTestCaseForSeedAndInfoOf: aClass withConfig: combinations withPackageName: aPackageName andBlock: aBlock [
  | coverageArray generated |
	coverageArray := OrderedCollection new.
  combinations doWithIndex: [:c :i |  | factory |
        
        generated := aClass createTestCaseConfigWithName: aClass name, '_' , i asString , '_' , c first asString , '_' , c second asString , '_' , c third asString , '_' , c fourth asString , '_' , c fifth printString , '_' , aPackageName.
        generated
           addTypeInfo: typeInfo withKey: 'var';
           typeInfo: 'var';
           fitness: fitness;
           stopIterations: c first;
           numberOfGenerations: c second;
           numberOfStatements: c third;
           populationSize: c fourth;
           selectionStrategy: c fifth;
           targetPackageRegex: regex;
           outputPackageName: aPackageName.
        factory := (STestCaseFactoryPharo from: generated)
           seedBlock: aBlock;
           createTestCases;
           yourself.
        coverageArray add: (Array with: factory engine logs last fittestTestCase fitness with: factory engine logs last fittestTestCase fitnessByClass) ].
		^ coverageArray
]

{ #category : #generationOfReportWithoutSeed }
SReportGenerator >> generateTestCaseOf: aClass withConfig: combinations withPackageName: aPackageName andBlock: aBlock [
  | coverageArray generated |
  coverageArray := OrderedCollection new.
  combinations doWithIndex: [:c :i |  | factory |
        
        generated := aClass createTestCaseConfigWithName: aClass name, '_' , i asString , '_' , c first asString , '_' , c second asString , '_' , c third asString , '_' , c fourth asString , '_' , c fifth printString , '_' , aPackageName.
        generated
           addTypeInfo: typeInfo withKey: 'var';
           typeInfo: 'var';
           fitness: fitness;
           stopIterations: c first;
           numberOfGenerations: c second;
           numberOfStatements: c third;
           populationSize: c fourth;
           selectionStrategy: c fifth;
           targetPackageRegex: regex;
           outputPackageName: aPackageName.
        factory := (STestCaseFactoryPharo from: generated)
           seedBlock: aBlock;
           createTestCases;
           yourself.
        coverageArray add: (Array with: factory engine logs last fittestTestCase fitness with: factory engine logs last fittestTestCase fitnessByClass) ].
		^ coverageArray
]

{ #category : #generationOfReportWithSeed }
SReportGenerator >> generateTestCasesWithSeed [
  | combinations packageName resultArray resultResume |
  combinations := self generateCombinationsForConfig.
  packageName := 'Generated_' , targetClass asString , '_onlySeed'.
  typeInfo := STypeInfo asTypeInfo: (SSTypeCollector profile: executionBlock onPackagesMatching: regex).
  resultArray := self generateTestCaseForOnlySeedOf: targetClass asClass withConfig: combinations withPackageName: packageName andBlock: executionBlock.
  resultResume := self calculateAndInspectClassInformationOf: resultArray.
  resultCollector add: (Array with: 'seed' with: resultResume).
  self generateReportWithSeedOf: targetClass inPackage: packageName
]

{ #category : #generationOfReportWithSeedAndInfo }
SReportGenerator >> generateTestCasesWithSeedAndCompletingInfo [
  | combinations packageName resultArray resultResume |
  combinations := self generateCombinationsForConfig.
  packageName := self generatePackageNameForSeedAndInfo.
  typeInfo := self typeInformationWithoutCollector.
  resultArray := self generateTestCaseForSeedAndInfoOf: targetClass asClass withConfig: combinations withPackageName: packageName andBlock: executionBlock.
  resultResume := self calculateAndInspectClassInformationOf: resultArray.
  resultCollector add: (Array with: 'seed + nevena + roelf' with: resultResume).
  self generateReportWithSeedAndInfoOf: targetClass inPackage: packageName
]

{ #category : #generationOfReportWithoutSeed }
SReportGenerator >> generateTestCasesWithoutSeed [
  | aBlock combinations packageName resultArray resultResume |
  aBlock := [  ].
  combinations := self generateCombinationsForConfig.
  self collectorTypes do: [:collectorType |  
		packageName := self generatePackageNameWithCollector: collectorType.
		typeInfo := self typeInfoOfCollector: collectorType withBlock: aBlock.
      resultArray := self generateTestCaseOf: targetClass asClass withConfig: combinations withPackageName: packageName andBlock: aBlock.
		resultResume := self calculateAndInspectClassInformationOf: resultArray.
		resultCollector add: (Array with: collectorType asString with: resultResume).
		self generateReportOf: targetClass inPackage: packageName andCollector: collectorType ]
]

{ #category : #initialization }
SReportGenerator >> initialize [
	fitness := #statement.
	executionBlock := [ ].
	resultCollector := OrderedCollection new.
	collectorTypeString := ''
]

{ #category : #accessing }
SReportGenerator >> obtainCoverageOption [
  ^ (fitness = #statement)
		ifTrue: [ SStatementCoverage new ]
		ifFalse: [ SBranchCoverage new ]
]

{ #category : #accessing }
SReportGenerator >> regex [
	^ regex
]

{ #category : #accessing }
SReportGenerator >> regex: aString [
	regex := aString
]

{ #category : #accessing }
SReportGenerator >> targetClass: aClass [
	targetClass := aClass
]

{ #category : #accessing }
SReportGenerator >> typeInfo [
	^ typeInfo
]

{ #category : #accessing }
SReportGenerator >> typeInfo: anObject [
	typeInfo := anObject
]

{ #category : #typeInformation }
SReportGenerator >> typeInfoOfCollector: collectorType withBlock: aBlock [
  ^(STypeInfo new smallCollector: collectorType asClass) asTypeInfo: (SSTypeCollector profile: aBlock onPackagesMatching: regex)
]

{ #category : #typeInformation }
SReportGenerator >> typeInformationWithoutCollector [
  ^STypeInfo asTypeInfo: (SSTypeCollector profile: executionBlock onPackagesMatching: regex)
]
