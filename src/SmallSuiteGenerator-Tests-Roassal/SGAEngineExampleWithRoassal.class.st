Class {
	#name : #SGAEngineExampleWithRoassal,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Tests-Roassal'
}

{ #category : #actions }
SGAEngineExampleWithRoassal >> clean [
	S2Lock value: false.
	S2Context value: nil.
	S2Profiler remove
]

{ #category : #'examples - onClass' }
SGAEngineExampleWithRoassal >> exampleRTAMItemOnClass [
	|engine |
	engine := SGAEngineExample new
		runOnClass: RTAMItem
		withBlock: [ RTAMItem new
				itemName: 'Bonus Card';
				row: 'France';
				column: 'Customer Relationship';
				color: Color lightGreen ]
		andFitness: SMethodCoverage.
	self assert: engine logs first fittestTestCase fitness >= 7.14.	"7.14 = (1/14) * 100"
	self assert: engine logs last fittestTestCase fitness equals: 35.71.	"35.71 = (4/14) * 100"
	engine := SGAEngineExample new
		runOnClass: RTAMItem
		withBlock: [ RTAMItem new
				itemName: 'Bonus Card';
				row: 'France';
				column: 'Customer Relationship';
				color: Color lightGreen ]
		andFitness: SStatementCoverage.
	self assert: engine logs first fittestTestCase fitness >= 31.58.	"31.58 = (6/19) * 100"
	self assert: engine logs last fittestTestCase fitness equals: 52.63.	"52.63 = (10/19) * 100"
	self clean
]

{ #category : #'examples - onPackages' }
SGAEngineExampleWithRoassal >> exampleRTAMItemOnPackage [
	|  engine |
	engine := SGAEngineExample new
		runOnPackagesMatching: 'Roassal2'
		withBlock: [ RTAMItem new
				itemName: 'Bonus Card';
				row: 'France';
				column: 'Customer Relationship';
				color: Color lightGreen ]
		andFitness: SStatementCoverage.
	self
		assert:
			engine logs first fittestTestCase fitness
				<= engine logs last fittestTestCase fitness.
	self clean
]

{ #category : #'examples - onClass' }
SGAEngineExampleWithRoassal >> exampleRTBorderAttachPointOnClass [
	| engine |
	engine := SGAEngineExample new
		runOnClass: RTBorderAttachPoint
		withBlock: [ RTBorderAttachPoint instance offset: 4 ]
		andFitness: SMethodCoverage.
	"At least the constructor must be initialized"
	
	self assert: engine logs first fittestTestCase fitness >= 12.5.	"12.5 = (1/8) * 100"
	self assert: engine logs last fittestTestCase fitness >= 25.	"25 = (2/8) * 100 round: 2"
	
	engine := SGAEngineExample new
		runOnClass: RTBorderAttachPoint
		withBlock: [ RTBorderAttachPoint instance offset: 4 ]
		andFitness: SStatementCoverage.
	self assert: engine logs first fittestTestCase fitness >= 6.45.	"6.45 = (2/31) * 100"
	self assert: engine logs last fittestTestCase fitness >= 9.68.	"9.68 = (3/31) * 100 round: 2"
	
	self clean
]

{ #category : #'examples - onPackages' }
SGAEngineExampleWithRoassal >> exampleRTBorderAttachPointPackage [
	| engine  |
	engine := SGAEngineExample new
		runOnPackagesMatching: 'Roassal2-Cor*'
		withBlock: [ RTBorderAttachPoint instance offset: 4 ]
		andFitness: SStatementCoverage.
	self
		assert:
			engine logs first fittestTestCase fitness
				<= engine logs last fittestTestCase fitness.
	
	self clean
]

{ #category : #'examples - onClass' }
SGAEngineExampleWithRoassal >> exampleRTBoxOnClass [
	| engine |
	engine := SGAEngineExample new
		runOnClass: RTBox
		withBlock: [ RTBox new
				defaultWidth;
				borderStyle ]
		andFitness: SMethodCoverage .
	self assert: engine logs first fittestTestCase fitness equals: 20.	"20 = (1/5) * 100"
	self assert: engine logs last fittestTestCase fitness equals: 20.	
	engine := SGAEngineExample new
		runOnClass: RTBox
		withBlock: [ RTBox new
				defaultWidth;
				borderStyle ]
		andFitness: SStatementCoverage .
	self assert: engine logs first fittestTestCase fitness equals: 22.22.	"22.22 = (2/9) * 100"
	self assert: engine logs last fittestTestCase fitness equals: 22.22.	
	self clean
]

{ #category : #'examples - onPackages' }
SGAEngineExampleWithRoassal >> exampleRTBoxOnPackage [
	| engine |
	engine := SGAEngineExample new
		runOnPackagesMatching: 'Roassal2-Cor*'
		withBlock: [ RTBox new
				defaultWidth;
				borderStyle ]
		andFitness: SStatementCoverage .
	self
		assert:
			engine logs first fittestTestCase fitness
				<= engine logs last fittestTestCase fitness.
	self clean
]

{ #category : #'examples - onClass' }
SGAEngineExampleWithRoassal >> exampleRTCalendarBuilderOnClass [
	| engine |
	engine := SGAEngineExample new
		runOnClass: RTCalendarBuilder
		withBlock: [ | classes dictByJulian dictByDate maxPerDays b |
			"Set your classes here:"
			classes := RTShape withAllSubclasses.
			"classes := (RPackageOrganizer default packageNamed: 'Roassal2') definedClasses."

			"Script"
			dictByJulian := (classes flatCollect: #methods)
				groupedBy: [ :m | m date julianDayNumber ].
			dictByDate := (classes flatCollect: #methods)
				groupedBy: [ :m | m date ].
			maxPerDays := (dictByJulian values collect: #size) max.
			b := RTCalendarBuilder new.
			b yearShape
				composite: [ :comp | 
					comp
						add:
							(RTLabel new
								text: [ :d | d year ];
								height: 20).
					comp add: (RTBox new color: Color lightGray trans) ].
			b yearLayout verticalLine.
			b dateShape rectangle
				size: 15;
				borderColor: Color lightGray;
				color: Color lightGray;
				if: [ :d | dictByJulian includesKey: d julianDayNumber ]
					color: [ :d | 
					| i |
					i := (dictByJulian at: d julianDayNumber) size / maxPerDays.
					Color r: i g: 0 b: 0 ].
			b dateInteraction
				when: TRMouseClick
				do: [ :evt | 
					(dictByJulian at: evt element model julianDayNumber ifAbsent: [ #() ])
						inspect ].
			b dateInteraction popup
				text: [ :d | 
					(dictByJulian at: d julianDayNumber ifAbsent: [ #() ]) size asString
						, ' Methods' ].
			b dates: (dictByDate keys min to: dictByDate keys max).
			b ]
		andFitness: SMethodCoverage .
	self assert: engine logs first fittestTestCase fitness >= 4.17.	"4.17 = 1/24 * 100"
	self assert: engine logs last fittestTestCase fitness >= 4.17.	
	
	
	"StatementCoverage: >=17.36 = 21/121 * 100"
	self clean
]

{ #category : #'examples - onPackages' }
SGAEngineExampleWithRoassal >> exampleRTCalendarOnPackage [
	| engine |
	engine := SGAEngineExample new
		runOnPackagesMatching: 'Roassal2-C*'
		withBlock: [ | classes dictByJulian dictByDate maxPerDays b |
			"Set your classes here:"
			classes := RTShape withAllSubclasses.
			"classes := (RPackageOrganizer default packageNamed: 'Roassal2') definedClasses."

			"Script"
			dictByJulian := (classes flatCollect: #methods)
				groupedBy: [ :m | m date julianDayNumber ].
			dictByDate := (classes flatCollect: #methods)
				groupedBy: [ :m | m date ].
			maxPerDays := (dictByJulian values collect: #size) max.
			b := RTCalendarBuilder new.
			b yearShape
				composite: [ :comp | 
					comp
						add:
							(RTLabel new
								text: [ :d | d year ];
								height: 20).
					comp add: (RTBox new color: Color lightGray trans) ].
			b yearLayout verticalLine.
			b dateShape rectangle
				size: 15;
				borderColor: Color lightGray;
				color: Color lightGray;
				if: [ :d | dictByJulian includesKey: d julianDayNumber ]
					color: [ :d | 
					| i |
					i := (dictByJulian at: d julianDayNumber) size / maxPerDays.
					Color r: i g: 0 b: 0 ].
			b dateInteraction
				when: TRMouseClick
				do: [ :evt | 
					(dictByJulian at: evt element model julianDayNumber ifAbsent: [ #() ])
						inspect ].
			b dateInteraction popup
				text: [ :d | 
					(dictByJulian at: d julianDayNumber ifAbsent: [ #() ]) size asString
						, ' Methods' ].
			b dates: (dictByDate keys min to: dictByDate keys max).
			b ]
		andFitness: SStatementCoverage.
	self
		assert:
			engine logs first fittestTestCase fitness
				<= engine logs last fittestTestCase fitness.
	self clean
]

{ #category : #'examples - onClass' }
SGAEngineExampleWithRoassal >> exampleRTDirectedLineOnClass [
	| engine |
	engine := SGAEngineExample new
		runOnClass: RTDirectedLine
		withBlock: [ RTDirectedLine instance
				pointsFrom: 1 @ 3 To: 3 @ 5;
				offset: 6.5 ]
		andFitness: SMethodCoverage .
	self assert: engine logs first fittestTestCase fitness >= 20. "20 = (1/5) * 100 round: 2"
	self assert: engine logs first fittestTestCase fitness equals: 60. "60 = (3/5) * 100 round: 2"
	
	engine := SGAEngineExample new
		runOnClass: RTDirectedLine
		withBlock: [ RTDirectedLine instance
				pointsFrom: 1 @ 3 To: 3 @ 5;
				offset: 6.5 ]
		andFitness: SStatementCoverage  .
	self assert: engine logs first fittestTestCase fitness >= 18.18. "18.18 = (2/11) * 100 round: 2"
	self assert: engine logs first fittestTestCase fitness equals: 54.55. "54.55 = (6/11) * 100 round: 2"

	self clean
]

{ #category : #'examples - onPackages' }
SGAEngineExampleWithRoassal >> exampleRTDirectedLineOnPackage [
	| engine |
	engine := SGAEngineExample new
		runOnPackagesMatching: 'Roassal2-Cor*'
		withBlock: [ RTDirectedLine instance
				pointsFrom: 1 @ 3 To: 3 @ 5;
				offset: 6.5 ]
		andFitness: SMethodCoverage .
	self
		assert:
			engine logs first fittestTestCase fitness
				<= engine logs last fittestTestCase fitness.
	self clean
]

{ #category : #'examples - onClass' }
SGAEngineExampleWithRoassal >> exampleRTLineSegmentOnClass [
	| engine |
	engine := SGAEngineExample new
		runOnClass: RTLineSegment
		withBlock: [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
				angleInDeg;
				angleInRad;
				cotan;
				bottom ]
		andFitness: SMethodCoverage.
	self assert: engine logs first fittestTestCase fitness >= 2.94.	"2.94 = (1/34) * 100 round: 2"
	self assert: engine logs first fittestTestCase fitness >= 23.53.	"23.53 = (8/34) * 100 round: 2"
	engine := SGAEngineExample new
		runOnClass: RTLineSegment
		withBlock: [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
				angleInDeg;
				angleInRad;
				cotan;
				bottom ]
		andFitness: SMethodCoverage.
	self assert: engine logs first fittestTestCase fitness >= 2.88.	"2.88 = (3/104) * 100 round: 2"
	self assert: engine logs first fittestTestCase fitness >= 13.46.	"13.46 = (14/104) * 100 round: 2"
	self clean
]

{ #category : #'examples - onPackages' }
SGAEngineExampleWithRoassal >> exampleRTLineSegmentOnPackage [
	| engine |
	engine := SGAEngineExample new
		runOnPackagesMatching: 'Roassal2-Cor*'
		withBlock: [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
				angleInDeg;
				angleInRad;
				cotan;
				bottom ]
		andFitness: SStatementCoverage .
	self assert: engine logs first fittestTestCase fitness <=  engine logs last fittestTestCase fitness.
	
	self clean
]

{ #category : #'examples - onClass' }
SGAEngineExampleWithRoassal >> exampleRTMondrianOnClass [
	| engine |
	engine := SGAEngineExample new
		runOnClass: RTMondrian
		withBlock: [ | nbOfNodes nbOfRandomEdges nodes edges b |
			nbOfNodes := 40.
			nbOfRandomEdges := 40.
			nodes := 1 to: nbOfNodes.
			edges := (1 to: nbOfRandomEdges)
				collect: [ :notUsed | nodes atRandom -> nodes atRandom ].

			"
In case you do not wish random data. You can set it manually. 
nodes := #(1 2 3 4 5).
edges := { 1 -> 2 . 1 -> 4 . 4 -> 3 }.
"
			b := RTMondrian new.
			b shape circle color: (Color black alpha: 0.5).
			b nodes: nodes.
			b shape line color: (Color gray alpha: 0.3).
			b edges source: edges connectFrom: #key to: #value.
			b layout force.
			b ]
		andFitness: SStatementCoverage .
	self assert: engine logs first fittestTestCase fitness >= 6.76. "6.76 = (5/74) * 100"
	self assert: engine logs last fittestTestCase fitness >= 6.76.
	"SMethodCoverage: >= 2.78. 2.78 = (1/36) * 100"
	
	self clean
]

{ #category : #'examples - onPackages' }
SGAEngineExampleWithRoassal >> exampleRTMondrianOnPackage [
	| engine |
	engine := SGAEngineExample new
		runOnPackagesMatching: 'Roassal2'
		withBlock: [ | nbOfNodes nbOfRandomEdges nodes edges b |
			nbOfNodes := 40.
			nbOfRandomEdges := 40.
			nodes := 1 to: nbOfNodes.
			edges := (1 to: nbOfRandomEdges)
				collect: [ :notUsed | nodes atRandom -> nodes atRandom ].

			"
In case you do not wish random data. You can set it manually. 
nodes := #(1 2 3 4 5).
edges := { 1 -> 2 . 1 -> 4 . 4 -> 3 }.
"
			b := RTMondrian new.
			b shape circle color: (Color black alpha: 0.5).
			b nodes: nodes.
			b shape line color: (Color gray alpha: 0.3).
			b edges source: edges connectFrom: #key to: #value.
			b layout force.
			b ]
		andFitness: SMethodCoverage .
	self assert: engine logs first fittestTestCase fitness <=
 engine logs last fittestTestCase fitness.

	self clean
]

{ #category : #'examples - onPackages' }
SGAEngineExampleWithRoassal >> exampleRTNameCloudExampleOnPackage [
	| engine |
	engine := SGAEngineExample new
		runOnPackagesMatching: 'Roassal2'
		withBlock: [ | b |
			b := RTNameCloud new
				addString:
					'open

		| v shape |
		v := RTView new.
		shape := RTLabel new height: [ :assoc | assoc value ]; text: #key.
		v addAll: (shape elementsOn: table associations).
		RTFlowLayout on: v elements.
		v open'.
			b ]
		andFitness: SStatementCoverage.
	self assert: engine logs first fittestTestCase fitness <= engine logs last fittestTestCase fitness.

	self clean
]

{ #category : #'examples - onClass' }
SGAEngineExampleWithRoassal >> exampleRTPieBuilderOnClass [
	| engine |
	engine := SGAEngineExample new
		runOnClass: RTPieBuilder
		withBlock: [ | b |
			b := RTPieBuilder new.
			b interaction popup.
			b shape current
				innerRadius: 70;
				externalRadius: 100.
			b
				objects:
					(Array
						with: Dictionary
						with: Collection
						with: Set
						with: OrderedCollection).
			b slice: #numberOfMethods.
			b normalizer distinctColor.
			b ]
		andFitness: SMethodCoverage .
	self assert: engine logs first fittestTestCase fitness >= 16.67.
	self assert: engine logs last fittestTestCase fitness >= 16.67.
	"statementCoverage: >= 15" 
	
	self clean
]

{ #category : #'examples - onPackages' }
SGAEngineExampleWithRoassal >> exampleRTPieOnPackage [
	| engine |
	engine := SGAEngineExample new
		runOnPackagesMatching: 'Roassal2'
		withBlock: [ | b |
			b := RTPieBuilder new.
			b interaction popup.
			b shape current
				innerRadius: 70;
				externalRadius: 100.
			b
				objects:
					(Array
						with: Dictionary
						with: Collection
						with: Set
						with: OrderedCollection).
			b slice: #numberOfMethods.
			b normalizer distinctColor.
			b ]
		andFitness: SStatementCoverage.
	self assert: engine logs first fittestTestCase fitness <= engine logs last fittestTestCase fitness.
	
	self clean
]

{ #category : #'examples - onPackages' }
SGAEngineExampleWithRoassal >> exampleRTSVGOnPackage [
	| engine |
	engine := SGAEngineExample new
		runOnPackagesMatching: 'Roassal2-C*'
		withBlock: [ | v s elements |
			v := RTView new.
			v @ RTDraggableView.
			s := RTSVGPath new
				path:
					'M397.49,222.581c-31.734-6.53-70.661,22.749-95.237,63.244c-11.35-13.957-25.565-26.455-42.892-37.536
	c-10.193-6.521-16.261-13.093-16.63-18.03c-0.771-10.444,18.708-27.653,32.917-40.218c10.427-9.212,20.284-17.913,27.594-27.234
	c13.411-17.141,16.73-38.533,8.684-55.842c-6.17-13.261-18.105-22.246-33.025-25.314c-2.146-6.379-5.666-12.339-10.353-17.351
	C259.932,55.08,248.297,50,235.757,50c-14.669,0-37.167,6.974-61.005,40.184c-7.159,9.958-12.422,19.791-17.083,28.475
	c-10.427,19.455-17.971,33.512-41.576,43.436C74.409,179.605,50,221.08,50,252.404c0,23,16.287,33.932,26.396,40.729
	c12.573,8.449,17.267,11.609,12.154,30.629c-6.505,24.023-3.487,43.117,7.326,56.697C54.836,395.479,64.895,462,117.602,462
	c29.807,0,82.062,0,185.07,0c10.998,0,20.988-2.582,29.472-7.058c11.366,4.644,23.034,7.058,35.255,7.058
	C422.336,462,462,410.115,462,343.543C462,287.5,434.842,230.25,397.49,222.581z M393.4,242.379
	c16.865,3.461,33.16,25.993,41.91,55.422l-4.979,2.213l-10.008-10.847l-13.429,6.035l-9.975-10.854l-13.429,6.019l-9.957-10.838
	l-13.429,6.043l-9.958-10.838l-13.412,6.043l-3.688-4.039C352.697,253.167,376.568,238.917,393.4,242.379z M302.672,427.667H200.669
	c-20.318,0-21.073-34.267,6.253-31.718c9.64,0.889,23.939,4.928,45.163,13.109c-21.19-10.461-63.302-73.294-6.806-115.506
	c-52.204,17.87-55.021,56.361-53.646,73.662c-32.992,0-46.202,33.327-37.636,60.452H117.2c-16.764,0-21.324-29.505,18.374-37.82
	c-28.164-34.87-11.718-61.29-11.718-78.491c0-27.351-17.72-39.262-29.187-46.965c-26.286-17.669,5.767-58.616,34.065-70.511
	c34.534-14.518,46.554-36.948,58.206-58.65c8.55-15.993,19.162-34.568,34.032-45.087c18.139-12.833,30.679-2.331,25.632,14.124
	c-5.247,17.041-24.191,45.574-34.584,59.195c11.735-12.456,35.406-41.575,53.813-47.015c13.471-3.982,24.267,8.357,11.392,24.836
	c-5.373,6.865-14.107,14.568-23.328,22.724c-21.827,19.262-46.538,41.098-44.459,68.885c1.207,16.161,10.36,31.508,29.975,42.824
	c37.375,21.559,59.941,59.496,62.422,100.217c0.369,5.801,3.554,11.015,8.482,13.865
	C333.82,403.408,329.293,427.667,302.672,427.667z M352.73,440.24c-0.973-0.201-1.777-0.553-2.699-0.771
	c3.336-4.777,5.851-10.176,7.359-16.127c1.106-4.275,1.475-8.566,1.441-12.824l13.379-5.985l9.99,10.829l13.429-6.001l9.976,10.829
	l13.479-6.035l0.469,0.504C404.398,434.104,381.766,446.208,352.73,440.24z M439.1,371.238c-1.979,9.656-5.297,19.212-9.79,28.029
	l-5.868-6.32l-13.444,6.02l-10.024-10.863l-13.412,6.035l-9.992-10.848l-13.41,6.02l-9.959-10.83l-4.123,1.844
	c-3.891-5.615-8.701-10.83-14.652-15.322c-0.504-4.711-1.309-9.254-2.18-13.78c4.945-1.659,8.986-5.6,10.125-11.064
	c1.678-8.198-3.604-16.212-11.801-17.904c-2.381-0.47-4.695-0.235-6.874,0.353c-2.581-6.287-5.432-12.423-8.817-18.257
	c2.363-4.501,4.76-8.994,7.477-13.16l10.025,10.805l13.41-6.019l9.926,10.838l13.444-6.043l9.958,10.838l13.445-6.043l9.991,10.854
	l13.429-6.035l9.975,10.863l13.445-6.035C442.587,333.149,442.955,352.529,439.1,371.238z M152.707,225.648
	c2.381,8.407-3.185,17.401-12.506,20.067c-9.304,2.64-18.776-2.045-21.207-10.469c-2.397-8.433,3.202-17.41,12.506-20.05
	C140.821,212.53,150.292,217.216,152.707,225.648z M357.206,343.208c1.693-8.181,9.69-13.479,17.888-11.785
	s13.479,9.673,11.803,17.888c-1.711,8.181-9.707,13.479-17.904,11.785C360.794,359.402,355.514,351.389,357.206,343.208z
	 M413.518,370.232c-8.197-1.643-13.479-9.689-11.785-17.854c1.693-8.215,9.689-13.496,17.887-11.819
	c8.182,1.692,13.479,9.706,11.786,17.904C429.712,366.645,421.699,371.942,413.518,370.232z'.
			s color: Color black.
			elements := s elementsOn: (1 to: 40).
			v addAll: elements.
			RTGridLayout on: elements.
			v ]
		andFitness: SStatementCoverage .
	self assert: engine logs first fittestTestCase fitness <= engine logs last fittestTestCase fitness.

	self clean
]

{ #category : #'examples - onClass' }
SGAEngineExampleWithRoassal >> exampleRTSVGPathOnClass [
	| engine |
	engine := SGAEngineExample new
		runOnClass: RTSVGPath
		withBlock: [ | v s elements |
			v := RTView new.
			v @ RTDraggableView.
			s := RTSVGPath new
				path:
					'M397.49,222.581c-31.734-6.53-70.661,22.749-95.237,63.244c-11.35-13.957-25.565-26.455-42.892-37.536
	c-10.193-6.521-16.261-13.093-16.63-18.03c-0.771-10.444,18.708-27.653,32.917-40.218c10.427-9.212,20.284-17.913,27.594-27.234
	c13.411-17.141,16.73-38.533,8.684-55.842c-6.17-13.261-18.105-22.246-33.025-25.314c-2.146-6.379-5.666-12.339-10.353-17.351
	C259.932,55.08,248.297,50,235.757,50c-14.669,0-37.167,6.974-61.005,40.184c-7.159,9.958-12.422,19.791-17.083,28.475
	c-10.427,19.455-17.971,33.512-41.576,43.436C74.409,179.605,50,221.08,50,252.404c0,23,16.287,33.932,26.396,40.729
	c12.573,8.449,17.267,11.609,12.154,30.629c-6.505,24.023-3.487,43.117,7.326,56.697C54.836,395.479,64.895,462,117.602,462
	c29.807,0,82.062,0,185.07,0c10.998,0,20.988-2.582,29.472-7.058c11.366,4.644,23.034,7.058,35.255,7.058
	C422.336,462,462,410.115,462,343.543C462,287.5,434.842,230.25,397.49,222.581z M393.4,242.379
	c16.865,3.461,33.16,25.993,41.91,55.422l-4.979,2.213l-10.008-10.847l-13.429,6.035l-9.975-10.854l-13.429,6.019l-9.957-10.838
	l-13.429,6.043l-9.958-10.838l-13.412,6.043l-3.688-4.039C352.697,253.167,376.568,238.917,393.4,242.379z M302.672,427.667H200.669
	c-20.318,0-21.073-34.267,6.253-31.718c9.64,0.889,23.939,4.928,45.163,13.109c-21.19-10.461-63.302-73.294-6.806-115.506
	c-52.204,17.87-55.021,56.361-53.646,73.662c-32.992,0-46.202,33.327-37.636,60.452H117.2c-16.764,0-21.324-29.505,18.374-37.82
	c-28.164-34.87-11.718-61.29-11.718-78.491c0-27.351-17.72-39.262-29.187-46.965c-26.286-17.669,5.767-58.616,34.065-70.511
	c34.534-14.518,46.554-36.948,58.206-58.65c8.55-15.993,19.162-34.568,34.032-45.087c18.139-12.833,30.679-2.331,25.632,14.124
	c-5.247,17.041-24.191,45.574-34.584,59.195c11.735-12.456,35.406-41.575,53.813-47.015c13.471-3.982,24.267,8.357,11.392,24.836
	c-5.373,6.865-14.107,14.568-23.328,22.724c-21.827,19.262-46.538,41.098-44.459,68.885c1.207,16.161,10.36,31.508,29.975,42.824
	c37.375,21.559,59.941,59.496,62.422,100.217c0.369,5.801,3.554,11.015,8.482,13.865
	C333.82,403.408,329.293,427.667,302.672,427.667z M352.73,440.24c-0.973-0.201-1.777-0.553-2.699-0.771
	c3.336-4.777,5.851-10.176,7.359-16.127c1.106-4.275,1.475-8.566,1.441-12.824l13.379-5.985l9.99,10.829l13.429-6.001l9.976,10.829
	l13.479-6.035l0.469,0.504C404.398,434.104,381.766,446.208,352.73,440.24z M439.1,371.238c-1.979,9.656-5.297,19.212-9.79,28.029
	l-5.868-6.32l-13.444,6.02l-10.024-10.863l-13.412,6.035l-9.992-10.848l-13.41,6.02l-9.959-10.83l-4.123,1.844
	c-3.891-5.615-8.701-10.83-14.652-15.322c-0.504-4.711-1.309-9.254-2.18-13.78c4.945-1.659,8.986-5.6,10.125-11.064
	c1.678-8.198-3.604-16.212-11.801-17.904c-2.381-0.47-4.695-0.235-6.874,0.353c-2.581-6.287-5.432-12.423-8.817-18.257
	c2.363-4.501,4.76-8.994,7.477-13.16l10.025,10.805l13.41-6.019l9.926,10.838l13.444-6.043l9.958,10.838l13.445-6.043l9.991,10.854
	l13.429-6.035l9.975,10.863l13.445-6.035C442.587,333.149,442.955,352.529,439.1,371.238z M152.707,225.648
	c2.381,8.407-3.185,17.401-12.506,20.067c-9.304,2.64-18.776-2.045-21.207-10.469c-2.397-8.433,3.202-17.41,12.506-20.05
	C140.821,212.53,150.292,217.216,152.707,225.648z M357.206,343.208c1.693-8.181,9.69-13.479,17.888-11.785
	s13.479,9.673,11.803,17.888c-1.711,8.181-9.707,13.479-17.904,11.785C360.794,359.402,355.514,351.389,357.206,343.208z
	 M413.518,370.232c-8.197-1.643-13.479-9.689-11.785-17.854c1.693-8.215,9.689-13.496,17.887-11.819
	c8.182,1.692,13.479,9.706,11.786,17.904C429.712,366.645,421.699,371.942,413.518,370.232z'.
			s color: Color black.
			elements := s elementsOn: (1 to: 40).
			v addAll: elements.
			RTGridLayout on: elements.
			v ]
		andFitness: SStatementCoverage .
	self assert: engine logs first fittestTestCase fitness >= 3.45. "3.45 = (8/232) * 100"
	self assert: engine logs last fittestTestCase fitness >= 3.45.
	"sMethodCoverage: >= 1.07. 1.07 = (2/187) * 100"
	
	self clean
]

{ #category : #'examples - unfunctional' }
SGAEngineExampleWithRoassal >> exampleRTSpectrographOnClass [
	| engine |
	engine := SGAEngineExample new
		runOnClass: RTSpectrograph
		withBlock: [ | b |
			b := RTSpectrograph new.
			b
				objects: (RTLayout withAllSubclasses reverseSortedAs: #numberOfMethods).
			b
				popupText: [ :aClass :cm | cm methodClass name , '>>' , cm selector ].
			b lineBlock: [ :cls | cls rtmethods , cls class rtmethods ].
			b highlight: [ :aClass :cm | cm methodClass isMeta ].
			b title: 'Proportion of class methods'.
			b build.
			b view ]
		andFitness: SMethodCoverage .
	self assert: engine logs first fittestTestCase fitness equals: 20. "20 = (1/5) * 100"
	self assert: engine logs last fittestTestCase fitness equals: 20.
	
	"statementCoverage: =22.22 = (2/9) * 100"
	self clean
]

{ #category : #'examples - unfunctional' }
SGAEngineExampleWithRoassal >> exampleRTSpectrographOnPackage [
	| engine |
	engine := SGAEngineExample new
		runOnPackagesMatching: 'Roassal2-Co*'
		withBlock: [ | b |
			b := RTSpectrograph new.
			b
				objects: (RTLayout withAllSubclasses reverseSortedAs: #numberOfMethods).
			b
				popupText: [ :aClass :cm | cm methodClass name , '>>' , cm selector ].
			b lineBlock: [ :cls | cls rtmethods , cls class rtmethods ].
			b highlight: [ :aClass :cm | cm methodClass isMeta ].
			b title: 'Proportion of class methods'.
			b build.
			b view ]
		andFitness: SMethodCoverage .
	self assert: engine logs first fittestTestCase fitness <= engine logs last fittestTestCase fitness.
	
	self clean
]

{ #category : #'examples - onClass' }
SGAEngineExampleWithRoassal >> exampleRTUMLClassBuilderOnClass [
	| engine |
	engine := SGAEngineExample new
		runOnClass: RTUMLClassBuilder
		withBlock: [ | someClasses allMethodCategories b n |
			someClasses := RTShape withAllSubclasses.
			allMethodCategories := (someClasses flatCollect: #protocols) asSet
				asArray.
			b := RTUMLClassBuilder new.
			n := RTMultiLinearColorForIdentity new objects: allMethodCategories.
			b methodShape color: [ :m | n rtValue: m protocol ].
			b methodsNames: [ :cls | cls rtmethods sortedAs: #protocol ].
			b addObjects: someClasses.
			b treeLayout.
			b build.
			b view ]
		andFitness: SStatementCoverage .
	self assert: engine logs first fittestTestCase fitness >= 11.7. "11.7 = (20/171) * 100"
	self assert: engine logs last fittestTestCase fitness >= 11.7.
	
	"statementCoverage: >= 24.53 = (13/53) * 100"
	
	self clean
]

{ #category : #'examples - onPackages' }
SGAEngineExampleWithRoassal >> exampleRTUMLClassBuilderOnPackage [
	| engine |
	engine := SGAEngineExample new
		runOnPackagesMatching: 'Roassal2-Cor*'
		withBlock: [ | someClasses allMethodCategories b n |
			someClasses := RTShape withAllSubclasses.
			allMethodCategories := (someClasses flatCollect: #protocols) asSet
				asArray.
			b := RTUMLClassBuilder new.
			n := RTMultiLinearColorForIdentity new objects: allMethodCategories.
			b methodShape color: [ :m | n rtValue: m protocol ].
			b methodsNames: [ :cls | cls rtmethods sortedAs: #protocol ].
			b addObjects: someClasses.
			b treeLayout.
			b build.
			b view ]
		andFitness: SMethodCoverage .
	self assert: engine logs first fittestTestCase fitness <= engine logs last fittestTestCase fitness.
	
	self clean
]
