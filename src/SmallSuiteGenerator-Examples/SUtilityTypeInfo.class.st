Class {
	#name : #SUtilityTypeInfo,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Examples'
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
				"_Var0 scoreStudent: 36"
					addFactoryMessage: #SStudent ofSelector: #new;
				addFieldAccessMessage: #scoreStudent from: #SStudent; yourself);
		"_Var4 nickname"
			add:
			((SSTestCase with: self typeInfosSStudent first)
				addLiteral: #SmallInteger;
				addFactoryMessage: #SStudent ofSelector: #new;
				addMessage: #scoreStudent: from: #SStudent;
				addFactoryMessage: #SStudent ofSelector: #new;
				addFieldAccessMessage: #idStudent from: #SStudent; yourself);
		"_var3 idStudent"
			yourself
	"_Var4 scoreStudent"
	"addMessage: #nickname from: #SStudent"
]

{ #category : #'as yet unclassified' }
SUtilityTypeInfo >> typeInfosSFoo [
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
SUtilityTypeInfo >> typeInfosSSTeacher [
	^ OrderedCollection new
		add:
			(STypeInfo new
				type:
					#SSTeacher
						->
							{{(#initialize
								->
									{#SSTeacher.
									{}.
									false}).
							(#yearsWorkExperience
								->
									{#SmallInteger.
									{}.
									true}).
							(#yearsWorkExperience:
								->
									{#SSTeacher.
									{#SmallInteger}.
									false})}.
							{}};
				scalar: #SmallInteger with: #(0 100);
				scalar: #ByteString with: {'teacher_Ann'});
		add:
			(STypeInfo new
				type:
					#SSTeacher
						->
							{{(#initialize
								->
									{#SSTeacher.
									{}.
									false}).
							(#idTeacher
								->
									{#SmallInteger.
									{}.
									true}).
							(#yearsWorkExperience:
								->
									{#SSTeacher.
									{#SmallInteger}.
									false}).
							(#nickname
								->
									{#ByteString.
									{}.
									false})}.
							{}};
				scalar: #SmallInteger with: #(1 29 -7 9);
				scalar: #ByteString with: {'teacher_Amy' . 'teacher_Mark'});
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
SUtilityTypeInfo >> typeInfosSStudent [
	^ OrderedCollection new
		add:
			(STypeInfo new
				type:
					#SStudent
						->
							{{(#initialize
								->
									{#SStudent.
									{}.
									false}).
							(#scoreStudent
								->
									{#SmallInteger.
									{}.
									true}).
							(#scoreStudent:
								->
									{#SStudent.
									{#SmallInteger}.
									false}).
									
									(#idStudent
								->
									{#SmallInteger.
									{}.
									true}).}.
							{}};
				scalar: #SmallInteger with: #(10 1);
				scalar: #ByteString with: {'student_Jane'});
		add:
			(STypeInfo new
				type:
					#SStudent
						->
							{{(#scoreStudent:
								->
									{#SStudent.
									{#SmallInteger}.
									false}).
							(#nickname
								->
									{#ByteString.
									{}.
									false})}.
							{}};
				scalar: #SmallInteger with: #(1 6 8);
				scalar: #ByteString with: {'Jane' . 'Ann' . 'Peter'});
		yourself
]
