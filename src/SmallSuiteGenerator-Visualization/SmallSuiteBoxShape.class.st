Class {
	#name : #SmallSuiteBoxShape,
	#superclass : #TRBoxShape,
	#category : #'SmallSuiteGenerator-Visualization'
}

{ #category : #drawing }
SmallSuiteBoxShape >> drawOn: athensCanvas [
  self shouldBeDrawn ifFalse: [ ^self ].
  athensCanvas pathTransform restoreAfter: [ athensCanvas pathTransform multiplyBy: matrix asFloatTransform.
        athensCanvas
           setPaint: Color blue;
           drawShape: self path.
        self drawStrokeIfNecessaryOn: athensCanvas.
        "athensCanvas
           setPaint: Color red;
           drawShape: self path1.
        athensCanvas
           setPaint: Color red;
           drawShape: self path2.
        self drawStrokeIfNecessaryOn: athensCanvas" ]
]

{ #category : #'as yet unclassified' }
SmallSuiteBoxShape >> path1 [
	canvas ifNil: [ ^ self ].
	path := self athensCanvas
		createPath: [ :builder | 
			builder
				absolute;
				moveTo: (rectangle topLeft + (0@2));
				lineTo: (rectangle topLeft + (10@2));
				closePath ].
	^ path
			
]

{ #category : #'as yet unclassified' }
SmallSuiteBoxShape >> path2 [
	canvas ifNil: [ ^ self ].
	path := self athensCanvas
		createPath: [ :builder | 
			builder
				absolute;
				moveTo: (rectangle topLeft + (0@4));
				lineTo: (rectangle topLeft + (10@4));
				closePath ].
	^ path
]
