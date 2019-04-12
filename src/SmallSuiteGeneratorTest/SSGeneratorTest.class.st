Class {
	#name : #SSGeneratorTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Generator'
}

{ #category : #'generator-tests' }
SSGeneratorTest >> testConstructorGenerator [
	| profile testCase |
	profile := SSGenerator profile: [ SFoo score: 2 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	self
		assert: testCase statements first printString
		equals: '_var0 := SFoo score: 2 .'
]

{ #category : #tests }
SSGeneratorTest >> testFieldGenerator [
	| profile testCase |
	profile := SSGenerator
		profile: [ (SFoo score: 2) score ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addField.
	self
		assert: testCase printString
		equals:
			'_var0 := SFoo score: 2 .
_var1 := _var0 score.
'
]

{ #category : #tests }
SSGeneratorTest >> testMergeTypes [
	| profile method |
	profile := SSGenerator
		profile: [ SFoo new
				return: Stack new;
				return: OrderedCollection new ]
		onClass: SFoo.
	method := profile >> #SFoo >> #return:.
	self assert: method returnType equals: SequenceableCollection.
	self assert: method argTypes first equals: SequenceableCollection
]

{ #category : #tests }
SSGeneratorTest >> testMethodGenerator [
	| profile testCase |
	profile := SSGenerator
		profile: [ (SFoo score: 2) return: 2 ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addMethod.
	self
		assert:
			(testCase printString
				=
					'_var0 := SFoo score: 2 .
_var1 := _var0 return: 2 '
				or: [ testCase printString
						=
							'_var0 := SFoo score: 2 .
_var1 := _var0 initialize.
' ])
]

{ #category : #tests }
SSGeneratorTest >> testMethodGeneratorInAbstractClass [
	| profile testCase |
	profile := SSGenerator
		profile: [ (SFoo score: 2)
				person:
					(SStudent new
						name: 'Peter';
						nickname: 'peter';
						score: 5).
			(SFoo score: 6)
				person: ((SSTeacher name: 'Carl' with: 110) yearsWorkExperience: 5) ]
		onClass: SFoo.
	testCase := STestCase seed: profile. self halt.
	testCase addConstructor.
	testCase addMethod
]

{ #category : #'generator-tests' }
SSGeneratorTest >> testMultipleConstructorGenerator [
	| profile testCase |
	profile := SSGenerator
		profile: [ SFoo score: 2.
			SFoo score: 5.
			SFoo score: 7 ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	10 timesRepeat: [ testCase addConstructor ].
	self assert: testCase statements size equals: 10
]

{ #category : #tests }
SSGeneratorTest >> testPrimitiveGenerator [
	| profile testCase |
	profile := SSGenerator
		profile: [ SFoo score: 2 ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	self
		assert: testCase statements first printString
		equals: '_var0 := 2.'
]

{ #category : #tests }
SSGeneratorTest >> testReturnType [
	| profile |
	profile := SSGenerator
		profile: [ SFoo new score ]
		onClass: SFoo.
	self
		assert: (profile >> #SFoo >> #score) returnType equals: SmallInteger
]

{ #category : #tests }
SSGeneratorTest >> testScalars [
	| profile |
	profile := SSGenerator
		profile: [ SFoo new
				return: 1;
				return: 2 ]
		onClass: SFoo.
	self assert: profile scalars size equals: 1.
	self assert: (profile scalars at: #SmallInteger) size equals: 2
]
