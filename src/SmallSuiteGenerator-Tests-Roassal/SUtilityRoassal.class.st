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
					{{(#initialize
						->
							{#RTBorderAttachPoint.
							{}.
							false}).
					(#offset:
						->
							{#RTBorderAttachPoint.
							{#SmallInteger}.
							false})}.
					#()};
		scalar: #SmallInteger with: #(5 )
]

{ #category : #'as yet unclassified' }
SUtilityRoassal >> typeInfoRTBox [
	^ STypeInfo new
		type:
			#RTBox
				->
					{{(#borderStyle
						->
							{#RTBorderStyle.
							#().
							false})}.
					#()};
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
							{{(#color:
								->
									{#RTAMItem.
									{#Color}.
									false}).
							(#itemName:
								->
									{#RTAMItem.
									{#ByteString}.
									false})}.
							{}};
				scalar: #ByteString with: #('Bonus Card');
				scalar: #Color with: (Array with: Color lightCyan));
		add:
			(STypeInfo new
				type:
					#RTAMItem
						->
							{{(#row:
								->
									{#RTAMItem.
									{#ByteString}.
									false}).
							(#column:
								->
									{#RTAMItem.
									{#ByteString}.
									false}).
							(#color:
								->
									{#RTAMItem.
									{#Color}.
									false}).
							(#itemName:
								->
									{#RTAMItem.
									{#ByteString}.
									false})}.
							{}};
				scalar: #ByteString
					with: #('Corporate Services'  'Australia'  'Contact Management');
				scalar: #Color
					with:
					(Array with: Color red with:
					Color lightGreen));
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
							{{(#initialize
								->
									{#RTDirectedLine.
									{}.
									false}).
							(#offset:
								->
									{#RTDirectedLine.
									{#SmallFloat64}.
									false})}.
							{}};
				scalar: #SmallFloat64 with: #(6.5);
				scalar: #SmallInteger with: #(2));
		add:
			(STypeInfo new
				type:
					#RTDirectedLine
						->
							{{(#pointsFrom:To:
								->
									{#Array.
									{#Point . #Point}.
									false}).
							(#initialize
								->
									{#RTDirectedLine.
									#().
									false})}.
							#()};
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
							{{(#to:
								->
									{#Point.
									#(#Point).
									false}).
							(#initialize
								->
									{#RTLineSegment.
									#().
									false}).
							(#c
								->
									{#SmallInteger.
									#().
									false}).
							(#a
								->
									{#SmallInteger.
									#().
									false}).
							(#from
								->
									{#Point.
									#().
									false}).
							(#b
								->
									{#SmallInteger.
									#().
									false}).
							(#from:to:
								->
									{#RTLineSegment.
									#(#Point #Point).
									false})}.
							{(#from:to:
								->
									{#RTLineSegment.
									#(#Point #Point).
									false})}};
				scalar: #Point with: (Array with: 3 @ 4);
				scalar: #SmallInteger with: #(2 -3 14));
		add:
			(STypeInfo new
				type:
					#RTLineSegment
						->
							{{(#angleInDeg
								->
									{#SmallFloat64.
									#().
									false}).
							(#initialize
								->
									{#RTLineSegment.
									#().
									false}).
							(#vector
								->
									{#Point.
									#().
									false}).
							(#from:to:
								->
									{#RTLineSegment.
									#(#Point #Point).
									false}).
							(#cotan
								->
									{#Fraction.
									#().
									false}).
							(#angleInRad
								->
									{#SmallFloat64.
									#().
									false}).
							(#bottom
								->
									{#Point.
									#().
									false})}.
							{(#from:to:
								->
									{#RTLineSegment.
									#(#Point #Point).
									false})}};
				scalar: #Point with: (Array with: 4 @ 9);
				scalar: #Fraction with: #(#(1 / 9));
				scalar: #SmallFloat64 with: #(83.6598 1.4601));
		yourself
]
