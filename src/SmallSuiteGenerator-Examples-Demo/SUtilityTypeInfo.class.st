Class {
	#name : #SUtilityTypeInfo,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Examples-Demo'
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
	^ self testSuiteOf: self typeInfosSSTeacher 
]

{ #category : #tests }
SUtilityTypeInfo >> testSuiteSStack [
	^ self testSuiteOf: self typeInfosSStack
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
								with: #fillPreserve -> #(#nil #() false)
								with: #textPath -> #(#nil #() false))
						with: #());
		scalar: #ByteString with: #('hello')
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfosSEvent [
	^ OrderedCollection new
		add:
			(STypeInfo new
				type:
					#SEvent
						->
							(Array
								with:
									(Array
										with: #initialize -> #(#SEvent #() false)
										with: #discount -> #(#SmallInteger #() true)
										with: #discount: -> #(#SEvent #(#SmallInteger) false)
										with: #price -> #(#SmallInteger #() true)
										with: #price: -> #(#SEvent #(#SmallInteger) false))
								with: (Array with: #price: -> #(#SEvent #(#SmallInteger) false)));
				scalar: #SmallInteger with: #(0 1 8 30));
		add:
			(STypeInfo new
				type:
					#SEvent
						->
							(Array with: (Array with: (#initialize -> #(#SEvent #() false)) with:
							(#discount -> #(#SmallInteger #() true)) with:
							(#price -> #(#SmallInteger #() true))) with:
							(Array with: (#price: -> #(#SEvent #(#SmallInteger) false))));
				scalar: #SmallInteger with: #(0 15));
		yourself
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfosSFoo [
	^ OrderedCollection new
		add:
			(STypeInfo new
				type:
					#SFoo
						->
							(Array
								with:
									(Array
										with:
											#returnNum -> #(#SmallInteger #() false)
										with:
											#returnFloat -> #(#SmallFloat64 #() false)
										with:
											#returnString -> #(#ByteString #() false)
										with:
											#score -> #(#SmallFloat64 #() true)
										with:
											#return: -> #(#ByteString #(#ByteString) false))
								with:
									(Array with:
										#score: -> #(#SFoo #(#SmallFloat64) false)));
				scalar: #ByteString with: #('hello');
				scalar: #SmallInteger with: #(5);
				scalar: #SmallFloat64 with: #(7.3));
		add:
			(STypeInfo new
				type:
					#SFoo
						->
							(Array with: (Array with: (#return:
								->
									#(#SFoo
									#(#SFoo)
									false))) with:
							#());
				scalar: #ByteString with: #('hello');
				scalar: #SmallInteger with: #(5);
				scalar: #SmallFloat64 with: #(7.3));
		add:
			(STypeInfo new
				type:
					#SFoo
						->
							(Array with: (Array with: (#returnNum
								->
									#(#SmallInteger
									#()
									false)) with:
							(#returnFloat
								->
									#(#SmallFloat64
									#()
									false)) with:
							(#returnString
								->
									#(#ByteString
									#()
									false)) with:
							(#score
								->
									#(#SmallInteger
									#()
									true)) with:
							(#score:
								->
									#(#SFoo
									#(#SmallInteger)
									false))) with:
							(Array with: (#score:
								->
									#(#SFoo
									#(#SmallInteger)
									false))));
				scalar: #ByteString with: #('Hello');
				scalar: #SmallInteger with: #(4);
				scalar: #SmallFloat64 with: #(2.3));
		add:
			(STypeInfo new
				type:
					#SFoo
						->
							(Array with: (Array with: (#returnCollection
								->
									#(#OrderedCollection
									#()
									false)) with:
							(#returnFloat
								->
									#(#SmallFloat64
									#()
									false)) with:
							(#score
								->
									#(#SmallInteger
									#()
									true)) with:
							(#return:
								->
									#(#Array
									#(#Array)
									false))) with: 
							(Array with: (#score:
								->
									#(#SFoo
									#(#SmallInteger)
									false))));
				scalar: #OrderedCollection
					with: (Array with: OrderedCollection new);
				scalar: #Array with: (Array with: #(1 5 6));
				scalar: #SmallInteger with: #(15);
				scalar: #SmallFloat64 with: #(2.3));
		yourself
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfosSSTeacher [
	^ OrderedCollection new
		add:
			(STypeInfo new
				type:
					#SSTeacher
						->
							(Array with: (Array with: (#initialize
								->
									#(#SSTeacher
									#()
									false)) with: 
							(#yearsWorkExperience
								->
									#(#SmallInteger
									#()
									true)) with: 
							(#yearsWorkExperience:
								->
									#(#SSTeacher
									#(#SmallInteger)
									false))) with: 
							#());
				scalar: #SmallInteger with: #(0 100);
				scalar: #ByteString with: #('teacher_Ann'));
		add:
			(STypeInfo new
				type:
					#SSTeacher
						->
							(Array with: (Array with: (#initialize
								->
									#(#SSTeacher
									#()
									false)) with:
							(#idTeacher
								->
									#(#SmallInteger
									#()
									true)) with:
							(#yearsWorkExperience:
								->
									#(#SSTeacher
									#(#SmallInteger)
									false)) with:
							(#nickname
								->
									#(#ByteString
									#()
									false))) with: 
							#());
				scalar: #SmallInteger with: #(1 29 -7 9);
				scalar: #ByteString with: #('teacher_Amy' 'teacher_Mark'));
		add:
			(STypeInfo new
				type:
					#SSTeacher
						->
							(Array with: (Array with: (#initialize
								->
									#(#SSTeacher
									#()
									false)) with: 
							(#yearsWorkExperience
								->
									#(#SmallInteger
									#()
									false)) with: 
							(#nickname
								->
									#(#ByteString
									#()
									false))) with: 
							#());
				scalar: #SmallInteger with: #(1 10);
				scalar: #ByteString with: #('teacher_Amy' 'teacher_Mark'));
		yourself
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfosSStack [
	^ OrderedCollection new
		add:
			(STypeInfo new
				type:
					#SStack
						->
							(Array
								with:
									(Array
										with:
											#firstLinkStack -> #(#SmallInteger #() true)
										with:
											#pop -> #(#SmallInteger #() false)
										with:
											#push: -> #(#SmallInteger #(#SmallInteger) false))
								with:
									(Array with:
										#newStackWith: -> #(#SStack #(#Array) false)));
				scalar: #Array with: #(#(2 4 6 1));
				scalar: #SmallInteger with: #(1 2 4 6 8));
		add:
			(STypeInfo new
				type:
					#SStack
						->
							(Array
								with:
									(Array
										with:
											#lastLinkStack -> #(#SmallInteger #()  true)
										with:
											#pop -> #(#SmallInteger #() false)
										with:
											#top -> #(#SmallInteger #() false))
								with:
									(Array
										with: #newStack -> #(#SStack #() false)
										with:
											#newStackWith: -> #(#SStack #(#Array) false)));
				scalar: #Array with: #(#(2 4 6 1) #(5 7 9 0));
				scalar: #SmallInteger with: #(1 2 5 8 9));
		add:
			(STypeInfo new
				type:
					#SStack
						->
							(Array
								with:
									(Array
										with:
											#pop -> #(#SmallInteger #() false)
										with:
											#push: -> #(#SmallInteger #(#SmallInteger) false)
										with:
											#top -> #(#SmallInteger #() false))
								with:
									(Array with:
										#newStackWith: -> #(#SStack #(#Array) false)));
				scalar: #Array with: (Array with: #(2 4 6 1));
				scalar: #SmallInteger with: #(7 5 9 1));
		yourself
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfosSStudent [
	^ OrderedCollection new
		add:
			(STypeInfo new
				type:
					#SStudent
						->
							(Array with: (Array with: (#initialize
								->
									#(#SStudent
									#()
									false)) with: 
							(#scoreStudent
								->
									#(#SmallInteger
									#()
									true)) with: 
							(#scoreStudent:
								->
									#(#SStudent
									#(#SmallInteger)
									false)) with:
							(#idStudent
								->
									#(#SmallInteger
									#()
									true))) with: 
							#());
				scalar: #SmallInteger with: #(1);
				scalar: #ByteString with: #('student_Jane'));
		add:
			(STypeInfo new
				type:
					#SStudent
						->
							(Array with: (Array with: (#scoreStudent:
								->
									#(#SStudent
									#(#SmallInteger)
									false)) with:
							(#nickname
								->
									#(#ByteString
									#()
									false))) with: 
							#());
				scalar: #SmallInteger with: #(1 6 8);
				scalar: #ByteString with: #('Jane'  'Ann'  'Peter'));
		yourself
]
