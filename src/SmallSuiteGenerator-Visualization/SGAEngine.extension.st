Extension { #name : #SGAEngine }

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualize [
  | b |
  b := RTMondrian new.
  b shape rectangle
     withBorder;
     width: [:cls |  (cls fitnessByClass values first at: targetClassName) * 1.5 ];
     height: [:cls |  cls numberStatements * 1.5 ].
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
  b shape rectangle
	  noBorder;
     width: [":cls |"  1"(cls fitnessByClass values first at: targetClassName) * 1.5" ];
     height: [:cls |  cls numberStatements * 1.5 ].
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
  b shape verticalBezierLine.
  b edges moveBehind.
  b edges connectFromAll: [:testCase |  testCase parents ].
  "b normalizer normalizeColor: [:testCase |  [testCase fitness values first] on: Error do: [ 0 ] ] using: (Array with: Color black with: Color white)."
  b layout smallSuite.
  
  "b normalizer normalizeColorAsGray: [:testCase |  testCase fitness values first ]."
  ^ b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeWithRandomColor [
  | b |
  b := RTMondrian new.
  b shape rectangle
     withBorder;
     width: [:cls |  (cls fitnessByClass values first at: targetClassName) * 1.5 ];
     height: [:cls |  cls numberStatements * 1.5 ].
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
