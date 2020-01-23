Extension { #name : #SGAEngine }

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualize [
  | b |
  b := RTMondrian new.
  b shape rectangle
     withBorder;
     width: [:cls |  (cls fitnessByClass values first at: targetClassName) * 2 ];
     height: [:cls |  cls numberStatements * 2 ].
  b nodes: (logs flatCollect: #population).
  b shape verticalBezierLine.
  b edges moveBehind.
  b edges connectFromAll: [:testCase |  testCase parents ].
  b layout smallSuite.
  b normalizer normalizeColorAsGray: [:testCase |  testCase fitness values first ].
  ^b
]
