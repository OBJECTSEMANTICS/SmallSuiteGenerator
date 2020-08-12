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
		add: ((SSTestCase with: aCollection first) targetClassName: symbol; generateStatements);
		add: ((SSTestCase with: aCollection second) targetClassName: symbol; generateStatements);
		yourself
]

{ #category : #tests }
SUtilityTypeInfo >> testSuiteSSTeacher [
	^ self
		testSuiteOf:
			(Array
				with: self typeInfoSSTeacher1
				with: self typeInfoSSTeacher2
				with: self typeInfoSSTeacher3) withTargetClassName: #SSTeacher fullClassNameSymbol
]

{ #category : #tests }
SUtilityTypeInfo >> testSuiteSStack [
	^ self
		testSuiteOf:
			(Array
				with: self typeInfoSStack1
				with: self typeInfoSStack2
				with: self typeInfoSStack3
				with: self typeInfoSStack4) withTargetClassName: #SStack fullClassNameSymbol 
]

{ #category : #tests }
SUtilityTypeInfo >> testSuiteSStudent [
	^ self testSuiteOf: self typeInfosSStudent withTargetClassName: #SStudent fullClassNameSymbol
]

{ #category : #tests }
SUtilityTypeInfo >> testSuiteSStudentManual [
	| studentSymbol intSymbol stringSymbol |
	studentSymbol := #SStudent fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	^ OrderedCollection new
		add:
			((SSTestCase with: self typeInfosSStudent first)
				targetClassName: studentSymbol;
				addFactoryMessage: studentSymbol usingSelector: #new;
				addLiteral: stringSymbol;
				addFieldAccessMessage: #idStudent from: studentSymbol;
				addMessage: #scoreStudent: from: studentSymbol;
				addFactoryMessage: studentSymbol usingSelector: #new;
				addFieldAccessMessage: #scoreStudent from: studentSymbol;
				yourself);
		add:
			((SSTestCase with: self typeInfosSStudent first)
				targetClassName: studentSymbol;
				addLiteral: intSymbol;
				addFactoryMessage: studentSymbol usingSelector: #new;
				addMessage: #scoreStudent: from: studentSymbol;
				addFactoryMessage: studentSymbol usingSelector: #new;
				addFieldAccessMessage: #idStudent from: studentSymbol;
				yourself);
		add:
			((SSTestCase with: self typeInfosSStudent first)
				targetClassName: studentSymbol;
				addFactoryMessage: studentSymbol usingSelector: #new;
				addLiteral: intSymbol;
				addMessage: #scoreStudent: from: studentSymbol;
				addLiteral: intSymbol;
				addFactoryMessage: studentSymbol usingSelector: #new;
				yourself);
		yourself
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoOnPackage1 [
	"the first typeInfo is about a class has as argument other class from other package"
	| eventSymbol confSymbol falseSymbol studentSymbol intSymbol |
	eventSymbol := #SEvent fullClassNameSymbol.
	confSymbol := #SConference fullClassNameSymbol.
	falseSymbol := #False fullClassNameSymbol.
	studentSymbol := #SStudent fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.

	^ STypeInfo new
		type:
			eventSymbol
				->
					(Array
						with:
							(Array
								with: #canRegister: -> (Array 
									with: confSymbol 
									with: falseSymbol  
									with: (Array with: studentSymbol)
									with: false)
								with: #price -> (Array 
									with: confSymbol 
									with: intSymbol 
									with: #()
									with: false))
						with: #());
		type:
			confSymbol 
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array 
									with: confSymbol  
									with: confSymbol
									with: #()
									with: false)
								with: #offerPrice -> (Array 
									with: confSymbol
									with: intSymbol
									with: #()
									with: true)
								with: #offerPrice: -> (Array 
									with: confSymbol
									with: confSymbol
									with: (Array with: intSymbol)
									with: false)
								with: #discount -> (Array 
									with: confSymbol
									with: intSymbol
									with: #()
									with: true))
						with: #());
		scalar: intSymbol with: #(95 100);
		scalar: falseSymbol with: #(false);
		scalar: studentSymbol with: (Array with: (SStudent new name: 'Mary'))
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoOnPackage2 [
	"the first typeInfo is about a class has as argument other class from other package"
	| eventSymbol confSymbol intSymbol |
	eventSymbol := #SEvent fullClassNameSymbol.
	confSymbol := #SConference fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			eventSymbol
				->
					(Array
						with:
							(Array
								with: #price: -> (Array with: confSymbol
															with: confSymbol
															with: (Array with: intSymbol)
															with: false))
						with:
							(Array
								with: #price: -> (Array with: confSymbol
															with: confSymbol
															with: (Array with: intSymbol)
															with: false)));
		type:
			confSymbol 
				->
					(Array
						with: (Array with: #initialize -> (Array with: confSymbol
															with: confSymbol
															with: #()
															with: false))
						with: #());
		scalar: intSymbol with: #(95)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoOnPackage3 [
	"the first typeInfo is about a class has as argument other class from other package"
	"review and modify"
	| teacherSymbol confSymbol falseSymbol studentSymbol intSymbol stringSymbol |
	teacherSymbol := #SSTeacher fullClassNameSymbol.
	confSymbol := #SConference fullClassNameSymbol.
	falseSymbol := #False fullClassNameSymbol.
	studentSymbol := #SStudent fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.

	^ STypeInfo new
		type:
			teacherSymbol
				->
					(Array
						with:
							(OrderedCollection new
								add: #name: -> (Array with: teacherSymbol
														with: teacherSymbol
														with: (Array with: stringSymbol)
														with: false);
								add: #id: -> (Array with: teacherSymbol
														with: teacherSymbol
														with: (Array with: intSymbol)
														with: false);
								add: #nickname: -> (Array with: teacherSymbol
														with: teacherSymbol
														with: (Array with: stringSymbol)
														with: false);
								add: #initialize -> (Array with: teacherSymbol
														with: teacherSymbol
														with: #()
														with: false);
								add: #nickname -> (Array with: teacherSymbol
														with: stringSymbol 
														with: #()
														with: false);
								add: #name -> (Array with: teacherSymbol
														with: stringSymbol 
														with: #()
														with: true);
								add: #id -> (Array with: teacherSymbol
														with: intSymbol 
														with: #()
														with: true);
								add: #yearsWorkExperience -> (Array with: teacherSymbol
														with: intSymbol 
														with: #()
														with: true);
								add: #idTeacher -> (Array with: teacherSymbol
														with: intSymbol 
														with: #()
														with: true);
								yourself)
						with:
							(Array
								with:
									#name:with:
										-> (Array with: teacherSymbol 
														with: teacherSymbol
														with: (Array with: stringSymbol with: intSymbol )
														with: false)));
		type:
			confSymbol 
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array with: confSymbol
														with: confSymbol
														with: #()
														with: false)
								with: #offerPrice -> (Array with: confSymbol
														with: intSymbol 
														with: #()
														with: true)
								with: #offerPrice: -> (Array with: confSymbol
														with: confSymbol 
														with: (Array with: intSymbol )
														with: false)
								with: #discount -> (Array with: confSymbol
														with: intSymbol 
														with: #()
														with: true))
						with: #());
		scalar: intSymbol with: #(95);
		scalar: falseSymbol  with: #(false);
		scalar: studentSymbol with: (Array with: (SStudent new name: 'Mary'));
		scalar: stringSymbol with: #('Mary')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoOnPackage4 [
	"the first typeInfo is about a class has as argument other class from other package"
	"review and modify"
	| eventSymbol confSymbol intSymbol |
	eventSymbol := #SEvent fullClassNameSymbol.
	confSymbol := #SConference fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.

	^ STypeInfo new
		type:
			eventSymbol
				->
					(Array
						with:
							(Array
								with: #price: -> (Array with: confSymbol
															with: confSymbol
															with: (Array with: intSymbol)
															with: false))
						with:
							(Array
								with: #price: -> (Array with: confSymbol
															with: confSymbol
															with: (Array with: intSymbol )
															with: false)));
		type:
			confSymbol
				->
					(Array
						with: (Array with: #initialize -> (Array with: confSymbol
															with: confSymbol
															with: #() 
															with: false))
						with: #());
		type: #SParty fullClassNameSymbol -> #(#() #());
		scalar: intSymbol with: #(95)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSAbstractClass [
	| abstractSymbol intSymbol |
	abstractSymbol := #SAbstractClass fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	^ STypeInfo new
		type:
			abstractSymbol
				->
					(Array
						with: (Array with: #id -> (Array with: abstractSymbol
																with: intSymbol
																with: #()
																with: false))
						with: #());
		scalar: intSymbol with: #(1)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSEvent1 [
	| eventSymbol intSymbol |
	eventSymbol := #SEvent fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			eventSymbol
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array with: eventSymbol
																with: eventSymbol
																with: #()
																with: false)
								with: #discount -> (Array with: eventSymbol
																with: intSymbol
																with: #()
																with: true)
								with: #discount: -> (Array with: eventSymbol
																with: eventSymbol
																with: (Array with: intSymbol) 
																with: false)
								with: #price -> (Array with: eventSymbol
																with: intSymbol
																with: #() 
																with: true)
								with: #price: -> (Array with: eventSymbol
																with: eventSymbol
																with: (Array with: intSymbol)
																with: false))
						with: (Array with: #price: -> (Array with: eventSymbol
																with: eventSymbol
																with: (Array with: intSymbol) 
																with: false)));
		scalar: intSymbol with: #(8)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSEvent2 [
	| eventSymbol intSymbol |
	eventSymbol := #SEvent fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.

	^ STypeInfo new
		type:
			eventSymbol
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array with: eventSymbol
																with: eventSymbol
																with: #()
																with: false)
								with: #discount -> (Array with: eventSymbol
																with: intSymbol
																with: #()
																with: true)
								with: #price -> (Array with: eventSymbol
																with: intSymbol
																with: #()
																with: true))
						with: (Array with: #price: -> (Array with: eventSymbol
																with: eventSymbol
																with: (Array with: intSymbol)
																with: false)));
		scalar: intSymbol with: #(0 15)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSEventOnPackage1 [
	| eventSymbol intSymbol |
	eventSymbol := #SEvent fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			eventSymbol
				->
					(Array
						with:
							(Array
								with: #price -> (Array with: eventSymbol
														with: intSymbol
														with: #()
														with: false)
								with: #discount -> (Array with: eventSymbol
														with: intSymbol
														with: #()
														with: true)
								with: #initialize -> (Array with: eventSymbol
														with: eventSymbol
														with: #()
														with: false)
								with: #price: -> (Array with: eventSymbol
														with: eventSymbol
														with: (Array with: intSymbol)
														with: false))
						with: (Array with: #price: -> (Array with: eventSymbol
														with: eventSymbol
														with: (Array with: intSymbol)
														with: false)));
		type: #SSTeacher fullClassNameSymbol -> #(#() #());
		type: #SSPerson fullClassNameSymbol -> #(#() #());
		type: #SStack fullClassNameSymbol -> #(#() #());
		type: #SConference fullClassNameSymbol -> #(#() #());
		type: #SFoo fullClassNameSymbol -> #(#() #());
		type: #SParty fullClassNameSymbol -> #(#() #());
		type: eventSymbol -> #(#() #());
		scalar: intSymbol with: #(15 0)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFoo1 [
	| sfooSymbol stringSymbol floatSymbol intSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	floatSymbol := #SmallFloat64 fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			sfooSymbol
				->
					(Array
						with:
							(Array
								with: #returnNum -> (Array 
									with: sfooSymbol 
									with: intSymbol 
									with: #()
									with: false)
								with: #returnFloat -> (Array 
									with: sfooSymbol
									with: floatSymbol
									with: #()
									with: false)
								with: #returnString -> (Array 
									with: sfooSymbol
									with: stringSymbol 
									with: #()
									with: false)
								with: #score -> (Array 
									with: sfooSymbol
									with: floatSymbol
									with: #()
									with: true)
								with: #return: -> (Array 
									with: sfooSymbol
									with: stringSymbol
									with: (Array with: stringSymbol)
									with: false))
						with: (Array with: #score: -> (Array 
									with: sfooSymbol
									with: sfooSymbol
									with: (Array with: floatSymbol)
									with: false)));
		scalar: stringSymbol with: #('hello');
		scalar: intSymbol with: #(5);
		scalar: floatSymbol with: #(7.3)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFoo100 [
	| sfooSymbol stringSymbol floatSymbol intSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	floatSymbol := #SmallFloat64 fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			sfooSymbol
				->
					(Array
						with:
							(Array
								with: #returnNum -> (Array 
									with: sfooSymbol
									with: intSymbol
									with: #()
									with: false)
								with: #returnFloat -> (Array 
									with: sfooSymbol
									with: floatSymbol
									with: #()
									with: false)
								with: #returnString -> (Array 
									with: sfooSymbol
									with: stringSymbol
									with: #()
									with: false)
								with: #score -> (Array 
									with: sfooSymbol
									with: floatSymbol 
									with: #()
									with: true)
								with: #return: -> (Array 
									with: sfooSymbol
									with: stringSymbol
									with: (Array with: stringSymbol)
									with: false))
						with: (Array with: #score: -> (Array 
									with: sfooSymbol
									with: sfooSymbol
									with: (Array with: floatSymbol)
									with: false)));
		scalar: stringSymbol with: #('hello');
		scalar: intSymbol with: #(5);
		scalar: floatSymbol with: #(7.3 4.7)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFoo2 [
	| sfooSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			sfooSymbol
				->
					(Array
						with: (Array with: #return: -> (Array 
									with: sfooSymbol 
									with: sfooSymbol
									with: (Array with: sfooSymbol)
									with: false))
						with: #())
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFoo3 [
	| sfooSymbol stringSymbol floatSymbol intSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	floatSymbol := #SmallFloat64 fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			sfooSymbol
				->
					(Array
						with:
							(Array
								with: #returnNum -> (Array
																with: sfooSymbol
																with: intSymbol 
																with: #()
																with: false)
								with: #returnFloat -> (Array
																with: sfooSymbol
																with: floatSymbol 
																with: #()
																with: false)
								with: #returnString -> (Array
																with: sfooSymbol
																with: stringSymbol
																with: #()
																with: false)
								with: #score -> (Array 
																with: sfooSymbol
																with: intSymbol
																with: #()
																with: true)
								with: #score: -> (Array
																with: sfooSymbol
																with: sfooSymbol 
																with: (Array with: intSymbol)
																with: false))
						with: (Array with: #score: -> (Array 
																with: sfooSymbol
																with: sfooSymbol
																with: (Array with: intSymbol)
																with: false)));
		scalar: stringSymbol with: #('Hello');
		scalar: intSymbol with: #(4);
		scalar: floatSymbol with: #(2.3)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFoo4 [
	| sfooSymbol studentSymbol intSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	studentSymbol := #SStudent fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			sfooSymbol
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array 
									with: sfooSymbol
									with: sfooSymbol
									with: #()
									with: false)
								with: #return: ->  (Array 
									with: sfooSymbol
									with: studentSymbol 
									with: (Array with: studentSymbol)
									with: false))
						with: #());
		type:
			studentSymbol
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array with: studentSymbol
																with: studentSymbol
																with: #()
																with: false)
								with: #idStudent -> (Array with: studentSymbol
																with: intSymbol
																with: #()
																with: true)
								with: #scoreStudent -> (Array with: studentSymbol
																with: intSymbol
																with: #()
																with: true)
								with: #scoreStudent: -> (Array with: studentSymbol
																with: intSymbol
																with: (Array with: intSymbol)
																with: false))
						with: #());
		scalar: (1 class name fullClassNameSymbol ) with: { 1 . 2 };
		yourself.
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFoo5 [
	| sfooSymbol collSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	collSymbol := #OrderedCollection fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			sfooSymbol
				->
					(Array
						with:
							(Array
								with: #return: -> (Array with: sfooSymbol
															with: collSymbol
															with: (Array with: collSymbol)
															with:  false))
						with: #());
		scalar: collSymbol
			with:
			(Array
				with:
					(OrderedCollection new
						addAll: #(1 4 5);
						yourself))
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFooEmpty [
	^ STypeInfo new type: #SFoo fullClassNameSymbol -> (Array with: #() with: #())
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFooOnPackage1 [
	| sfooSymbol stringSymbol intSymbol studentSymbol collSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	studentSymbol := #SStudent fullClassNameSymbol.
	collSymbol := #OrderedCollection fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			sfooSymbol
				->
					(Array
						with:
							(Array
								with: #returnCollection -> (Array 
									with: sfooSymbol 
									with: collSymbol
									with: #()
									with: false)
								with: #returnString -> (Array 
									with:sfooSymbol
									with: stringSymbol 
									with: #()
									with: false)
								with: #score -> (Array 
									with: sfooSymbol 
									with: intSymbol  
									with: #()
									with: true)
								with: #score: -> (Array 
									with: sfooSymbol
									with: sfooSymbol
									with: (Array with: intSymbol)
									with: false)
								with: #return: -> (Array 
									with: sfooSymbol
									with: studentSymbol 
									with: (Array with: studentSymbol)
									with: false))
						with: (Array with: #score: -> (Array 
									with: sfooSymbol 
									with: sfooSymbol
									with: (Array with: intSymbol)
									with: false)));
		type:
			(#SSPerson fullClassNameSymbol)
				->
					(Array
						with:
							(Array
								with: #id: -> (Array 
									with: studentSymbol
									with: studentSymbol
									with: (Array with: intSymbol)
									with: false)
								with: #nickname: -> (Array 
									with: studentSymbol 
									with: studentSymbol
									with: (Array with: stringSymbol)
									with: false)
								with: #name: -> (Array 
									with: studentSymbol
									with: studentSymbol
									with: (Array with: stringSymbol )
									with: false))
						with: (Array with: #name: -> (Array 
									with: studentSymbol
									with: studentSymbol
									with: (Array with: stringSymbol )
									with: false)));
		type: #SStack fullClassNameSymbol -> #(#() #());
		type: #SConference fullClassNameSymbol -> #(#() #());
		type: #SEvent fullClassNameSymbol -> #(#() #());
		type: #SSTeacher fullClassNameSymbol -> #(#() #());
		type: #SParty fullClassNameSymbol -> #(#() #());
		type: #SEventTest fullClassNameSymbol -> #(#() #());
		scalar: intSymbol with: #(5 1 4);
		scalar: stringSymbol with: #('Emily' 'Hello');
		scalar: collSymbol
			with: (Array with: OrderedCollection new);
		scalar: studentSymbol
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
	| sfooSymbol intSymbol studentSymbol collSymbol floatSymbol |
	sfooSymbol := #SFoo fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	studentSymbol := #SStudent fullClassNameSymbol.
	collSymbol := #OrderedCollection fullClassNameSymbol.
	floatSymbol := #SmallFloat64 fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			sfooSymbol
				->
					(Array
						with:
							(Array
								with: #returnFloat -> (Array with: sfooSymbol
																with: floatSymbol
																with: #()
																with: false)
								with: #returnCollection -> (Array with: sfooSymbol
																with: collSymbol 
																with: #()
																with: false)
								with: #initialize -> (Array with: sfooSymbol
																with: sfooSymbol
																with: #()
																with: false)
								with: #score -> (Array with: sfooSymbol
																with: intSymbol 
																with: #()
																with: true)
								with: #score: -> (Array with: sfooSymbol
																with: sfooSymbol
																with: (Array with: intSymbol )
																with: false)
								with: #return: -> (Array with: sfooSymbol
																with: studentSymbol 
																with: (Array with: studentSymbol)
																with: false))
						with: (Array with: #score: -> (Array with: sfooSymbol
																with: sfooSymbol
																with: (Array with: intSymbol )
																with: false)));
		type: #SSPerson fullClassNameSymbol -> #(#() #());
		type: #SStack fullClassNameSymbol -> #(#() #());
		type: #SConference fullClassNameSymbol -> #(#() #());
		type: #SEvent fullClassNameSymbol -> #(#() #());
		type: #SSTeacher fullClassNameSymbol -> #(#() #());
		type: #SParty fullClassNameSymbol -> #(#() #());
		type: #SEventTest fullClassNameSymbol -> #(#() #());
		scalar: intSymbol  with: #(15);
		scalar: floatSymbol with: #(2.3);
		scalar: collSymbol 
			with: (Array with: OrderedCollection new);
		scalar: #Array fullClassNameSymbol with: #(#(1 5 6))
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSFooOnPackage3 [
	| personSymbol intSymbol studentSymbol stringSymbol sfooSymbol dictSymbol stackSymbol |
	personSymbol := #SSPerson fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	studentSymbol := #SStudent fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	sfooSymbol := #SFoo fullClassNameSymbol.
	dictSymbol := #Dictionary fullClassNameSymbol.
	stackSymbol := #SStack fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			personSymbol
				->
					(Array
						with:
							(Array
								with: #id: -> (Array with: studentSymbol
														with: studentSymbol
														with: (Array with: intSymbol)
														with: false)
								with: #nickname: -> (Array with:studentSymbol
														with: studentSymbol
														with: (Array with: stringSymbol)
														with: false)
								with: #name: -> (Array with: studentSymbol
														with: studentSymbol
														with: (Array with: stringSymbol)
														with: false))
						with:
							(Array
								with:
									#name:with:
										-> (Array with: studentSymbol
												with: studentSymbol
												with: (Array with: stringSymbol with: intSymbol)
												with: false)));
		type:
			sfooSymbol
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array with: sfooSymbol
																with: sfooSymbol
																with: #()
																with: false)
								with: #return: -> (Array with: sfooSymbol
																with: dictSymbol
																with: (Array with: dictSymbol)
																with: false))
						with: #());
		type:
			stackSymbol 
				->
					(Array
						with: (Array with: #push: -> (Array with: stackSymbol 
																with: studentSymbol 
																with: (Array with: studentSymbol)
																with: false))
						with: #());
		type: #SConference fullClassNameSymbol -> #(#() #());
		type: #SEvent fullClassNameSymbol -> #(#() #());
		type: #SParty fullClassNameSymbol -> #(#() #());
		type: #SSTeacher fullClassNameSymbol -> #(#() #());
		type: #SEventTest fullClassNameSymbol -> #(#() #());
		scalar: studentSymbol
			with:
			(Array
				with: (SStudent name: 'Mery' with: 5)
				with: (SStudent name: 'Josh' with: 2)
				with: (SStudent name: 'Lian'));
		scalar: dictSymbol
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
		scalar: intSymbol with: #(5 1 2);
		scalar: stringSymbol with: #('Josh' 'Lian' 'Mery')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSSPerson1 [
	| personSymbol intSymbol stringSymbol |
	personSymbol := #SSPerson fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			personSymbol
				->
					(Array
						with:
							(Array
								with: #name -> (Array with: personSymbol
														with: stringSymbol 
														with: #()
														with: true)
								with: #id -> (Array with: personSymbol
														with: intSymbol 
														with:  #()
														with: false))
						with:
							(Array
								with:
									#name:with:
										-> (Array with: personSymbol
													with: personSymbol
													with: (Array with: stringSymbol with: intSymbol )
													with: false)));
		scalar: intSymbol with: #(50);
		scalar: stringSymbol with: #('Ann')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSSTeacher1 [
	| teacherSymbol intSymbol stringSymbol |
	teacherSymbol := #SSTeacher fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			teacherSymbol
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array with: teacherSymbol
																with: teacherSymbol
																with: #()
																with: false)
								with: #yearsWorkExperience -> (Array with: teacherSymbol
																with: intSymbol 
																with: #()
																with: true)
								with:
									#yearsWorkExperience:
										-> (Array with: teacherSymbol
												with: teacherSymbol
												with: (Array with: intSymbol)
												with: false))
						with: #());
		scalar: intSymbol with: #(0 100);
		scalar: stringSymbol with: #('teacher_Ann')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSSTeacher2 [
	| teacherSymbol intSymbol stringSymbol |
	teacherSymbol := #SSTeacher fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			teacherSymbol
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array with: teacherSymbol
																with: teacherSymbol
																with: #()
																with: false)
								with: #idTeacher -> (Array with: teacherSymbol
																with: intSymbol 
																with: #()
																with: true)
								with:
									#yearsWorkExperience:
										-> (Array with: teacherSymbol
													with: teacherSymbol
													with: (Array with: intSymbol)
													with: false)
								with: #nickname -> (Array with: teacherSymbol
													with: stringSymbol
													with: #()
													with: false))
						with: #());
		scalar: intSymbol with: #(1 29 -7 9);
		scalar: stringSymbol with: #('teacher_Amy' 'teacher_Mark')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSSTeacher3 [
	| teacherSymbol intSymbol stringSymbol |
	teacherSymbol := #SSTeacher fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			teacherSymbol
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array with: teacherSymbol
																with: teacherSymbol
																with: #()
																with: false)
								with: #yearsWorkExperience -> (Array with: teacherSymbol
																with: intSymbol
																with: #()
																with: false)
								with: #nickname -> (Array with: teacherSymbol
																with: stringSymbol
																with: #()
																with: false))
						with: #());
		scalar: intSymbol with: #(1 10);
		scalar: stringSymbol with: #('teacher_Amy' 'teacher_Mark')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSSTeacher4 [
	| teacherSymbol intSymbol stringSymbol |
	teacherSymbol := #SSTeacher fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			teacherSymbol
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array with: teacherSymbol
																with: teacherSymbol
																with: #()
																with: false)
								with: #idTeacher -> (Array with: teacherSymbol
																with: intSymbol
																with: #()
																with: true)
								with: #yearsWorkExperience -> (Array with: teacherSymbol
																with: teacherSymbol
																with: #()
																with: true))
						with: #());
		scalar: intSymbol with: #(1 29 9);
		scalar: stringSymbol with: #('teacher_Amy' 'teacher_Mark')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSSTeacherOnPackage1 [
	| teacherSymbol intSymbol stringSymbol personSymbol |
	teacherSymbol := #SSTeacher fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	personSymbol := #SSPerson fullClassNameSymbol.

	^ STypeInfo new
		type:
			personSymbol
				->
					(Array
						with:
							(Array
								with: #id: -> (Array 
									with: teacherSymbol
									with: teacherSymbol
									with: (Array with: intSymbol )
									with: false)
								with: #nickname: -> (Array 
									with: teacherSymbol
									with: teacherSymbol
									with: (Array with: stringSymbol )
									with: false)
								with: #name -> (Array 
									with: teacherSymbol
									with: stringSymbol 
									with: #()
									with: true)
								with: #id -> (Array 
									with: teacherSymbol
									with: stringSymbol 
									with: #()
									with: true)
								with: #name: -> (Array 
									with: teacherSymbol
									with: teacherSymbol
									with: (Array with: stringSymbol )
									with: false))
						with:
							(Array
								with:
									#name:with:
										-> (Array 
									with: teacherSymbol
									with: teacherSymbol
									with: (Array with: stringSymbol with: intSymbol)
									with: false)));
		type:
			teacherSymbol
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array 
									with: teacherSymbol
									with: teacherSymbol
									with: #()
									with: false)
								with: #idTeacher -> (Array 
									with: teacherSymbol
									with: intSymbol 
									with: #()
									with: true)
								with:
									#yearsWorkExperience:
										-> (Array 
									with: teacherSymbol
									with: teacherSymbol
									with: (Array with: intSymbol )
									with: false)
								with: #nickname -> (Array 
									with: teacherSymbol
									with: stringSymbol 
									with: #()
									with: false))
						with: #());
		type: #SStack fullClassNameSymbol -> #(#() #());
		type: #SConference fullClassNameSymbol -> #(#() #());
		type: #SEvent fullClassNameSymbol -> #(#() #());
		type: #SFoo fullClassNameSymbol -> #(#() #());
		type: #SParty fullClassNameSymbol -> #(#() #());
		type: #SEventTest fullClassNameSymbol -> #(#() #());
		scalar: intSymbol with: #(0 100 34);
		scalar: stringSymbol with: #('Ann' 'teacher_Ann')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSSTeacherOnPackage2 [
	| teacherSymbol intSymbol stringSymbol |
	teacherSymbol := #SSTeacher fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			teacherSymbol
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array with: teacherSymbol
																with: teacherSymbol
																with: #()
																with: false)
								with: #nickname -> (Array with: teacherSymbol
																with: teacherSymbol
																with: #()
																with: false)
								with: #yearsWorkExperience -> (Array with: teacherSymbol
																with: intSymbol
																with: #()
																with: true))
						with: #());
		type: #SSPerson fullClassNameSymbol -> #(#() #());
		type: #SStack fullClassNameSymbol -> #(#() #());
		type: #SConference fullClassNameSymbol -> #(#() #());
		type: #SEvent fullClassNameSymbol -> #(#() #());
		type: #SFoo fullClassNameSymbol -> #(#() #());
		type: #SParty fullClassNameSymbol -> #(#() #());
		type: #SEventTest fullClassNameSymbol -> #(#() #());
		scalar: intSymbol with: #(0);
		scalar: stringSymbol with: #('teacher_1')
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSStack1 [
	| stackSymbol intSymbol arraySymbol |
	stackSymbol := #SStack fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	arraySymbol := #Array fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			stackSymbol
				->
					(Array
						with:
							(Array
								with: #firstLinkStack -> (Array with: stackSymbol
																	with: intSymbol
																	with: #()
																	with: true)
								with: #pop -> (Array with: stackSymbol
																	with: intSymbol
																	with: #()
																	with: false)
								with: #push: -> (Array with: stackSymbol
																	with: intSymbol 
																	with: (Array with: intSymbol)
																	with: false))
						with: (Array with: #newStackWith: -> (Array with: stackSymbol
																	with: stackSymbol
																	with: (Array with: arraySymbol)
																	with: false)));
		scalar: arraySymbol with: #(#(2 4 6 1));
		scalar: intSymbol with: #(1 2 4 6 8)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSStack2 [
	| stackSymbol intSymbol arraySymbol |
	stackSymbol := #SStack fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	arraySymbol := #Array fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			stackSymbol
				->
					(Array
						with:
							(Array
								with: #lastLinkStack -> (Array with: stackSymbol
																	with: intSymbol
																	with: #()
																	with: true)
								with: #pop -> (Array with: stackSymbol
																	with: intSymbol
																	with: #()
																	with: false)
								with: #top -> (Array with: stackSymbol
																	with: intSymbol
																	with: #()
																	with: false))
						with:
							(Array
								with: #newStack -> (Array with: stackSymbol
																	with: stackSymbol
																	with: #()
																	with: false)
								with: #newStackWith: -> (Array with: stackSymbol
																	with: stackSymbol
																	with: (Array with: arraySymbol)
																	with: false)));
		scalar: arraySymbol with: #(#(2 4 6 1) #(5 7 9 0));
		scalar: intSymbol with: #(1 2 5 8 9)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSStack3 [
	| stackSymbol intSymbol arraySymbol |
	stackSymbol := #SStack fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	arraySymbol := #Array fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			stackSymbol
				->
					(Array
						with:
							(Array
								with: #pop -> (Array with: stackSymbol
														with: intSymbol
														with: #()
														with: false)
								with: #push: -> (Array with: stackSymbol
														with: intSymbol
														with: (Array with: intSymbol)
														with: false)
								with: #top -> (Array with: stackSymbol
														with: intSymbol
														with: #()
														with: false))
						with: (Array with: #newStackWith: -> (Array with: stackSymbol
														with: stackSymbol
														with: (Array with: arraySymbol)
														with: false)));
		scalar: arraySymbol with: (Array with: #(2 4 6 1));
		scalar: intSymbol with: #(7 5 9 1)
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSStack4 [
	| stackSymbol intSymbol arraySymbol |
	stackSymbol := #SStack fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	arraySymbol := #Array fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			stackSymbol
				->
					(Array
						with:
							(Array
								with: #firstLinkStack -> (Array 
									with: stackSymbol
									with: intSymbol 
									with: #()
									with: true)
								with: #lastLinkStack -> (Array 
									with: stackSymbol
									with: intSymbol 
									with: #()
									with: true)
								with: #pop -> (Array 
									with: stackSymbol
									with: intSymbol 
									with: #()
									with: false)
								with: #push: -> (Array 
									with: stackSymbol
									with: intSymbol 
									with: (Array with: intSymbol )
									with: false)
								with: #top -> (Array 
									with: stackSymbol
									with: intSymbol
									with: #()
									with: false))
						with:
							(Array
								with: #newStack -> (Array 
									with: stackSymbol
									with: stackSymbol
									with: #()
									with: false)
								with: #newStackWith: -> (Array 
									with: stackSymbol
									with: stackSymbol
									with: (Array with: arraySymbol)
									with: false)));
		scalar: intSymbol with: #(5);
		scalar: arraySymbol with: #(#(1 4 5))
]

{ #category : #examples }
SUtilityTypeInfo >> typeInfoSStackOnPackage1 [
	| stackSymbol intSymbol arraySymbol |
	stackSymbol := #SStack fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	arraySymbol := #Array fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			stackSymbol
				->
					(Array
						with:
							(Array
								with: #pop -> (Array with: stackSymbol
														with: intSymbol 
														with: #()
														with: false)
								with: #push: -> (Array with: stackSymbol
														with: intSymbol 
														with: (Array with: intSymbol)
														with: false)
								with: #top -> (Array with: stackSymbol
														with: intSymbol 
														with: #()
														with: false))
						with: (Array with: #newStackWith: -> (Array with: stackSymbol
														with: stackSymbol
														with: (Array with: arraySymbol)
														with: false)));
		type: #SSPerson fullClassNameSymbol -> #(#() #());
		type: #SSTeacher fullClassNameSymbol -> #(#() #());
		type: #SConference fullClassNameSymbol -> #(#() #());
		type: #SEvent fullClassNameSymbol -> #(#() #());
		type: #SFoo fullClassNameSymbol -> #(#() #());
		type: #SParty fullClassNameSymbol -> #(#() #());
		type: #SEventTest fullClassNameSymbol -> #(#() #());
		scalar: intSymbol with: #(1 2 4 6 8);
		scalar: arraySymbol with: #(#(2 4 6 1))
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
	| studentSymbol intSymbol |
	studentSymbol := #SStudent fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	
	^ STypeInfo new
		type:
			studentSymbol
				->
					(Array
						with:
							(Array
								with: #initialize -> (Array with: studentSymbol
																with: studentSymbol
																with: #()
																with: false)
								with: #idStudent -> (Array with: studentSymbol
																with: intSymbol 
																with: #()
																with: true)
								with: #scoreStudent -> (Array with: studentSymbol
																with: intSymbol 
																with: #()
																with: true)
								with: #scoreStudent: -> (Array with: studentSymbol
																with: intSymbol 
																with: (Array with: intSymbol)
																with: false))
						with: #());
		type: #SAbstractClass fullClassNameSymbol -> #(#() #());
		scalar: intSymbol with: #(10 1)
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
	| studentSymbol intSymbol stringSymbol |
	studentSymbol := #SStudent fullClassNameSymbol.
	intSymbol := #SmallInteger fullClassNameSymbol.
	stringSymbol := #ByteString fullClassNameSymbol.
	
	^ OrderedCollection new
		add:
			(STypeInfo new
				type:
					studentSymbol
						->
							(Array
								with:
									(Array
										with: #initialize -> (Array 
									with: studentSymbol
									with: studentSymbol
									with: #()
									with: false)
										with: #scoreStudent -> (Array 
									with: studentSymbol
									with: intSymbol
									with: #()
									with: true)
										with: #scoreStudent: -> (Array 
									with: studentSymbol 
									with: studentSymbol
									with: (Array with: intSymbol)
									with: false)
										with: #idStudent -> (Array 
									with: studentSymbol 
									with: intSymbol 
									with: #()
									with: true))
								with: #());
				scalar: intSymbol with: #(1);
				scalar: stringSymbol with: #('student_Jane'));
		add:
			(STypeInfo new
				type:
					studentSymbol
						->
							(Array
								with:
									(Array
										with: #scoreStudent: -> (Array 
									with: studentSymbol
									with: studentSymbol
									with: (Array with: intSymbol)
									with: false)
										with: #nickname -> (Array 
									with: studentSymbol
									with: stringSymbol
									with: #()
									with: false))
								with: #());
				scalar: intSymbol with: #(1 6 8);
				scalar: stringSymbol with: #('Jane' 'Ann' 'Peter'));
		yourself
]
