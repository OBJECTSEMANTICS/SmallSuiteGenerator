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
	self class compile: ('performTest',aBlock body formattedCode)
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
SSTestRunner >> performTest| var [ |
var := Dictionary new.
var at: 1 put: RSChart new.
var at: 2 put: (var at: 1) colors.
var at: 4 put: ((var at: 1) yScale: (var at: 2)).
var at: 3 put: (var at: 1) open.
var at: 5 put: RSXLabelDecoration new.
var at: 6 put: ((var at: 1) addDecoration: (var at: 5)).
var at: 8 put: (var at: 6) show.
var at: 9 put: (var at: 5) initialize.
var at: 10 put: (var at: 6) colors.
var at: 11 put: (var at: 1) initializeDecorations.
var at: 12 put: (var at: 5) initialize.
var at: 13 put: RSScatterPlot new.
var at: 14 put: ((var at: 6) addPlot: (var at: 13)).
var at: 15 put: RSChart new.
var at: 16 put: ((var at: 13) chart: (var at: 14)).
var at: 17 put: (var at: 11) extent.
var at: 18 put: (var at: 15) colors.
var at: 19 put: (var at: 14) plots.
var at: 20 put: (var at: 6) mustInclude0inX.
var at: 21 put: (var at: 15) colors.
var at: 22 put: (var at: 6) colors.
var at: 23 put: (var at: 14) colors.
var at: 24 put: (var at: 11) plots.
var at: 25 put: RSScatterPlot new.
var at: 26 put: ((var at: 6) addPlot: (var at: 16)).
var at: 27 put: RSChart new.
var at: 28 put: RSChart new.
var at: 29 put: ((var at: 16) chart: (var at: 11)).
var at: 30 put: (var at: 27) extent.
var at: 31 put: (var at: 14) colors.
var at: 32 put: RSScatterPlot new.
var at: 33 put: ((var at: 27) addPlot: (var at: 32)).
var at: 34 put: RSChart new.
var at: 35 put: RSChart new.
var at: 36 put: ((var at: 25) chart: (var at: 35)).
var at: 37 put: (var at: 26) extent.
var at: 38 put: (var at: 34) colors.
var at: 39 put: (var at: 11) open.
var at: 40 put: (var at: 28) defaultPlotColors.
var at: 41 put: (var at: 6) plots.
var at: 42 put: (var at: 15) mustInclude0inX.
var at: 43 put: (var at: 35) colors.
var at: 44 put: (var at: 14) colors.
var at: 45 put: (var at: 14) colors.
var at: 46 put: (var at: 28) plots.
var at: 47 put: RSScatterPlot new.
var at: 48 put: ((var at: 27) addPlot: (var at: 47)).
var at: 49 put: RSChart new.
var at: 50 put: ((var at: 29) chart: (var at: 15)).
var at: 51 put: (var at: 49) extent.
var at: 52 put: (var at: 28) colors.
var at: 53 put: (var at: 27) colors.
var at: 54 put: (var at: 28) colors.
var at: 55 put: (var at: 35) plots.
var at: 56 put: ((var at: 27) addPlot: (var at: 50)).
var at: 57 put: RSChart new.
var at: 58 put: RSChart new.
var at: 59 put: ((var at: 29) chart: (var at: 33)).
var at: 60 put: (var at: 15) extent.
var at: 61 put: (var at: 14) colors.
var at: 62 put: (var at: 34) plots.
var at: 63 put: (var at: 58) mustInclude0inX.
var at: 64 put: (var at: 14) colors.
var at: 65 put: (var at: 56) colors.
var at: 66 put: (var at: 6) colors.
var at: 67 put: (var at: 11) plots.
var at: 70 put: ((var at: 48) addPlot: (var at: 16)).
var at: 71 put: RSChart new.
var at: 72 put: RSChart new.
var at: 73 put: ((var at: 13) chart: (var at: 48)).
var at: 74 put: (var at: 57) extent.
var at: 75 put: (var at: 6) colors.
var at: 76 put: ((var at: 26) addPlot: (var at: 16)).
var at: 77 put: ((var at: 32) chart: (var at: 27)).
var at: 78 put: (var at: 71) extent.
var at: 163 put: ((var at: 29) chart: (var at: 15)).
var at: 79 put: (var at: 1) colors.
var at: 80 put: (var at: 11) open.
var at: 81 put: (var at: 76) defaultPlotColors.
var at: 82 put: (var at: 56) plots.
var at: 7 put: (var at: 11) initializeDecorations.
var at: 68 put: (var at: 12) initialize.
var at: 69 put: (var at: 1) plots.
var at: 83 put: (var at: 76) initializeDecorations.
var at: 84 put: (var at: 68) initialize.
var at: 85 put: (var at: 15) plots.
var at: 87 put: ((var at: 58) addDecoration: (var at: 9)).
var at: 88 put: ((var at: 9) chart: (var at: 87)).
var at: 89 put: 15.
var at: 90 put: ((var at: 27) minValueY: (var at: 89)).
var at: 91 put: (var at: 14) ySqrt.
var at: 92 put: (var at: 76) plots.
var at: 93 put: 'Y Axis'.
var at: 94 put: ((var at: 27) ylabel: (var at: 93)).
var at: 95 put: ''.
var at: 96 put: ''.
var at: 97 put: ((var at: 72) ylabel: (var at: 95)).
var at: 98 put: (var at: 97) ySqrt.
var at: 99 put: (var at: 33) plots.
var at: 100 put: 'Hello World'.
var at: 101 put: ((var at: 90) ylabel: (var at: 96)).
var at: 102 put: ((var at: 7) ylabel: (var at: 100)).
var at: 103 put: (var at: 14) initializeDecorations.
var at: 104 put: (var at: 9) initialize.
var at: 105 put: (var at: 76) plots.
var at: 106 put: ((var at: 28) addDecoration: (var at: 84)).
var at: 107 put: RSChart new.
var at: 108 put: ((var at: 9) chart: (var at: 106)).
var at: 109 put: ((var at: 58) minValueY: (var at: 89)).
var at: 110 put: (var at: 48) ySqrt.
var at: 111 put: (var at: 76) plots.
var at: 112 put: 'Y Axis'.
var at: 114 put: ((var at: 33) ylabel: (var at: 95)).
var at: 115 put: ((var at: 11) ylabel: (var at: 95)).
var at: 116 put: (var at: 87) ySqrt.
var at: 117 put: (var at: 83) plots.
var at: 118 put: ((var at: 1) ylabel: (var at: 112)).
var at: 119 put: ''.
var at: 120 put: ((var at: 114) ylabel: (var at: 95)).
var at: 121 put: (var at: 57) initializeDecorations.
var at: 122 put: (var at: 84) initialize.
var at: 123 put: (var at: 120) plots.
var at: 124 put: (var at: 109) initializeDecorations.
var at: 125 put: (var at: 108) initialize.
var at: 126 put: (var at: 11) plots.
var at: 127 put: ((var at: 87) addDecoration: (var at: 104)).
var at: 128 put: ((var at: 5) chart: (var at: 115)).
var at: 129 put: 10.
var at: 130 put: ((var at: 26) minValueY: (var at: 129)).
var at: 131 put: (var at: 72) ySqrt.
var at: 132 put: (var at: 26) plots.
var at: 133 put: ((var at: 121) ylabel: (var at: 96)).
var at: 134 put: ''.
var at: 135 put: ''.
var at: 136 put: ((var at: 27) ylabel: (var at: 100)).
var at: 137 put: (var at: 90) ySqrt.
var at: 138 put: (var at: 83) plots.
var at: 139 put: ((var at: 94) ylabel: (var at: 135)).
var at: 162 put: (var at: 28) colors.
var at: 141 put: ((var at: 57) ylabel: (var at: 134)).
var at: 142 put: (var at: 109) initializeDecorations.
var at: 143 put: (var at: 122) initialize.
var at: 144 put: (var at: 57) plots.
var at: 146 put: ((var at: 49) addDecoration: (var at: 104)).
var at: 148 put: RSChart new.
var at: 149 put: ((var at: 9) chart: (var at: 136)).
var at: 150 put: ((var at: 56) minValueY: (var at: 129)).
var at: 151 put: (var at: 58) ySqrt.
var at: 152 put: (var at: 114) plots.
var at: 154 put: ''.
var at: 155 put: ((var at: 90) ylabel: (var at: 93)).
var at: 157 put: ((var at: 76) ylabel: (var at: 95)).
var at: 158 put: (var at: 102) ySqrt.
var at: 159 put: (var at: 7) plots.
var at: 160 put: ((var at: 107) ylabel: (var at: 154)).
var at: 161 put: ((var at: 148) ylabel: (var at: 119)).
^self analyze: thisContext
]

{ #category : #running }
SSTestRunner >> run: aSTestCase [
	self compile: aSTestCase parseTreeWithAssertions.
	self setTestSelector: #performTest.
	^ self run.
]

{ #category : #running }
SSTestRunner >> runWithoutAssertions: aSTestCase [
	self compile: aSTestCase parseTree.
	self setTestSelector: #performTest.
	^ self run.
]
