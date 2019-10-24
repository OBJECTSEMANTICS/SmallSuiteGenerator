Class {
	#name : #SUtilityTypeInfo,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Tests-Utility'
}

{ #category : #tests }
SUtilityTypeInfo >> testSuiteOf: aCollection [
	self assert: aCollection size >= 2 description: 'list must have at least two or more testCases.'.
	^ OrderedCollection new
		add: (SSTestCase with: aCollection first) generateStatements;
		add: (SSTestCase with: aCollection second) generateStatements;
		yourself
]

{ #category : #tests }
SUtilityTypeInfo >> testSuiteSSTeacher [
	^ self testSuiteOf: (Array with: self typeInfoSSTeacher1 with: self typeInfoSSTeacher2 with: self typeInfoSSTeacher3 )
]

{ #category : #tests }
SUtilityTypeInfo >> testSuiteSStack [
	^ self testSuiteOf: (Array with: self typeInfoSStack1 with: self typeInfoSStack2 with: self typeInfoSStack3 with: self typeInfoSStack4 )
]

{ #category : #tests }
SUtilityTypeInfo >> testSuiteSStudent [
	^ self testSuiteOf: self typeInfosSStudent
]

{ #category : #tests }
SUtilityTypeInfo >> testSuiteSStudentManual [
	^ OrderedCollection new
		add:
			((SSTestCase with: self typeInfosSStudent first)
				addFactoryMessage: #SStudent ofSelector: #new;
				addLiteral: #ByteString;
				addFieldAccessMessage: #idStudent from: #SStudent;
				addMessage: #scoreStudent: from: #SStudent;
				addFactoryMessage: #SStudent ofSelector: #new;
				addFieldAccessMessage: #scoreStudent from: #SStudent;
				yourself);
		add:
			((SSTestCase with: self typeInfosSStudent first)
				addLiteral: #SmallInteger;
				addFactoryMessage: #SStudent ofSelector: #new;
				addMessage: #scoreStudent: from: #SStudent;
				addFactoryMessage: #SStudent ofSelector: #new;
				addFieldAccessMessage: #idStudent from: #SStudent;
				yourself);
				add:
			((SSTestCase with: self typeInfosSStudent first)
				addFactoryMessage: #SStudent ofSelector: #new;
				addLiteral: #SmallInteger;
				addMessage: #scoreStudent: from: #SStudent;
				addLiteral: #SmallInteger;
				addFactoryMessage: #SStudent ofSelector: #new;
				yourself);
		yourself
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfoAthensCairo [
	^ STypeInfo new
		type:
			#AthensCairoCanvas
				->
					(Array
						with:
							(Array
								with: #fillPreserve -> #(#AthensCairoCanvas #nil #() false)
								with: #textPath -> #(#AthensCairoCanvas #nil #() false))
						with: #());
		scalar: #ByteString with: #('hello')
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfoOnPackage1 [
	"the first typeInfo is about a class has as argument other class from other package"

	^ STypeInfo new
				type:
					#SEvent
						->
							(Array
								with:
									(Array
										with: #canRegister: -> #(#SConference #False #(#SStudent) false)
										with: #price -> #(#SConference #SmallInteger #() false))
								with: #());
				type:
					#SConference
						->
							(Array
								with:
									(Array
										with: #initialize -> #(#SConference #SConference #() false)
										with: #offerPrice -> #(#SConference #SmallInteger #() true)
										with: #offerPrice: -> #(#SConference #SConference #(#SmallInteger) false)
										with: #discount -> #(#SConference #SmallInteger #() true))
								with: #());
				scalar: #SmallInteger with: #(95 100);
				scalar: #False with: #(false);
				scalar: #SStudent with: (Array with: (SStudent new name: 'Mary'))
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfoOnPackage2 [
	"the first typeInfo is about a class has as argument other class from other package"

	^ STypeInfo new
				type:
					#SEvent
						->
							(Array
								with:
									(Array
										with: #price: -> #(#SConference #SConference #(#SmallInteger) false))
								with:
									(Array
										with: #price: -> #(#SConference #SConference #(#SmallInteger) false)));
				type:
					#SConference
						->
							(Array
								with: (Array with: #initialize -> #(#SConference #SConference #() false))
								with: #());
				scalar: #SmallInteger with: #(95)
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfoOnPackage3 [
	"the first typeInfo is about a class has as argument other class from other package"

	"review and modify"

	^ STypeInfo new
				type:
					#SSTeacher
						->
							(Array
								with:
									(OrderedCollection new
										add: #name: -> #(#SSTeacher #SSTeacher #(#ByteString) false);
										add: #id: -> #(#SSTeacher #SSTeacher #(#SmallInteger) false);
										add: #nickname: -> #(#SSTeacher #SSTeacher #(#ByteString) false);
										add: #initialize -> #(#SSTeacher #SSTeacher #() false);
										add: #nickname -> #(#SSTeacher #ByteString #() false);
										add: #name -> #(#SSTeacher #ByteString #() true);
										add: #id -> #(#SSTeacher #SmallInteger #() true);
										add: #yearsWorkExperience -> #(#SSTeacher #SmallInteger #() true);
										add: #idTeacher -> #(#SSTeacher #SmallInteger #() true);
										yourself)
								with:
									(Array
										with:
											#name:with:
												-> #(#SSTeacher #SSTeacher #(#ByteString #SmallInteger) false)));
				type:
					#SConference
						->
							(Array
								with:
									(Array
										with: #initialize -> #(#SConference #SConference #() false)
										with: #offerPrice -> #(#SConference #SmallInteger #() true)
										with: #offerPrice: -> #(#SConference #SConference #(#SmallInteger) false)
										with: #discount -> #(#SConference #SmallInteger #() true))
								with: #());
				scalar: #SmallInteger with: #(95);
				scalar: #False with: #(false);
				scalar: #SStudent with: (Array with: (SStudent new name: 'Mary'));
				scalar: #ByteString with: #('Mary')
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfoOnPackage4 [
	"the first typeInfo is about a class has as argument other class from other package"

	"review and modify"

	^ (STypeInfo new
				type:
					#SEvent
						->
							(Array
								with:
									(Array
										with: #price: -> #(#SConference #SConference #(#SmallInteger) false))
								with:
									(Array
										with: #price: -> #(#SConference #SConference #(#SmallInteger) false)));
				type:
					#SConference
						->
							(Array
								with: (Array with: #initialize -> #(#SConference #SConference #() false))
								with: #());
				scalar: #SmallInteger with: #(95))
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfoSEvent1 [
	^ STypeInfo new
				type:
					#SEvent
						->
							(Array
								with:
									(Array
										with: #initialize -> #(#SEvent #SEvent #() false)
										with: #discount -> #(#SEvent #SmallInteger #() true)
										with: #discount: -> #(#SEvent #SEvent #(#SmallInteger) false)
										with: #price -> #(#SEvent #SmallInteger #() true)
										with: #price: -> #(#SEvent #SEvent #(#SmallInteger) false))
								with: (Array with: #price: -> #(#SEvent #SEvent #(#SmallInteger) false)));
				scalar: #SmallInteger with: #(0 1 8 30)
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfoSEvent2 [
	^ STypeInfo new
				type:
					#SEvent
						->
							(Array
								with:
									(Array
										with: #initialize -> #(#SEvent #SEvent #() false)
										with: #discount -> #(#SEvent #SmallInteger #() true)
										with: #price -> #(#SEvent #SmallInteger #() true))
								with: (Array with: #price: -> #(#SEvent #SEvent #(#SmallInteger) false)));
				scalar: #SmallInteger with: #(0 15)
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfoSFoo1 [ 
	^ (STypeInfo new
				type:
					#SFoo
						->
							(Array
								with:
									(Array
										with: #returnNum -> #(#SFoo #SmallInteger #() false)
										with: #returnFloat -> #(#SFoo #SmallFloat64 #() false)
										with: #returnString -> #(#SFoo #ByteString #() false)
										with: #score -> #(#SFoo #SmallFloat64 #() true)
										with: #return: -> #(#SFoo #ByteString #(#ByteString) false))
								with: (Array with: #score: -> #(#SFoo #SFoo #(#SmallFloat64) false)));
				scalar: #ByteString with: #('hello');
				scalar: #SmallInteger with: #(5);
				scalar: #SmallFloat64 with: #(7.3))
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfoSFoo2 [
	^  (STypeInfo new
				type:
					#SFoo
						->
							(Array
								with: (Array with: #return: -> #(#SFoo #SFoo #(#SFoo) false))
								with: #());
				scalar: #ByteString with: #('hello');
				scalar: #SmallInteger with: #(5);
				scalar: #SmallFloat64 with: #(7.3))
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfoSFoo3 [
	^ 
			(STypeInfo new
				type:
					#SFoo
						->
							(Array
								with:
									(Array
										with: #returnNum -> #(#SFoo #SmallInteger #() false)
										with: #returnFloat -> #(#SFoo #SmallFloat64 #() false)
										with: #returnString -> #(#SFoo #ByteString #() false)
										with: #score -> #(#SFoo #SmallInteger #() true)
										with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false))
								with: (Array with: #score: -> #(#SFoo #SFoo #(#SmallInteger) false)));
				scalar: #ByteString with: #('Hello');
				scalar: #SmallInteger with: #(4);
				scalar: #SmallFloat64 with: #(2.3))
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfoSFoo4 [
	^ 
		STypeInfo new
				type:
					#SFoo
						->
							(Array
								with:
									(Array
										with: #initialize -> #(#SFoo #SFoo #() false)
										with: #return: -> #(#SFoo #SStudent #(#SStudent) false))
								with: #());
				scalar: #SStudent with: (Array with: SStudent new)
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfoSFoo5 [
	^ STypeInfo new
				type:
					#SFoo
						->
							(Array
								with:
									(Array
										with: #initialize -> #(#SFoo #SFoo #() false)
										with: #return: -> #(#SFoo #SStudent #(#SStudent) false))
								with: #());
				scalar: #SStudent with: (Array with: SStudent new)
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfoSSTeacher2 [
	^ 
			(STypeInfo new
				type:
					#SSTeacher
						->
							(Array
								with:
									(Array
										with: #initialize -> #(#SSTeacher #SSTeacher #() false)
										with: #idTeacher -> #(#SSTeacher #SmallInteger #() true)
										with:
											#yearsWorkExperience:
												-> #(#SSTeacher #SSTeacher #(#SmallInteger) false)
										with: #nickname -> #(#SSTeacher #ByteString #() false))
								with: #());
				scalar: #SmallInteger with: #(1 29 -7 9);
				scalar: #ByteString with: #('teacher_Amy' 'teacher_Mark'))
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfoSSTeacher3 [
	^ STypeInfo new
				type:
					#SSTeacher
						->
							(Array
								with:
									(Array
										with: #initialize -> #(#SSTeacher #SSTeacher #() false)
										with: #yearsWorkExperience -> #(#SSTeacher #SmallInteger #() false)
										with: #nickname -> #(#SSTeacher #ByteString #() false))
								with: #());
				scalar: #SmallInteger with: #(1 10);
				scalar: #ByteString with: #('teacher_Amy' 'teacher_Mark')
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfoSStack2 [
	^ 
			(STypeInfo new
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
				scalar: #SmallInteger with: #(1 2 5 8 9))
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfoSStack3 [
	^ 
		STypeInfo new
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

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfoSStack4 [
	^ 
			(STypeInfo new
				type:
					#SStack
						->
							(Array
								with:
									(Array
										with: #firstLinkStack -> #(#SStack #SmallInteger #() true)
										with: #lastLinkStack -> #(#SStack #SmallInteger #() true)
										with: #pop -> #(#SStack #SmallInteger #() false)
										with: #push: -> #(#SStack #SmallInteger #(#SmallInteger) false)
										with: #top -> #(#SStack #SmallInteger #() false))
								with:
									(Array
										with: #newStack -> #(#SStack #SStack #() false)
										with: #newStackWith: -> #(#SStack #SStack #(#Array) false)));
				scalar: #SmallInteger with: #(5);
				scalar: #Array with: #(#(1 4 5)))
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfosSStudent [
	^ OrderedCollection new
		add:
			(STypeInfo new
				type:
					#SStudent
						->
							(Array
								with:
									(Array
										with:
											#initialize -> #(#SStudent #SStudent #() false)
										with:
											#scoreStudent -> #(#SStudent #SmallInteger #() true)
										with:
											#scoreStudent: -> #(#SStudent #SStudent #(#SmallInteger) false)
										with:
											#idStudent -> #(#SStudent #SmallInteger #() true))
								with: #());
				scalar: #SmallInteger with: #(1);
				scalar: #ByteString with: #('student_Jane'));
		add:
			(STypeInfo new
				type:
					#SStudent
						->
							(Array
								with:
									(Array
										with:
											#scoreStudent: -> #(#SStudent #SStudent #(#SmallInteger) false)
										with:
											#nickname -> #(#SStudent #ByteString #() false))
								with: #());
				scalar: #SmallInteger with: #(1 6 8);
				scalar: #ByteString with: #('Jane' 'Ann' 'Peter'));
		yourself
]