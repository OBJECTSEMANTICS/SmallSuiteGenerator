Class {
	#name : #SKiviatBuilder,
	#superclass : #RTKiviatBuilder,
	#category : #'SmallSuiteGenerator-Visualization'
}

{ #category : #'as yet unclassified' }
SKiviatBuilder >> executeHighlightLowColor: lowColor highColor: highColor [
| titles |
"define the alpha values of the highlighted and others chart nodes to the view"
	
	( axisTitle = #activated ) ifTrue: [ 
		"for now this way to recover the axis Titles elements in the view is not really clean, but because of using RTAxisRenderer to create the axis and titles in the same time I did not found a way to get only the title element from it."
		titles := OrderedCollection new.
		self kiviatMetrics do: [ :m | titles add: (view elements detect: [ :e |  (e shape isKindOf: RTLabel) and: [ (e trachelShape text) = (m named) ] ])].
		 ].
	
	((kiviatNodes flatCollect: [ :kn | kn nodeKiviatElements]) asGroup) do: [  :e | 
		e @ (RTShowLabel new labelledInteraction: (RTLabeled new text: [ :el | el kiviatNode named])).
		].
	
	((kiviatNodes flatCollect: [ :kn | kn nodeKiviatElements]) asGroup)  when: TRMouseEnter do: [  :evt | 
		|els edges |
		els := OrderedCollection new.
		edges := OrderedCollection new.
		(kiviatNodes select: [ :kn | kn named = evt element model kiviatNode named ]) do: [ :kn |
			kn nodeKiviatElements do: [ :e | 
				self recordElement: e.
				(e model value = evt element model value) ifTrue: [ e trachelShape color: (e trachelShape color alpha: highColor) ] ifFalse: [ e trachelShape color: (e trachelShape color alpha: lowColor) ]  ].
			
			kn edgeKiviatElements do: [ :e | 
				| selected |
				self recordElement: e. 
				selected := e from model value = evt element model value.
				e trachelShape color: (e trachelShape color alpha: (selected ifTrue: [highColor] ifFalse: [lowColor])).
				selected ifTrue: [ 
					els add: e to.
					e to trachelShape color: (e to trachelShape color alpha: highColor).
					els addAll: (self highlightParents: e to with: highColor).
					edges addAll: (self highlightEdges: e from with: highColor).
				]
			].
		].
		(kiviatNodes select: [ :kn | kn named ~= evt element model kiviatNode named ]) do: [ :kn |
			"kn nodeKiviatElements do: [ :e | self recordElement: e. e trachelShape color: (e trachelShape color alpha: lowColor)]."
			kn nodeKiviatElements do: [:e | self recordElement: e. 
				(els includes: e) ifFalse: [ 
				e trachelShape color: (e trachelShape color alpha: lowColor)]].
			kn edgeKiviatElements do: [ :e | self recordElement: e. 
				(edges includes: e) ifFalse: [ 
				e trachelShape color: (e trachelShape color alpha: lowColor)]]
			].
		( axisTitle = #activated ) ifTrue: [ titles do: [ :t | t trachelShape color: (t trachelShape color alpha: 0)]].
		view signalUpdate.
		].
	
	((kiviatNodes flatCollect: [ :kn | kn nodeKiviatElements]) asGroup) when: TRMouseLeave do: [  :evt | 
		kiviatNodes do: [ :kn |
			kn nodeKiviatElements do: [ :e | e trachelShape color: (e attributes at: #originalColor)].
			kn edgeKiviatElements do: [ :e | e trachelShape color: (e attributes at: #originalColor)].
			view signalUpdate].
		( axisTitle = #activated ) ifTrue: [ titles do: [ :t | t trachelShape color: (t trachelShape color alpha: 1)]].
		view signalUpdate.
		]. 
]

{ #category : #'as yet unclassified' }
SKiviatBuilder >> highlightEdges: element with: highColor [
	| parents edges |
	edges := OrderedCollection new.
	parents := element model value parents.
	parents ifNotEmpty: [ 
		kiviatNodes do: [ :kn | 
			kn edgeKiviatElements select: [ :e | parents includes: e from model value ]
			thenDo: [ :e | 
				edges add: e.
				e trachelShape color: (e trachelShape color alpha: highColor).
				edges addAll: (self highlightEdges: e from with: highColor) ] 
		]
	].
	^ edges
]

{ #category : #'as yet unclassified' }
SKiviatBuilder >> highlightParents: element with: highColor [
	| parents  els |
	els := OrderedCollection new.
	parents := element model value parents.
	parents ifNotEmpty: [ 
		kiviatNodes do: [ :kn | 
			kn nodeKiviatElements select: [ :e | parents includes: e model value ]
			thenDo: [ :e | 
				els add: e.
				e trachelShape color: (e trachelShape color alpha: highColor).
				els addAll: (self highlightParents: e with: highColor) ] 
		]
	].
	^ els
]

{ #category : #accessing }
SKiviatBuilder >> node: anRTKiviatNode [
"a chart node is represented by a set of elements according to the metrics values and connected by edges.
 Finish the creation of a chart node, creating elements in the view and edges."
| nodeElems edgeElems shapeNode shapeEdge prevElements  |

	kiviatNodes add: anRTKiviatNode.
	nodeElems := OrderedCollection new.
	edgeElems := OrderedCollection new.
	
	shapeNode := (shapes isNil) ifFalse: [ RTEllipse new color:(shapes at: (kiviatNodes indexOf: anRTKiviatNode)); size: 10 ] ifTrue: [ anRTKiviatNode shapeNode ] .
	shapeEdge := anRTKiviatNode shapeEdge. 
	
	kiviatMetrics do: [ :m |
		nodeElems add: ((shapeNode) elementOn: ( RTKiviatElement new metric:(m block); position: (m modelBlock value: (self getNormalizedValue: (anRTKiviatNode arrayValues at: (kiviatMetrics indexOf: m)) min: 0  max: (m maxSize)  minValue: 0  maxValue:(m maxValue))); kiviatNode: anRTKiviatNode; value: (anRTKiviatNode named at: (kiviatMetrics indexOf: m) "anRTKiviatNode named"))).
		].
	prevElements := kiviatNodes flatCollect: #nodeKiviatElements.
	anRTKiviatNode addNodeElements: nodeElems "(prevElements select: [ :elm | pts includes: elm model value ])".
	nodeElems do: [ :elm | 
		| parents |
		parents := elm model value parents.
		prevElements select: [ :prevElm | parents includes: prevElm model value ]	
			thenDo: [ :prevElm | edgeElems add: ((RTEdge from: elm to: (prevElm)) + (shapeEdge color: (elm trachelShape color))) ].
	].
	anRTKiviatNode addEdgeElements: edgeElems.
	
	
	"anRTKiviatNode addNodeElements: nodeElems.	
		
	nodeElems allButLast do: [ :e | edgeElems add: ((RTEdge from: e to: (nodeElems after:e)) + (shapeEdge color: (e trachelShape color)))]. 
	edgeElems add: ((RTEdge from: (nodeElems last) to: (nodeElems first)) + (shapeEdge color: (nodeElems first trachelShape color))).
	
	anRTKiviatNode addEdgeElements: edgeElems.	"
	
	nodeElems do: [  :e | 
		"e model position do: [ :pos | e translateBy: pos ]."
		e translateBy: (e model position) ].
]
