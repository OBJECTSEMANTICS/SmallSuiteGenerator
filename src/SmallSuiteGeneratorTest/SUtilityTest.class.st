Class {
	#name : #SUtilityTest,
	#superclass : #Object,
	#category : #'SmallSuiteGeneratorTest-GeneticAlgorithm'
}

{ #category : #'as yet unclassified' }
SUtilityTest class >> generateTestSuiteOf: aBlock blockOnClass: aClass [
	| generatorInfo testCase |
	generatorInfo := STypeInfo
		typeInfo: (SSGenerator profile: aBlock onClass: aClass).
	testCase := STestCase seed: generatorInfo.
	^ testCase
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> generateTestSuiteOf: aBlock blockOnPackagesMatching: regex [
	| generatorInfo testCase |
	generatorInfo := STypeInfo
		typeInfo: (SSGenerator profile: aBlock onPackagesMatching: regex).
	testCase := STestCase seed: generatorInfo.
	^ testCase
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCase [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self generateTestSuiteOf: [ SFoo score: 34 ] blockOnClass: SFoo)
				generateStatements;
		add:
			(self generateTestSuiteOf: [ (SFoo score: 2) score ] blockOnClass: SFoo)
				generateStatements;
		add:
			(self generateTestSuiteOf: [ (SFoo score: 2) return: 2 ] blockOnClass: SFoo)
				generateStatements;
		add:
			(self
				generateTestSuiteOf: [ (SStudent name: 'Ann' with: 34)
						name;
						nickname;
						id ]
				blockOnClass: SStudent) generateStatements;
		add:
			(self
				generateTestSuiteOf: [ (SStudent name: 'Ann' with: 34)
						age: 34;
						identifier;
						nickname: 'Ann34';
						fullIdentifier ]
				blockOnClass: SStudent) generateStatements;
		add:
			(self
				generateTestSuiteOf: [ SStudent name: 'Peter'.
					SStudent name: 'Ann' with: 2 ]
				blockOnClass: SStudent) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCaseRTAMItem [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self
				generateTestSuiteOf: [ RTAMItem basicNew
						itemName: 'Bonus Card';
						color: Color lightCyan ]
				blockOnClass: RTAMItem) generateStatements;
		add:
			(self
				generateTestSuiteOf: [ RTAMItem basicNew
						itemName: 'Contract Management';
						row: 'Australia';
						column: 'Corporate Services';
						color: Color red ]
				blockOnClass: RTAMItem) generateStatements;
		add:
			(self
				generateTestSuiteOf: [ RTAMItem basicNew
						itemName: 'Bonus Card';
						row: 'France';
						column: 'Customer Relationship';
						color: Color lightGreen ]
				blockOnClass: RTAMItem) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCaseRTBorderAttachPoint [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self
				generateTestSuiteOf: [ RTBorderAttachPoint instance offset: 4 ]
				blockOnClass: RTBorderAttachPoint) generateStatements;
		add:
			(self
				generateTestSuiteOf: [ RTBorderAttachPoint instance offset: 19 ]
				blockOnClass: RTBorderAttachPoint) generateStatements;
		add:
			(self
				generateTestSuiteOf: [ RTBorderAttachPoint instance offset: 4 ]
				blockOnClass: RTBorderAttachPoint) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCaseRTBox [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self
				generateTestSuiteOf: [ RTBox instance
						defaultWidth;
						borderStyle ]
				blockOnClass: RTBox) generateStatements;
		add:
			(self generateTestSuiteOf: [ RTBox instance borderStyle ] blockOnClass: RTBox)
				generateStatements;
		add:
			(self
				generateTestSuiteOf: [ RTBox instance
						defaultWidth;
						height;
						borderStyle ]
				blockOnClass: RTBox) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCaseRTDirectedLine [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self
				generateTestSuiteOf: [ RTDirectedLine instance offset: 6.5 ]
				blockOnClass: RTDirectedLine) generateStatements;
		add:
			(self
				generateTestSuiteOf: [ RTDirectedLine instance pointsFrom: 1 @ 3 To: 3 @ 5 ]
				blockOnClass: RTDirectedLine) generateStatements;
		add:
			(self
				generateTestSuiteOf: [ RTDirectedLine instance
						offset: 56;
						offset: 2.4 ]
				blockOnClass: RTDirectedLine) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCaseRTLineSegment [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self
				generateTestSuiteOf: [ RTLineSegment from: 1 @ 2 to: 3 @ 4 ]
				blockOnClass: RTLineSegment) generateStatements;
		add:
			(self
				generateTestSuiteOf: [ (RTLineSegment from: 2 @ 6 to: 5 @ 8)
						from;
						to;
						a;
						b;
						c ]
				blockOnClass: RTLineSegment) generateStatements;
		add:
			(self
				generateTestSuiteOf: [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
						angleInDeg;
						angleInRad;
						cotan;
						bottom ]
				blockOnClass: RTLineSegment) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCaseSFoo [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self generateTestSuiteOf: [ SFoo score: 34 ] blockOnClass: SFoo)
				generateStatements;
		add:
			(self generateTestSuiteOf: [ (SFoo score: 2) score ] blockOnClass: SFoo)
				generateStatements;
		add:
			(self
				generateTestSuiteOf: [ (SFoo score: 2) return: 2 ]
				blockOnClass: SFoo) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCaseSSTeacher [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self
				generateTestSuiteOf: [ (SSTeacher name: 'Carl' with: 110) yearsWorkExperience: 5 ]
				blockOnClass: SSTeacher) generateStatements;
		add:
			(self
				generateTestSuiteOf: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
				blockOnClass: SSTeacher) generateStatements;
		add:
			(self
				generateTestSuiteOf: [ (SSTeacher name: 'Ann' with: 34)
				age: 34;
				identifier;
				nickname: 'Ann34';
				fullIdentifier;
				name;
				id;
				nickname ]
				blockOnClass: SSTeacher) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCaseSStack [
	| list |
	list := OrderedCollection new.
	list
		add:
			((self
				generateTestSuiteOf: [ (SStack newStackWith: {2 . 4 . 6 . 1})
						push: 8;
						pop;
						top ]
				blockOnClass: SStack) generateStatements:10);
		add:
			((self generateTestSuiteOf: [ SStack newStack push: 2 ] blockOnClass: SStack)
				generateStatements: 10);
		add:
			((self
				generateTestSuiteOf: [ (SStack newStackWith: {2 . 4 . 6 . 1})
						pop;
						top ]
				blockOnClass: SStack) generateStatements:10).
	^ list
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCaseSStudent [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self
				generateTestSuiteOf: [ SStudent new
						name: 'Peter';
						nickname: 'peter';
						scoreStudent: 5 ]
				blockOnClass: SStudent) generateStatements;
		add:
			(self
				generateTestSuiteOf: [ (SStudent name: 'Ann' with: 34)
						age: 34;
						identifier;
						nickname: 'Ann34';
						fullIdentifier ]
				blockOnClass: SStudent) generateStatements;
		add:
			(self
				generateTestSuiteOf: [ (SStudent name: 'Jane')
						age: 19;
						identifier;
						nickname: 'Jane5';
						fullIdentifier ]
				blockOnClass: SStudent) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
SUtilityTest class >> listTestCaseSStudentGeneratedManually [
	^ {(STestCase new
		addStatement:
			(SConstructorStatement new
				theClassName: #SStudent;
				selector: 'new');
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: #ByteString;
				value: 'Sophie');
		addStatement:
			(SFieldStatement new
				returnTypeName: #SmallInteger;
				fieldName: #idStudent;
				receiverVarName: '_var0');
		addStatement:
			(SMethodStatement new
				returnTypeName: #SStudent;
				selector: #scoreStudent:;
				receiverVarName: '_var0';
				args: #(36));
		addStatement:
			(SConstructorStatement new
				theClassName: #SStudent;
				selector: 'new');
		addStatement:
			(SFieldStatement new
				returnTypeName: #SmallInteger;
				fieldName: #scoreStudent;
				receiverVarName: '_var4');
		addStatement:
			(SMethodStatement new
				returnTypeName: #ByteString;
				selector: #nickname;
				receiverVarName: '_var4');
		typeInfo:
			(SSGenerator
				profile: [ (SStudent name: 'Sophie')
						scoreStudent: 45;
						scoreStudent;
						idStudent;
						nickname;
						yourself ]
				onClass: SStudent);
		yourself). "change this"
	(STestCase new
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: #SmallInteger;
				value: 36);
		addStatement:
			(SConstructorStatement new
				theClassName: #SStudent;
				selector: 'new');
		addStatement:
			(SMethodStatement new
				returnTypeName: #SStudent;
				selector: #scoreStudent:;
				receiverVarName: '_var1';
				args: #('_var0'));
		addStatement:
			(SConstructorStatement new
				theClassName: #SStudent;
				selector: 'new');
		addStatement:
			(SFieldStatement new
				returnTypeName: #SmallInteger;
				fieldName: #idStudent;
				receiverVarName: '_var3');
		typeInfo:
			(SSGenerator
				profile: [ (SStudent name: 'Sophie' with: 45)
						scoreStudent: 36;
						idStudent;
						yourself ]
				onClass: SStudent);
		yourself)}
]

{ #category : #tests }
SUtilityTest >> testSuiteOf: aCollection [
	self assert: aCollection size >= 2 description: 'list must have at least two or more testCases.'.
	^ OrderedCollection new
		add: (SSTestCase with: aCollection first) generateStatements;
		add: (SSTestCase with: aCollection second) generateStatements;
		yourself
]

{ #category : #tests }
SUtilityTest >> testSuiteSStack [
	^ self testSuiteOf: self typeInfosSStack
	"| typeInfos |
	typeInfos := self typeInfosSStack.
	^ OrderedCollection new
		add: (SSTestCase with: typeInfos first) generateStatements;
		add: (SSTestCase with: typeInfos second) generateStatements;
		yourself"
]

{ #category : #tests }
SUtilityTest >> testSuiteSStudent [
	^ self testSuiteOf: self typeInfosSStudent 
	"^ OrderedCollection new
		add: (SSTestCase with: self typeInfosSStudent) generateStatements;
		add: (SSTestCase with: self typeInfosSStudent) generateStatements;
		yourself"
]

{ #category : #'as yet unclassified' }
SUtilityTest >> typeInfosSFoo [
	^ OrderedCollection new 
	add: (STypeInfo new
		type:
			#SFoo
				->
					{{(#returnNum
						->
							{#SmallInteger.
							{}.
							false}).
					(#returnFloat
						->
							{#SmallFloat64.
							{}.
							false}).
					(#returnString
						->
							{#ByteString.
							{}.
							false}).
					(#score
						->
							{#SmallFloat64.
							{}.
							true}).
					(#return:
						->
							{#ByteString.
							{#ByteString}.
							false})}.
					{(#score:
						->
							{#SFoo.
							{#SmallFloat64}.
							false})}};
		scalar: #ByteString with: {'hello'};
		scalar: #SmallInteger with: {5};
		scalar: #SmallFloat64 with: {7.3});
		add: (
		STypeInfo new
		type:
			#SFoo
				->
					{{(#return:
						->
							{#SFoo.
							{#SFoo}.
							false})}.
					{}};
		scalar: #ByteString with: {'hello'};
		scalar: #SmallInteger with: {5};
		scalar: #SmallFloat64 with: {7.3}
		); add: (STypeInfo new
		type:
			#SFoo
				->
					{{(#returnNum
						->
							{#SmallInteger.
							{}.
							false}).
					(#returnFloat
						->
							{#SmallFloat64.
							{}.
							false}).
					(#returnString
						->
							{#ByteString.
							{}.
							false}).
					(#score
						->
							{#SmallInteger.
							{}.
							true}).
					
							(#score:
						->
							{#SFoo.
							{#SmallInteger}.
							false}).
							
							}.
					{(#score:
						->
							{#SFoo.
							{#SmallInteger}.
							false})}};
		scalar: #ByteString with: {'Hello'};
		scalar: #SmallInteger with: {4};
		scalar: #SmallFloat64 with: {2.3});yourself.
]

{ #category : #'as yet unclassified' }
SUtilityTest >> typeInfosSStack [
	^ OrderedCollection new
		add:
			(STypeInfo new
				type:
					#SStack
						->
							{{(#firstLinkStack
								->
									{#SmallInteger.
									{}.
									true}).
							(#pop
								->
									{#SmallInteger.
									{}.
									false}).
							(#push:
								->
									{#SmallInteger.
									{#SmallInteger}.
									false})}.
							{(#newStackWith:
								->
									{#SStack.
									{#Array}.
									false})}};
				scalar: #Array with: {#(2 4 6 1)};
				scalar: #SmallInteger with: #(1  2  4  6  8));
		add:
			(STypeInfo new
				type:
					#SStack
						->
							{{(#lastLinkStack
								->
									{#SmallInteger.
									{}.
									true}).
							(#pop
								->
									{#SmallInteger.
									{}.
									false}).
							(#top
								->
									{#SmallInteger.
									{}.
									false})}.
							{(#newStack
								->
									{#SStack.
									{}.
									false}).
							(#newStackWith:
								->
									{#SStack.
									{#Array}.
									false})}};
				scalar: #Array
					with:
					{#(2 4 6 1).
					#(5  7  9  0)};
				scalar: #SmallInteger with: #(1  2  5  8  9));
		yourself
]

{ #category : #'as yet unclassified' }
SUtilityTest >> typeInfosSStudent [
	^ OrderedCollection new
		add:
			(STypeInfo new
				type:
					#SStudent -> { { 
					(#initialize -> { #SStudent. {  }. false }). 
					(#scoreStudent -> { #SmallInteger. {  }. true }). 
					(#scoreStudent: -> { #SStudent. { #SmallInteger }. false }).
				
					 }. {  } }; 
					scalar: #SmallInteger with: #(10 1);
					scalar: #ByteString with: {'student_Jane'}); 
		add: (STypeInfo new
				type:
					#SStudent -> { { 
					(#scoreStudent: -> { #SStudent. { #SmallInteger }. false }).
					(#idStudent -> { #SmallInteger. {  }. true }).
					(#nickname -> { #ByteString. {  }. false }) }. {  } }; 
					scalar: #SmallInteger with: #( 1 6 8);
					scalar: #ByteString with: {'Jane'. 'Ann'. 'Peter'}); yourself.
]
