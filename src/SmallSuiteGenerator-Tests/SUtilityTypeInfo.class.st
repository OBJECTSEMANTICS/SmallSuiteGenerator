"
SUtilityTypeInfo is a class which declares typeInfos for tests. 
"
Class {
	#name : #SUtilityTypeInfo,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-Tests-Utility'
}

{ #category : #tests }
SUtilityTypeInfo >> testSuiteOf: aCollection withTargetClassName: symbol [
	self
		assert: aCollection size >= 2
		description: 'list must have at least two or more testCases.'.
	^ OrderedCollection new
		add: ((SSTestCase with: aCollection first) addTargetClassName: symbol; generateStatements);
		add: ((SSTestCase with: aCollection second) addTargetClassName: symbol; generateStatements);
		yourself
]

{ #category : #tests }
SUtilityTypeInfo >> testSuiteSSTeacher [
	^ self
		testSuiteOf:
			(Array
				with: self typeInfoSSTeacher1
				with: self typeInfoSSTeacher2
				with: self typeInfoSSTeacher3) withTargetClassName: (self fullSymbolOf: #SSTeacher)
]

{ #category : #tests }
SUtilityTypeInfo >> testSuiteSStack [
	^ self
		testSuiteOf:
			(Array
				with: self typeInfoSStack1
				with: self typeInfoSStack2
				with: self typeInfoSStack3
				with: self typeInfoSStack4) withTargetClassName: (self fullSymbolOf: #SStack)
]

{ #category : #tests }
SUtilityTypeInfo >> testSuiteSStudent [
	^ self testSuiteOf: self typeInfosSStudent withTargetClassName: (self fullSymbolOf: #SStudent)
]

{ #category : #tests }
SUtilityTypeInfo >> testSuiteSStudentManual [
	^ OrderedCollection new
		add:
			((SSTestCase with: self typeInfosSStudent first)
				addTargetClassName: (self fullSymbolOf: #SStudent);
				addFactoryMessage: (self fullSymbolOf: #SStudent) ofSelector: #new;
				addLiteral: (self fullSymbolOf: #ByteString);
				addFieldAccessMessage: #idStudent from: (self fullSymbolOf: #SStudent);
				addMessage: #scoreStudent: from: (self fullSymbolOf: #SStudent);
				addFactoryMessage: (self fullSymbolOf: #SStudent) ofSelector: #new;
				addFieldAccessMessage: #scoreStudent from: (self fullSymbolOf: #SStudent);
				yourself);
		add:
			((SSTestCase with: self typeInfosSStudent first)
				addTargetClassName: (self fullSymbolOf: #SStudent);
				addLiteral: (self fullSymbolOf: #SmallInteger);
				addFactoryMessage: (self fullSymbolOf: #SStudent) ofSelector: #new;
				addMessage: #scoreStudent: from: (self fullSymbolOf: #SStudent);
				addFactoryMessage: (self fullSymbolOf: #SStudent) ofSelector: #new;
				addFieldAccessMessage: #idStudent from: (self fullSymbolOf: #SStudent);
				yourself);
		add:
			((SSTestCase with: self typeInfosSStudent first)
				addTargetClassName: (self fullSymbolOf: #SStudent);
				addFactoryMessage: (self fullSymbolOf: #SStudent) ofSelector: #new;
				addLiteral: (self fullSymbolOf: #SmallInteger);
				addMessage: #scoreStudent: from: (self fullSymbolOf: #SStudent);
				addLiteral: (self fullSymbolOf: #SmallInteger);
				addFactoryMessage: (self fullSymbolOf: #SStudent) ofSelector: #new;
				yourself);
		yourself
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoArrayedCollection [
	^ STypeInfo new
		type:
			(self fullSymbolOf: #ArrayedCollection)
				->
					(Array
						with:
							(Array
								with: #add -> #(#AthensCairoCanvas #nil #() false)
								with: #size -> #(#AthensCairoCanvas #nil #() false))
						with: #());
		scalar: (self fullSymbolOf: #ByteString) with: #('hello')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoOnPackage1 [
	"the first typeInfo is about a class has as argument other class from other package"

	^ STypeInfo new
		type:
			(self fullSymbolOf: #SEvent)
				->
					(Array
						with:
							(Array
								with: #canRegister: -> (Array 
									with: (self fullSymbolOf: #SConference) 
									with: (self fullSymbolOf: #False) 
									with: (Array with: (self fullSymbolOf: #SStudent))
									with: false)
								with: #price -> (Array 
									with: (self fullSymbolOf: #SConference) 
									with: (self fullSymbolOf: #SmallInteger) 
									with: #()
									with: false))
						with: #());
		type:
			(self fullSymbolOf: #SConference)
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array 
									with: (self fullSymbolOf: #SConference) 
									with: (self fullSymbolOf: #SConference) 
									with: #()
									with: false)
								with: #offerPrice -> (Array 
									with: (self fullSymbolOf: #SConference) 
									with: (self fullSymbolOf: #SmallInteger) 
									with: #()
									with: true)
								with: #offerPrice: -> (Array 
									with: (self fullSymbolOf: #SConference) 
									with: (self fullSymbolOf: #SConference) 
									with: (Array with: (self fullSymbolOf: #SmallInteger))
									with: false)
								with: #discount -> (Array 
									with: (self fullSymbolOf: #SConference) 
									with: (self fullSymbolOf: #SmallInteger) 
									with: #()
									with: true))
						with: #());
		scalar: (self fullSymbolOf: #SmallInteger) with: #(95 100);
		scalar: (self fullSymbolOf: #False) with: #(false);
		scalar: (self fullSymbolOf: #SStudent) with: (Array with: (SStudent new name: 'Mary'))
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoOnPackage2 [
	"the first typeInfo is about a class has as argument other class from other package"

	^ STypeInfo new
		type:
			(self fullSymbolOf: #SEvent)
				->
					(Array
						with:
							(Array
								with: #price: -> (Array with: (self fullSymbolOf:#SConference) 
															with: (self fullSymbolOf:#SConference)
															with: (Array with: (self fullSymbolOf:#SmallInteger))
															with: false))
						with:
							(Array
								with: #price: -> (Array with: (self fullSymbolOf:#SConference)
															with: (self fullSymbolOf:#SConference)
															with: (Array with: (self fullSymbolOf:#SmallInteger))
															with: false)));
		type:
			(self fullSymbolOf: #SConference)
				->
					(Array
						with: (Array with: #initialize -> (Array with: (self fullSymbolOf:#SConference)
															with: (self fullSymbolOf:#SConference)
															with: #()
															with: false))
						with: #());
		scalar: (self fullSymbolOf: #SmallInteger) with: #(95)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoOnPackage3 [
	"the first typeInfo is about a class has as argument other class from other package"

	"review and modify"

	^ STypeInfo new
		type:
			(self fullSymbolOf: #SSTeacher)
				->
					(Array
						with:
							(OrderedCollection new
								add: #name: -> (Array with: (self fullSymbolOf: #SSTeacher)
														with: (self fullSymbolOf: #SSTeacher)
														with: (Array with: (self fullSymbolOf: #ByteString))
														with: false);
								add: #id: -> (Array with: (self fullSymbolOf: #SSTeacher)
														with: (self fullSymbolOf: #SSTeacher)
														with: (Array with: (self fullSymbolOf: #SmallInteger))
														with: false);
								add: #nickname: -> (Array with: (self fullSymbolOf: #SSTeacher)
														with: (self fullSymbolOf:  #SSTeacher)
														with: (Array with: (self fullSymbolOf: #ByteString))
														with: false);
								add: #initialize -> (Array with: (self fullSymbolOf: #SSTeacher)
														with: (self fullSymbolOf: #SSTeacher)
														with: #()
														with: false);
								add: #nickname -> (Array with: (self fullSymbolOf: #SSTeacher)
														with: (self fullSymbolOf: #ByteString)
														with: #()
														with: false);
								add: #name -> (Array with: (self fullSymbolOf: #SSTeacher)
														with: (self fullSymbolOf: #ByteString)
														with: #()
														with: true);
								add: #id -> (Array with: (self fullSymbolOf: #SSTeacher)
														with: (self fullSymbolOf:  #SmallInteger)
														with: #()
														with: true);
								add: #yearsWorkExperience -> (Array with: (self fullSymbolOf: #SSTeacher)
														with: (self fullSymbolOf:  #SmallInteger)
														with: #()
														with: true);
								add: #idTeacher -> (Array with: (self fullSymbolOf: #SSTeacher)
														with: (self fullSymbolOf:  #SmallInteger)
														with: #()
														with: true);
								yourself)
						with:
							(Array
								with:
									#name:with:
										-> (Array with: (self fullSymbolOf: #SSTeacher)
														with: (self fullSymbolOf:  #SSTeacher)
														with: (Array with: (self fullSymbolOf: #ByteString) with: (self fullSymbolOf: #SmallInteger))
														with: false)));
		type:
			(self fullSymbolOf: #SConference)
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array with: (self fullSymbolOf: #SConference)
														with: (self fullSymbolOf:  #SConference)
														with: #()
														with: false)
								with: #offerPrice -> (Array with: (self fullSymbolOf: #SConference)
														with: (self fullSymbolOf: #SmallInteger)
														with: #()
														with: true)
								with: #offerPrice: -> (Array with: (self fullSymbolOf: #SConference)
														with: (self fullSymbolOf:  #SConference)
														with: (Array with: (self fullSymbolOf: #SmallInteger))
														with: false)
								with: #discount -> (Array with: (self fullSymbolOf: #SConference)
														with: (self fullSymbolOf: #SmallInteger)
														with: #()
														with: true))
						with: #());
		scalar: (self fullSymbolOf: #SmallInteger) with: #(95);
		scalar: (self fullSymbolOf: #False) with: #(false);
		scalar: (self fullSymbolOf: #SStudent) with: (Array with: (SStudent new name: 'Mary'));
		scalar: (self fullSymbolOf: #ByteString) with: #('Mary')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoOnPackage4 [
	"the first typeInfo is about a class has as argument other class from other package"

	"review and modify"

	^ STypeInfo new
		type:
			(self fullSymbolOf: #SEvent)
				->
					(Array
						with:
							(Array
								with: #price: -> (Array with: (self fullSymbolOf:#SConference)
															with: (self fullSymbolOf:#SConference)
															with: (Array with: (self fullSymbolOf:#SmallInteger))
															with: false))
						with:
							(Array
								with: #price: -> (Array with: (self fullSymbolOf:#SConference)
															with: (self fullSymbolOf: #SConference)
															with: (Array with: (self fullSymbolOf:#SmallInteger))
															with: false)));
		type:
			(self fullSymbolOf: #SConference)
				->
					(Array
						with: (Array with: #initialize -> (Array with: (self fullSymbolOf:#SConference)
															with: (self fullSymbolOf:#SConference)
															with: #() 
															with: false))
						with: #());
		type: (self fullSymbolOf: #SParty) -> #(#() #());
		scalar: (self fullSymbolOf: #SmallInteger) with: #(95)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSAbstractClass [
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SAbstractClass)
				->
					(Array
						with: (Array with: #id -> #(#SAbstractClass #SmallInteger #() false))
						with: #());
		scalar: (self fullSymbolOf: #SmallInteger) with: #(1)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSEvent1 [
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SEvent)
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array with: (self fullSymbolOf: #SEvent)
																with: (self fullSymbolOf: #SEvent)
																with: #()
																with: false)
								with: #discount -> (Array with: (self fullSymbolOf: #SEvent)
																with: (self fullSymbolOf: #SmallInteger)
																with: #()
																with: true)
								with: #discount: -> (Array with: (self fullSymbolOf: #SEvent)
																with: (self fullSymbolOf: #SEvent)
																with: (Array with: (self fullSymbolOf: #SmallInteger)) 
																with: false)
								with: #price -> (Array with: (self fullSymbolOf: #SEvent)
																with: (self fullSymbolOf: #SmallInteger)
																with: #() 
																with: true)
								with: #price: -> (Array with: (self fullSymbolOf: #SEvent)
																with: (self fullSymbolOf: #SEvent)
																with: (Array with: (self fullSymbolOf: #SmallInteger))
																with: false))
						with: (Array with: #price: -> (Array with: (self fullSymbolOf: #SEvent)
																with: (self fullSymbolOf: #SEvent)
																with: (Array with: (self fullSymbolOf: #SmallInteger)) 
																with: false)));
		scalar: (self fullSymbolOf: #SmallInteger) with: #(8)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSEvent2 [
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SEvent)
				->
					(Array
						with:
							(Array
								with: #initialize -> #(#SEvent #SEvent #() false)
								with: #discount -> #(#SEvent #SmallInteger #() true)
								with: #price -> #(#SEvent #SmallInteger #() true))
						with: (Array with: #price: -> #(#SEvent #SEvent #(#SmallInteger) false)));
		scalar: (self fullSymbolOf: #SmallInteger) with: #(0 15)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSEventOnPackage1 [
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SEvent)
				->
					(Array
						with:
							(Array
								with: #price -> #(#SEvent #SmallInteger #() false)
								with: #discount -> #(#SEvent #SmallInteger #() true)
								with: #initialize -> #(#SEvent #SEvent #() false)
								with: #price: -> #(#SEvent #SEvent #(#SmallInteger) false))
						with: (Array with: #price: -> #(#SEvent #SEvent #(#SmallInteger) false)));
		type: (self fullSymbolOf: #SSTeacher) -> #(#() #());
		type: (self fullSymbolOf: #SSPerson )-> #(#() #());
		type: (self fullSymbolOf: #SStack) -> #(#() #());
		type: (self fullSymbolOf: #SConference) -> #(#() #());
		type: (self fullSymbolOf: #SFoo) -> #(#() #());
		type: (self fullSymbolOf: #SParty) -> #(#() #());
		type: (self fullSymbolOf: #SEventTest) -> #(#() #());
		scalar: (self fullSymbolOf: #SmallInteger) with: #(15 0)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFoo1 [
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SFoo)
				->
					(Array
						with:
							(Array
								with: #returnNum -> (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #SmallInteger) 
									with: #()
									with: false)
								with: #returnFloat -> (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #SmallFloat64) 
									with: #()
									with: false)
								with: #returnString -> (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #ByteString) 
									with: #()
									with: false)
								with: #score -> (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #SmallFloat64) 
									with: #()
									with: true)
								with: #return: -> (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #ByteString) 
									with: (Array with: (self fullSymbolOf: #ByteString))
									with: false))
						with: (Array with: #score: -> (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #SFoo) 
									with: (Array with: (self fullSymbolOf: #SmallFloat64))
									with: false)));
		scalar: (self fullSymbolOf: #ByteString) with: #('hello');
		scalar: (self fullSymbolOf: #SmallInteger) with: #(5);
		scalar: (self fullSymbolOf: #SmallFloat64) with: #(7.3)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFoo2 [
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SFoo)
				->
					(Array
						with: (Array with: #return: -> (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #SFoo) 
									with: (Array with: (self fullSymbolOf: #SFoo))
									with: false))
						with: #())
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFoo3 [
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SFoo)
				->
					(Array
						with:
							(Array
								with: #returnNum -> (Array
																with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #SmallInteger)
																with: #()
																with: false)
								with: #returnFloat -> (Array
																with: (self fullSymbolOf:#SFoo)
																with: (self fullSymbolOf:#SmallFloat64)
																with: #()
																with: false)
								with: #returnString -> (Array
																with: (self fullSymbolOf:#SFoo)
																with: (self fullSymbolOf:#ByteString)
																with: #()
																with: false)
								with: #score -> (Array 
																with: (self fullSymbolOf:#SFoo)
																with: (self fullSymbolOf: #SmallInteger)
																with: #()
																with: true)
								with: #score: -> (Array
																with: (self fullSymbolOf:#SFoo)
																with: (self fullSymbolOf: #SFoo) 
																with: (Array with: (self fullSymbolOf:#SmallInteger))
																with: false))
						with: (Array with: #score: -> (Array 
																with: (self fullSymbolOf:#SFoo)
																with: (self fullSymbolOf: #SFoo)
																with: (Array with: (self fullSymbolOf:#SmallInteger))
																with: false)));
		scalar: (self fullSymbolOf: #ByteString) with: #('Hello');
		scalar: (self fullSymbolOf: #SmallInteger) with: #(4);
		scalar: (self fullSymbolOf: #SmallFloat64) with: #(2.3)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFoo4 [
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SFoo)
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #SFoo) 
									with: #()
									with: false)
								with: #return: ->  (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #SStudent) 
									with: (Array with: (self fullSymbolOf: #SStudent))
									with: false))
						with: #());
		scalar: (self fullSymbolOf: #SStudent) with: (Array with: SStudent new)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFoo5 [
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SFoo)
				->
					(Array
						with:
							(Array
								with: #return: -> (Array with: (self fullSymbolOf: #SFoo)
															with: (self fullSymbolOf: #OrderedCollection)
															with: (Array with: (self fullSymbolOf: #OrderedCollection))
															with:  false))
						with: #());
		scalar: (self fullSymbolOf: #OrderedCollection)
			with:
			(Array
				with:
					(OrderedCollection new
						addAll: #(1 4 5);
						yourself))
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFooEmpty [
	^ STypeInfo new type: (self fullSymbolOf: #SFoo) -> (Array with: #() with: #())
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFooOnPackage1 [
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SFoo)
				->
					(Array
						with:
							(Array
								with: #returnCollection -> (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #OrderedCollection) 
									with: #()
									with: false)
								with: #returnString -> (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #ByteString) 
									with: #()
									with: false)
								with: #score -> (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #SmallInteger) 
									with: #()
									with: true)
								with: #score: -> (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #SFoo) 
									with: (Array with: (self fullSymbolOf: #SmallInteger))
									with: false)
								with: #return: -> (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #SStudent) 
									with: (Array with: (self fullSymbolOf: #SStudent))
									with: false))
						with: (Array with: #score: -> (Array 
									with: (self fullSymbolOf: #SFoo) 
									with: (self fullSymbolOf: #SFoo) 
									with: (Array with: (self fullSymbolOf: #SmallInteger))
									with: false)));
		type:
			(self fullSymbolOf: #SSPerson)
				->
					(Array
						with:
							(Array
								with: #id: -> (Array 
									with: (self fullSymbolOf: #SStudent) 
									with: (self fullSymbolOf: #SStudent) 
									with: (Array with: (self fullSymbolOf: #SmallInteger))
									with: false)
								with: #nickname: -> (Array 
									with: (self fullSymbolOf: #SStudent) 
									with: (self fullSymbolOf: #SStudent) 
									with: (Array with: (self fullSymbolOf: #ByteString))
									with: false)
								with: #name: -> (Array 
									with: (self fullSymbolOf: #SStudent) 
									with: (self fullSymbolOf: #SStudent) 
									with: (Array with: (self fullSymbolOf: #ByteString))
									with: false))
						with: (Array with: #name: -> (Array 
									with: (self fullSymbolOf: #SStudent) 
									with: (self fullSymbolOf: #SStudent) 
									with: (Array with: (self fullSymbolOf: #ByteString))
									with: false)));
		type: (self fullSymbolOf: #SStack) -> #(#() #());
		type: (self fullSymbolOf: #SConference) -> #(#() #());
		type: (self fullSymbolOf: #SEvent) -> #(#() #());
		type: (self fullSymbolOf: #SSTeacher) -> #(#() #());
		type: (self fullSymbolOf: #SParty) -> #(#() #());
		type: (self fullSymbolOf: #SEventTest) -> #(#() #());
		scalar: (self fullSymbolOf: #SmallInteger) with: #(5 1 4);
		scalar: (self fullSymbolOf: #ByteString) with: #('Emily' 'Hello');
		scalar: (self fullSymbolOf: #OrderedCollection)
			with: (Array with: OrderedCollection new);
		scalar: (self fullSymbolOf: #SStudent)
			with:
			(Array
				with:
					((SStudent name: 'Emily')
						nickname;
						scoreStudent;
						yourself))
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFooOnPackage2 [
	^ STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #returnFloat -> #(#SFoo #SmallFloat64 #() false)
								with: #returnCollection -> #(#SFoo #OrderedCollection #() false)
								with: #initialize -> #(#SFoo #SFoo #() false)
								with: #score -> #(#SFoo #SmallInteger #() true)
								with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false)
								with: #return: -> #(#SFoo #SStudent #(#SStudent) false))
						with: (Array with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false)));
		type: #SSPerson -> #(#() #());
		type: #SStack -> #(#() #());
		type: #SConference -> #(#() #());
		type: #SEvent -> #(#() #());
		type: #SSTeacher -> #(#() #());
		type: #SParty -> #(#() #());
		type: #SEventTest -> #(#() #());
		scalar: #SmallInteger with: #(15);
		scalar: #SmallFloat64 with: #(2.3);
		scalar: #OrderedCollection
			with: (Array with: OrderedCollection new);
		scalar: #Array with: #(#(1 5 6))
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFooOnPackage3 [
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SSPerson)
				->
					(Array
						with:
							(Array
								with: #id: -> (Array with: (self fullSymbolOf: #SStudent)
														with: (self fullSymbolOf: #SStudent)
														with: (Array with: (self fullSymbolOf: #SmallInteger))
														with: false)
								with: #nickname: -> (Array with: (self fullSymbolOf: #SStudent)
														with: (self fullSymbolOf: #SStudent)
														with: (Array with: (self fullSymbolOf: #ByteString))
														with: false)
								with: #name: -> (Array with: (self fullSymbolOf: #SStudent)
														with: (self fullSymbolOf: #SStudent)
														with: (Array with: (self fullSymbolOf: #ByteString))
														with: false))
						with:
							(Array
								with:
									#name:with:
										-> (Array with: (self fullSymbolOf: #SStudent)
												with: (self fullSymbolOf: #SStudent)
												with: (Array with: (self fullSymbolOf: #ByteString) with: (self fullSymbolOf:  #SmallInteger))
												with: false)));
		type:
			(self fullSymbolOf: #SFoo)
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf:  #SFoo)
																with: #()
																with: false)
								with: #return: -> (Array with: (self fullSymbolOf: #SFoo)
																with: (self fullSymbolOf: #Dictionary)
																with: (Array with: (self fullSymbolOf: #Dictionary))
																with: false))
						with: #());
		type:
			(self fullSymbolOf: #SStack)
				->
					(Array
						with: (Array with: #push: -> (Array with: (self fullSymbolOf: #SStack)
																with: (self fullSymbolOf: #SStudent)
																with: (Array with: (self fullSymbolOf: #SStudent))
																with: false))
						with: #());
		type: (self fullSymbolOf: #SConference) -> #(#() #());
		type: (self fullSymbolOf: #SEvent) -> #(#() #());
		type: (self fullSymbolOf: #SParty) -> #(#() #());
		type: (self fullSymbolOf: #SSTeacher) -> #(#() #());
		type: (self fullSymbolOf: #SEventTest) -> #(#() #());
		scalar: (self fullSymbolOf: #SStudent)
			with:
			(Array
				with: (SStudent name: 'Mery' with: 5)
				with: (SStudent name: 'Josh' with: 2)
				with: (SStudent name: 'Lian'));
		scalar: (self fullSymbolOf: #Dictionary)
			with:
			(Array
				with:
					(Dictionary new
						at: 1
							put:
							(SStack new
								push: (SStudent name: 'Josh' with: 2);
								push: (SStudent name: 'Lian');
								yourself);
						at: 2
							put:
							(OrderedCollection new
								add: (SStudent name: 'Mery' with: 5);
								yourself);
						yourself));
		scalar: (self fullSymbolOf: #SmallInteger) with: #(5 1 2);
		scalar: (self fullSymbolOf: #ByteString) with: #('Josh' 'Lian' 'Mery')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSSPerson1 [
	^ STypeInfo new
		type:
			(self fullNameOfClass: #SSPerson)
				->
					(Array
						with:
							(Array
								with: #name -> (Array with: (self fullNameOfClass: #SSPerson)
														with: (self fullNameOfClass:  #ByteString)
														with: #()
														with: true)
								with: #id -> (Array with: (self fullNameOfClass: #SSPerson)
														with: (self fullNameOfClass:  #SmallInteger)
														with:  #()
														with: false))
						with:
							(Array
								with:
									#name:with:
										-> (Array with: (self fullNameOfClass: #SSPerson)
													with: (self fullNameOfClass: #SSPerson)
													with: (Array with: (self fullNameOfClass: #ByteString)with: (self fullNameOfClass: #SmallInteger))
													with: false)));
		scalar: (self fullNameOfClass: #SmallInteger) with: #(50);
		scalar: (self fullNameOfClass: #ByteString) with: #('Ann')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSSTeacher1 [
	^ STypeInfo new
		type:
			#SSTeacher
				->
					(Array
						with:
							(Array
								with: #initialize -> #(#SSTeacher #SSTeacher #() false)
								with: #yearsWorkExperience -> #(#SSTeacher #SmallInteger #() true)
								with:
									#yearsWorkExperience:
										-> #(#SSTeacher #SSTeacher #(#SmallInteger) false))
						with: #());
		scalar: #SmallInteger with: #(0 100);
		scalar: #ByteString with: #('teacher_Ann')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSSTeacher2 [
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SSTeacher)
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array with: (self fullSymbolOf: #SSTeacher)
																with: (self fullSymbolOf:  #SSTeacher)
																with: #()
																with: false)
								with: #idTeacher -> (Array with: (self fullSymbolOf: #SSTeacher)
																with: (self fullSymbolOf:  #SmallInteger)
																with: #()
																with: true)
								with:
									#yearsWorkExperience:
										-> (Array with: (self fullSymbolOf: #SSTeacher)
													with: (self fullSymbolOf: #SSTeacher)
													with: (Array with: (self fullSymbolOf: #SmallInteger))
													with: false)
								with: #nickname -> (Array with: (self fullSymbolOf: #SSTeacher)
													with: (self fullSymbolOf: #ByteString)
													with: #()
													with: false))
						with: #());
		scalar: (self fullSymbolOf: #SmallInteger) with: #(1 29 -7 9);
		scalar: (self fullSymbolOf: #ByteString) with: #('teacher_Amy' 'teacher_Mark')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSSTeacher3 [
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SSTeacher)
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array with: (self fullSymbolOf: #SSTeacher)
																with: (self fullSymbolOf: #SSTeacher)
																with: #()
																with: false)
								with: #yearsWorkExperience -> (Array with: (self fullSymbolOf: #SSTeacher)
																with: (self fullSymbolOf:  #SmallInteger)
																with: #()
																with: false)
								with: #nickname -> (Array with: (self fullSymbolOf: #SSTeacher)
																with: (self fullSymbolOf: #ByteString) 
																with: #()
																with: false))
						with: #());
		scalar: (self fullSymbolOf: #SmallInteger) with: #(1 10);
		scalar: (self fullSymbolOf: #ByteString) with: #('teacher_Amy' 'teacher_Mark')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSSTeacher4 [
	^ STypeInfo new
		type:
			(self fullSymbolOf:#SSTeacher)
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array with: (self fullSymbolOf:#SSTeacher)
																with: (self fullSymbolOf: #SSTeacher)
																with: #()
																with: false)
								with: #idTeacher -> (Array with: (self fullSymbolOf:#SSTeacher)
																with: (self fullSymbolOf:#SmallInteger)
																with: #()
																with: true)
								with: #yearsWorkExperience -> (Array with: (self fullSymbolOf:#SSTeacher)
																with: (self fullSymbolOf: #SSTeacher)
																with: #()
																with: true))
						with: #());
		scalar: (self fullSymbolOf:#SmallInteger) with: #(1 29 9);
		scalar: (self fullSymbolOf:#ByteString) with: #('teacher_Amy' 'teacher_Mark')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSSTeacherOnPackage1 [
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SSPerson)
				->
					(Array
						with:
							(Array
								with: #id: -> (Array 
									with: (self fullSymbolOf: #SSTeacher) 
									with: (self fullSymbolOf: #SSTeacher) 
									with: (Array with: (self fullSymbolOf: #SmallInteger))
									with: false)
								with: #nickname: -> (Array 
									with: (self fullSymbolOf: #SSTeacher) 
									with: (self fullSymbolOf: #SSTeacher) 
									with: (Array with: (self fullSymbolOf: #ByteString))
									with: false)
								with: #name -> (Array 
									with: (self fullSymbolOf: #SSTeacher) 
									with: (self fullSymbolOf: #ByteString) 
									with: #()
									with: true)
								with: #id -> (Array 
									with: (self fullSymbolOf: #SSTeacher) 
									with: (self fullSymbolOf: #SmallInteger) 
									with: #()
									with: true)
								with: #name: -> (Array 
									with: (self fullSymbolOf: #SSTeacher) 
									with: (self fullSymbolOf: #SSTeacher) 
									with: (Array with: (self fullSymbolOf: #ByteString))
									with: false))
						with:
							(Array
								with:
									#name:with:
										-> (Array 
									with: (self fullSymbolOf: #SSTeacher) 
									with: (self fullSymbolOf: #SSTeacher) 
									with: (Array with: (self fullSymbolOf: #ByteString) with: (self fullSymbolOf: #SmallInteger))
									with: false)));
		type:
			(self fullSymbolOf: #SSTeacher)
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array 
									with: (self fullSymbolOf: #SSTeacher) 
									with: (self fullSymbolOf: #SSTeacher) 
									with: #()
									with: false)
								with: #idTeacher -> (Array 
									with: (self fullSymbolOf: #SSTeacher) 
									with: (self fullSymbolOf: #SmallInteger) 
									with: #()
									with: true)
								with:
									#yearsWorkExperience:
										-> (Array 
									with: (self fullSymbolOf: #SSTeacher) 
									with: (self fullSymbolOf: #SSTeacher) 
									with: (Array with: (self fullSymbolOf: #SmallInteger))
									with: false)
								with: #nickname -> (Array 
									with: (self fullSymbolOf: #SSTeacher) 
									with: (self fullSymbolOf: #ByteString) 
									with: #()
									with: false))
						with: #());
		type: (self fullSymbolOf: #SStack) -> #(#() #());
		type: (self fullSymbolOf: #SConference) -> #(#() #());
		type: (self fullSymbolOf: #SEvent) -> #(#() #());
		type: (self fullSymbolOf: #SFoo) -> #(#() #());
		type: (self fullSymbolOf: #SParty) -> #(#() #());
		type: (self fullSymbolOf: #SEventTest) -> #(#() #());
		scalar: (self fullSymbolOf: #SmallInteger) with: #(0 100 34);
		scalar: (self fullSymbolOf: #ByteString) with: #('Ann' 'teacher_Ann')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSSTeacherOnPackage2 [
	^ STypeInfo new
		type:
			#SSTeacher
				->
					(Array
						with:
							(Array
								with: #initialize -> #(#SSTeacher #SSTeacher #() false)
								with: #nickname -> #(#SSTeacher #SSTeacher #() false)
								with: #yearsWorkExperience -> #(#SSTeacher #SmallInteger #() true))
						with: #());
		type: #SSPerson -> #(#() #());
		type: #SStack -> #(#() #());
		type: #SConference -> #(#() #());
		type: #SEvent -> #(#() #());
		type: #SFoo -> #(#() #());
		type: #SParty -> #(#() #());
		type: #SEventTest -> #(#() #());
		scalar: #SmallInteger with: #(0);
		scalar: #ByteString with: #('teacher_1')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSStack1 [
	^ STypeInfo new
		type:
			#SStack
				->
					(Array
						with:
							(Array
								with: #firstLinkStack -> #(#SStack #SmallInteger #() true)
								with: #pop -> #(#SStack #SmallInteger #() false)
								with: #push: -> #(#SStack #SmallInteger #(#SmallInteger) false))
						with: (Array with: #newStackWith: -> #(#SStack #SStack #(#Array) false)));
		scalar: #Array with: #(#(2 4 6 1));
		scalar: #SmallInteger with: #(1 2 4 6 8)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSStack2 [
	^ STypeInfo new
		type:
			#SStack
				->
					(Array
						with:
							(Array
								with: #lastLinkStack -> #(#SStack #SmallInteger #() true)
								with: #pop -> #(#SStack #SmallInteger #() false)
								with: #top -> #(#SStack #SmallInteger #() false))
						with:
							(Array
								with: #newStack -> #(#SStack #SStack #() false)
								with: #newStackWith: -> #(#SStack #SStack #(#Array) false)));
		scalar: #Array with: #(#(2 4 6 1) #(5 7 9 0));
		scalar: #SmallInteger with: #(1 2 5 8 9)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSStack3 [
	^ STypeInfo new
		type:
			#SStack
				->
					(Array
						with:
							(Array
								with: #pop -> #(#SStack #SmallInteger #() false)
								with: #push: -> #(#SStack #SmallInteger #(#SmallInteger) false)
								with: #top -> #(#SStack #SmallInteger #() false))
						with: (Array with: #newStackWith: -> #(#SStack #SStack #(#Array) false)));
		scalar: #Array with: (Array with: #(2 4 6 1));
		scalar: #SmallInteger with: #(7 5 9 1)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSStack4 [
	^ STypeInfo new
		type:
			(self fullSymbolOf: #SStack)
				->
					(Array
						with:
							(Array
								with: #firstLinkStack -> (Array 
									with: (self fullSymbolOf: #SStack) 
									with: (self fullSymbolOf: #SmallInteger) 
									with: #()
									with: true)
								with: #lastLinkStack -> (Array 
									with: (self fullSymbolOf: #SStack) 
									with: (self fullSymbolOf: #SmallInteger) 
									with: #()
									with: true)
								with: #pop -> (Array 
									with: (self fullSymbolOf: #SStack) 
									with: (self fullSymbolOf: #SmallInteger) 
									with: #()
									with: false)
								with: #push: -> (Array 
									with: (self fullSymbolOf: #SStack) 
									with: (self fullSymbolOf: #SmallInteger) 
									with: (Array with: (self fullSymbolOf: #SmallInteger))
									with: false)
								with: #top -> (Array 
									with: (self fullSymbolOf: #SStack) 
									with: (self fullSymbolOf: #SmallInteger) 
									with: #()
									with: false))
						with:
							(Array
								with: #newStack -> (Array 
									with: (self fullSymbolOf: #SStack) 
									with: (self fullSymbolOf: #SStack) 
									with: #()
									with: false)
								with: #newStackWith: -> (Array 
									with: (self fullSymbolOf: #SStack) 
									with: (self fullSymbolOf: #SStack) 
									with: (Array with: (self fullSymbolOf: #Array))
									with: false)));
		scalar: (self fullSymbolOf: #SmallInteger) with: #(5);
		scalar: (self fullSymbolOf: #Array) with: #(#(1 4 5))
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSStackOnPackage1 [
	^ STypeInfo new
		type:
			#SStack
				->
					(Array
						with:
							(Array
								with: #pop -> #(#SStack #SmallInteger #() false)
								with: #push: -> #(#SStack #SmallInteger #(#SmallInteger) false)
								with: #top -> #(#SStack #SmallInteger #() false))
						with: (Array with: #newStackWith: -> #(#SStack #SStack #(#Array) false)));
		type: #SSPerson -> #(#() #());
		type: #SSTeacher -> #(#() #());
		type: #SConference -> #(#() #());
		type: #SEvent -> #(#() #());
		type: #SFoo -> #(#() #());
		type: #SParty -> #(#() #());
		type: #SEventTest -> #(#() #());
		scalar: #SmallInteger with: #(1 2 4 6 8);
		scalar: #Array with: #(#(2 4 6 1))
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSStackOnPackage2 [
	^ STypeInfo new
		type:
			#SSPerson
				->
					(Array
						with:
							(Array
								with: #id: -> #(#SStudent #SStudent #(#SmallInteger) false)
								with: #nickname: -> #(#SStudent #SStudent #(#ByteString) false)
								with: #name: -> #(#SStudent #SStudent #(#ByteString) false))
						with:
							(Array
								with:
									#name:with:
										-> #(#SStudent #SStudent #(#ByteString #SMallInteger) false)));
		type:
			#SStack
				->
					(Array
						with:
							(Array
								with: #push: -> #(#SStack #OrderedCollection #(#OrderedCollection) false))
						with: #());
		type: #SFoo -> #(#() #());
		type: #SConference -> #(#() #());
		type: #SEvent -> #(#() #());
		type: #SParty -> #(#() #());
		type: #SSTeacher -> #(#() #());
		type: #SEventTest -> #(#() #());
		scalar: #SStudent
			with:
			(Array
				with: (SStudent name: 'Josh' with: 2)
				with: (SStudent name: 'Mery' with: 5)
				with: (SStudent name: 'Lian'));
		scalar: #OrderedCollection
			with:
			(Array
				with:
					(OrderedCollection new
						add: (SStudent name: 'Mery' with: 5);
						yourself)
				with:
					(OrderedCollection new
						add: (SStudent name: 'Lian');
						add: (SStudent name: 'Josh' with: 2);
						yourself));
		scalar: #SmallInteger with: #(5 1 2);
		scalar: #ByteString with: #('Josh' 'Lian' 'Mery')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSStudentOnPackage1 [
	^ STypeInfo new
		type:
			#SStudent
				->
					(Array
						with:
							(Array
								with: #initialize -> #(#SStudent #SStudent #() false)
								with: #idStudent -> #(#SStudent #SmallInteger #() true)
								with: #scoreStudent -> #(#SStudent #SmallInteger #() true)
								with: #scoreStudent: -> #(#SStudent #SmallInteger #(#SmallInteger) false))
						with: #());
		type: #SAbstractClass -> #(#() #());
		scalar: #SmallInteger with: #(10 1)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoStringSEvent [
	"(SSTypeCollector
				profile: [ (SEvent price: 15)
						price;
						discount ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario')"
	^ 'STypeInfo {
	#types : {
		#SStack : STypeClassInfo {
			#typeName : #SStack,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SSPerson : STypeClassInfo {
			#typeName : #SSPerson,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SConference : STypeClassInfo {
			#typeName : #SConference,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SEvent : STypeClassInfo {
			#typeName : #SEvent,
			#methodTypes : {
				#price : STypeMethodInfo {
					#selector : #price,
					#returnType : SMultiTypeInfo [ #SmallInteger ],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SEvent ]
				},
				#discount : STypeMethodInfo {
					#selector : #discount,
					#returnType : SMultiTypeInfo [ #SmallInteger ],
					#isQuick : true,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SEvent ]
				},
				#initialize : STypeMethodInfo {
					#selector : #initialize,
					#returnType : SMultiTypeInfo [ #SEvent ],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SEvent ]
				},
				#''price:'' : STypeMethodInfo {
					#selector : #''price:'',
					#returnType : SMultiTypeInfo [ #SEvent ],
					#argTypes : [
						SMultiTypeInfo [ #SmallInteger ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SEvent ]
				}
			},
			#classMethodTypes : {
				#''price:'' : STypeMethodInfo {
					#selector : #''price:'',
					#returnType : SMultiTypeInfo [ #SEvent ],
					#argTypes : [
						SMultiTypeInfo [ #SmallInteger ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SEvent ]
				}
			}
		},
		#SSTeacher : STypeClassInfo {
			#typeName : #SSTeacher,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SParty : STypeClassInfo {
			#typeName : #SParty,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SEventTest : STypeClassInfo {
			#typeName : #SEventTest,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SFoo : STypeClassInfo {
			#typeName : #SFoo,
			#methodTypes : { },
			#classMethodTypes : { }
		}
	},
	#scalars : {
		#SmallInteger : [
			15,
			0
		]
	}
}'
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoStringSFoo2 [
	"SSTypeCollector
				profile: [ (SFoo score: 15)
						returnCollection;
						returnFloat;
						score;
						return: #(1 5 6) ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario'"
	^ 'STypeInfo {
	#types : {
		#SStack : STypeClassInfo {
			#typeName : #SStack,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SSPerson : STypeClassInfo {
			#typeName : #SSPerson,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SConference : STypeClassInfo {
			#typeName : #SConference,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SEvent : STypeClassInfo {
			#typeName : #SEvent,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SSTeacher : STypeClassInfo {
			#typeName : #SSTeacher,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SParty : STypeClassInfo {
			#typeName : #SParty,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SEventTest : STypeClassInfo {
			#typeName : #SEventTest,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SFoo : STypeClassInfo {
			#typeName : #SFoo,
			#methodTypes : {
				#returnFloat : STypeMethodInfo {
					#selector : #returnFloat,
					#returnType : SMultiTypeInfo [ #SmallFloat64 ],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SFoo ]
				},
				#''score:'' : STypeMethodInfo {
					#selector : #''score:'',
					#returnType : SMultiTypeInfo [ #SFoo ],
					#argTypes : [
						SMultiTypeInfo [ #SmallInteger ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SFoo ]
				},
				#initialize : STypeMethodInfo {
					#selector : #initialize,
					#returnType : SMultiTypeInfo [ #SFoo ],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SFoo ]
				},
				#returnCollection : STypeMethodInfo {
					#selector : #returnCollection,
					#returnType : SMultiTypeInfo [ #OrderedCollection ],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SFoo ]
				},
				#''return:'' : STypeMethodInfo {
					#selector : #''return:'',
					#returnType : SMultiTypeInfo [ #Array ],
					#argTypes : [
						SMultiTypeInfo [ #Array ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SFoo ]
				},
				#score : STypeMethodInfo {
					#selector : #score,
					#returnType : SMultiTypeInfo [ #SmallInteger ],
					#isQuick : true,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SFoo ]
				}
			},
			#classMethodTypes : {
				#''score:'' : STypeMethodInfo {
					#selector : #''score:'',
					#returnType : SMultiTypeInfo [ #SFoo ],
					#argTypes : [
						SMultiTypeInfo [ #SmallInteger ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SFoo ]
				}
			}
		}
	},
	#scalars : {
		#OrderedCollection : [
			OrderedCollection [ ]
		],
		#Array : [
			[
				1,
				5,
				6
			]
		],
		#SmallInteger : [
			15
		],
		#SmallFloat64 : [
			2.3
		]
	}
}'
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoStringSFoo3 [
	"SSTypeCollector profile:[ (SFoo score: 4)
				score;
				returnCollection;
				returnString;
				score: 5;
				return:
					((SStudent name: 'Emily')
						nickname;
						scoreStudent;
						yourself) ] onPackagesMatching: 'SmallSuiteGenerator-Scenario'."

	^ 'STypeInfo {
	#types : {
		#SStack : STypeClassInfo {
			#typeName : #SStack,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SSPerson : STypeClassInfo {
			#typeName : #SSPerson,
			#methodTypes : {
				#''id:'' : STypeMethodInfo {
					#selector : #''id:'',
					#returnType : SMultiTypeInfo [ #SStudent ],
					#argTypes : [
						SMultiTypeInfo [ #SmallInteger ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStudent ]
				},
				#''nickname:'' : STypeMethodInfo {
					#selector : #''nickname:'',
					#returnType : SMultiTypeInfo [ #SStudent ],
					#argTypes : [
						SMultiTypeInfo [ #ByteString ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStudent ]
				},
				#''name:'' : STypeMethodInfo {
					#selector : #''name:'',
					#returnType : SMultiTypeInfo [ #SStudent ],
					#argTypes : [
						SMultiTypeInfo [ #ByteString ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStudent ]
				}
			},
			#classMethodTypes : {
				#''name:'' : STypeMethodInfo {
					#selector : #''name:'',
					#returnType : SMultiTypeInfo [ #SStudent ],
					#argTypes : [
						SMultiTypeInfo [ #ByteString ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStudent ]
				}
			}
		},
		#SConference : STypeClassInfo {
			#typeName : #SConference,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SEvent : STypeClassInfo {
			#typeName : #SEvent,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SSTeacher : STypeClassInfo {
			#typeName : #SSTeacher,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SParty : STypeClassInfo {
			#typeName : #SParty,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SEventTest : STypeClassInfo {
			#typeName : #SEventTest,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SFoo : STypeClassInfo {
			#typeName : #SFoo,
			#methodTypes : {
				#''score:'' : STypeMethodInfo {
					#selector : #''score:'',
					#returnType : SMultiTypeInfo [ #SFoo ],
					#argTypes : [
						SMultiTypeInfo [ #SmallInteger ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SFoo ]
				},
				#initialize : STypeMethodInfo {
					#selector : #initialize,
					#returnType : SMultiTypeInfo [ #SFoo ],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SFoo ]
				},
				#returnCollection : STypeMethodInfo {
					#selector : #returnCollection,
					#returnType : SMultiTypeInfo [ #OrderedCollection ],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SFoo ]
				},
				#returnString : STypeMethodInfo {
					#selector : #returnString,
					#returnType : SMultiTypeInfo [ #ByteString ],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SFoo ]
				},
				#''return:'' : STypeMethodInfo {
					#selector : #''return:'',
					#returnType : SMultiTypeInfo [ #SStudent ],
					#argTypes : [
						SMultiTypeInfo [ #SStudent ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SFoo ]
				},
				#score : STypeMethodInfo {
					#selector : #score,
					#returnType : SMultiTypeInfo [ #SmallInteger ],
					#isQuick : true,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SFoo ]
				}
			},
			#classMethodTypes : {
				#''score:'' : STypeMethodInfo {
					#selector : #''score:'',
					#returnType : SMultiTypeInfo [ #SFoo ],
					#argTypes : [
						SMultiTypeInfo [ #SmallInteger ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SFoo ]
				}
			}
		}
	},
	#scalars : {
		#OrderedCollection : [
			OrderedCollection [ ]
		],
		#SmallInteger : [
			5,
			1,
			4
		],
		#ByteString : [
			''Emily'',
			''Hello''
		],
		#SStudent : [
			SStudent {
				#name : ''Emily'',
				#id : 1,
				#nickname : ''Emily'',
				#scoreStudent : 1
			}
		]
	}
}'
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoStringSFoo6 [
	"SSTypeCollector profile: [ SFoo new return: (Dictionary new at: 1 put: (SStack new push: (SStudent  name: 'Lian' with: 1); push: (SStudent name: 'Josh' with: 2); yourself ); at: 2 put: (OrderedCollection new add: (SStudent name: 'Mery' with: 5); yourself); yourself ) ] onPackagesMatching: 'SmallSuiteGenerator-Scenario'."
	^ 'STypeInfo {
	#types : {
		#SStack : STypeClassInfo {
			#typeName : #SStack,
			#methodTypes : {
				#''push:'' : STypeMethodInfo {
					#selector : #''push:'',
					#returnType : SMultiTypeInfo [ #SStudent ],
					#argTypes : [
						SMultiTypeInfo [ #SStudent ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStack ]
				}
			},
			#classMethodTypes : { }
		},
		#SSPerson : STypeClassInfo {
			#typeName : #SSPerson,
			#methodTypes : {
				#''id:'' : STypeMethodInfo {
					#selector : #''id:'',
					#returnType : SMultiTypeInfo [ #SStudent ],
					#argTypes : [
						SMultiTypeInfo [ #SmallInteger ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStudent ]
				},
				#''nickname:'' : STypeMethodInfo {
					#selector : #''nickname:'',
					#returnType : SMultiTypeInfo [ #SStudent ],
					#argTypes : [
						SMultiTypeInfo [ #ByteString ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStudent ]
				},
				#''name:'' : STypeMethodInfo {
					#selector : #''name:'',
					#returnType : SMultiTypeInfo [ #SStudent ],
					#argTypes : [
						SMultiTypeInfo [ #ByteString ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStudent ]
				}
			},
			#classMethodTypes : {
				#''name:with:'' : STypeMethodInfo {
					#selector : #''name:with:'',
					#returnType : SMultiTypeInfo [ #SStudent ],
					#argTypes : [
						SMultiTypeInfo [ #ByteString ],
						SMultiTypeInfo [ #SmallInteger ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStudent ]
				}
			}
		},
		#SConference : STypeClassInfo {
			#typeName : #SConference,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SEvent : STypeClassInfo {
			#typeName : #SEvent,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SSTeacher : STypeClassInfo {
			#typeName : #SSTeacher,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SParty : STypeClassInfo {
			#typeName : #SParty,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SEventTest : STypeClassInfo {
			#typeName : #SEventTest,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SFoo : STypeClassInfo {
			#typeName : #SFoo,
			#methodTypes : {
				#initialize : STypeMethodInfo {
					#selector : #initialize,
					#returnType : SMultiTypeInfo [ #SFoo ],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SFoo ]
				},
				#''return:'' : STypeMethodInfo {
					#selector : #''return:'',
					#returnType : SMultiTypeInfo [ #Dictionary ],
					#argTypes : [
						SMultiTypeInfo [ #Dictionary ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SFoo ]
				}
			},
			#classMethodTypes : { }
		}
	},
	#scalars : {
		#Dictionary : [
			{
				1 : SStack [
					SStudent {
						#name : ''Josh'',
						#id : 2,
						#nickname : ''Josh'',
						#scoreStudent : 1,
						#idStudent : 1
					},
					SStudent {
						#name : ''Lian'',
						#id : 1,
						#nickname : ''Lian'',
						#scoreStudent : 1,
						#idStudent : 1
					}
				],
				2 : OrderedCollection [
					SStudent {
						#name : ''Mery'',
						#id : 5,
						#nickname : ''Mery'',
						#scoreStudent : 1,
						#idStudent : 1
					}
				]
			}
		],
		#ByteString : [
			''Josh'',
			''Lian'',
			''Mery''
		],
		#SmallInteger : [
			5,
			1,
			2
		],
		#SStudent : [
			@65,
			@68,
			@66
		]
	}
}'
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoStringSSTeacher1 [
	"SSTypeCollector
		profile: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario'."
	^ 'STypeInfo {
	#types : {
		#SStack : STypeClassInfo {
			#typeName : #SStack,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SSPerson : STypeClassInfo {
			#typeName : #SSPerson,
			#methodTypes : {
				#''id:'' : STypeMethodInfo {
					#selector : #''id:'',
					#returnType : SMultiTypeInfo [ #SSTeacher ],
					#argTypes : [
						SMultiTypeInfo [ #SmallInteger ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SSTeacher ]
				},
				#''nickname:'' : STypeMethodInfo {
					#selector : #''nickname:'',
					#returnType : SMultiTypeInfo [ #SSTeacher ],
					#argTypes : [
						SMultiTypeInfo [ #ByteString ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SSTeacher ]
				},
				#name : STypeMethodInfo {
					#selector : #name,
					#returnType : SMultiTypeInfo [ #ByteString ],
					#isQuick : true,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SSTeacher ]
				},
				#id : STypeMethodInfo {
					#selector : #id,
					#returnType : SMultiTypeInfo [ #SmallInteger ],
					#isQuick : true,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SSTeacher ]
				},
				#''name:'' : STypeMethodInfo {
					#selector : #''name:'',
					#returnType : SMultiTypeInfo [ #SSTeacher ],
					#argTypes : [
						SMultiTypeInfo [ #ByteString ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SSTeacher ]
				}
			},
			#classMethodTypes : {
				#''name:with:'' : STypeMethodInfo {
					#selector : #''name:with:'',
					#returnType : SMultiTypeInfo [ #SSTeacher ],
					#argTypes : [
						SMultiTypeInfo [ #ByteString ],
						SMultiTypeInfo [ #SmallInteger ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SSTeacher ]
				}
			}
		},
		#SConference : STypeClassInfo {
			#typeName : #SConference,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SEvent : STypeClassInfo {
			#typeName : #SEvent,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SSTeacher : STypeClassInfo {
			#typeName : #SSTeacher,
			#methodTypes : {
				#yearsWorkExperience : STypeMethodInfo {
					#selector : #yearsWorkExperience,
					#returnType : SMultiTypeInfo [ #SmallInteger ],
					#isQuick : true,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SSTeacher ]
				},
				#initialize : STypeMethodInfo {
					#selector : #initialize,
					#returnType : SMultiTypeInfo [ #SSTeacher ],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SSTeacher ]
				},
				#idTeacher : STypeMethodInfo {
					#selector : #idTeacher,
					#returnType : SMultiTypeInfo [ #SmallInteger ],
					#isQuick : true,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SSTeacher ]
				},
				#nickname : STypeMethodInfo {
					#selector : #nickname,
					#returnType : SMultiTypeInfo [ #ByteString ],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SSTeacher ]
				}
			},
			#classMethodTypes : { }
		},
		#SParty : STypeClassInfo {
			#typeName : #SParty,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SEventTest : STypeClassInfo {
			#typeName : #SEventTest,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SFoo : STypeClassInfo {
			#typeName : #SFoo,
			#methodTypes : { },
			#classMethodTypes : { }
		}
	},
	#scalars : {
		#ByteString : [
			''Ann'',
			''teacher_Ann''
		],
		#SmallInteger : [
			0,
			100,
			34
		]
	}
}'
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoStringSSTeacher2 [
	"SSTypeCollector
				profile: [ SSTeacher new
						nickname;
						yearsWorkExperience ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario'"
	^ 'STypeInfo {
	#types : {
		#SStack : STypeClassInfo {
			#typeName : #SStack,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SSPerson : STypeClassInfo {
			#typeName : #SSPerson,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SConference : STypeClassInfo {
			#typeName : #SConference,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SEvent : STypeClassInfo {
			#typeName : #SEvent,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SSTeacher : STypeClassInfo {
			#typeName : #SSTeacher,
			#methodTypes : {
				#yearsWorkExperience : STypeMethodInfo {
					#selector : #yearsWorkExperience,
					#returnType : SMultiTypeInfo [ #SmallInteger ],
					#isQuick : true,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SSTeacher ]
				},
				#initialize : STypeMethodInfo {
					#selector : #initialize,
					#returnType : SMultiTypeInfo [ #SSTeacher ],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SSTeacher ]
				},
				#nickname : STypeMethodInfo {
					#selector : #nickname,
					#returnType : SMultiTypeInfo [ #ByteString ],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SSTeacher ]
				}
			},
			#classMethodTypes : { }
		},
		#SParty : STypeClassInfo {
			#typeName : #SParty,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SEventTest : STypeClassInfo {
			#typeName : #SEventTest,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SFoo : STypeClassInfo {
			#typeName : #SFoo,
			#methodTypes : { },
			#classMethodTypes : { }
		}
	},
	#scalars : {
		#ByteString : [
			''teacher_1''
		],
		#SmallInteger : [
			0
		]
	}
}'
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoStringSStack1 [
	"SSTypeCollector profile: [ SStack new push: (OrderedCollection new add: (SStudent  name: 'Lian' with: 1); add: (SStudent name: 'Josh' with: 2); yourself); push: (OrderedCollection new add: (SStudent name: 'Mery' with: 5); yourself); yourself ] onPackagesMatching: 'SmallSuiteGenerator-Scenario'."
	^ 'STypeInfo {
	#types : {
		#SStack : STypeClassInfo {
			#typeName : #SStack,
			#methodTypes : {
				#''push:'' : STypeMethodInfo {
					#selector : #''push:'',
					#returnType : SMultiTypeInfo [ #OrderedCollection ],
					#argTypes : [
						SMultiTypeInfo [ #OrderedCollection ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStack ]
				}
			},
			#classMethodTypes : { }
		},
		#SSPerson : STypeClassInfo {
			#typeName : #SSPerson,
			#methodTypes : {
				#''id:'' : STypeMethodInfo {
					#selector : #''id:'',
					#returnType : SMultiTypeInfo [ #SStudent ],
					#argTypes : [
						SMultiTypeInfo [ #SmallInteger ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStudent ]
				},
				#''nickname:'' : STypeMethodInfo {
					#selector : #''nickname:'',
					#returnType : SMultiTypeInfo [ #SStudent ],
					#argTypes : [
						SMultiTypeInfo [ #ByteString ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStudent ]
				},
				#''name:'' : STypeMethodInfo {
					#selector : #''name:'',
					#returnType : SMultiTypeInfo [ #SStudent ],
					#argTypes : [
						SMultiTypeInfo [ #ByteString ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStudent ]
				}
			},
			#classMethodTypes : {
				#''name:with:'' : STypeMethodInfo {
					#selector : #''name:with:'',
					#returnType : SMultiTypeInfo [ #SStudent ],
					#argTypes : [
						SMultiTypeInfo [ #ByteString ],
						SMultiTypeInfo [ #SmallInteger ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStudent ]
				}
			}
		},
		#SConference : STypeClassInfo {
			#typeName : #SConference,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SEvent : STypeClassInfo {
			#typeName : #SEvent,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SSTeacher : STypeClassInfo {
			#typeName : #SSTeacher,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SParty : STypeClassInfo {
			#typeName : #SParty,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SEventTest : STypeClassInfo {
			#typeName : #SEventTest,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SFoo : STypeClassInfo {
			#typeName : #SFoo,
			#methodTypes : { },
			#classMethodTypes : { }
		}
	},
	#scalars : {
		#OrderedCollection : [
			OrderedCollection [
				SStudent {
					#name : ''Mery'',
					#id : 5,
					#nickname : ''Mery'',
					#scoreStudent : 1,
					#idStudent : 1
				}
			],
			OrderedCollection [
				SStudent {
					#name : ''Lian'',
					#id : 1,
					#nickname : ''Lian'',
					#scoreStudent : 1,
					#idStudent : 1
				},
				SStudent {
					#name : ''Josh'',
					#id : 2,
					#nickname : ''Josh'',
					#scoreStudent : 1,
					#idStudent : 1
				}
			]
		],
		#ByteString : [
			''Josh'',
			''Lian'',
			''Mery''
		],
		#SmallInteger : [
			5,
			1,
			2
		],
		#SStudent : [
			@56,
			@59,
			@58
		]
	}
}'
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoStringSStack2 [
	"SSTypeCollector
				profile: [ (SStack newStackWith: #(2 4 6 1))
						push: 8;
						pop;
						top ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario'"
	^ 'STypeInfo {
	#types : {
		#SStack : STypeClassInfo {
			#typeName : #SStack,
			#methodTypes : {
				#''push:'' : STypeMethodInfo {
					#selector : #''push:'',
					#returnType : SMultiTypeInfo [ #SmallInteger ],
					#argTypes : [
						SMultiTypeInfo [ #SmallInteger ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStack ]
				},
				#pop : STypeMethodInfo {
					#selector : #pop,
					#returnType : SMultiTypeInfo [ #SmallInteger ],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStack ]
				},
				#top : STypeMethodInfo {
					#selector : #top,
					#returnType : SMultiTypeInfo [ #SmallInteger ],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStack ]
				}
			},
			#classMethodTypes : {
				#''newStackWith:'' : STypeMethodInfo {
					#selector : #''newStackWith:'',
					#returnType : SMultiTypeInfo [ #SStack ],
					#argTypes : [
						SMultiTypeInfo [ #Array ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStack ]
				}
			}
		},
		#SSPerson : STypeClassInfo {
			#typeName : #SSPerson,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SConference : STypeClassInfo {
			#typeName : #SConference,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SEvent : STypeClassInfo {
			#typeName : #SEvent,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SSTeacher : STypeClassInfo {
			#typeName : #SSTeacher,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SParty : STypeClassInfo {
			#typeName : #SParty,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SEventTest : STypeClassInfo {
			#typeName : #SEventTest,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SFoo : STypeClassInfo {
			#typeName : #SFoo,
			#methodTypes : { },
			#classMethodTypes : { }
		}
	},
	#scalars : {
		#Array : [
			[
				2,
				4,
				6,
				1
			]
		],
		#SmallInteger : [
			1,
			2,
			4,
			6,
			8
		]
	}
}'
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoStringSStudent1 [
	"SSTypeCollector
				profile: [ SStudent new
						idStudent;
						scoreStudent: 10;
						scoreStudent ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario2'"
	^ 'STypeInfo {
	#types : {
		#SAbstractClass : STypeClassInfo {
			#typeName : #SAbstractClass,
			#methodTypes : { },
			#classMethodTypes : { }
		},
		#SStudent : STypeClassInfo {
			#typeName : #SStudent,
			#methodTypes : {
				#initialize : STypeMethodInfo {
					#selector : #initialize,
					#returnType : SMultiTypeInfo [ #SStudent ],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStudent ]
				},
				#idStudent : STypeMethodInfo {
					#selector : #idStudent,
					#returnType : SMultiTypeInfo [ #SmallInteger ],
					#isQuick : true,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStudent ]
				},
				#scoreStudent : STypeMethodInfo {
					#selector : #scoreStudent,
					#returnType : SMultiTypeInfo [ #SmallInteger ],
					#isQuick : true,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStudent ]
				},
				#''scoreStudent:'' : STypeMethodInfo {
					#selector : #''scoreStudent:'',
					#returnType : SMultiTypeInfo [ #SStudent ],
					#argTypes : [
						SMultiTypeInfo [ #SmallInteger ]
					],
					#isQuick : false,
					#isDeprecated : false,
					#receiver : SMultiTypeInfo [ #SStudent ]
				}
			},
			#classMethodTypes : { }
		}
	},
	#scalars : {
		#SmallInteger : [
			10,
			1
		]
	}
}'
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfosSStudent [
	^ OrderedCollection new
		add:
			(STypeInfo new
				type:
					(self fullSymbolOf: #SStudent)
						->
							(Array
								with:
									(Array
										with: #initialize -> (Array 
									with: (self fullSymbolOf: #SStudent) 
									with: (self fullSymbolOf: #SStudent) 
									with: #()
									with: false)
										with: #scoreStudent -> (Array 
									with: (self fullSymbolOf: #SStudent) 
									with: (self fullSymbolOf: #SmallInteger) 
									with: #()
									with: true)
										with: #scoreStudent: -> (Array 
									with: (self fullSymbolOf: #SStudent) 
									with: (self fullSymbolOf: #SStudent) 
									with: (Array with: (self fullSymbolOf: #SmallInteger))
									with: false)
										with: #idStudent -> (Array 
									with: (self fullSymbolOf: #SStudent) 
									with: (self fullSymbolOf: #SmallInteger) 
									with: #()
									with: true))
								with: #());
				scalar: (self fullSymbolOf: #SmallInteger) with: #(1);
				scalar: (self fullSymbolOf: #ByteString) with: #('student_Jane'));
		add:
			(STypeInfo new
				type:
					(self fullSymbolOf: #SStudent)
						->
							(Array
								with:
									(Array
										with: #scoreStudent: -> (Array 
									with: (self fullSymbolOf: #SStudent) 
									with: (self fullSymbolOf: #SStudent) 
									with: (Array with: (self fullSymbolOf: #SmallInteger))
									with: false)
										with: #nickname -> (Array 
									with: (self fullSymbolOf: #SStudent) 
									with: (self fullSymbolOf: #ByteString) 
									with: #()
									with: false))
								with: #());
				scalar: (self fullSymbolOf: #SmallInteger) with: #(1 6 8);
				scalar: (self fullSymbolOf: #ByteString) with: #('Jane' 'Ann' 'Peter'));
		yourself
]
