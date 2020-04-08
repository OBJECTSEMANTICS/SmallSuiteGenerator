Class {
	#name : #RSSparkCircleB,
	#superclass : #RSAbstractShapesBuilder,
	#instVars : [
		'objects',
		'values',
		'sumValues',
		'totalSum',
		'sliceColor',
		'sliceShape'
	],
	#category : #'SmallSuiteGenerator-Visualization'
}

{ #category : #'accessing - computed' }
RSSparkCircleB >> alphaAngleFor: aShape [
	values ifNil: [ self slices: #yourself ].
	^ ((sumValues at: aShape index) + (self defaultSliceShape border width/360)) * 360 / totalSum
]

{ #category : #'accessing - computed' }
RSSparkCircleB >> betaAngleFor: aShape [
	^ ( aShape index - (self defaultSliceShape border width / 360)) * 360 / totalSum.
]

{ #category : #'as yet unclassified' }
RSSparkCircleB >> defaultSliceShape [
	^ sliceShape
]

{ #category : #initialization }
RSSparkCircleB >> initialize [
	super initialize.
	self sliceColor: [ :slice | 
		slice index even 
			ifTrue: [ Color lightGray ]
			ifFalse: [ Color gray ] ].
	sliceShape := RSPieSlice new
		segmentSpacing: 0.13;
		border: (RSBorder new width: 5; color: Color gray; yourself);
		innerRadius: 10;
		externalRadius: 120
]

{ #category : #accessing }
RSSparkCircleB >> objects [
	^ objects
]

{ #category : #accessing }
RSSparkCircleB >> objects: anObject [
	objects := anObject
]

{ #category : #hooks }
RSSparkCircleB >> shapeFor: anObject index: index [
	| slice value border |
	slice := self defaultSliceShape copy.
	value := values at: index.
	slice
		model: value;
		index: index;
		color: (self sliceColor rsValue: slice);
		alphaAngle: (self alphaAngleFor: slice);
		betaAngle: (self betaAngleFor: slice);
		externalRadius: slice innerRadius + (slice externalRadius / 5 * value) + 3.
	border := (values min * 10).
	slice border: (RSBorder new width: border ; color: (value > 0 ifTrue: [ slice color muchDarker ] ifFalse: [ slice color muchLighter]));
		popup.
	^ slice
]

{ #category : #hooks }
RSSparkCircleB >> shapesFor: anObject [
	| k |
	k := 0.
	^ values collect: [ :m |
		k := k + 1. 
		self shapeFor: m yourself index: k.
		 ] as: RSGroup.
]

{ #category : #accessing }
RSSparkCircleB >> sliceColor [
	^ sliceColor
]

{ #category : #accessing }
RSSparkCircleB >> sliceColor: anObject [
	sliceColor := anObject
]

{ #category : #accessing }
RSSparkCircleB >> slices: blocksOrSymbols [
	| tempSum  |
	values := blocksOrSymbols collect: [:blOrSymbol | 
		blOrSymbol value: objects ] as: Array.
	sumValues := Array new: blocksOrSymbols size.
	tempSum := 0.
	values doWithIndex: [ :v :i |
		sumValues at: i put: tempSum.
		tempSum := i
		 ].
	totalSum := blocksOrSymbols size "+ ((blocksOrSymbols size * self defaultSliceShape segmentSpacing) / 360)"
]

{ #category : #accessing }
RSSparkCircleB >> totalSum [
	^ totalSum
]

{ #category : #accessing }
RSSparkCircleB >> values [
	^ values
]
