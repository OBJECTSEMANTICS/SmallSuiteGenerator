Class {
	#name : #SMessageNotUnderstoodTest,
	#superclass : #TestCase,
	#instVars : [
		'utility'
	],
	#category : #'SmallSuiteGenerator-Tests-Exception-Management'
}

{ #category : #initialization }
SMessageNotUnderstoodTest >> setUp [
	utility := SUtilityTypeInfo new
]

{ #category : #running }
SMessageNotUnderstoodTest >> tearDown [ 
	SMultiFitnessFunction clean.
	SCoverageWithProfiler allSubclassesDo: #clean.
]

{ #category : #tests }
SMessageNotUnderstoodTest >> testCanResolve [
	| testCase aException |
	testCase := SSTestCase
		with: utility typeInfosOnPackageExamplesOthers first.
	self
		should: [ testCase addMessage: #canRegister: from: #SEvent ]
		raise: SError.
	testCase addMessage: #canRegister: from: #SConference.
	SStatementCoverage
		coverageOf: [ | aConference aPerson |
			aConference := SConference new offerPrice: 95.
			aPerson := SStudent new name: 'Mary'.
			aConference canRegister: aPerson ]
		onPackagesMatching: 'SmallSuiteGenerator-Examples-Others'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_var0 := SConference new.'
				with: '_var1 := ' , (SStudent new name: 'Mary') storeString , '.'
				with: '_var2 := _var0 canRegister: _var1.').
	SStatementCoverage compileTestCase: testCase.
	self
		should: [ testCase run]
		raise: MessageNotUnderstood.
	[ SStatementCoverage executeStatements ]
		on: MessageNotUnderstood
		do: [ :exception | aException := exception ].
	self assert: (SMessageNotUnderstood canResolve: aException)
]

{ #category : #tests }
SMessageNotUnderstoodTest >> testSolveExceptionOf [
	| testCase aException |
	testCase := SSTestCase
		with: utility typeInfosOnPackageExamplesOthers first.
	testCase addMessage: #canRegister: from: #SEvent.
	SStatementCoverage
		coverageOf: [ | aConference aPerson |
			aConference := SConference new offerPrice: 95.
			aPerson := SStudent new name: 'Mary'.
			aConference canRegister: aPerson ]
		onPackagesMatching: 'SmallSuiteGenerator-Examples-Others'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_var0 := SEvent new.'
				with: '_var1 := ' , (SStudent new name: 'Mary') storeString , '.'
				with: '_var2 := _var0 canRegister: _var1.').self halt.
	SStatementCoverage compileTestCase: testCase.
	self
		should: [ SStatementCoverage executeStatements ]
		raise: MessageNotUnderstood.
	[ SStatementCoverage executeStatements ]
		on: Exception
		do: [ :exception | aException := exception ].
	self assert: (SMessageNotUnderstood canResolve: aException)
]
