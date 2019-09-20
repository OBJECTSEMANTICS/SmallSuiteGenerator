Class {
	#name : #SUtilityRoassal,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Tests-Roassal'
}

{ #category : #'as yet unclassified' }
SUtilityRoassal >> testSuiteRTAMItem [
	| typeInfos |
	typeInfos := self typeInfosRTAMItem.
	^ OrderedCollection new
		add: (SSTestCase with: typeInfos first) generateStatements;
		add: (SSTestCase with: typeInfos second) generateStatements;
		yourself
]

{ #category : #'as yet unclassified' }
SUtilityRoassal >> testSuiteRTBorderAttachPoint [
	| typeInfo |
	typeInfo := self typeInfoRTBorderAttachPoint.
	^ OrderedCollection new
		add: (SSTestCase with: typeInfo) generateStatements;
		add: (SSTestCase with: typeInfo) generateStatements;
		yourself
]

{ #category : #'as yet unclassified' }
SUtilityRoassal >> testSuiteRTBox [
	^ OrderedCollection new
		add: (SSTestCase with: self typeInfoRTBox) generateStatements;
		add: (SSTestCase with: self typeInfoRTBox) generateStatements;
		yourself
]

{ #category : #'as yet unclassified' }
SUtilityRoassal >> testSuiteRTDirectedLine [
	| typeInfos |
	typeInfos := self typeInfosRTDirectedLine.
	^ OrderedCollection new
		add: (SSTestCase with: typeInfos first) generateStatements;
		add: (SSTestCase with: typeInfos second) generateStatements;
		yourself
]

{ #category : #'as yet unclassified' }
SUtilityRoassal >> testSuiteRTLineSegment [
	| typeInfos |
	typeInfos := self typeInfosRTLineSegment.
	^ OrderedCollection new
		add: (SSTestCase with: typeInfos first) generateStatements;
		add: (SSTestCase with: typeInfos second) generateStatements;
		yourself
]

{ #category : #'as yet unclassified' }
SUtilityRoassal >> typeInfoRTBorderAttachPoint [
	^ STypeInfo new
		type:
			#RTBorderAttachPoint
				->
					(Array
						with:
							(Array
								with:
									#initialize
										->
											(Array
												with: #RTBorderAttachPoint
												with: #RTBorderAttachPoint
												with: #()
												with: false)
								with:
									#offset:
										->
											(Array with: #RTBorderAttachPoint with: #RTBorderAttachPoint with: #(#SmallInteger) with: false))
						with: #());
		scalar: #SmallInteger with: #(5)
]

{ #category : #'as yet unclassified' }
SUtilityRoassal >> typeInfoRTBox [
	^ STypeInfo new
		type:
			#RTBox
				->
					(Array
						with:
							(Array
								with:
									#borderStyle -> (Array with: #RTBox with: #RTBorderStyle with: #() with: false))
						with: #());
		scalar: #RTBorderStyle with: (Array with: RTBorderStyle new)
]

{ #category : #'as yet unclassified' }
SUtilityRoassal >> typeInfosRTAMItem [
	^ OrderedCollection new
		add:
			(STypeInfo new
				type:
					#RTAMItem
						->
							(Array with: (Array with: (#color:
								->
									(Array with: #RTAMItem
									with: #RTAMItem
									with: #(#Color)
									with: false)) with: 
							(#itemName:
								->
									(Array with: #RTAMItem
									with: #RTAMItem
									with: #(#ByteString)
									with: false))) with: 
							#());
				scalar: #ByteString with: #('Bonus Card');
				scalar: #Color with: (Array with: Color lightCyan));
		add:
			(STypeInfo new
				type:
					#RTAMItem
						->
							(Array with: (Array with: (#row:
								->
									(Array with: #RTAMItem with: #RTAMItem 
									with: #(#ByteString)
									with: false)) with: 
							(#column:
								->
									(Array with: #RTAMItem with: #RTAMItem
									with: #(#ByteString)
									with: false)) with:
							(#color:
								->
									(Array with: #RTAMItem with: #RTAMItem
									with: #(#Color) with:
									false)) with:
							(#itemName:
								->
									(Array with: #RTAMItem with: #RTAMItem
									with: #(#ByteString)
									with: false))) 
							with: #());
				scalar: #ByteString
					with: #('Corporate Services' 'Australia' 'Contact Management');
				scalar: #Color
					with: (Array with: Color red with: Color lightGreen));
		yourself
]

{ #category : #'as yet unclassified' }
SUtilityRoassal >> typeInfosRTDirectedLine [
	^ OrderedCollection new
		add:
			(STypeInfo new
				type:
					#RTDirectedLine
						->
							(Array with: (Array with: (#initialize
								->
									(Array with: #RTDirectedLine with: #RTDirectedLine with: 
									#() with: 
									false)) with:
							(#offset:
								->
									(Array with: #RTDirectedLine with: #RTDirectedLine with: 
									#(#SmallFloat64) with:
									false))) with:
							#());
				scalar: #SmallFloat64 with: #(6.5);
				scalar: #SmallInteger with: #(2));
		add:
			(STypeInfo new
				type:
					#RTDirectedLine
						->
							(Array with: (Array with: (#pointsFrom:To:
								->
									(Array with: #RTDirectedLine with: #Array with: 
									#(#Point  #Point) with:
									false)) with: 
							(#initialize
								->
									(Array with: #RTDirectedLine with: #RTDirectedLine with: 
									#() with: 
									false))) with:
							#());
				scalar: #Array with: (Array with: (Array with: 0.0 @ 4.0));
				scalar: #Point with: (Array with: 3 @ 5));
		yourself
]

{ #category : #'as yet unclassified' }
SUtilityRoassal >> typeInfosRTLineSegment [
	^ OrderedCollection new
		add:
			(STypeInfo new
				type:
					#RTLineSegment
						->
							(Array
								with:
									(OrderedCollection new
										add:
											#to:
												->
													(Array
														with: #RTLineSegment
														with: #Point
														with: #(#Point)
														with: false);
										add:
											#initialize
												->
													(Array
														with: #RTLineSegment
														with: #RTLineSegment
														with: #()
														with: false);
										add:
											#c
												->
													(Array
														with: #RTLineSegment
														with: #SmallInteger
														with: #()
														with: false);
										add:
											#a
												->
													(Array
														with: #RTLineSegment
														with: #SmallInteger
														with: #()
														with: false);
										add:
											#from
												->
													(Array
														with: #RTLineSegment
														with: #Point
														with: #()
														with: false);
										add:
											#b
												->
													(Array
														with: #RTLineSegment
														with: #SmallInteger
														with: #()
														with: false);
										add:
											#from:to:
												->
													(Array with: #RTLineSegment with: #RTLineSegment with: #(#Point #Point) with: false);
										yourself)
								with:
									(Array
										with:
											#from:to:
												->
													(Array
														with: #RTLineSegment
														with: #RTLineSegment
														with: #(#Point #Point)
														with: false)));
				scalar: #Point with: (Array with: 3 @ 4);
				scalar: #SmallInteger with: #(2 -3 14));
		add:
			(STypeInfo new
				type:
					#RTLineSegment
						->
							(Array
								with:
									(OrderedCollection new
										add:
											#angleInDeg
												->
													(Array
														with: #RTLineSegment
														with: #SmallFloat64
														with: #()
														with: false);
										add:
											#initialize
												->
													(Array
														with: #RTLineSegment
														with: #RTLineSegment
														with: #()
														with: false);
										add:
											#vector
												->
													(Array
														with: #RTLineSegment
														with: #Point
														with: #()
														with: false);
										add:
											#from:to:
												->
													(Array
														with: #RTLineSegment
														with: #RTLineSegment
														with: #(#Point #Point)
														with: false);
										add:
											#cotan
												->
													(Array
														with: #RTLineSegment
														with: #Fraction
														with: #()
														with: false);
										add:
											#angleInRad
												->
													(Array
														with: #RTLineSegment
														with: #SmallFloat64
														with: #()
														with: false);
										add:
											#bottom
												->
													(Array
														with: #RTLineSegment
														with: #Point
														with: #()
														with: false);
										yourself)
								with:
									(Array
										with:
											#from:to:
												->
													(Array
														with: #RTLineSegment
														with: #RTLineSegment
														with: #(#Point #Point)
														with: false)));
				scalar: #Point with: (Array with: 4 @ 9);
				scalar: #Fraction with: #(#(1 / 9));
				scalar: #SmallFloat64 with: #(83.6598 1.4601));
		yourself
]
