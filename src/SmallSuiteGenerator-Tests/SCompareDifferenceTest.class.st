Class {
	#name : #SCompareDifferenceTest,
	#superclass : #SExpressionTest,
	#instVars : [
		'fitness',
		'profiler'
	],
	#category : #'SmallSuiteGenerator-Tests-AST'
}

{ #category : #displaying }
SCompareDifferenceTest >> installOn: aPackageName [
	profiler := self aSLProfilerCoverage profilerForPackagesMatching: aPackageName.
	fitness profiler: profiler.
	profiler uninstall.
	profiler beforeProfiling 
]

{ #category : #running }
SCompareDifferenceTest >> setUp [ 
	super setUp.
	fitness := SStatementCoverage new.
]

{ #category : #tests }
SCompareDifferenceTest >> tearDown [
	profiler uninstall
]

{ #category : #tests }
SCompareDifferenceTest >> testDifferentBranchCoverage [
	| tests |
	self installOn: 'SpyLite-Scenario'.
	fitness targetClass: #SLCounter fullClassNameSymbol.
	tests := OrderedCollection new 
		add: (SSTestCase new addStatements:
			(self parse:
					'_var0 := SLCounter new.
					 _var1 := _var0 methWithDoubleCondition: 9.'); yourself);
		add: (SSTestCase new addStatements:
			(self parse:
					'_var0 := SLCounter new.
					 _var1 := _var0 methWithDoubleCondition: 0.'); yourself);
		yourself.
	fitness run: tests.
	self assert: (tests first differenceWith: tests second) equals: 3/4.
	self assert: (tests second differenceWith: tests first) equals: 3/4.
	
]

{ #category : #tests }
SCompareDifferenceTest >> testSameBranchCoverage [
	| tests |
	self installOn: 'SpyLite-Scenario'.
	fitness targetClass: #SLCounter fullClassNameSymbol.
	tests := OrderedCollection new 
		add: (SSTestCase new addStatements:
			(self parse:
					'_var0 := SLCounter new.
					 _var1 := _var0 methWithDoubleCondition: 9.'); yourself);
		add: (SSTestCase new addStatements:
			(self parse:
					'_var0 := SLCounter new.
					 _var1 := _var0 methWithDoubleCondition: 7.'); yourself);
		yourself.
	fitness run: tests.
	self assert: (tests first differenceWith: tests second) equals: 0
	
]

{ #category : #tests }
SCompareDifferenceTest >> testSomeSimilarBranchCoverage [
	| tests |
	self installOn: 'SpyLite-Scenario'.
	fitness targetClass: #SLCounter fullClassNameSymbol.
	tests := OrderedCollection new 
		add: (SSTestCase new addStatements:
			(self parse:
					'_var0 := SLCounter new.
					 _var1 := _var0 methWithDoubleCondition: 9.'); yourself);
		add: (SSTestCase new addStatements:
			(self parse:
					'_var0 := SLCounter new.
					 _var1 := _var0 methWithDoubleCondition: 11.'); yourself);
		yourself.
	fitness run: tests.
	self assert: (tests first differenceWith: tests second) equals: 1/4.
	self assert: (tests second differenceWith: tests first) equals: 1/4.
	
]

{ #category : #tests }
SCompareDifferenceTest >> testTotallyDifferentBranchCoverage [
	| tests |
	self installOn: 'SpyLite-Scenario'.
	fitness targetClass: #SLCounter fullClassNameSymbol.
	tests := OrderedCollection new 
		add: (SSTestCase new addStatements:
			(self parse:
					'_var0 := SLCounter new.
					 _var1 := _var0 one.'); yourself);
		add: (SSTestCase new addStatements:
			(self parse:
					'_var0 := SLCounter new.
					_var1 := _var0 anAssignment.'); yourself);
		yourself.
	fitness run: tests.
	self assert: (tests first differenceWith: tests second) equals: 1.
	self assert: (tests second differenceWith: tests first) equals: 1.
	
]
