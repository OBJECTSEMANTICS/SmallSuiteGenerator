<?xml version="1.0"?>

<st-source>
<time-stamp>From VisualWorks®, 7.4 of December 5, 2005 on May 28, 2020 at 10:55:40 am</time-stamp>
<!-- Package SmallSuiteGenerator-Extensions2* -->


<component-property>
<name>SmallSuiteGenerator-Extensions2</name> <type>package</type>
<property>parcelName</property> <value>'SmallSuiteGenerator-Extensions2'</value>
</component-property>

<component-property>
<name>SmallSuiteGenerator-Extensions2</name> <type>package</type>
<property>packageName</property> <value>'SmallSuiteGenerator-Extensions2'</value>
</component-property>

<class>
<name>SStateCoverage</name>
<environment>SmallSuiteGenerator</environment>
<super>SmallSuiteGenerator.SSimpleFitnessFunction</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>class </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>SmallSuiteGenerator-GA</category>
<attributes>
<package>SmallSuiteGenerator-Extensions2</package>
</attributes>
</class>

<class>
<name>SVisitorNodes</name>
<environment>SmallSuiteGenerator</environment>
<super>Refactory.Browser.RBProgramNodeVisitor</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>isAbstractt </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>SmallSuiteGenerator-Extensions2</category>
<attributes>
<package>SmallSuiteGenerator-Extensions2</package>
</attributes>
</class>












<shared-variable>
<name>PundleAccess</name>
<environment>SmallSuiteGenerator.STestCaseFactory</environment>
<private>false</private>
<constant>false</constant>
<category>As yet unclassified</category>
<attributes>
<package>SmallSuiteGenerator-Extensions2</package>
</attributes>
</shared-variable>



















<methods>
<class-id>SmallSuiteGenerator.SStateCoverage class</class-id> <category>As yet unclassified</category>

<body package="SmallSuiteGenerator-Extensions2" selector="for:">for: aClass
	^ self new class: aClass</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SStateCoverage</class-id> <category>As yet unclassified</category>

<body package="SmallSuiteGenerator-Extensions2" selector="tearDown">tearDown</body>

<body package="SmallSuiteGenerator-Extensions2" selector="computeFitness">computeFitness
	^ profiler stateCoverageFor: class</body>

<body package="SmallSuiteGenerator-Extensions2" selector="setUp">setUp</body>

<body package="SmallSuiteGenerator-Extensions2" selector="functionName">functionName
	^ 'state-coverage'</body>

<body package="SmallSuiteGenerator-Extensions2" selector="fitnessOf:withKey:">fitnessOf: testCase withKey: string
	testCase fitness at:string put: (profiler stateCoverageFor: class).
	testCase fitnessByClass at: string put: (profiler statementCoverage1)</body>

<body package="SmallSuiteGenerator-Extensions2" selector="class:">class: aClass
	class := aClass</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SVisitorNodes</class-id> <category>initialize-release</category>

<body package="SmallSuiteGenerator-Extensions2" selector="isAbstract">isAbstract

	^isAbstractt ifNil: [false]</body>
</methods>

<methods>
<class-id>SmallSuiteGenerator.SVisitorNodes</class-id> <category>visitor-double dispatching</category>

<body package="SmallSuiteGenerator-Extensions2" selector="acceptMessageNode:">acceptMessageNode: t1 

	isAbstractt := t1 selector == #subclassResponsibility.
	^self</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SSTestCaseTest</class-id> <category>tests</category>

<body package="SmallSuiteGenerator-Extensions2" selector="typeInfo">typeInfo 
	|typeInfo|
	typeInfo := STypeInfo new
		type:
			(self fullSymbolOf: #SFoo)
				-&gt;
					(Array
						with:
							(Array
								with: #returnNum -&gt; (Array
																with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #Float)
																with: #()
																with: false)
								with: #returnFloat -&gt; (Array
																with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #Float)
																with: #()
																with: false)
								with: #score -&gt; (Array
																with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #SmallInteger)
																with: #()
																with: true)
								with: #return: -&gt; (Array
																with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #ByteString)
																with: (Array with: (self fullSymbolOf: #ByteString))
																with: false))
						with: (Array with: #score: -&gt; (Array
																with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #SFoo)
																with: (Array with: (self fullSymbolOf: #Float))
																with: false))).
	typeInfo scalar: (self fullSymbolOf: #ByteString) with: #('hello').
	typeInfo scalar: (self fullSymbolOf: #SmallInteger) with: #(5).
	typeInfo scalar: (self fullSymbolOf: #Float) with: #(7.3).
	^ typeInfo</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.STypeInfoTest</class-id> <category>tests</category>

<body package="SmallSuiteGenerator-Extensions2" selector="testAsTypeInfoSTeacherOnPackagesMatching">testAsTypeInfoSTeacherOnPackagesMatching

	| t1 |
	t1 := STypeInfo asTypeInfo: (Spy1.SSTypeCollector profile: [(SSTeacher name: 'Ann' with: 34) name; nickname; yearsWorkExperience; idTeacher; id]
					onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	self assertCollection: ((t1 types at: (self nameOf: SSTeacher)) methodTypes values collect: #selector)
		hasSameElements: #(#idTeacher #initialize #nickname #yearsWorkExperience ).
	self assertCollection: ((t1 factoryMessagesFrom: (self nameOf: SSTeacher))
			collect: #selector)
		hasSameElements: #(#name:with: ).
	self assertCollection: ((t1 messagesFrom: (self nameOf: SSTeacher))
			collect: #selector)
		hasSameElements: #(#initialize #nickname #id: #nickname: #name: ).
	self assertCollection: ((t1 accessMessagesFrom: (self nameOf: SSTeacher))
			collect: #selector)
		hasSameElements: #(#idTeacher #yearsWorkExperience #name #id ).
	^self</body>

<body package="SmallSuiteGenerator-Extensions2" selector="testAsTypeInfoScalars">testAsTypeInfoScalars

	| t1 |
	t1 := STypeInfo asTypeInfo: (Spy1.SSTypeCollector profile: [SConference price: 95]
					onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	self assertCollection: (t1 scalars values flatCollect: [:t2 | t2])
		hasSameElements: #(95 0 100 ).
	t1 := STypeInfo asTypeInfo: (Spy1.SSTypeCollector profile: [(SFoo new) returnCollection; returnFloat; returnNum; returnString]
					onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	self assertCollection: t1 scalars associations hasSameElements: (Array
			with: (self nameOf: SmallInteger)
					-&gt; #(0 4 )
			with: (self nameOf: OrderedCollection)
					-&gt; (Array with: OrderedCollection new)
			with: (self nameOf: ByteString)
					-&gt; #('Hello' )
			with: (self nameOf: 2.3 class)
					-&gt; #(2.3 )).
	^self</body>

<body package="SmallSuiteGenerator-Extensions2" selector="nameOf:">nameOf: t1 

	^t1 fullName asSymbol</body>

<body package="SmallSuiteGenerator-Extensions2" selector="testAsTypeInfoSFoo">testAsTypeInfoSFoo

	| t1 t2 t3 t4 t5 t6 t7 t8 t9 |
	t4 := self nameOf: SFoo.
	t5 := self nameOf: OrderedCollection.
	t6 := self nameOf: Float.
	t7 := self nameOf: ByteString.
	t8 := self nameOf: SmallInteger.
	t9 := self nameOf: Dictionary.
	t1 := Spy1.SSTypeCollector profile: [(SFoo new) return: Dictionary new; return: OrderedCollection new; returnFloat; returnString; returnCollection; returnNum; score; score: 5]
				forClassNamed: t4.
	t2 := STypeInfo asTypeInfo: t1.
	self assert: (t2 types at: t4) methodTypes size equals: 8.
	self assert: (t2 types at: t4) classMethodTypes size equals: 0.
	self assert: (t2 methodType: #initialize from: t4) returnType type equals: t4.
	t3 := t2 methodType: #return: from: t4.
	self assertCollection: t3 returnType types hasSameElements: (Array with: t5 with: t9).
	self assertCollection: t3 allArgTypes hasSameElements: (Array with: t5 with: t9).
	self assert: (t2 methodType: #returnFloat from: t4) returnType type equals: t6.
	self assert: (t2 methodType: #returnCollection from: t4) returnType type equals: t5.
	self assert: (t2 methodType: #returnString from: t4) returnType type equals: t7.
	self assert: (t2 methodType: #returnNum from: t4) returnType type equals: t8.
	self assert: (t2 methodType: #score from: t4) returnType type equals: t8.
	t3 := t2 methodType: #score: from: t4.
	self assert: t3 returnType type equals: t4.
	self assertCollection: t3 allArgTypes hasSameElements: (Array with: t8).
	self assert: (t2 factoryMessagesFrom: t4) isEmpty.
	self assertCollection: t2 scalars keys hasSameElements: (Array
			with: t5
			with: t9
			with: t7
			with: t8
			with: t6).
	^self</body>

<body package="SmallSuiteGenerator-Extensions2" selector="testAsTypeInfoSConferenceOnPackagesMatching">testAsTypeInfoSConferenceOnPackagesMatching
	| typeInfo messages |
	typeInfo := STypeInfo asTypeInfo: (Spy1.SSTypeCollector
		profile: [ SConference price: 95 ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	messages := typeInfo messagesFrom: (self nameOf: SConference).
	self
		assertCollection: (messages collect: #selector)
		hasSameElements: #(#initialize #price:).
	self
		assert:
			((messages flatCollect: [ :aMessage | aMessage receiver types ])
				allSatisfy: [ :aType | aType = (self nameOf: SConference) ]).
	self assert: ((typeInfo messagesFrom: (self nameOf: SEvent)) allSatisfy: #isUnary).
	self assert: (typeInfo messagesFrom: (self nameOf: SParty)) isEmpty.
	messages := typeInfo factoryMessagesFrom: (self nameOf:  SConference).
	self
		assertCollection: (messages collect: #selector)
		hasSameElements: #(#price:)</body>

<body package="SmallSuiteGenerator-Extensions2" selector="testAsTypeInfoSTeacherOnClass">testAsTypeInfoSTeacherOnClass

	| t1 t2 |
	t2 := self nameOf: SSTeacher.
	t1 := STypeInfo asTypeInfo: (Spy1.SSTypeCollector profile: [(SSTeacher name: 'Ann' with: 34) name; nickname; yearsWorkExperience; idTeacher; id]
					forClassNamed: t2).
	self assertCollection: ((t1 types at: t2) methodTypes values collect: #selector)
		hasSameElements: #(#idTeacher #initialize #nickname #yearsWorkExperience ).
	self assert: (t1 types at: t2) classMethodTypes isEmpty.
	self assertCollection: ((t1 messagesFrom: t2)
			collect: #selector)
		hasSameElements: #(#initialize #nickname ).
	self assertCollection: ((t1 accessMessagesFrom: t2)
			collect: #selector)
		hasSameElements: #(#idTeacher #yearsWorkExperience ).
	^self</body>

<body package="SmallSuiteGenerator-Extensions2" selector="testAsTypeInfoSFooOnClass">testAsTypeInfoSFooOnClass
	| profile typeInfo methodInfo classNameSFoo |
	classNameSFoo := self nameOf: SFoo.
	profile := Spy1.SSTypeCollector
		profile: [ SFoo new return: OrderedCollection ]
		forClassNamed: classNameSFoo.
	typeInfo := STypeInfo asTypeInfo: profile.
	self
		assert: (typeInfo types at: classNameSFoo) methodTypes size
		equals: 7.
	self
		assert: (typeInfo types at: classNameSFoo) classMethodTypes isEmpty.
	self
		assert: (typeInfo methodType: #initialize from: classNameSFoo) returnType type
		equals: classNameSFoo.
	methodInfo := typeInfo methodType: #return: from: classNameSFoo.
	self
		assertCollection: methodInfo returnType types
		hasSameElements: (Array with: (self nameOf: OrderedCollection class)).
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: (self nameOf: OrderedCollection class)).
	self
		assertCollection: ((typeInfo messagesFrom: classNameSFoo) collect: #selector)
		hasSameElements: #(#returnFloat #returnCollection #initialize #returnNum #returnString #return:)</body>

<body package="SmallSuiteGenerator-Extensions2" selector="testAsTypeInfoSFooWithNil">testAsTypeInfoSFooWithNil
	| profile typeInfo methodInfo classNameSFoo |
	classNameSFoo := self nameOf: SFoo.
	profile := Spy1.SSTypeCollector
		profile: [ SFoo new return: nil ]
		forClassNamed: classNameSFoo.
	typeInfo := STypeInfo asTypeInfo: profile.
	self
		assert: (typeInfo types at: classNameSFoo) methodTypes size
		equals: 7.
	self
		assert: (typeInfo types at: classNameSFoo) classMethodTypes isEmpty.
	self
		assert: (typeInfo methodType: #initialize from: classNameSFoo) returnType type
		equals: classNameSFoo.
	methodInfo := typeInfo methodType: #return: from: classNameSFoo.
	self
		assertCollection: methodInfo returnType types
		hasSameElements: (Array with: (self nameOf: UndefinedObject)).
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: (self nameOf: UndefinedObject)).
	self
		assertCollection: ((typeInfo messagesFrom: classNameSFoo) collect: #selector)
		hasSameElements: #(#returnFloat #returnCollection #initialize #returnNum #returnString #return:)</body>

<body package="SmallSuiteGenerator-Extensions2" selector="testFactoryMessages">testFactoryMessages

	| t1 t2 |
	t2 := self nameOf: SStudent.
	t1 := STypeInfo asTypeInfo: (Spy1.SSTypeCollector profile: [SStudent name: 'Mary']
					forClassNamed: t2).
	self assert: (t1 factoryMessagesFrom: t2) isEmpty.
	t1 := STypeInfo asTypeInfo: (Spy1.SSTypeCollector profile: [SStudent name: 'Mary']
					onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	self assertCollection: ((t1 factoryMessagesFrom: t2)
			collect: #selector)
		hasSameElements: #(#name: ).
	t1 := STypeInfo asTypeInfo: (Spy1.SSTypeCollector profile: [SConference price: 95]
					onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	self assertCollection: ((t1 factoryMessagesFrom: (self nameOf: SConference))
			collect: #selector)
		hasSameElements: #(#price: ).
	^self</body>

<body package="SmallSuiteGenerator-Extensions2" selector="testAsTypeInfoSEventOnPackagesMatching">testAsTypeInfoSEventOnPackagesMatching
	| typeInfo messages methodInfo classNameSEvent classNameSConference classNameSParty classNameByteString classNameSmallInteger classNameSStudent |
	classNameSEvent := self nameOf: SEvent.
	classNameSConference := self nameOf: SConference.
	classNameSParty := self nameOf: SParty.
	classNameByteString := self nameOf: ByteString.
	classNameSmallInteger := self nameOf: SmallInteger.
	classNameSStudent := self nameOf: SStudent.
	typeInfo := STypeInfo asTypeInfo: (Spy1.SSTypeCollector
		profile: [ | aConference aPerson |
			aConference := SConference new offerPrice: 95.
			aPerson := SStudent new name: 'Mary'.
			aConference canRegister: aPerson ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	self
		assert: (typeInfo types at: classNameSEvent) methodTypes size
		equals: 4.
	self
		assert: (typeInfo types at: classNameSEvent) classMethodTypes isEmpty.
	self
		assert: (typeInfo types at: classNameSConference) methodTypes size
		equals: 5.
	self
		assert: (typeInfo types at: classNameSConference) classMethodTypes isEmpty.
	self assert: ((typeInfo types at: classNameSParty) methodTypes allSatisfy: #isUnary).
	self
		assert: (typeInfo types at: classNameSParty) classMethodTypes isEmpty.
	messages := typeInfo messagesFrom: classNameSConference.
	self
		assertCollection: (messages collect: #selector)
		hasSameElements: #(#initialize #offerPrice: #canRegister: #price).
	self
		assert:
			((messages flatCollect: [ :aMessage | aMessage receiver types ])
				allSatisfy: [ :aType | aType = classNameSConference ]).
	methodInfo := messages
		detect: [ :aMessage | aMessage selector = #canRegister: ].
	self
		assertCollection: methodInfo returnType types
		hasSameElements: (Array with: (self nameOf: False)).
	self
		assertCollection: methodInfo allArgTypes
		hasSameElements: (Array with: classNameSStudent).
	self
		assertCollection: methodInfo allReceivers
		hasSameElements: (Array with: classNameSConference).
	self
		assertCollection: typeInfo scalars keys
		hasSameElements:
			(Array
				with: (self nameOf: (SUndefinedObject basicNew) class)
				with: classNameSStudent
				with: classNameSmallInteger
				with: (self nameOf: False)
				with: classNameByteString
				with: (self nameOf: 2.3 class))</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SError</class-id> <category>signaling</category>

<body package="SmallSuiteGenerator-Extensions2" selector="signal:">signal: t1 

	SPlatform saveOnLog: t1.
	self raiseSignal: t1.
	^self</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SAssertionTest</class-id> <category>tests</category>

<body package="SmallSuiteGenerator-Extensions2" selector="testAssertString">testAssertString

	| t1 |
	(t1 := SSTestCase new) addStatements: (self parse: '_var0 := 1.
			 _var1 := 2.
			 _var3 := Point x: _var1 y: _var0.').
	t1 generateAssertions: (Array with: SStringAssertion).
	self assert: t1 assertions size equals: 1.
	self assert: t1 assertions first printString equals: 'self assert: _var3 printString equals: ''2@1''.'.
	^self</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SUtilityTypeInfo</class-id> <category>examples</category>

<body package="SmallSuiteGenerator-Extensions2" selector="typeInfoSFoo1">typeInfoSFoo1
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SFoo)
				-&gt;
					(Array
						with:
							(Array
								with: #returnNum -&gt; (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #SmallInteger) 
									with: #()
									with: false)
								with: #returnFloat -&gt; (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #Float) 
									with: #()
									with: false)
								with: #returnString -&gt; (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #ByteString) 
									with: #()
									with: false)
								with: #score -&gt; (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #Float) 
									with: #()
									with: true)
								with: #return: -&gt; (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #ByteString) 
									with: (Array with: (self fullSymbolOf: #ByteString))
									with: false))
						with: (Array with: #score: -&gt; (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #SFoo) 
									with: (Array with: (self fullSymbolOf: #Float))
									with: false)));
		scalar: (self fullSymbolOf: #ByteString) with: #('hello');
		scalar: (self fullSymbolOf: #SmallInteger) with: #(5);
		scalar: (self fullSymbolOf: #Float) with: #(7.3)</body>

<body package="SmallSuiteGenerator-Extensions2" selector="typeInfoSFoo3">typeInfoSFoo3
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SFoo)
				-&gt;
					(Array
						with:
							(Array
								with: #returnNum -&gt; (Array
																with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #SmallInteger)
																with: #()
																with: false)
								with: #returnFloat -&gt; (Array
																with: (self fullSymbolOf:#SFoo)
																with: (self fullSymbolOf:#Float)
																with: #()
																with: false)
								with: #returnString -&gt; (Array
																with: (self fullSymbolOf:#SFoo)
																with: (self fullSymbolOf:#ByteString)
																with: #()
																with: false)
								with: #score -&gt; (Array 
																with: (self fullSymbolOf:#SFoo)
																with: (self fullSymbolOf: #SmallInteger)
																with: #()
																with: true)
								with: #score: -&gt; (Array
																with: (self fullSymbolOf:#SFoo)
																with: (self fullSymbolOf: #SFoo) 
																with: (Array with: (self fullSymbolOf:#SmallInteger))
																with: false))
						with: (Array with: #score: -&gt; (Array 
																with: (self fullSymbolOf:#SFoo)
																with: (self fullSymbolOf: #SFoo)
																with: (Array with: (self fullSymbolOf:#SmallInteger))
																with: false)));
		scalar: (self fullSymbolOf: #ByteString) with: #('Hello');
		scalar: (self fullSymbolOf: #SmallInteger) with: #(4);
		scalar: (self fullSymbolOf: #Float) with: #(2.3)</body>

<body package="SmallSuiteGenerator-Extensions2" selector="typeInfoSFooOnPackage2">typeInfoSFooOnPackage2
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SFoo)
				-&gt;
					(Array
						with:
							(Array
								with: #returnFloat -&gt; (Array with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #Float)
																with: #()
																with: false)
								with: #returnCollection -&gt; (Array with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #OrderedCollection)
																with: #()
																with: false)
								with: #initialize -&gt; (Array with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #SFoo)
																with: #()
																with: false)
								with: #score -&gt; (Array with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #SmallInteger)
																with: #()
																with: true)
								with: #score: -&gt; (Array with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #SFoo)
																with: (Array with: (self fullSymbolOf: #SmallInteger))
																with: false)
								with: #return: -&gt; (Array with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #SStudent)
																with: (Array with: (self fullSymbolOf: #SStudent))
																with: false))
						with: (Array with: #score: -&gt; (Array with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #SFoo)
																with: (Array with: (self fullSymbolOf: #SmallInteger))
																with: false)));
		type: (self fullSymbolOf: #SSPerson) -&gt; #(#() #());
		type: (self fullSymbolOf: #SStack) -&gt; #(#() #());
		type: (self fullSymbolOf: #SConference) -&gt; #(#() #());
		type: (self fullSymbolOf: #SEvent) -&gt; #(#() #());
		type: (self fullSymbolOf: #SSTeacher) -&gt; #(#() #());
		type: (self fullSymbolOf: #SParty) -&gt; #(#() #());
		type: (self fullSymbolOf: #SEventTest) -&gt; #(#() #());
		scalar: (self fullSymbolOf: #SmallInteger) with: #(15);
		scalar: (self fullSymbolOf: #Float) with: #(2.3);
		scalar: (self fullSymbolOf: #OrderedCollection)
			with: (Array with: OrderedCollection new);
		scalar: (self fullSymbolOf: #Array) with: #(#(1 5 6))</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SStack</class-id> <category>accessing</category>

<body package="SmallSuiteGenerator-Extensions2" selector="addLast:">addLast: t1

	| t2 |
	t2 := t1 asLink.
	self isEmpty
		ifTrue: [firstLink := t2]
		ifFalse: [lastLink nextLink: t2].
	lastLink := t2.
	^t2</body>

<body package="SmallSuiteGenerator-Extensions2" selector="addFirst:">addFirst: t1

	| t2 |
	t2 := t1 asLink.
	self isEmpty ifTrue: [lastLink := t2].
	t2 nextLink: firstLink.
	firstLink := t2.
	^t2</body>

<body package="SmallSuiteGenerator-Extensions2" selector="removeLast">removeLast

	| t1 t2 |
	self emptyCheck.
	t1 := lastLink.
	firstLink == lastLink
		ifTrue: 
			[firstLink := nil.
			lastLink := nil]
		ifFalse: 
			[t2 := firstLink.
			[t2 nextLink == t1]
				whileFalse: [t2 := t2 nextLink].
			t2 nextLink: nil.
			lastLink := t2].
	t1 nextLink: nil.
	^t1 value</body>

<body package="SmallSuiteGenerator-Extensions2" selector="removeFirst">removeFirst

	| t1 |
	self emptyCheck.
	t1 := firstLink.
	firstLink == lastLink
		ifTrue: 
			[firstLink := nil.
			lastLink := nil]
		ifFalse: [firstLink := t1 nextLink].
	t1 nextLink: nil.
	^t1 value</body>

<body package="SmallSuiteGenerator-Extensions2" selector="=">= t1

	self == t1 ifTrue: [^true].
	self species == t1 species ifFalse: [^false].
	^self hasEqualElements: t1</body>

<body package="SmallSuiteGenerator-Extensions2" selector="hasEqualElements:">hasEqualElements: t1

	| t2 t3 |
	(t1 isKindOf: SequenceableCollection)
		ifFalse: [^false].
	(t2 := self size) = t1 size ifFalse: [^false].
	t3 := 1.
	[t3 &lt;= t2]
		whileTrue: 
			[(self at: t3) value = (t1 at: t3) value ifFalse: [^false].
			t3 := t3 + 1].
	^true</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SSTestRunner</class-id> <category>test - instrumentation</category>

<body package="SmallSuiteGenerator-Extensions2" selector="analyze:">analyze: t1 

	| t2 |
	t2 := SSExecutionContext new.
	t1 tempNames doWithIndex: [:t3 :t4 | t2 at: t3 put: (t1 tempAt: t4)].
	^t2</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SCoverageTest</class-id> <category>running</category>

<body package="SmallSuiteGenerator-Extensions2" selector="installOn:">installOn: t1 

	fitness tagetPackagesRegex: t1.
	profiler := Spy1.SLProfilerCoverage profilerForPackagesMatching: t1.
	fitness profiler: profiler.
	profiler uninstall.
	profiler beforeProfiling.
	^self</body>

<body package="SmallSuiteGenerator-Extensions2" selector="setUp">setUp

	utility := SUtilityTypeInfo new.
	fitness := self fitnessClass new.
	profiler := Spy1.SLProfilerCoverage new.
	^self</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SInsertTest</class-id> <category>mutation-insert</category>

<body package="SmallSuiteGenerator-Extensions2" selector="testInsertStatementOfSelectorRandomMessageInLiteral">testInsertStatementOfSelectorRandomMessageInLiteral
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addLiteral: (self fullSymbolOf: #Float).
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.').
	self
		should: [ testCase insertStatementOfSelector: #insertRandomMessage:using: ]
		raise: SError</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SSTestShifterTest</class-id> <category>tests</category>

<body package="SmallSuiteGenerator-Extensions2" selector="testNewFieldAccessMessageOfTypeBefore">testNewFieldAccessMessageOfTypeBefore
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: (self fullSymbolOf:#SFoo).
	expression := testCase addLiteral:(self fullSymbolOf: #SmallInteger).
	self
		should: [ testCase newFieldAccessMessageOfType: (self fullSymbolOf:#SmallInteger) before: expression ]
		raise: SError.
	testCase
		addStatement:
			(testCase
				newAssignment: (testCase newFactoryMessage: (self fullSymbolOf:#SFoo) before: expression))
		before: expression.
	self
		assert:
			(testCase newFieldAccessMessageOfType: (self fullSymbolOf:#Float) before: expression)
				printString
		equals: '_var2 score'.
	self
		assertCollection: testCase printStatements
		hasSameElements: (Array with: '_var1 := 7.3.'
									with: '_var2 := ',(self fullNameOfClass: 'SFoo')asString,' score: _var1.'
									with: '_var0 := 5.')</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SChangeTest</class-id> <category>mutation-change</category>

<body package="SmallSuiteGenerator-Extensions2" selector="testChangeStatementOfFactoryMessageWithMoreThanOneLiteral">testChangeStatementOfFactoryMessageWithMoreThanOneLiteral
	| testCase expression expressionChanged |
	testCase := (SSTestCase with: utility typeInfoSFoo1) addTargetClassName: (self fullSymbolOf: #SFoo).
	testCase
		addLiteral: (self fullSymbolOf: #Float);
		addLiteral: (self fullSymbolOf: #Float).
	expression := testCase addFactoryMessage: (self fullSymbolOf: #SFoo) ofSelector: #score:.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll: #('_var0 := 7.3.' '_var1 := 7.3.').
	self
		assert:
			((Array with: '_var3 := ',(self fullNameOfClass: 'SFoo')asString,' score: _var2.')
				includes: expression printString).
	expressionChanged := testCase changeStatementOfVarName: '_var2'.
	self
		assert:
			(#('_var2 := 679.9.')
				includes: expressionChanged printString).
	self assert: testCase validReferences</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SGAEngineTest</class-id> <category>running</category>

<body package="SmallSuiteGenerator-Extensions2" selector="setUp">setUp

	super setUp.
	engine := SGAEngine new.
	profiler := Spy1.SLProfilerCoverage new.
	utility := SUtilityTypeInfo new.
	^self</body>

<body package="SmallSuiteGenerator-Extensions2" selector="tearDown">tearDown

	[profiler cleanInstrumentation]
		on: Error do: [nil].
	super tearDown.
	^self</body>
</methods>

<methods>
<class-id>SmallSuiteGenerator.SGAEngineTest</class-id> <category>as yet unclassified</category>

<body package="SmallSuiteGenerator-Extensions2" selector="profilerOf:">profilerOf: t1 

	profiler beforeProfiling; gatherForPackages: (Store.Registry allPackages select: [:t2 | t1 match: t2 name asString]); install; beforeProfiling.
	^self</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SObject</class-id> <category>accessing</category>

<body package="SmallSuiteGenerator-Extensions2" selector="classOf:">classOf: aString 

	| classes |
	classes := self findClass: aString.
	classes 
		ifEmpty: [ self error: 'I cant find the class with name: ' , aString. ].
	^ classes</body>

<body package="SmallSuiteGenerator-Extensions2" selector="fullSymbolOf:">fullSymbolOf: aSymbol 

	| classes |
	classes := self findClass: aSymbol asString.
	classes ifNotEmpty: [ ^ classes collect: [:cls | cls fullName asSymbol ] ]
		ifEmpty: [ self error: 'I cant find the namespace for: ' , aSymbol. ]</body>

<body package="SmallSuiteGenerator-Extensions2" selector="findClass:">findClass: aString
	| classes |
	classes := Root allClasses select: [:each | aString  = each fullName or: [ (('*.', aString) match: each fullName) ]].
	^ classes</body>

<body package="SmallSuiteGenerator-Extensions2" selector="initialize">initialize

	^self</body>

<body package="SmallSuiteGenerator-Extensions2" selector="fullNameOfClass:">fullNameOfClass: aString
	| classes |
	classes := self findClass: aString.
	classes ifNotEmpty: [ ^ classes collect: [:cls | cls fullName ] ]
		ifEmpty: [ self error: 'I cant find the namespace for: ' , aString. ]</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SSTestShifter</class-id> <category>parsing</category>

<body package="SmallSuiteGenerator-Extensions2" selector="parseTreeAsDictWith:">parseTreeAsDictWith: statementCollection
	| node temporaries rbParserClass |
	statementCollection
		ifEmpty: [ self error: 'testCase does not have statements' ].
	rbParserClass := SPlatform rbParserClass.
	node := rbParserClass parseExpression: '[]'.
	temporaries := Array with: (Refactory.Browser.RBVariableNode named: 'var').
	node body temporaries: temporaries.
	node body
		addNode: (rbParserClass parseExpression: 'var := Dictionary new.').
	statementCollection
		do: [ :stm | 
			| aNode |
			[ aNode := rbParserClass parseExpression: (self getStringOf: stm).
			node body addNode: aNode ]
				on: Error
				do: [  ] ].
	^ node</body>

<body package="SmallSuiteGenerator-Extensions2" selector="parseTreeWith:">parseTreeWith: t1 

	| t2 t3 t4 |
	t1 ifEmpty: [self error: 'testCase does not have statements'].
	t2 := (t4 := SPlatform rbParserClass) parseExpression: '[]'.
	t3 := (self allVarNames collect: [:t5 | t4 parseExpression: t5])
				select: [:t6 | t6 isKindOf: Refactory.Browser.RBVariableNode].
	t2 body temporaries: t3.
	t1 do: 
		[:t7 | 
		| t8 |
		
		[t8 := t4 parseExpression: (self getStringOf: t7).
		t2 body addNode: t8]
			on: Error do: [nil]].
	^t2</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SGALog class</class-id> <category>as yet unclassified</category>

<body package="SmallSuiteGenerator-Extensions2" selector="logOf:inGeneration:inTime:">logOf: aSGAEngine inGeneration: anInteger inTime: t
	| log dictFitness |
	log := self new 
		generationNumber: anInteger;
		fittestTestCase: aSGAEngine population first;
		timeToProduceGeneration: Time new asSeconds - t;
		population: aSGAEngine population.
	dictFitness := self collectFitnessByNameOf: aSGAEngine population.
	log lowestFit: aSGAEngine population last fitness;
	averageFit: (self pickAverageFitTest: dictFitness). 
	log summaryTargetClass: (aSGAEngine fitness runPopulation: aSGAEngine population).
	log typeInfoGeneration: (aSGAEngine typeInfo classAt: aSGAEngine targetClassName) dcopy.
	^ log</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SSTestCase</class-id> <category>actions</category>

<body package="SmallSuiteGenerator-Extensions2" selector="tearDown">tearDown

	(Process allInstances select: [:t1 | t1 name ~= nil and: [(t1 name startsWith: 'FiniteStateMachine')
				or: [t1 name startsWith: 'FSMTicTacToe']]])
		do: [:t2 | t2 terminate].
	^self</body>

<body package="SmallSuiteGenerator-Extensions2" selector="setUp">setUp

	(Process allInstances select: [:t1 | t1 name ~= nil and: [(t1 name startsWith: 'FiniteStateMachine')
				or: [t1 name startsWith: 'FSMTicTacToe']]])
		do: [:t2 | t2 terminate].
	^self</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SSExecutionContext</class-id> <category>initialize-release</category>

<body package="SmallSuiteGenerator-Extensions2" selector="initialize">initialize

	super initialize.
	values := OrderedDictionary new.
	^self</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SGAEngineExample</class-id> <category>actions</category>

<body package="SmallSuiteGenerator-Extensions2" selector="runOnClass:withBlock:andFitness:">runOnClass: t1 withBlock: t2 andFitness: t3 

	| t4 |
	(t4 := SGAEngine new) populationSize: 30; numberOfStatements: 15; blockToExecute: t2; targetClassName: t1 name.
	t4 typeInfo: (Spy1.SSTypeCollector profile: t4 blockToExecute forClassNamed: t1) asTypeInfo; fitness: t3; targetClassName: t1 name; numberOfIterations: 15; run.
	^t4</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SAbstractMessage</class-id> <category>accessing</category>

<body package="SmallSuiteGenerator-Extensions2" selector="replaceBy:">replaceBy: t1 

	receiver replaceBy: t1 receiver.
	self selector: t1 selector.
	self args size = t1 args size
		ifTrue: [self args with: t1 args do: [:t2 :t3 | t2 replaceBy: t3]]
		ifFalse: [self args: t1 args dcopy].
	^self</body>
</methods>

<methods>
<class-id>SmallSuiteGenerator.SAbstractMessage</class-id> <category>copying</category>

<body package="SmallSuiteGenerator-Extensions2" selector="copy">copy

	| t1 |
	(t1 := super copy) args: args dcopy; receiver: receiver copy; selector: selector copy.
	^t1</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SPlatformVisualWorks class</class-id> <category>logging</category>

<body package="SmallSuiteGenerator-Extensions2" selector="implementationType">implementationType

	^'VisualWorks'</body>

<body package="SmallSuiteGenerator-Extensions2" selector="createTestCaseClass:inPackage:">createTestCaseClass: t1 inPackage: t2 

	| t3 t4 t5 |
	(t3 := SystemUtils validateClassName: t1 for: nil) ifNil: [^nil].
	^(t4 := (t5 := self testCaseClass) classBuilder addRecord: (BehaviorBuilderRecord forName: t3 in: self environment)) superclass: t5; instVarString: ''; classVarString: ''; poolString: (t5 computeFullPoolString: ''); category: t2; beFixed; reviseSystem</body>

<body package="SmallSuiteGenerator-Extensions2" selector="classConfigurationName">classConfigurationName

	^superclass fullName , self implementationType</body>

<body package="SmallSuiteGenerator-Extensions2" selector="testCaseClass">testCaseClass

	^SUnit.TestCase</body>

<body package="SmallSuiteGenerator-Extensions2" selector="rbParserClass">rbParserClass

	^Refactory.Browser.RBParser</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.STypeInfo</class-id> <category>as yet unclassified</category>

<body package="SmallSuiteGenerator-Extensions2" selector="isAbstractClass:">isAbstractClass: t1 

	^((self classes at: t1) methodDictionary values select: #isAbstract) isNotEmpty</body>
</methods>

<methods>
<class-id>SmallSuiteGenerator.STypeInfo</class-id> <category>converting</category>

<body package="SmallSuiteGenerator-Extensions2" selector="updateArgsOf:">updateArgsOf: aMethod 
	aMethod argTypes do: [ :argType |
	| includeTypes |
	includeTypes := argType types anySatisfy: [ :type | self scalars keys includes: type ].
	includeTypes ifFalse: [ 
		argType types do: [ :type |
			(type substrings: '.') last = 'Object' ifFalse: [
			self scalars keys 
				select: [ :scalar | ((self classOf: type asString) first allSubclasses 
					collect: [:e | e fullName asSymbol]) includes: scalar ] 
				thenDo: [ :scalar | argType type: scalar ] ] ] ]]</body>

<body package="SmallSuiteGenerator-Extensions2" selector="asTypeInfo:methodsBlacklist:">asTypeInfo: t1 methodsBlacklist: t2 

	| t3 |
	t3 := self class new.
	t1 allClasses
		do: 
			[:t4 | 
			t2 select: [:t5 | (t5 mclass name without: ' class') asSymbol == (t4 className substrings: '.') last asSymbol]
				thenDo: [:t6 | t4 removeMethod: t6].
			(t4 className endsWith: 'BlockClosure')
				ifTrue: [nil]
				ifFalse: [t3 addClassInfo: (STypeClassInfo asClassInfo: t4)]].
	t3 joinScalars: t1 scalars copy.
	^t3</body>
</methods>

<methods>
<class-id>SmallSuiteGenerator.STypeInfo</class-id> <category>accessing</category>

<body package="SmallSuiteGenerator-Extensions2" selector="classes">classes

	classes ifNil: [classes := Dictionary new].
	types keysDo: [:t1 | classes at: t1 ifAbsentPut: (SPlatform lookUpClass: t1)].
	^classes</body>
</methods>

<methods>
<class-id>SmallSuiteGenerator.STypeInfo</class-id> <category>adding</category>

<body package="SmallSuiteGenerator-Extensions2" selector="completeTypeInfo">completeTypeInfo
	self types keysDo: [:aClass | |classInfo realClassInfo|
	classInfo := SmallTypeCollector new collectTypeFrom: (self classOf: aClass asString) first.
	realClassInfo := self types at: aClass.
	classInfo methodTypes keysAndValuesDo: [ :key :value | 
		((self isInBlackListClass: aClass with: key) not and: [ key isUnary not and: [ value argTypes allSatisfy: [ :arg | arg types notEmpty ] ] ]) 
		ifTrue: [
			realClassInfo methodTypes 
			at: key
			ifAbsentPut: [ 
				self updateArgsOf: value.
				value returnType types ifEmpty: [value returnType type: #SUndefinedObject].
				value receiver type: aClass.
				value hasProfiler: false.
				value executions: 0.5 ] ] ] ]</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.STypeClassInfo</class-id> <category>adding</category>

<body package="SmallSuiteGenerator-Extensions2" selector="instanceMethodsFor:">instanceMethodsFor: aSpyClass
	| instanceMethods |
	instanceMethods := OrderedCollection new.
	(aSpyClass typeName endsWith: ' class') ifFalse: [ 
		instanceMethods := (aSpyClass methods reject: #isTest)
				select: [ :instMeth | instMeth wasExecuted or: [ instMeth isUnary ] ].
		instanceMethods do: [ :instMeth | instMeth wasExecuted ifFalse: [
			instMeth numberOfExecutions: 0.5.
			instMeth returnValue: SUndefinedObject basicNew.
			instMeth saveReceiver: (instMeth originalMethod mclass)
		] ] ].
	^ instanceMethods</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SmallTypeCollector</class-id> <category>action</category>

<body package="SmallSuiteGenerator-Extensions2" selector="collectTypeFrom:">collectTypeFrom: aClass
	|  typeInfo methodInfo|
	aClass isMeta ifTrue:[ ^ nil.].
	typeInfo := STypeClassInfo newFrom: aClass name.
	aClass methodDictionary values do:[ :method | 
				methodInfo := self methodInfoIn: method.
				typeInfo addMethod: methodInfo.
		].
	aClass class methodDictionary values do:[ :method | 		
				methodInfo := self methodInfoIn: method.
				typeInfo addClassMethod: methodInfo.		
			].
	^ typeInfo.</body>

<body package="SmallSuiteGenerator-Extensions2" selector="typeFor:">typeFor: argName
	|index lastPart|
	(argName = 'arg') ifTrue:[^#'SUndefinedObject'.].
	"Case 1:"
	(classDict at: argName asLowercase ifPresent:[ :value | ^ value name ]).
	"Case 2:"
	index := 1.
	[(index &lt;= argName size) and:[ (argName at: index) isLowercase]] whileTrue:[ index := index + 1.].
	lastPart := argName copyFrom: index to: argName size.
	(classDict at: lastPart asLowercase ifPresent:[ :value | ^ value name ]).
	"Case 3:"
	(argName asLowercase = 'spec') ifTrue:[^ #MetacelloAbstractVersionConstructor].
	"Case 4:"
	('.*(b|B)lock.*' match: argName) ifTrue:[^#BlockClosure].
	"Case 5:"
	('.*(o|O)rderedCollection.*' match: argName) ifTrue:[^#OrderedCollection].
	('.*(a|A)rray.*' match: argName) ifTrue:[^#Array].
	('.*(d|D)ictionary.*' match: argName) ifTrue:[^#Dictionary].
	('.*(s|S)et.*' match: argName) ifTrue:[^#Set ].
	('.*(b|B)ag.*' match: argName) ifTrue:[^#Bag].
	('.*(c|C)ollection.*' match: argName) ifTrue:[^#Collection].
	('.*(s|S)tring.*' match: argName) ifTrue:[^#String].
	('.*(s|S)ymbol.*' match: argName) ifTrue:[^#Symbol].
	
	^ #SUndefinedObject.</body>

<body package="SmallSuiteGenerator-Extensions2" selector="methodInfoIn:">methodInfoIn: aCompiledMethod
	| methodTypeInfo argTypes returnType |
	methodTypeInfo := STypeMethodInfo new.
	methodTypeInfo
		selector: aCompiledMethod selector;
		isQuick: aCompiledMethod isQuick;
		scalars: Dictionary new;
		isDeprecated: aCompiledMethod isDeprecated;
		executions: 0.
	argTypes := OrderedCollection new.
	aCompiledMethod ast argumentNames
		doWithIndex: [ :argName :index | 
			| argType |
			argType := SMultiTypeInfo new.
			 (self fullSymbolOf: (self typeFor: argName)) do: [ :t | argType type: t].
			argTypes add: argType ].
	returnType := SMultiTypeInfo new.
	 returnType type: aCompiledMethod mclass instanceBehavior fullName asSymbol.	"if not it is empty"
	methodTypeInfo returnType: returnType.
	methodTypeInfo argTypes: argTypes.
	^ methodTypeInfo</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.STestCaseFactory</class-id> <category>actions</category>

<body package="SmallSuiteGenerator-Extensions2" selector="moveClass:">moveClass: t1 

	| t2 t3 t4 t5 |
	t2 := Store.Registry bundleNamed: 'SmallSuiteGenerator'.
	t3 := Store.Registry packageNamedOrCreate: self outputPackageName.
	Store.XMainChangeSet current moveWholeClass: t1 toPackage: t3.
	(t5 := (t4 := t2 containedItems) select: [:t6 | t6 name = self outputPackageName]) isEmpty ifFalse: [t4 remove: t5 first].
	t4 add: t3.
	t2 containedItems: t4.
	^self</body>

<body package="SmallSuiteGenerator-Extensions2" selector="exportFitnessLog">exportFitnessLog

	| t1 t2 t3 |
	t1 := 'fitnessEvolution.txt' asFilename.
	t3 := $,.
	(t2 := t1 writeStream) nextPutAll: 'Generation number'; nextPut: t3; nextPutAll: 'bestFit'; nextPut: t3; nextPutAll: 'lowestFit'; nextPut: t3; nextPutAll: 'averageFit'; cr.
	([engine logs do: [:t5 | t2 nextPutAll: t5 generationNumber asString; nextPut: t3; nextPutAll: t5 fittestTestCase fitness values first asString; nextPut: t3; nextPutAll: t5 lowestFit values first asString; nextPut: t3; nextPutAll: t5 averageFit values first asString; cr]]) valueNowOrOnUnwindDo: [t2 close].
	^self</body>

<body package="SmallSuiteGenerator-Extensions2" selector="export:with:">export: t1 with: t2 

	| t3 |
	t3 := self getClassOf: 'GA' , (self targetClassName substrings: '.') last , 'Test'.
	self moveClass: t3.
	[ t1 generateAssertions.
	t3
		compile: (SPlatform rbParserClass parseMethod: t2 , t1 printDescriptiveComment , t1 parseTreeWithAssertions body formattedCode) formattedCode
		classified: ClassOrganizer defaultProtocol
		notifying: SilentCompilerErrorHandler new]
		on: Error
		do: 
			[:e || t4 |
			t4 := String with: Character cr.
			t3 compile: t2 , t4 , 'self should:' , t1 parseTree formattedCode , t4 , ' raise:Error.' , t4].
	^self</body>

<body package="SmallSuiteGenerator-Extensions2" selector="createConfigurationMethods">createConfigurationMethods

	| t1 |
	t1 := self getClassOf: 'GA' , (self targetClassName substrings: '.') last , 'Test'.
	setUpMethod ifNotNil: [t1 compile: setUpMethod].
	tearDownMethod ifNotNil: [t1 compile: tearDownMethod].
	^self</body>

<body package="SmallSuiteGenerator-Extensions2" selector="exportTests">exportTests
	engine population
		doWithIndex: [ :test :index | 
			test lastMessage: lastMessage.
			self export: test with: 'test' , index printString ].
	self createConfigurationMethods</body>

<body package="SmallSuiteGenerator-Extensions2" selector="tearDown">tearDown
	self uninstall.
	self exportTests.
	self exportFitnessLog.
	SPlatform asDict: false.
	SPlatform resetRandomGenerator </body>
</methods>

<methods>
<class-id>SmallSuiteGenerator.STestCaseFactory</class-id> <category>configuration</category>

<body package="SmallSuiteGenerator-Extensions2" selector="setUp">setUp
	
	self initializeProfiler.
	self firstExecution ifTrue: [
	SPlatform resetRandomGenerator.
	fitness profiler: profiler;
		typeInfo: typeInfo;
		targetClass: self targetClassName.
	engine fitness: fitness;
		numberOfGenerations: numberOfIterations;
		typeInfo: self typeInfo;
		targetClassName: self targetClassName;
		targetPackageRegex: targetPackageRegex.
	typeInfoSeed := (typeInfo classAt: targetClassName) dcopy]
ifFalse: [ engine fitness profiler: profiler.
	engine numberOfGenerations: numberOfIterations ]</body>

<body package="SmallSuiteGenerator-Extensions2" selector="seedBlock:">seedBlock: aBlock
	fitnessSeed := (Spy1.SLProfilerCoverage
		profile: aBlock
		inPackagesMatching: targetPackageRegex)
		statementCoverageFor: targetClassName</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.STestCaseFactoryVisualWorks</class-id> <category>actions</category>

<body package="SmallSuiteGenerator-Extensions2" selector="uninstall">uninstall

	profiler uninstall.
	^self</body>

<body package="SmallSuiteGenerator-Extensions2" selector="initializeProfiler">initializeProfiler

	((profiler := Spy1.SLProfilerCoverage profilerForPackagesMatching: self targetPackageRegex) allMethods select: #isNotMethodExtension)
		do: #installGhosts.
	^self</body>

<body package="SmallSuiteGenerator-Extensions2" selector="cleanInstrumentation">cleanInstrumentation

	profiler class removeFromPackages: packageInfos.
	^self</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SGAEngine</class-id> <category>actions</category>

<body package="SmallSuiteGenerator-Extensions2" selector="profilerForTargetClass">profilerForTargetClass
	| packageSpy cls classSpy |
	cls := Smalltalk at: targetClassName.
	Transcript show: 'profiling...'; cr.
	typeInfoProfiler := Spy1.SSTypeCollector new.
	Spy1.SSTypeCollector installOnClass: cls.
	typeInfoProfiler beforeProfiling .
	classSpy := typeInfoProfiler spyForClass: cls.
	packageSpy := typeInfoProfiler class spyClassForPackage new.
	packageSpy classAt: targetClassName put: classSpy.
	typeInfoProfiler addPackage: packageSpy.
	classSpy packageSpy: packageSpy.</body>

<body package="SmallSuiteGenerator-Extensions2" selector="initializeProfiler">initializeProfiler
	| aProfiler |
	aProfiler := Spy1.SLProfilerCoverage profilerForClass: targetClassName.
	(aProfiler allMethods select: #isNotMethodExtension)
		do: #installGhosts
		"displayingProgress: 'Instrumenting ' , targetClassName".
	^ aProfiler</body>

<body package="SmallSuiteGenerator-Extensions2" selector="updateTypeInfoWith:">updateTypeInfoWith: aPopulation
	"fitness profiler uninstallClass: targetClassName."
   self profilerForTargetClass.
   aPopulation do:
		[ :aTestCase | aTestCase runWithoutAssertions ].
   self mergeTypeInfo: (STypeInfo asTypeInfo: typeInfoProfiler).
   self uninstall .
   "fitness profiler updateClass: ((self initializeProfiler packages at:1) classes at: targetClassName). 
	fitness profiler deleteCache."</body>

<body package="SmallSuiteGenerator-Extensions2" selector="run">run
	| counter bestFitness stopFlag |
	counter := 0.
   stopFlag := false.
	population ifNil: [ self initializePopulation ]
		ifNotNil: [ 
			fitness typeInfo: typeInfo.
			initialPopulation := population ].
   bestFitness := self lastBestFitness.
   (1 to: numberOfGenerations) do: [:iteration |  | t lastBestFitness |
		stopFlag ifFalse: [ 
			t := Time now asSeconds.
         self doSelection.
			logs add: (SGALog logOf: self inGeneration: self lastGenerationNumber + 1 inTime: t).
         lastBestFitness := self lastBestFitness.
         lastBestFitness &lt;= bestFitness ifTrue: [ 
				counter := counter + 1.
				counter &gt; stopIterations ifTrue: [ stopFlag := true ] ] 
			ifFalse: [ 
				counter := 0.
				bestFitness := lastBestFitness ] ] ] 
	"displayingProgress: [:iteration |  'Evolving - Iteration' , iteration printString ]"</body>

<body package="SmallSuiteGenerator-Extensions2" selector="exportFitnessLog">exportFitnessLog

	| t1 t2 t3 |
	t1 := 'fitnessEvolution.txt' asFilename.
	t3 := $,.
	(t2 := t1 writeStream) nextPutAll: 'generation'; nextPut: t3; nextPutAll: 'bestFit'; nextPut: t3; nextPutAll: 'lowestFit'; nextPut: t3; nextPutAll: 'averageFit'; nextLine.
	([self logs do: [:t5 | t2 nextPutAll: t5 generationNumber asString; nextPut: t3; nextPutAll: t5 fittestTestCase fitness values first asString; nextPut: t3; nextPutAll: t5 lowestFit values first asString; nextPut: t3; nextPutAll: t5 averageFit values first asString; nextLine]]) valueNowOrOnUnwindDo: [t2 close].
	^self</body>

<body package="SmallSuiteGenerator-Extensions2" selector="nameOfTargetClass">nameOfTargetClass
	^ (targetClassName substrings: '.') last asSymbol</body>
</methods>

<methods>
<class-id>SmallSuiteGenerator.SGAEngine</class-id> <category>creating</category>

<body package="SmallSuiteGenerator-Extensions2" selector="createNewPopulation">createNewPopulation
	| newPopulation currentPopulationSize newNumber lastLowestFitness |
	lastLowestFitness := logs last lowestFit at: fitness functionName.
	currentPopulationSize := initialPopulation size.
	newPopulation := self eliteOfCurrentPopulation.
	[ newPopulation size &lt; currentPopulationSize ]
		whileTrue:
			[ | selectedList P1copy P2copy P1 P2 O1 O2 OM1 OM2 selectedOptions children |
			selectedList := selectionStrategy selectOf: initialPopulation.
			P1 := selectedList first.
			P2 := selectedList second.
			P1copy := (self similarChild: P1) idPopulation: 1.
			P2copy := (self similarChild: P2) idPopulation: 2.
			self shouldCrossOver
				ifTrue: [ children := crossoverOperator crossover: P1 with: P2.
					O1 := children first.
					O2 := children second ]
				ifFalse: [ O1 := P1copy deepCopy addParent: P1.
					O2 := P2copy deepCopy addParent: P2 ].
			OM1 := (self mutateAndUpdate: O1) idPopulation: 3.
			OM2 := (self mutateAndUpdate: O2) idPopulation: 4.
			fitness compute: (Array with: OM1 with: OM2).
			selectedOptions := self
				selectTwoBestOf:
					(Array
						with: OM1
						with: OM2
						with: P1copy
						with: P2copy)
				excludingAll: newPopulation. 
			newNumber := newPopulation size.
			selectedOptions
				select:
					[ :option | (option fitness at: fitness functionName) &gt;= lastLowestFitness ]
				thenDo: [ :option | 
					newNumber := newNumber + 1.
					option idPopulation: newNumber.
					newPopulation size &lt; currentPopulationSize
						ifTrue: [ newPopulation add: option ] ] ].
	self updateTypeInfoWith: newPopulation.
	self fixPopulation: newPopulation.
	population := newPopulation.
	population := self order: population</body>
</methods>



</st-source>
