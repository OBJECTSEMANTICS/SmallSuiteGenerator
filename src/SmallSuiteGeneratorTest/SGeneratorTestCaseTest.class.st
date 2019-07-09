Class {
	#name : #SGeneratorTestCaseTest,
	#superclass : #TestCase,
	#instVars : [
		'generator'
	],
	#category : #'SmallSuiteGeneratorTest-Mutation'
}

{ #category : #initialization }
SGeneratorTestCaseTest >> setUp [
	generator := SGeneratorTestCase new
]

{ #category : #tests }
SGeneratorTestCaseTest >> testMethodsWithMutation [
	| methods |
	methods := generator
		methodsWithMutationFrom: {SEventTest}
		mutating: {SEvent}
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	self
		assertCollection: (methods collect: [:met | met originalMethod selector]) asSet
		hasSameElements: {#discount . #price. #discount:. #price:}
]

{ #category : #tests }
SGeneratorTestCaseTest >> testProfilerMutatedMethods [
	| profile methods newProfile |
	profile := SSGenerator
		profile: [ (SEvent price: 200)
				discount: 15;
				discount;
				price ]
		onClass: SEvent.
	methods := generator
		mutatedMethodsFrom: {SEventTest}
		mutating: {SEvent}
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	newProfile := generator
		profileMutatedMethodsFrom: methods
		using: profile.
	self
		assertCollection: newProfile allClassesAsDictionary keys
		hasSameElements: {#SEvent}.
	self
		assertCollection: (newProfile allMethods collect: #selector)
		hasSameElements: (methods collect: [ :meth | meth originalMethod selector ]) asSet
]