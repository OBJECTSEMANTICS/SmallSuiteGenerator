Class {
	#name : #SRankSelection,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-GeneticAlgorithm'
}

{ #category : #'as yet unclassified' }
SRankSelection >> doSelection [
	| fittest fitnessBlock |
	"populationSize := initialPopulation size.
	fittest := initialPopulation first.
	initialPopulation
		do: [ :testCase | 
			testCase computeFitnessUsing: fitnessBlock.
			(self isTestCase: testCase betterThan: fittest)
				ifTrue: [ fittest := testCase ] ].
	self createNewPopulation.
	initialPopulation := population"
]

{ #category : #'as yet unclassified' }
SRankSelection >> probabilityRank: ranks using: rsum [
	^ ranks collect: [ :rank | (rank / rsum) asFloat round: 2 ]
]

{ #category : #'as yet unclassified' }
SRankSelection >> rankSelection2: population [
	| l mpool newPopulation |
	l := 1.
	mpool := 5.
	newPopulation := population
		sort: [ :tC1 :tC2 | tC1 coverage < tC2 coverage ].
	l to: mpool do: [ newPopulation := self rankSelectionPopulation: newPopulation.
		l := l + 1 ].
	^ newPopulation
]

{ #category : #'as yet unclassified' }
SRankSelection >> rankSelection: population [
	| sortedPopulation sumOfRanks probabilityRanks |
	sortedPopulation := population
		sort: [ :tC1 :tC2 | tC1 coverage < tC2 coverage ].
	"sumOfRanks := self sumRanks: sortedPopulation.
	probabilityRanks := self
		probabilityRanks: sortedPopulation
		using: sumOfRanks"
]

{ #category : #'as yet unclassified' }
SRankSelection >> rankSelectionPopulation: population [
	| rsum pRanks r n c ranks newPopulation |
	n := population size.
	c := 0.
	newPopulation := OrderedCollection new.
	ranks := 1 to: n.	"self ranksOf: population."
	rsum := ranks sum.
	pRanks := self probabilityRank: ranks using: rsum.
	r := (0 to: rsum) atRandom.
	1 to: n do: [ :index | 
		c := c + (pRanks at: index).
		c <= r
			ifTrue: [ newPopulation add: (population at: index) ] ].
	^ newPopulation
]

{ #category : #'as yet unclassified' }
SRankSelection >> ranksOf: population [
	^ population collect: #coverage
]

{ #category : #'as yet unclassified' }
SRankSelection >> statementsGroupedByDependencies [
	| groups dependencies referencedVarNames statements |
	groups := Dictionary new.
	referencedVarNames := Set new.
	dependencies := STransformValue
		collectDependenciesStatements: statements.
	dependencies associations
		do: [ :assoc | 
			| group |
			group := OrderedCollection new.
			assoc value
				do: [ :varName | 
					groups
						at: varName
						ifPresent: [ :groupVarName | 
							group addAll: groupVarName.
							referencedVarNames add: varName ]
						ifAbsent: [ group add: varName ] ].
			groups
				at: assoc key
				put:
					(group
						add: assoc key;
						yourself) ].
	^ {groups.
	referencedVarNames asOrderedCollection}
]

{ #category : #'as yet unclassified' }
SRankSelection >> sumRank: population [
	^ (population collect: #coverage) sum
]
