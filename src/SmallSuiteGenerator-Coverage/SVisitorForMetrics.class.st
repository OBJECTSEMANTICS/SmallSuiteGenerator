Class {
	#name : #SVisitorForMetrics,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'methodEntity',
		'numberOfConditionals',
		'booleanOperators',
		'cyclomaticNumber',
		'consideredBlocks',
		'blockId'
	],
	#category : #'SmallSuiteGenerator-Coverage'
}

{ #category : #'instance creation' }
SVisitorForMetrics class >> for: aMethod [
	^ self new
		processMethod: aMethod;
		yourself
]

{ #category : #initialization }
SVisitorForMetrics >> computeCyclomaticNumber: sel [
	"The following equations defined McCabe Cyclomatic Complexity:

	     1.The number of regions in a flow graph. 
     		2.V(G) = E - N + 2, where E are the edges and N are the nodes. 
     		3.V(G) = P + 1, where P are the predicate nodes. 

	The score is basically the number of decision points in a routine + 1. Decision points 
	are taken to be	conditionals and loops."

	| branches loops |
	branches := #(#ifTrue: #ifFalse: #ifTrue:ifFalse: #ifFalse:ifTrue: #ifNil: #ifNil:ifNotNil: #ifNotNil:ifNil: #ifNotNil: #ifEmpty:ifNotEmpty: #ifNotEmpty:ifEmpty: #ifEmpty: #ifNotEmpty:  #at:ifAbsent: #at:ifAbsentPut: #detect:ifNone: #on:do: "#and: #or: #xor:").
	loops := #(#whileTrue: #whileTrue #whileFalse #whileFalse: #timesRepeat: #to:do: #do:separatedBy: #do: #collect: #select: #reject: #inject:into: #detect: #detect:ifNone: #anySatisfy: #allSatisfy: #piecesCutWhere:).	"-- please not that #detect:ifNone: is listed twice because it is both loop and branch!!! -- akuhn"
	(branches includes: sel) ifTrue: [ cyclomaticNumber := cyclomaticNumber + 1.
		consideredBlocks add: blockId ].
	(loops includes: sel) ifTrue: [ cyclomaticNumber := cyclomaticNumber + 1.
		consideredBlocks add: blockId ].
	"-- HERE STARTS THE OLD ERRORFUL IMPL --"
	"(#(#or: #and: #xor: #& #|) includes: sel)
		ifTrue: [ booleanOperators := booleanOperators + 1.
			^ self ].
	(#(#ifTrue: #ifFalse: #ifTrue:ifFalse: #ifFalse:ifTrue: #whileTrue #whileTrue: #whileFalse #whileFalse:) includes: sel) ifTrue: [ booleanOperators := 0 ]"
]

{ #category : #initialization }
SVisitorForMetrics >> cyclomaticNumber [
	
	^cyclomaticNumber
]

{ #category : #initialization }
SVisitorForMetrics >> initialize [
	
	super initialize.
	self resetMetricValues
]

{ #category : #initialization }
SVisitorForMetrics >> methodEntity [
	^ methodEntity
]

{ #category : #initialization }
SVisitorForMetrics >> methodEntity: aMethodEntity [
	methodEntity := aMethodEntity
]

{ #category : #initialization }
SVisitorForMetrics >> numberOfConditionals [
	
	^numberOfConditionals
]

{ #category : #initialization }
SVisitorForMetrics >> numberOfConditionals: anObject [
	
	numberOfConditionals := anObject
]

{ #category : #initialization }
SVisitorForMetrics >> processMethod: aMethodEntity [
	self methodEntity: aMethodEntity.
	(aMethodEntity methodClass parseTreeFor: aMethodEntity selector) ifNotNil: [ :parseTree | self visitMethodNode: parseTree ]
]

{ #category : #initialization }
SVisitorForMetrics >> resetMetricValues [
	numberOfConditionals := 0.
	booleanOperators := 0.
	cyclomaticNumber := 1.
	consideredBlocks := OrderedCollection newFrom: #(1).
	blockId := 0.
]

{ #category : #initialization }
SVisitorForMetrics >> visitBlockNode: aBlockNode [
	super visitBlockNode: aBlockNode.
	blockId := blockId + 1.
]

{ #category : #initialization }
SVisitorForMetrics >> visitCascadeNode: aCascadeNode [
	^ super visitCascadeNode: aCascadeNode
]

{ #category : #initialization }
SVisitorForMetrics >> visitMessageNode: aMessageNode [
	| receiver selector |
	receiver := aMessageNode receiver.
	selector := aMessageNode selector.
	super visitMessageNode: aMessageNode.
	self computeCyclomaticNumber: selector.
	"(self isSuperInMethod: selector withReceiver: receiver) ifTrue: [ self methodEntity propertyNamed: #cleanSuperSend put: true ].
	(self isDirtySuperInMethod: selector withReceiver: receiver) ifTrue: [ self methodEntity propertyNamed: #dirtySuperSend put: true ]"
]

{ #category : #initialization }
SVisitorForMetrics >> visitMethodNode: aMethodNode [
	
	" I do not know where this block came from"
	"methodComplexity := methodComplexity + (0.3 * block arguments size)."
	^ super visitMethodNode: aMethodNode
]

{ #category : #initialization }
SVisitorForMetrics >> visitSequenceNode: aSequenceNode [
	super visitSequenceNode: aSequenceNode.
]
