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
        
        ";
           heightElement: 1;
           color: [:line |  Color random ]"b nodes: testCase statements.
        b layout verticalLine gapSize: 0 ].
  b shape verticalBezierLine.
  b edges moveBehind.
  b edges connectFromAll: [:testCase |  testCase parents ].
  b layout smallSuite.
  
  "b normalizer normalizeColorAsGray: [:testCase |  testCase fitness values first ]."^b
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
