Extension { #name : #SGAEngine }

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualize [
  | b |
  b := RTMondrian new.
  b shape rectangle
     withBorder;
     width: [:cls |  (cls fitnessByClass values first at: targetClassName) * 1.5 ];
     height: [:cls |  cls length * 1.5 ].
  b nodes: (logs flatCollect: #population) forEach: [:testCase |  b shape smallSuiteBox.
  b nodes: testCase statements.
        b layout verticalLine gapSize: 0 ].
  b shape verticalBezierLine.
  b edges moveBehind.
  b edges connectFromAll: [:testCase |  testCase parents ].
  b layout smallSuite.
  
  "b normalizer normalizeColorAsGray: [:testCase |  testCase fitness values first ]."^b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeM [
  | b es |
  b := RTMondrian new.
  b interaction highlight.
  "b shape rectangle
	  noBorder;
     width: [:cls |  (cls fitnessByClass values first at: targetClassName) * 1.5 ];
     height: [:cls |  cls length * 1.5 ]."
  es := b nodes: (logs flatCollect: #population) forEach: [:testCase |  
	| shape stmts |
	shape := RTCompositeShape new.
   b shape: shape.
   b shape add: (RTBox new color: #mutantColor; width: 1; height: 1);
	add: (RTBox new color: #stmColor; width: 6; height: 1);
	horizontal.
	"b shape width: [ :cls | 5 ];
   height: [ :cls | 6 ]."
   stmts := b nodes: testCase statements.
   stmts @ (RTHighlightable highlight: [:stm | stm allParents]).
        b layout verticalLine gapSize: 0 ].
   es @ (RTHighlightable highlight: [:testCase | 
	testCase allParents
	]).
  es do: [:el | el width: 10; height: (el model length * 2)"; color: Color white"].
  b shape verticalBezierLine.
  b edges moveBehind.
  b edges connectFromAll: [:testCase |  testCase parents ].
  b normalizer normalizeColor: [:testCase |  [testCase fitness values first] on: Error do: [ :e | self halt. 0 ] ] using: (Array with: Color white with: Color black).
  b layout smallSuite.
  
  "b normalizer normalizeColorAsGray: [:testCase |  testCase fitness values first ]."
  ^ b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeMatrix [
  | b es |
  	b := RTMondrian new.
  	b interaction highlight.
  	"b shape rectangle
	  noBorder;
     width: [:cls |  (cls fitnessByClass values first at: targetClassName) * 1.5 ];
     height: [:cls |  cls length * 1.5 ]."
  	es := b nodes: (logs flatCollect: #population) forEach: [:testCase |  
		| shape stmts |
		shape := RTCompositeShape new.
   		b shape: shape.
   		b shape add: (RTBox new color: #mutantColor; width: 1; height: 1);
		add: (RTBox new color: #stmColor; width: 6; height: 1);
		horizontal.
   		stmts := b nodes: testCase statements.
   		stmts @ (RTHighlightable highlight: [:stm | stm allParents]).
      b layout verticalLine gapSize: 0 
	].

   es @ (RTHighlightable highlight: [:testCase | testCase allParents ]).
  	es do: [:el | el width: 10; height: (el model length * 2)"; color: Color white"].
  	b shape verticalBezierLine.
  	b edges moveBehind.
  	b edges connectFromAll: [:testCase |  testCase parents ].
	b normalizer elements: es.
  	b normalizer normalizeColor: [:testCase | testCase fitness values first ] 
	using: (Array with: Color black with: Color white).
  	b layout smallSuite.
  ^ b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeMatrixP [
  | b es generations |
  generations := numberOfGenerations + 1.
  b := RTMondrian new.
  b interaction highlight.
  es := b nodes: ((logs flatCollect: #population) select: [:tC | (tC ni = generations or: [ tC allChildren detect: [:tCe |  tCe ni = generations ] ifFound: [ true ] ifNone: [ false ]])])
"((logs flatCollect: #population) select: [:tC |  tC allChildren detect: [:tCe |  tCe ni = generations ] ifFound: [ true ] ifNone: [ false ] ])" forEach: [:testCase |  | shape stmts |
        shape := RTCompositeShape new.
        b shape: shape.
        b shape
           add: (RTBox new
                 color: #mutantColor;
                 width: 1;
                 height: 1);
           add: (RTBox new
                 color: #stmColor;
                 width: 6;
                 height: 1);
           horizontal.
        stmts := b nodes: testCase statements.
        stmts @ (RTHighlightable highlight: [:stm |  stm allParents ]).
        b layout verticalLine gapSize: 0 ].
  es @ (RTHighlightable highlight: [:testCase |  testCase allParents ]).
  es do: [:el |  el
           width: 10;
           height: el model length * 2
        "; color: Color white" ].
  b shape verticalBezierLine.
  b edges moveBehind.
  b edges connectFromAll: [:testCase |  testCase parents ].
  b normalizer elements: es.
  b normalizer normalizeColor: [:testCase |  testCase fitness values first ] using: (Array with: Color black with: Color white).
  b layout smallSuite.
  ^b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeRadial [
  | b es firstPopulation root |
  b := RTMondrian new.
  b interaction highlight.
  root := SSTestCase with: typeInfo.
  root addTargetClassName: targetClassName; generateStatements.
  firstPopulation := logs first population.
  firstPopulation do: [ :testCase | testCase addParent: root ].
  es := b nodes: ((Array with: root), (logs flatCollect: #population)) forEach: [:testCase |  
	| shape stmts |
	shape := RTCompositeShape new.
   b shape: shape.
   b shape add: (RTBox new color: #mutantColor; width: 1; height: 1);
	add: (RTBox new color: #stmColor; width: 6; height: 1);
	horizontal.
   stmts := b nodes: testCase statements.
   stmts @ (RTHighlightable highlight: [:stm | stm allParents]).
        b layout verticalLine gapSize: 0 ].
   es @ (RTHighlightable highlight: [:testCase | 
	testCase allParents
	]).
  es do: [:el | el width: 10; height: (el model length * 2)"; color: Color white"].
  b shape verticalBezierLine.
  b edges moveBehind.
  b edges connectFromAll: [:testCase |  testCase parents ].
  b layout radial.
  ^ b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeRadial1 [
  | es view shape |
  "b := RTMondrian new.
  b interaction highlight."
  view := RTView new.
  shape :=  RTEllipse new.
   "es := b nodes: (logs flatCollect: #population)."
  es := shape elementsOn: (logs flatCollect: #population).
   "es := b nodes:  (logs flatCollect: #population) forEach: [:testCase |  
	| shape stmts |
	shape := RTCompositeShape new.
   b shape: shape.
   b shape add: (RTBox new color: #mutantColor; width: 1; height: 1);
	add: (RTBox new color: #stmColor; width: 6; height: 1);
	horizontal.
   stmts := b nodes: testCase statements.
   stmts @ (RTHighlightable highlight: [:stm | stm allParents]).
        b layout verticalLine gapSize: 0 ]."
   es @ (RTHighlightable highlight: [:testCase | 
	testCase allParents
	]).
  es do: [:el | el width: 10; height: (el model length * 2)"; color: Color white"].
  view addAll: es.
  RTEdgeBuilder new 
     view: view; elements: es; connectFrom: [ :testCase | [randomGenerator selectAtRandom: testCase parents] on: Error do: [ testCase parents ]  ]; moveBehind.
  SRadialTreeLayout new on: es.
  "view edges do: #remove."
  ^ view
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeRadial2 [
  	| b objects limit |
	b := RTKiviatBuilder new.
	objects := logs flatCollect: #population.
  limit := populationSize + (populationSize \\ 2 ).
	b objects: objects.
	"b addMetric: [ :o | 
		o collect: #idPopulation  ]."
	(1 to: limit ) do: [:e| 
		b addMetric: [:v | 
			v  ni ]].
	"b objects: (Array with: 'object1' -> ((1 to: 25) collect: [:i |  i atRandom ]) with: 'object2' -> ((1 to: 25) collect: [:i |  i atRandom ])).
b shapes: ((Array with: Color blue with: Color red) do: [:c |  c alpha: 0.3 ]).
(1 to: 25) doWithIndex: [:ei :i |  b addMetric: [:e |  e idPopulation ] ]."
   b build.
   "b view edges do: #remove."
   ^ b view
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeRadial3 [
  	| b objects limit |
	b := SKiviatBuilder new.
	objects := logs collect: #population.
  limit := populationSize + (populationSize \\ 2 ).
	b objects: objects.
	b shape size: [ :e | e model value fitness values first ].
	b shapes: ((RTColorPalette qualitative 
		colors: (numberOfGenerations + 1) scheme: 'Paired') do: [:c |  c alpha: 0.3 ]).
	1 to: limit do: [:i | 
		b addMetric: [ :o | 
		(o at: i) ni ] ].
   "b desactivateHighlight."
	"b objects: (Array with: 'object1' -> ((1 to: 25) collect: [:i |  i atRandom ]) with: 'object2' -> ((1 to: 25) collect: [:i |  i atRandom ])).
b shapes: ((Array with: Color blue with: Color red) do: [:c |  c alpha: 0.3 ]).
(1 to: 25) doWithIndex: [:ei :i |  b addMetric: [:e |  e idPopulation ] ]."
   b build.
	b view elements select: [:el | el shape isKindOf: RTLabel ] thenDo: #remove.
   "b view edges do: #remove."
   ^ b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeRadial3P [
  | b objects limit generations |
  b := SKiviatBuilder new.
  generations := numberOfGenerations + 1.
  objects := (logs flatCollect: #population) select: [:tC |  tC ni = generations or: [ tC allChildren detect: [:tCe |  tCe ni = generations ] ifFound: [ true ] ifNone: [ false ] ] ].
  limit := populationSize + (populationSize \\ 2).
  b objects: objects.
  b shape size: [:e |  e model value fitness values first ].
  b shapes: ((RTColorPalette qualitative colors: numberOfGenerations + 1 scheme: 'Paired') do: [:c |  c alpha: 0.3 ]).
  1 to: limit do: [:i |  b addMetric: [:o |  (o at: i) ni ] ].
  b build.
  b view elements select: [:el |  el shape isKindOf: RTLabel ] thenDo: #remove.
  ^b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeRadial4 [
  	| b objects limit |
	b := SKiviatBuilder new.
	objects := logs flatCollect: #population.
  limit := populationSize + (populationSize \\ 2 ).
	b objects: objects.
	1 to: limit do: [:i | 
		b addMetric: [ :o | 
		"(o at: i)"o ni ]].
   "b desactivateHighlight."
	"b objects: (Array with: 'object1' -> ((1 to: 25) collect: [:i |  i atRandom ]) with: 'object2' -> ((1 to: 25) collect: [:i |  i atRandom ])).
b shapes: ((Array with: Color blue with: Color red) do: [:c |  c alpha: 0.3 ]).
(1 to: 25) doWithIndex: [:ei :i |  b addMetric: [:e |  e idPopulation ] ]."
   b build.
   "b view edges do: #remove."
   ^ b view
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeRadialModified [
  | b es |
  b := RTMondrian new.
  b interaction highlight.
  es := b nodes: (logs flatCollect: #population) forEach: [:testCase |  
	| shape stmts |
	shape := RTCompositeShape new.
   b shape: shape.
   b shape add: (RTBox new color: #mutantColor; width: 1; height: 1);
	add: (RTBox new color: #stmColor; width: 6; height: 1);
	horizontal.
   stmts := b nodes: testCase statements.
   stmts @ (RTHighlightable highlight: [:stm | stm allParents]).
        b layout verticalLine gapSize: 0 ].
   es @ (RTHighlightable highlight: [:testCase | 
	testCase allParents
	]).
  es do: [:el | el width: 10; height: (el model length * 2)"; color: Color white"].
  b shape verticalBezierLine.
  b edges moveBehind.
  b edges connectFromAll: [:testCase |  testCase parents ].
  b layout radial.
  ^ b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeWithRandomColor [
  | b |
  b := RTMondrian new.
  b shape rectangle
     withBorder;
     width: [:cls |  (cls fitnessByClass values first at: targetClassName) * 1.5 ];
     height: [:cls |  cls length * 1.5 ].
  b nodes: (logs flatCollect: #population) forEach: [:testCase |  b shape rectangle
           heightElement: 1;
           color: [:line |  Color random ].
        b nodes: testCase statements.
        b layout verticalLine gapSize: 0 ].
  b shape verticalBezierLine.
  b edges moveBehind.
  b edges connectFromAll: [:testCase |  testCase parents ].
  b layout smallSuite.
  
  "b normalizer normalizeColorAsGray: [:testCase |  testCase fitness values first ]."^b
]
