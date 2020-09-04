Class {
	#name : #RSSparkCircle,
	#superclass : #RSAbstractShapesBuilder,
	#instVars : [
		'objects',
		'values',
		'sumValues',
		'totalSum',
		'sliceColor',
		'sliceShape',
		'scale'
	],
	#category : #'SmallSuiteGenerator-Visualization'
}

{ #category : #'accessing - computed' }
RSSparkCircle >> alphaAngleFor: aShape [
	values ifNil: [ self slices: #yourself ].
	^ ((sumValues at: aShape index) + (self defaultSliceShape border width/360)) * 360 / totalSum
]

{ #category : #'accessing - computed' }
RSSparkCircle >> betaAngleFor: aShape [
	^ ( aShape index - (self defaultSliceShape border width / 360)) * 360 / totalSum.
]

{ #category : #accessing }
RSSparkCircle >> defaultSliceShape [
	^ sliceShape
]

{ #category : #initialization }
RSSparkCircle >> initialize [
	super initialize.
	scale := 100.
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
RSSparkCircle >> objects [
	^ objects
]

{ #category : #accessing }
RSSparkCircle >> objects: anObject [
	objects := anObject
]

{ #category : #actions }
RSSparkCircle >> scaleTo: aNumber [
	scale := aNumber.
	sliceShape 
		innerRadius: scale/ 10;
		externalRadius: scale * 1.2
]

{ #category : #hooks }
RSSparkCircle >> shapeFor: anObject index: index [
	| slice value externalRadius width |
	slice := self defaultSliceShape copy.
	value := values at: index.
	externalRadius := (Array with: 1 with: (value <= 1 ifTrue: [ value * 100 ] ifFalse: [ value ])) max.
	width := (values min * slice innerRadius) max: 0.2.
	slice
		model: value * 100;
		index: index;
		color: (self sliceColor rsValue: slice);
		alphaAngle: (self alphaAngleFor: slice);
		betaAngle: (self betaAngleFor: slice);
		externalRadius: slice innerRadius + (slice externalRadius/10 * (externalRadius log)) + 1.
	slice border: (RSBorder new width: width;
		color: (width == 0.2 ifTrue: [ Color black] ifFalse: [ slice color muchDarker]));
		popupText: ((value * 100) asFloat round: 2) printString, '%'.
	^ slice
]

{ #category : #hooks }
RSSparkCircle >> shapesFor: anObject [
	| k |
	k := 0.
	^ values collect: [ :m |
		k := k + 1. 
		self shapeFor: m yourself index: k.
		 ] as: RSGroup.
]

{ #category : #accessing }
RSSparkCircle >> sliceColor [
	^ sliceColor
]

{ #category : #accessing }
RSSparkCircle >> sliceColor: anObject [
	sliceColor := anObject
]

{ #category : #accessing }
RSSparkCircle >> slices: blocksOrSymbols [
	values := blocksOrSymbols collect: [:blOrSymbol | 
		blOrSymbol value: objects ] as: Array.
	sumValues := Array new: blocksOrSymbols size.
	1 to: values size do: [ :index | sumValues at: index put: index - 1 ]. 
	totalSum := blocksOrSymbols size
]

{ #category : #accessing }
RSSparkCircle >> totalSum [
	^ totalSum
]

{ #category : #accessing }
RSSparkCircle >> values [
	^ values
]
