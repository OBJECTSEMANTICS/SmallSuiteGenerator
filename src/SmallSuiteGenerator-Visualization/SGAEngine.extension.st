Extension { #name : #SGAEngine }

{ #category : #'*SmallSuiteGenerator-Visualization' }
SGAEngine >> visualize [
  | b nodes|
  b := RTMondrian new.
  b shape rectangle
     withBorder;
     width: [:cls |  (cls fitnessByClass values first at: targetClassName) * 2 ];
     height: [:cls |  cls numberStatements * 2 ].
	
  b nodes: logs forEach:[:each|
			nodes :=  nodes.
	
	].


 	b shape verticalBezierLine.
  b edges moveBehind.
 
  
  "b edges connectFrom: [:testCase |  testCase parents ].
  b shape
     bezierLineFollowing: [:testCase |  testCase parents ];
     color: Color blue trans.
  b edges
     notUseInLayout;
     connectTo: [:testCase |  testCase childs ]."b edges connectFromAll: [:testCase |  testCase parents ].
  "b layout tree."
"b build."
  nodes do:[:n |
			n translateTo: (n model number * 100 @ (n model ni * 100+100)).
	].
  b normalizer normalizeColorAsGray: [:testCase |  testCase fitness values first ].
	b inspect.
	nodes do:[:n |
			n translateTo: (n model number * 10 @ (n model ni * 10+20)).
	].
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
