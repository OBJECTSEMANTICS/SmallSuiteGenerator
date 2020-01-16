Extension { #name : #SGAEngine }

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualize [
  | b |
  b := RTMondrian new.
  b shape rectangle
     withBorder;
     width: [:cls |  (cls fitnessByClass values first at: targetClassName) * 2 ];
     height: [:cls |  cls numberStatements * 2 ].
  b nodes: selectionStrategy allPopulation"(logs flatCollect: #population)".
 	b shape verticalBezierLine.
  b edges moveBehind.
 
  
  "b edges connectFrom: [:testCase |  testCase parents ].
  b shape
     bezierLineFollowing: [:testCase |  testCase parents ];
     color: Color blue trans.
  b edges
     notUseInLayout;
     connectTo: [:testCase |  testCase childs ]."b edges connectFromAll: [:testCase |  testCase parents ].
  b layout tree.
	b build.
  b normalizer normalizeColorAsGray: [:testCase |  testCase fitness values first ].
  
  "cluster"
  "b normalizer normalizeColorAsGray: [ :cls | cls numberOf ]"^b
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualizeGraph [
  | view |
  view := RTView new.
  view addAll: (RTBox elementsOn: (logs flatCollect: #population)) @ RTDraggable.
  
  "collect: #childs"RTEdgeBuilder new
     view: view;
     objects: (logs flatCollect: #population);
     connectFromAll: #parents to: #yourself.
  
  "collect: #childs"RTTreeLayout on: view elements edges: view edges.
  view @ RTDraggableView.
  view edges do: [:e |  e trachelShape pushBack ].
  ^view
]
