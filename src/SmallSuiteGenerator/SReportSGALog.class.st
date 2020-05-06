Class {
	#name : #SReportSGALog,
	#superclass : #SReport,
	#category : #'SmallSuiteGenerator-Utility'
}

{ #category : #accessing }
SReportSGALog class >> dictOfDifferences: differences [ 
	| result keys |
	result := OrderedCollection new.
	keys := #('Generations' 'Method' 'UpdateReturnType' 'UpdateArgsType' 'ConvertToExecutedMethod' 'ConvertToUnexecutedMethod' 'AddTypeInfo' 'AddExecutedBlocks' 'DecreaseExecutedBlocks').
   differences do: [:e |  | generationText |
		generationText := (e key - 2) asString , ' -> ' , (e key - 1) asString.
      e value do: [:diff |  | aux |
         aux := Dictionary newFromKeys: keys andValues: (OrderedCollection ofSize: 9).
         aux at: 'Generations' put: generationText.
         aux at: 'Method' put: diff first.
         diff allButFirst do: [:d | 
             d key = 'WasExecuted' ifTrue: [ d value = #(false true) ifTrue: [ aux at: 'ConvertToExecutedMethod' put: true ] ifFalse: [ aux at: 'ConvertToUnexecutedMethod' put: true ]].
             d key = 'ReturnType' ifTrue: [ aux at: 'UpdateReturnType' put: true ].
             d key = 'HasTypeInfo' ifTrue: [ aux at: 'AddTypeInfo' put: true ].
             d key = 'ArgTypes' ifTrue: [ aux at: 'UpdateArgsType' put: true ].
             d key = 'ExecutedBlock' ifTrue: [ aux at: 'AddExecutedBlocks' put: (d value second difference: d value first) ].
             d key = 'UnexecutedBlock' ifTrue: [ aux at: 'DecreaseExecutedBlocks' put: (d value second difference: d value first) ] ].
         result add: aux ] ].
  ^ result 
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
	| differences dictColl keys |
	keys := #('Generations' 'Method' 'UpdateReturnType' 'UpdateArgsType' 'ConvertToExecutedMethod' 'ConvertToUnexecutedMethod' 'AddTypeInfo' 'AddExecutedBlocks' 'DecreaseExecutedBlocks').
	differences := aSGAEngine generateReportOfDifferencesBtwGenerations.
	dictColl := self dictOfDifferences: differences.
	(self fileReference: 'ReportChangesOfGenerations_', aSGAEngine targetClassName asString)
		writeStreamDo: [ :stream | 
			| neoCSVWriter |
			neoCSVWriter := (NeoCSVWriter on: stream)
				nextPut: keys;
				addRawFieldsAt: keys.
			dictColl do: [ :aDict | neoCSVWriter nextPut: aDict ].
			neoCSVWriter flush ]
]

{ #category : #accessing }
SReportSGALog class >> titles [
	^ #('ID' 'Class Name' 'Method Name' 'Is Class Side' 'Was Executed' 'Has TypeInfo' 'Code' 'Args Types' 'Return Type' 'Executed Block' 'Unexecuted Block')
]
