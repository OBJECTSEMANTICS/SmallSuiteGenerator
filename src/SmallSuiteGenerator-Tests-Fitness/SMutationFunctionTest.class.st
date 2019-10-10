Class {
	#name : #SMutationFunctionTest,
	#superclass : #TestCase,
	#instVars : [
		'utility',
		'fitness'
	],
	#category : #'SmallSuiteGenerator-Tests-Fitness'
}

{ #category : #running }
SMutationFunctionTest >> setUp [
	super setUp.
	utility := SUtilityTypeInfo new.
	fitness := SMutationFunction new
]

{ #category : #running }
SMutationFunctionTest >> tearDown [
	fitness class clean.
	SUtil resetCreatedClasses 
]

{ #category : #tests }
SMutationFunctionTest >> testClasses [
	fitness classesNames: #('STest1' 'STest2').
	self
		assertCollection: (fitness classes collect: #name)
		hasSameElements: #(#STest1 #STest2)
]

{ #category : #tests }
SMutationFunctionTest >> testComputeFitnessOnLiteral [
	| testCase |
	testCase := SSTestCase with: utility typeInfosSEvent second.
	testCase addLiteral.
	fitness class compileTestCase: testCase.
	SUtil createClass: 'SEvent1Test'.
	fitness classesNames: #('SEvent1Test').
	fitness classesToMutate: (Array with: SEvent).
	self assert: (fitness computeFitness: testCase) equals: 0
]

{ #category : #tests }
SMutationFunctionTest >> testComputeFitnessOnMethod [
	| testCase |
	testCase := SSTestCase with: utility typeInfosSEvent first.
	testCase addMessage: #discount: from: #SEvent.
	fitness class compileTestCase: testCase.
	SUtil createClass: 'SEvent1Test'.
	fitness classesNames: #('SEvent1Test').
	fitness classesToMutate: (Array with: SEvent).
	self assert: (fitness computeFitness: testCase) >= 27
]
