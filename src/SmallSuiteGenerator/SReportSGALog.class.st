Class {
	#name : #SReportSGALog,
	#superclass : #SReport,
	#instVars : [
		'engine'
	],
	#category : #'SmallSuiteGenerator-Utility'
}

{ #category : #'class-factory' }
SReportSGALog class >> engine: aSGAEngine [
	^ self new engine: aSGAEngine 
]

{ #category : #export }
SReportSGALog class >> exportResumeOf: logColl onCSV: aString [
	(self fileReference: aString)
		writeStreamDo: [ :stream | 
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: #('ID' 'Avg Tests Size' '% Has Errors' 'BestTest Size' 'BestTest hasErrors' 'Best' 'Average' 'Worst').
			logColl do: [ :aLog | neoCSVWriter nextPut: (Array withAll:
				(OrderedCollection new add: aLog generationNumber;
					add: aLog averageTestSize;
					add: aLog percentageOftestCasesWithErrors;
					add: aLog fittestTestCase statements size;
					add: aLog fittestTestCase hasErrors;
					add: aLog fittestTestCase fitness values first;
					add: aLog averageFit values first;
					add: aLog lowestFit values first;
					yourself )) ].
			neoCSVWriter flush ]
]

{ #category : #export }
SReportSGALog class >> generateReportForDifferencesBtwGenerationsOf: aSGAEngine [
	^ (self engine: aSGAEngine) generateReportForDifferencesBtwGenerations 
]

{ #category : #accessing }
SReportSGALog class >> titles [
	^ #('ID' 'Class Name' 'Method Name' 'Is Class Side' 'Was Executed' 'Has TypeInfo' 'Code' 'Args Types' 'Return Type' 'Executed Block' 'Unexecuted Block')
]

{ #category : #accessing }
SReportSGALog >> dictOfDifferences: differences [ 
	| result keys |
	result := OrderedCollection new.
	keys := #('Generations' 'Method' 'UpdateReturnType' 'UpdateArgsType' 'ConvertToExecutedMethod' 'ConvertToUnexecutedMethod' 'AddTypeInfo' 'AddExecutedBlocks' 'DecreaseExecutedBlocks').
   differences do: [:e |  | generationText |
		generationText := '{1} -> {2}' format: (Array with: (e key - 1) with: e key).
      e value do: [:diff |  | aux |
         aux := Dictionary newFromKeys: keys andValues: (OrderedCollection ofSize: 9).
         aux at: 'Generations' put: generationText.
         aux at: 'Method' put: diff first.
         diff allButFirst do: [:d | 
             d key = 'WasExecuted' ifTrue: [ d value = #(false true) ifTrue: [ aux at: 'ConvertToExecutedMethod' put: true ] ifFalse: [ aux at: 'ConvertToUnexecutedMethod' put: true ]].
             d key = 'ReturnType' ifTrue: [ aux at: 'UpdateReturnType' put: true ].
             d key = 'HasTypeInfo' ifTrue: [ aux at: 'AddTypeInfo' put: true ].
             d key = 'ArgTypes' ifTrue: [ aux at: 'UpdateArgsType' put: true ].
             d key = 'ExecutedBlock' ifTrue: [ aux at: 'AddExecutedBlocks' put: (d value second difference: d value first) asString].
             d key = 'UnexecutedBlock' ifTrue: [ aux at: 'DecreaseExecutedBlocks' put: (d value second difference: d value first) asString ] ].
         result add: aux ] ].
  ^ result 
]

{ #category : #reporting }
SReportSGALog >> differencesBtw: summary1 and: summary2 [
	| result |
   result := OrderedCollection new.
   summary1 with: summary2 do: [:x :y |  x = y 
		ifFalse: [ | aux |
			aux := OrderedCollection new.
         x keysAndValuesDo: [:key :value |  (x at: key) = (y at: key) 
				ifFalse: [ aux add: key -> (Array with: value with: (y at: key)) ] ]. 
		aux ifNotEmpty: [ aux addFirst: (x at: 'MethodName').
	result add: aux] ] ].
 	^ result
]

{ #category : #reporting }
SReportSGALog >> differencesBtwGenerations [
	| generations result |
	generations := self summaryGenerations.
	result := OrderedCollection new.
	2 to: generations size do: [ :index | |diff|
		diff := self differencesBtw: (generations at: index-1) and: (generations at: index).
		diff ifNotEmpty: [ result add: (index -> diff)] ].
	^ result
]

{ #category : #accessing }
SReportSGALog >> engine: anObject [ 
	engine := anObject 
]

{ #category : #reporting }
SReportSGALog >> generateReportForDifferencesBtwGenerations [
	| differences dictColl keys |
	keys := #('Generations' 'Method' 'UpdateReturnType' 'UpdateArgsType' 'ConvertToExecutedMethod' 'ConvertToUnexecutedMethod' 'AddTypeInfo' 'AddExecutedBlocks' 'DecreaseExecutedBlocks').
	differences := self differencesBtwGenerations.
	dictColl := self dictOfDifferences: differences.
	(self fileReference: 'ReportChangesOfGenerations_', engine targetClassName asString)
		writeStreamDo: [ :stream | 
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: keys;
				addRawFieldsAt: keys.
			dictColl do: [ :aDict | neoCSVWriter nextPut: aDict ].
			neoCSVWriter flush ]
]

{ #category : #'groups collecting' }
SReportSGALog >> methodTrackingFor: aSymbol [
	| methodCalls dict idMethods |
	idMethods := #().
	methodCalls := engine logs collect: [ :log | log population 
		select: [ :testCase | testCase statements anySatisfy: 
			[ :e | [e value selector = aSymbol] on: Error  do: [ false ] ] ] ].
	dict := Dictionary new.
	methodCalls doWithIndex: [ :methods :i | methods 
		ifNotEmpty: [ dict at: i put: (self reportOf: methods withParents: idMethods).
			idMethods := methods collect: #idPopulation ]
		ifEmpty: [ idMethods := #() ] ].
	^ dict
]

{ #category : #'groups collecting' }
SReportSGALog >> reportOf: methods withParents: idMethods [
	| keys |
	keys := #('TestCase' 'hasError' 'parentHasMethod').
	^ methods collect: [ :method | Dictionary 
		newFromKeys: keys 
		andValues: (Array with: method
			with: method hasErrors
			with: ((method parents collect: #idPopulation) includesAny: idMethods) )]
]

{ #category : #reporting }
SReportSGALog >> summaryGenerations [
	^ engine logs collect: [ :aLog | 
		aLog summaryTargetClass collect: [ :e | e ifNotNil: [ 
				Dictionary newFromKeys: #('ClassName' 'MethodName' 'IsClassSide' 'WasExecuted' 'HasTypeInfo' 'Code' 'ArgTypes' 'ReturnType' 'ExecutedBlock' 'UnexecutedBlock')
					 andValues: e summaryAsColl ] ] ]
	
]
