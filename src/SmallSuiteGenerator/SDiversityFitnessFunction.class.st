Class {
	#name : #SDiversityFitnessFunction,
	#superclass : #SOneVsAllFitnessFunction,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #accesing }
SDiversityFitnessFunction >> calcClassDifferenceBtw: blocksClsSummary1 and: blocksClsSummary2 [
	| test1 test2 keys result |
	result := 0.
	test1 := blocksClsSummary1 first.
	test2 := blocksClsSummary2 first.
	keys := (test1 keys union: test2 keys).
	keys do: [ :key | | val1 val2 sum |
		[sum := 0.
		val1 := test1 at: key ifAbsent: [nil].
		val2 := test2 at: key ifAbsent: [nil].
		val1 with: val2 do: [ :block1 :block2 |
			(block1 wasExecuted = block2 wasExecuted) ifTrue: [ sum := sum + 1 ].
		].
		result := result + (1 - (sum / val1 size))]
		on: Error
		do: [ { val1 . val2 } select: [ :e | e isNotNil ] 
			thenDo: [ :e | sum := 1 - ((e select: [ :b | b wasExecuted not ]) size / e size).
				result := result + sum ] ]			
	].
	^ result / blocksClsSummary1 second
]

{ #category : #actions }
SDiversityFitnessFunction >> computeFitnessByClassOf: testCase regardingAll: aColl [
	| differences |
	differences := Dictionary new.
	aColl do: [ :each | 
		 differences sum: (self differenceBtw: testCase and: each) ].
	^ differences / aColl size
]

{ #category : #accesing }
SDiversityFitnessFunction >> copyOf: summaryBlocks [
	^ Array with: Dictionary new with: summaryBlocks second
]

{ #category : #accesing }
SDiversityFitnessFunction >> differenceBtw: aTestCase1 and: aTestCase2 [
	| result classes summaryBlocks1 summaryBlocks2 |
	result := Dictionary new.
	summaryBlocks1 := aTestCase1 valueAt: 'summaryExecutedBlocks' ifAbsent: [ Dictionary new ].
	summaryBlocks2 := aTestCase2 valueAt: 'summaryExecutedBlocks' ifAbsent: [ Dictionary new ].
	classes := (summaryBlocks1 keys union: summaryBlocks2 keys).
	classes do: [ :cls |
		result at: cls put: (self calcClassDifferenceBtw: 
				(summaryBlocks1 at: cls ifAbsent: [ self copyOf: (summaryBlocks2 at: cls) ]) 
			and: (summaryBlocks2 at: cls ifAbsent: [ self copyOf: (summaryBlocks1 at: cls) ]))
	].
	^ result
]

{ #category : #accesing }
SDiversityFitnessFunction >> functionName [
	^ 'diversity'
]

{ #category : #actions }
SDiversityFitnessFunction >> saveInformationOf: testCase [
	(testCase valueAt: 'summaryExecutedBlocks') ifNil: [
		profiler cleanBlocksOfMethods.
      testCase runWithoutAssertionsAndLastStatement.
		testCase at: 'summaryExecutedBlocks' putValue: profiler collectExecutedMethodsByClass.
	]
]
