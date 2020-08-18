"
SSTestCase is a subclass that defines or initializes some instance variables which are util in the genetic algorithm evolution
"
Class {
	#name : #SSTestCase,
	#superclass : #SSTestShifter,
	#instVars : [
		'fitness',
		'idPopulation',
		'summaryExecutionMethods',
		'generationNumber',
		'summaryTargetClass',
		'fitnessByClass',
		'selectionStrategy',
		'parents',
		'children',
		'properties',
		'summaryExecutedBlocks'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'instance creation' }
SSTestCase class >> with: aTypeInfo [
  | testCase |
  testCase := self new.
  testCase typeInfo: aTypeInfo.
  ^testCase
]

{ #category : #comparing }
SSTestCase >> = another [
  ^ self class = another class 
	and: [ statements = another statements 
		and: [ fitness = another fitness 
			and: [ parents = another parents 
				and: [ generationNumber = another generationNumber and: [ idPopulation = another idPopulation  ] ] ] ] ]
]

{ #category : #visitor }
SSTestCase >> accept: aVisitor [
	aVisitor visitStatements: self statements.
]

{ #category : #accessing }
SSTestCase >> addChild: aTestCase [
	children add: aTestCase
]

{ #category : #accessing }
SSTestCase >> addParent: aTestCase [
   parents add: aTestCase.
	aTestCase addChild: self.
]

{ #category : #accessing }
SSTestCase >> addParents: aCollection [
   aCollection do: [ :e | self addParent: e ]
]

{ #category : #accessing }
SSTestCase >> allChildren [
	^ (Set newFrom: children)
	addAll: (children flatCollect: [ :tC | tC allChildren ]); yourself
]

{ #category : #accessing }
SSTestCase >> allParents [
	|  list |
	list := OrderedCollection new.
	self allParents: self on: list using: Set new.
	^ list
]

{ #category : #accessing }
SSTestCase >> allParents: testCase on: collection using: associationSet [
	testCase parents 
		reject: [ :tC | (associationSet includes: tC generationNumber -> tC idPopulation) ] 
		thenDo:  [ :tC | 
			associationSet add: tC generationNumber -> tC idPopulation.
			collection add: tC.
			self allParents: tC on: collection using: associationSet	
		]
]

{ #category : #accessing }
SSTestCase >> children [ 
	^ children
]

{ #category : #copying }
SSTestCase >> copy [
	| copy |
	copy := self class with: typeInfo copy.
	copy targetClassName: targetClassesName.
	statements do: [ :stm | copy addStatement: stm copy ].
	copy updateNextId.
	^ copy
]

{ #category : #copying }
SSTestCase >> deepCopy [
  | copy |
  copy := self copy.
  copy setFitness: self fitness.
  copy setFitnessByClass: self fitnessByClass.
  copy generationNumber: self generationNumber.
  copy summaryExecutionMethods: self summaryExecutionMethods.
  copy hasErrors: self hasErrors.
  ^ copy
]

{ #category : #comparing }
SSTestCase >> differenceWith: aTestCase [
	| test1 test2 keys result |
	result := 0.
	test1 := self summaryExecutedBlocks.
	test2 := aTestCase summaryExecutedBlocks.
	keys := (test1 keys union: test2 keys).
	keys do: [ :key | | val1 val2 sum |
		[sum := 0.
		val1 := test1 at: key ifAbsent: [].
		val2 := test2 at: key ifAbsent: [].
		val1 with: val2 do: [ :block1 :block2 |
			(block1 wasExecuted = block2 wasExecuted) ifTrue: [ sum := sum + 1 ].
		].
		result := result + (1 - (sum / val1 size))]
		on: Error
		do: [ { val1 . val2 } select: [ :e | e isNotNil ] 
			thenDo: [ :e | sum := 1 - ((e select: [ :b | b wasExecuted not ]) size / e size).
				result := result + sum ] ]			
	].
	^ result / keys size
]

{ #category : #comparing }
SSTestCase >> differenceWithAll: aColl [
	^ aColl collect: [ :aTestCase | self differenceWith: aTestCase ]
]

{ #category : #accessing }
SSTestCase >> fitness [ 	
	^ fitness
]

{ #category : #accessing }
SSTestCase >> fitnessByClass [
	^ fitnessByClass 
]

{ #category : #actions }
SSTestCase >> fitnessFor: functionName [ 
	^ self fitness at: functionName
]

{ #category : #accessing }
SSTestCase >> generationNumber [
	^ generationNumber
]

{ #category : #accessing }
SSTestCase >> generationNumber: anObject [
	generationNumber := anObject
]

{ #category : #comparing }
SSTestCase >> hash [
  ^ super hash bitXor: "(self number hash bitXor:" self statements hash")"
]

{ #category : #accessing }
SSTestCase >> idPopulation [
	^ idPopulation
]

{ #category : #accessing }
SSTestCase >> idPopulation: anObject [
	idPopulation := anObject
]

{ #category : #initialization }
SSTestCase >> initialize [
   super initialize.
   generationNumber := 1.
   idPopulation := 1.
	parents := OrderedCollection new.
  	children := OrderedCollection new.
   summaryExecutionMethods := OrderedCollection new.
	hasErrors := false.
	fitness := Dictionary new.
	summaryExecutedBlocks := Dictionary new.
	fitnessByClass := Dictionary new.
	selectionStrategy := SGARouletteSelection new.
	properties := Dictionary new.
	lastMessage := #()
]

{ #category : #util }
SSTestCase >> isBetterThan: testCase2 using: fitnessStrategy [
    |fitness1 fitness2|
    fitness1 := self fitness at: fitnessStrategy.
    fitness2 := testCase2 fitness at: fitnessStrategy.
    (fitness1 > fitness2) ifTrue:[ ^ true ].
	 (self hasErrors and: [ testCase2 hasErrors not and: [ self next < 0.5 ]]) ifTrue: [^ false].
    ((fitness1 = fitness2) and:
        [self length < testCase2 length]) 
                ifTrue:[^ true]. 
    (fitness1 = fitness2 and:
        [self length = testCase2 length and:[ self idPopulation > testCase2 idPopulation]])
                ifTrue:[^ true]. 
    ^ false
]

{ #category : #accessing }
SSTestCase >> parents [
	^ parents
]

{ #category : #printing }
SSTestCase >> printOn: aStream [
	self accept: (self printerClass on: aStream).
]

{ #category : #printing }
SSTestCase >> printString [
	^ String streamContents: [ :stream | self printOn: stream].
]

{ #category : #printing }
SSTestCase >> printStringWithAssertions [
	^ String streamContents: [ :stream | 
		self printerClass printTempVariables: self on: stream.
		(self printerClass on: stream) 
			visitStatements: self statements, self lastMessage,self assertions.
		].
]

{ #category : #printing }
SSTestCase >> printSummaryFitness [
	^ String
		streamContents: [ :stream | 
			stream
				nextPutAll: '"Fitness: ';
				nextPut: Character cr.
			fitness
				associationsDo: [ :assoc | 
					stream
						nextPutAll: assoc key;
						nextPutAll: ': ';
						nextPutAll: assoc value printString;
						nextPut: Character cr ].
			stream
				nextPutAll: '"' ]
]

{ #category : #printing }
SSTestCase >> printSummaryFitnessByClass [
	^ String
		streamContents: [ :stream | 
			stream
				nextPutAll: '"This test covers: ';
				nextPut: Character cr.
			fitnessByClass
				associationsDo: [ :assoc | 
					stream
						nextPutAll: assoc key;
						nextPutAll: (String with: Character cr).
					self printFunctionByClassName: assoc value on: stream ].
			stream
				nextPutAll: '"';
				nextPutAll: (String with: Character cr) ]
]

{ #category : #accessing }
SSTestCase >> properties [
	^ self.
]

{ #category : #accessing }
SSTestCase >> removeChild: testCase [
	| index |
	index := 0.
	children detect: [:tC | index := index + 1.
		(tC generationNumber == testCase generationNumber) and: [ tC idPopulation == testCase idPopulation ] ]
		ifFound: [ :tC | children removeAt: index ]
]

{ #category : #util }
SSTestCase >> selectMethod: aCollection [ 
	selectionStrategy ifNil: [  ^ aCollection  pickAny].
	^ selectionStrategy selectJustOneOf: aCollection with: (aCollection collect: #executions).
	
]

{ #category : #accessing }
SSTestCase >> selectionStrategy: selectStrategy [
	selectionStrategy := selectStrategy 
]

{ #category : #accessing }
SSTestCase >> setFitness: aDictionary [ 
	fitness := aDictionary copy
]

{ #category : #accessing }
SSTestCase >> setFitnessByClass: aDictionary [ 
	fitnessByClass := aDictionary copy
]

{ #category : #printing }
SSTestCase >> storeOn: aStream [
]

{ #category : #accessing }
SSTestCase >> summaryExecutedBlocks [
	^ summaryExecutedBlocks
]

{ #category : #accessing }
SSTestCase >> summaryExecutedBlocks: aSummaryExecutedBlocks [ 
	summaryExecutedBlocks := aSummaryExecutedBlocks 
]

{ #category : #accessing }
SSTestCase >> summaryExecutionMethods [
	^ summaryExecutionMethods
]

{ #category : #accessing }
SSTestCase >> summaryExecutionMethods: summaryExecutionMethod [ 
	summaryExecutionMethods := summaryExecutionMethod 
]

{ #category : #accessing }
SSTestCase >> summaryTargetClass [
	^ summaryTargetClass
]

{ #category : #accessing }
SSTestCase >> summaryTargetClass: anObject [
	summaryTargetClass := anObject 
]

{ #category : #util }
SSTestCase >> updateWith: anotherTestCase [
	self generationNumber: anotherTestCase generationNumber.
	self idPopulation: anotherTestCase idPopulation.
	anotherTestCase parents do: [ :parent | 
		parent removeChild: anotherTestCase.
		self addParent:  parent ]
]
