Class {
	#name : #SReportGenerator,
	#superclass : #SReport,
	#instVars : [
		'targetClass',
		'executionBlock',
		'typeInfo',
		'regex'
	],
	#category : #'SmallSuiteGenerator-Utility'
}

{ #category : #generation }
SReportGenerator class >> generateTestCasesAndReportsOf: aClass withRegex: aString block: aBlock [

	self generateTypeInfoReportOfClass: aClass withRegex: aString andBlock: aBlock.
	self new
		targetClass: aClass;
		regex: aString;
		executionBlock: aBlock;
		generateStatementTestCasesWithoutSeed;
		generateStatementTestCasesWithSeed;
		generateStatementTestCasesWithSeedAndCompletingInfo.
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
SReportGenerator >> calculateAndInspectClassInformationOf: covArray [
  | dictionaryInformation |
  dictionaryInformation := Dictionary new.
  dictionaryInformation at: 'avg' put: (covArray collect: [:e |  e first at: 'block-coverage' ]) average.
  dictionaryInformation at: 'median' put: (covArray collect: [:e |  e first at: 'block-coverage' ]) median.
  dictionaryInformation at: 'max' put: (covArray collect: [:e |  e first at: 'block-coverage' ]) max.
  dictionaryInformation inspect
]

{ #category : #initialization }
SReportGenerator >> collectorTypes [
	
	^ #(TypeCollectorWithRoelfTyper TypeCollectorWithLightWeight SmallTypeCollector)
]

{ #category : #initialization }
SReportGenerator >> configuration [
	
	"stopIterations numberOfGenerations numberOfStatements populationSize selectionStrategy"
	
	^ Array with: #(30) with: #(50) with: #(30) with: #(20) with: {SGARandomSelection . 
        SGARankSelection . 
        SGARouletteSelection . 
        SGATournamentSelection . 
        SGATruncatedSelection}.
]

{ #category : #initialization }
SReportGenerator >> defaultBlock [

	^ [  ]
]

{ #category : #initialization }
SReportGenerator >> executionBlock [

	^ executionBlock
]

{ #category : #initialization }
SReportGenerator >> executionBlock: aBlock [

	executionBlock := aBlock
]

{ #category : #generationOfReportWithoutSeed }
SReportGenerator >> generateBlockCoverageReportOf: aTargetClass inPackage: aPackageName andCollector: aTypeCollector [

	| aBlock typeInformation profiler fitness |

	aBlock := [ | exec |
		exec := ClyRunTestsFromClassesCommand new.
			(RPackage organizer packageNamed: aPackageName) classes do: [ :cls |
    			exec runTestCase: cls ] ].

	typeInformation := (STypeInfo new smallCollector: (aTypeCollector asClass)) 
		asTypeInfo: (SSTypeCollector profile: aBlock onPackagesMatching: regex).

	profiler := SLProfilerCoverage profilerForPackagesMatching: regex.
	fitness := SStatementCoverage new.
	fitness profiler: profiler;
    	typeInfo: typeInformation;
    	targetClass: aTargetClass.
	profiler uninstall.
	profiler beforeProfiling.
	profiler cleanBlocksOfMethods.
	aBlock value.
	profiler uninstall.
	self generateReportOfBlock: (SReportBlockCoverage profiler: profiler targetClass: aTargetClass) ofCollector: aTypeCollector.
]

{ #category : #generationOfReportWithSeed }
SReportGenerator >> generateBlockCoverageReportWithSeedAndInfoOf: aTargetClass inPackage: aPackageName [

	| aBlock typeInformation profiler fitness |

	aBlock := [ | exec |
		exec := ClyRunTestsFromClassesCommand new.
			(RPackage organizer packageNamed: aPackageName) classes do: [ :cls |
    			exec runTestCase: cls ] ].

	typeInformation := STypeInfo 
		asTypeInfo: (SSTypeCollector profile: aBlock onPackagesMatching: regex).

	profiler := SLProfilerCoverage profilerForPackagesMatching: regex.
	fitness := SStatementCoverage new.
	fitness profiler: profiler;
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

	| aBlock typeInformation profiler fitness |

	aBlock := [ | exec |
		exec := ClyRunTestsFromClassesCommand new.
			(RPackage organizer packageNamed: aPackageName) classes do: [ :cls |
    			exec runTestCase: cls ] ].

	typeInformation := STypeInfo 
		asTypeInfo: (SSTypeCollector profile: aBlock onPackagesMatching: regex).

	profiler := SLProfilerCoverage profilerForPackagesMatching: regex.
	fitness := SStatementCoverage new.
	fitness profiler: profiler;
    	typeInfo: typeInformation;
    	targetClass: aTargetClass.
	profiler uninstall.
	profiler beforeProfiling.
	profiler cleanBlocksOfMethods.
	aBlock value.
	profiler uninstall.
	self generateReportOfBlockWithOnlySeed: (SReportBlockCoverage profiler: profiler targetClass: aTargetClass).
]

{ #category : #accessing }
SReportGenerator >> generateCombinationsForConfig [
  | combinations configList |

  configList := self configuration.
  combinations := (((configList first combinationsWith: configList second) combinationsWith: configList third) combinationsWith: configList fourth) combinationsWith: configList fifth.
	^ combinations
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
	self generateReportOfTypeInfoInTestCasesOf: typeInformation andCollector: aTypeCollector
]

{ #category : #generationOfReportWithoutSeed }
SReportGenerator >> generateReportOfBlock: aBlockCoverage ofCollector: aTypeCollector [
		
	| classInfo instanceMethods classMethods |
	(self fileReference: targetClass asString , '_report_coverage_', aTypeCollector asString)
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
	(self fileReference: targetClass asString , '_report_coverage_with_only_seed')
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
SReportGenerator >> generateReportOfBlockWithSeedAndInfo: aBlockCoverage [
		
	| classInfo instanceMethods classMethods |
	(self fileReference: targetClass asString , '_report_coverage_with_seed_and_completing_info')
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

{ #category : #generationOfReportWithoutSeed }
SReportGenerator >> generateReportOfTypeInfoInTestCasesOf: aTypeInformation andCollector: aTypeCollector [
	| classInfo instanceMethods classMethods |
	(self fileReference: targetClass asString , '_typeInfo_testCases_', aTypeCollector asString)
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
SReportGenerator >> generateReportOfTypeInfoInTestCasesWithSeedAndInfoOf: aTypeInformation [
	| classInfo instanceMethods classMethods |
	(self fileReference: targetClass asString , '_typeInfo_result_with_seed_and_completing_info')
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
	(self fileReference: targetClass asString , '_typeInfo_result_withOnlySeed')
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
	(self fileReference: targetClass asString , '_typeInfo_', aTypeCollector name)
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
	(self fileReference: targetClass asString , '_typeInfo_', infoName)
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

{ #category : #generationOfReportWithSeed }
SReportGenerator >> generateReportWithSeedAndInfoOf: aTargetClass inPackage: aPackageName [

	| aBlock typeInformation |

	aBlock := [ | exec |
		exec := ClyRunTestsFromClassesCommand new.
			(RPackage organizer packageNamed: aPackageName) classes do: [ :cls |
    			exec runTestCase: cls ] ].

	typeInformation := STypeInfo 
		asTypeInfo: (SSTypeCollector profile: aBlock onPackagesMatching: regex).
	 self generateBlockCoverageReportWithSeedAndInfoOf: aTargetClass inPackage: aPackageName.
	self generateReportOfTypeInfoInTestCasesWithSeedAndInfoOf: typeInformation
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
	self generateReportOfTypeInfoInTestCasesWithSeedOf: typeInformation
]

{ #category : #generationOfReportWithSeed }
SReportGenerator >> generateStatementTestCasesWithSeed [
  | combinations packageName covArray |
  combinations := self generateCombinationsForConfig.
  packageName := 'Generated_' , targetClass asString , '_onlySeed'.
  typeInfo := STypeInfo asTypeInfo: (SSTypeCollector profile: executionBlock onPackagesMatching: regex).
  covArray := self generateTestCaseForOnlySeedOf: targetClass asClass withConfig: combinations withPackageName: packageName andBlock: executionBlock.
  self calculateAndInspectClassInformationOf: covArray.
  self generateReportWithSeedAndInfoOf: targetClass inPackage: packageName
]

{ #category : #generationOfReportWithSeed }
SReportGenerator >> generateStatementTestCasesWithSeedAndCompletingInfo [
  | combinations packageName covArray |

  combinations := self generateCombinationsForConfig.
 
		packageName := 'Generated_' , targetClass asString, '_seedPlusInfo'.
		typeInfo := STypeInfo 
			asTypeInfo: (SSTypeCollector profile: executionBlock onPackagesMatching: regex).
      	covArray := self generateTestCaseForSeedAndInfoOf: targetClass asClass withConfig: combinations withPackageName: packageName andBlock: executionBlock.
		self calculateAndInspectClassInformationOf: covArray.
		self generateReportWithSeedOf: targetClass inPackage: packageName.
]

{ #category : #generationOfReportWithoutSeed }
SReportGenerator >> generateStatementTestCasesWithoutSeed [
  | aBlock combinations packageName covArray |
  aBlock := [  ].
  combinations := self generateCombinationsForConfig.
  self collectorTypes do: [:collectorType |  packageName := 'Generated_' , targetClass asString , '_' , collectorType asClass asString.
        typeInfo := (STypeInfo new smallCollector: collectorType asClass) asTypeInfo: (SSTypeCollector profile: aBlock onPackagesMatching: regex).
        covArray := self generateTestCaseOf: targetClass asClass withConfig: combinations withPackageName: packageName andBlock: aBlock.
        self calculateAndInspectClassInformationOf: covArray.
        self generateReportOf: targetClass inPackage: packageName andCollector: collectorType ]
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
           fitness: #statement;
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

{ #category : #generationOfReportWithSeed }
SReportGenerator >> generateTestCaseForSeedAndInfoOf: aClass withConfig: combinations withPackageName: aPackageName andBlock: aBlock [
  | coverageArray generated |
	coverageArray := OrderedCollection new.
  combinations doWithIndex: [:c :i |  | factory |
        
        generated := aClass createTestCaseConfigWithName: aClass name, '_' , i asString , '_' , c first asString , '_' , c second asString , '_' , c third asString , '_' , c fourth asString , '_' , c fifth printString , '_' , aPackageName.
        generated
           addTypeInfo: typeInfo withKey: 'var';
           typeInfo: 'var';
           fitness: #statement;
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
           fitness: #statement;
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

{ #category : #initialization }
SReportGenerator >> initialize [

	executionBlock := [ ]
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
