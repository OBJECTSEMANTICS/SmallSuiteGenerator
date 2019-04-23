Class {
	#name : #SUtilityTest,
	#superclass : #Object,
	#category : #'SmallSuiteGeneratorTest-GeneticAlgorithm'
}

{ #category : #'as yet unclassified' }
SUtilityTest class >> generateTestCase: aBlock with: aClass [
	| profile testCase |
	profile := SSGenerator profile: aBlock onClass: aClass.
	testCase := STestCase seed: profile.
	^ testCase
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCase [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self generateTestCase: [ SFoo score: 34 ] with: SFoo)
				generateStatements;
		add:
			(self generateTestCase: [ (SFoo score: 2) score ] with: SFoo)
				generateStatements;
		add:
			(self generateTestCase: [ (SFoo score: 2) return: 2 ] with: SFoo)
				generateStatements;
		add:
			(self
				generateTestCase: [ (SStudent name: 'Ann' with: 34)
						name;
						nickname;
						id ]
				with: SStudent) generateStatements;
		add:
			(self
				generateTestCase: [ (SStudent name: 'Ann' with: 34)
						age: 34;
						identifier;
						nickname: 'Ann34';
						fullIdentifier ]
				with: SStudent) generateStatements;
		add:
			(self
				generateTestCase: [ SStudent name: 'Peter'.
					SStudent name: 'Ann' with: 2 ]
				with: SStudent) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCaseRTAMItem [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self
				generateTestCase: [ RTAMItem basicNew
						itemName: 'Bonus Card';
						color: Color lightCyan ]
				with: RTAMItem) generateStatements;
		add:
			(self
				generateTestCase: [ RTAMItem basicNew
						itemName: 'Contract Management';
						row: 'Australia';
						column: 'Corporate Services';
						color: Color red ]
				with: RTAMItem) generateStatements;
		add:
			(self
				generateTestCase: [ RTAMItem basicNew
						itemName: 'Bonus Card';
						row: 'France';
						column: 'Customer Relationship';
						color: Color lightGreen ]
				with: RTAMItem) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCaseRTBorderAttachPoint [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self
				generateTestCase: [ RTBorderAttachPoint instance offset: 4 ]
				with: RTBorderAttachPoint) generateStatements;
		add:
			(self
				generateTestCase: [ RTBorderAttachPoint instance offset: 19 ]
				with: RTBorderAttachPoint) generateStatements;
		add:
			(self
				generateTestCase: [ RTBorderAttachPoint instance offset: 4 ]
				with: RTBorderAttachPoint) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCaseRTBox [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self
				generateTestCase: [ RTBox instance
						defaultWidth;
						borderStyle ]
				with: RTBox) generateStatements;
		add:
			(self generateTestCase: [ RTBox instance borderStyle ] with: RTBox)
				generateStatements;
		add:
			(self
				generateTestCase: [ RTBox instance
						defaultWidth;
						height;
						borderStyle ]
				with: RTBox) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCaseRTDirectedLine [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self
				generateTestCase: [ RTDirectedLine instance offset: 6.5 ]
				with: RTDirectedLine) generateStatements;
		add:
			(self
				generateTestCase: [ RTDirectedLine instance pointsFrom: 1 @ 3 To: 3 @ 5 ]
				with: RTDirectedLine) generateStatements;
		add:
			(self
				generateTestCase: [ RTDirectedLine instance
						offset: 56;
						offset: 2.4 ]
				with: RTDirectedLine) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCaseRTLineSegment [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self
				generateTestCase: [ RTLineSegment from: 1 @ 2 to: 3 @ 4 ]
				with: RTLineSegment) generateStatements;
		add:
			(self
				generateTestCase: [ (RTLineSegment from: 2 @ 6 to: 5 @ 8)
						from;
						to;
						a;
						b;
						c ]
				with: RTLineSegment) generateStatements;
		add:
			(self
				generateTestCase: [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
						angleInDeg;
						angleInRad;
						cotan;
						bottom ]
				with: RTLineSegment) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCaseSStack [
	| list |
	list := OrderedCollection new.
	list
		add:
			((self
				generateTestCase: [ (SStack newStackWith: {2 . 4 . 6 . 1})
						push: 8;
						pop;
						top ]
				with: SStack) generateStatements:10);
		add:
			((self generateTestCase: [ SStack newStack push: 2 ] with: SStack)
				generateStatements: 10);
		add:
			((self
				generateTestCase: [ (SStack newStackWith: {2 . 4 . 6 . 1})
						pop;
						top ]
				with: SStack) generateStatements:10).
	^ list
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCaseStudent [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self generateTestCase: [ SFoo score: 34 ] with: SFoo)
				generateStatements;
		add:
			(self generateTestCase: [ (SFoo score: 2) score ] with: SFoo)
				generateStatements;
		add:
			(self generateTestCase: [ (SFoo score: 2) return: 2 ] with: SFoo)
				generateStatements.
	^ list
]
