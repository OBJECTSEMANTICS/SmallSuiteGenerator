Class {
	#name : #SSTestRunner,
	#superclass : #TestCase,
	#instVars : [
		'testCase',
		'invariants'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'test - instrumentation' }
SSTestRunner >> analyze: aSmalltalkContext [
	"it takes an snapshot of the thisContext object"
	| sContext |
	sContext := SSExecutionContext new.
	aSmalltalkContext tempNames
		doWithIndex:
			[ :varName :index | sContext at: varName put: (aSmalltalkContext namedTempAt: index) ].
	^ sContext
]

{ #category : #compiling }
SSTestRunner >> compile: aBlock [
	self class compile: ('performTest
	',aBlock body formattedCode)
]

{ #category : #compiling }
SSTestRunner >> compile: aBlock withName: symbol on: aClass [
	aClass
		compile: symbol asString , (String with: Character cr) , aBlock body formattedCode
]

{ #category : #running }
SSTestRunner >> evaluate: aSTestCase [
	| node |
	node := aSTestCase parseTree.
	node body
		addNode: (SPlatform rbParserClass parseExpression: '^ self analyze: thisContext').
	self compile: node.
	^ self performTest
]

{ #category : #initialization }
SSTestRunner >> initialize [
	invariants := OrderedCollection new
]

{ #category : #'as yet unclassified' }
SSTestRunner >> performTest [
	| var |
var := Dictionary new.
var at: 91 put: RSChart new.
var at: 2 put: (var at: 91) yLn.
var at: 3 put: -5.
var at: 4 put: ((var at: 91) minValueX: (var at: 3)).
var at: 5 put: 'Hello World'.
var at: 6 put: ((var at: 4) title: (var at: 5)).
var at: 7 put: ((var at: 6) ylabel: (var at: 5)).
var at: 8 put: (var at: 7) initializeDecorations.
var at: 1 put: (var at: 8) colors.
var at: 9 put: (var at: 91) extent.
var at: 10 put: (var at: 91) extent.
var at: 11 put: (var at: 6) yRawLog.
var at: 12 put: RSXLabelDecoration new.
var at: 13 put: ((var at: 7) addDecoration: (var at: 12)).
var at: 15 put: (var at: 6) decorations.
var at: 16 put: (var at: 8) colors.
var at: 17 put: (var at: 4) plots.
var at: 18 put: (var at: 7) show.
var at: 20 put: ((var at: 4) addDecoration: (var at: 12)).
var at: 21 put: (var at: 6) colors.
var at: 22 put: (var at: 8) decorations.
var at: 23 put: (var at: 13) defaultPlotColors.
var at: 24 put: (var at: 8) yLog.
var at: 25 put: RSChartTitleDecoration new.
var at: 26 put: ((var at: 91) addDecoration: (var at: 12)).
var at: 27 put: (var at: 4) xRawLog.
var at: 28 put: (var at: 20) colors.
var at: 29 put: ((var at: 8) yScale: (var at: 11)).
var at: 31 put: ((var at: 13) maxValueY: (var at: 3)).
var at: 33 put: ((var at: 27) minValueY: (var at: 3)).
var at: 34 put: (var at: 8) plots.
var at: 35 put: (var at: 6) colors.
var at: 37 put: ((var at: 4) addDecoration: (var at: 25)).
var at: 38 put: (var at: 8) decorations.
var at: 39 put: (var at: 27) xLinear.
var at: 40 put: (var at: 8) extent.
var at: 41 put: ((var at: 37) minValueY: (var at: 3)).
var at: 42 put: (var at: 91) minValueY.
var at: 19 put: (var at: 13) colors.
var at: 32 put: (var at: 26) colors.
var at: 36 put: (var at: 27) plots.
var at: 43 put: (var at: 4) mustInclude0inY.
var at: 44 put: (var at: 4) yLog.
var at: 45 put: (var at: 7) extent.
var at: 46 put: (var at: 13) colors.
var at: 47 put: (var at: 91) decorations.
var at: 48 put: (var at: 91) mustInclude0inY.
var at: 49 put: (var at: 33) yLog.
var at: 50 put: (var at: 8) extent.
var at: 51 put: (var at: 4) colors.
var at: 52 put: (var at: 91) decorations.
var at: 53 put: (var at: 4) extent.
var at: 54 put: (var at: 6) open.
var at: 55 put: (var at: 8) decorations.
var at: 56 put: RSXLabelDecoration new.
var at: 57 put: ((var at: 48) title: (var at: 5)).
var at: 58 put: ((var at: 7) maxValueX: (var at: 3)).
var at: 60 put: ((var at: 56) title: (var at: 5)).
var at: 62 put: (var at: 58) open.
var at: 63 put: (var at: 37) decorations.
var at: 64 put: (var at: 57) plots.
var at: 65 put: (var at: 41) open.
var at: 67 put: ((var at: 60) chart: (var at: 7)).
var at: 68 put: (var at: 4) mustInclude0inX.
var at: 69 put: (var at: 60) initialize.
var at: 70 put: (var at: 91) xLog.
var at: 72 put: ((var at: 58) xScale: (var at: 44)).
var at: 73 put: (var at: 91) niceGenerator.
var at: 74 put: (var at: 27) yLn.
var at: 30 put: ((var at: 13) ylabel: (var at: 5)).
var at: 14 put: (var at: 13) initialize.
var at: 59 put: (var at: 31) maxValueX.
var at: 71 put: ((var at: 67) chart: (var at: 26)).
var at: 75 put: ((var at: 12) offset: (var at: 42)).
var at: 83 put: (var at: 4) mustInclude0inX.
var at: 76 put: (var at: 27) numberOfPlots.
var at: 77 put: (var at: 69) initialize.
var at: 82 put: ((var at: 13) ylabel: (var at: 5)).
var at: 80 put: ((var at: 7) addDecoration: (var at: 56)).
var at: 81 put: ((var at: 43) addDecoration: (var at: 67)).
^self analyze: thisContext
]

{ #category : #running }
SSTestRunner >> run: aSTestCase [
	testCase := aSTestCase.
	self compile: aSTestCase parseTreeWithAssertions.
	self setTestSelector: #performTest.
	^ self run.
]

{ #category : #running }
SSTestRunner >> runCase [
	self resources do: [:each | each availableFor: self].
	[[self setUp.
	self performTest.
	testCase hasErrors: false]
    on: Error
	 do: [ testCase hasErrors: true]] ensure: [
		self tearDown.
		self cleanUpInstanceVariables]
]

{ #category : #running }
SSTestRunner >> runWithoutAssertions: aSTestCase [
	testCase := aSTestCase.
	self compile: aSTestCase parseTree.
	self setTestSelector: #performTest.
	^ self run.
]
