Class {
	#name : #SRadialTreeLayout,
	#superclass : #RTRadialTreeLayout,
	#category : #'SmallSuiteGenerator-Visualization'
}

{ #category : #algorithm }
SRadialTreeLayout >> computePosition: aNode [
	| children neighbor nodeA |
	
	children :=self childrenFor: aNode.
	neighbor := self leftSiblingOf: aNode.
	children isEmpty ifTrue: [ neighbor isNil ifTrue: [ self xOf: aNode put: 0. self modOf: aNode put: 0. ]  
		
											 ifFalse: [ self xOf: aNode put: ((self xOf: neighbor) + (horizontalGap /(self layerOf: aNode) /2)). self modOf: aNode put: ((self modOf: neighbor)).
													 self pointerOf: aNode put: (self followRightContour: neighbor toLayer: ((self layerOf: aNode) + 1)) ] ]
					 
					 ifFalse: [ self leftContourOf: aNode put: children first.
									self rightContourOf: aNode put: children last.
							  children do: [:e | self computePosition: e ].
							      self xOf: aNode put: ((self xOf: ( self leftContourOf: aNode ) ) + ( self xOf: ( self rightContourOf: aNode ) ) + (self modOf: ( self rightContourOf: aNode ) ) ) / 2. 
										self modOf: aNode put: 0. 
								neighbor isNil ifFalse: [ self modOf: aNode put: (self compareContourOf: aNode with: neighbor).
									
													  nodeA := (self followLeftContour: (self fatherOf: aNode) toLayer: (self layerOf: aNode)).
													  [(self followLeftContour: nodeA toLayer: ((self layerOf: nodeA) + 1)) isNil ] whileFalse: [ nodeA := self followLeftContour: nodeA toLayer: ((self layerOf: nodeA) + 1) ].
													 self pointerOf: nodeA put: (self followLeftContour: aNode toLayer: ((self layerOf: nodeA) + 1)).
													
													 nodeA := self followRightContour: aNode toLayer: ((self layerOf: aNode) + 1).
													nodeA ifNil: [ ^ self ].
													 [(self followRightContour: nodeA toLayer: ((self layerOf: nodeA) + 1)) isNil ] whileFalse: [ nodeA := self followRightContour: nodeA toLayer: ((self layerOf: nodeA) +1) ].
													self pointerOf: nodeA put: (self followRightContour: neighbor toLayer: ((self layerOf: nodeA) + 1) ) ] ]. 
											
]

{ #category : #hook }
SRadialTreeLayout >> doExecute: nodeElements [

	| rootNodes xOffset maximumRadius | 
	initialLayout isNil
		ifFalse: [ initialLayout new executeOnElements: nodeElements ].
	rootNodes := self rootNodesFor: nodeElements.
	rootNodes
		do: [ :e | self initialize: e whoseFatherIs: nil ];
		do: [ :e | self computePosition: e. self step];
		do: [ :e | self computeGap: e ];
		do: [ :e | self toRadialTree: e withMod: 0 ].
	xOffset := 0.
	rootNodes
		do: [ :e | 
			maximumRadius := self radialDraw: e.
			"Shifting all the subgroups"
			self shiftTree: e by:  (maximumRadius+xOffset)@maximumRadius.
			xOffset := xOffset + (2 * maximumRadius) + 10.  ].


]

{ #category : #algorithm }
SRadialTreeLayout >> getAbcissaOf: aNode inSubtreeFromLayer: anInteger [

	| node x |
	
	(anInteger <= 0) ifTrue: [^ self getAbcissaOf: aNode inSubtreeFromLayer: 1 ].
	
	((self layerOf: aNode) = anInteger ) ifTrue: [ ^ self xOf: aNode ].
	((self layerOf: aNode) < anInteger ) ifTrue: [ ^ nil ].
	
	x := (self xOf: aNode) + (self modOf: aNode).
	
	node := self fatherOf: aNode.
	
	[(self layerOf: node) = anInteger  ] whileFalse: [ x := x + (self modOf: node).
									node := self fatherOf: node ].
								
	^ x
]

{ #category : #'initialize-release' }
SRadialTreeLayout >> initialize: aNode whoseFatherIs: another [ 

	self fatherOf: aNode put: another.
	
	another isNil ifTrue: [ self layerOf: aNode put: 1 ] ifFalse: [ self layerOf: aNode put: (self layerOf: another) + 1 ] .
	
	( self childrenFor: aNode ) do: [ :e | self initialize: e whoseFatherIs: aNode ]
]
