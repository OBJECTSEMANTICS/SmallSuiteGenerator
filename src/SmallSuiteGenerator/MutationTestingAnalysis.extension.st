Extension { #name : #MutationTestingAnalysis }

{ #category : #'*SmallSuiteGenerator' }
MutationTestingAnalysis >> generateResults [
	^ mutations
		collect: [ :aMutation | 
			logger logStartEvaluating: aMutation.
			
					(MutantEvaluation
						for: aMutation
						using: testCases
						following: mutantsEvaluationStrategy
						andConsidering: self coverageAnalysisResult) value ].
]
