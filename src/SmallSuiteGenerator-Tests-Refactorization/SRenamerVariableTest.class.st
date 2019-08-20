Class {
	#name : #SRenamerVariableTest,
	#superclass : #SUnitTestCase,
	#instVars : [
		'renamer'
	],
	#category : #'SmallSuiteGenerator-Tests-Refactorization'
}

{ #category : #running }
SRenamerVariableTest >> setUp [
	renamer := SRenamerVariable
]

{ #category : #tests }
SRenamerVariableTest >> testNameBasedOnTypeFactoryMessage [
	| stm |
	stm := SFactoryMessage new returnType: 'SmallInteger'.
	self assert: (renamer nameBasedOnType: stm) equals: '_smaInt'.
	stm := SFactoryMessage new returnType: 'ByteString'.
	self assert: (renamer nameBasedOnType: stm) equals: '_bytStr'.
	stm := SFactoryMessage new returnType: 'Character'.
	self assert: (renamer nameBasedOnType: stm) equals: '_character'.
	stm := SFactoryMessage new returnType: 'Array'.
	self assert: (renamer nameBasedOnType: stm) equals: '_array'.
	stm := SFactoryMessage new returnType: 'False'.
	self assert: (renamer nameBasedOnType: stm) equals: '_false'.
	stm := SFactoryMessage new returnType: 'SSTeacher'.
	self assert: (renamer nameBasedOnType: stm) equals: '_ssteacher'.
	stm := SFactoryMessage new returnType: 'SStudent'.
	self assert: (renamer nameBasedOnType: stm) equals: '_sstudent'.
	stm := SFactoryMessage new returnType: 'SFoo'.
	self assert: (renamer nameBasedOnType: stm) equals: '_sfoo'.
	stm := SFactoryMessage new returnType: 'RTView'.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtview'.
	stm := SFactoryMessage new returnType: 'RTAMItem'.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtamitem'.
	stm := SFactoryMessage new returnType: 'RTBorderAttachPoint'.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtbAttPoi'.
	stm := SFactoryMessage new returnType: 'RTCalendarBuilder'.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtcBui'.
	stm := SFactoryMessage new returnType: 'UndefinedObject'.
	self assert: (renamer nameBasedOnType: stm) equals: '_var'.
	stm := SFactoryMessage new returnType: nil.
	self assert: (renamer nameBasedOnType: stm) equals: '_var'
]

{ #category : #tests }
SRenamerVariableTest >> testNameBasedOnTypeFieldAccessMessage [
	| stm |
	stm := SFieldAccessMessage new returnType: #SmallInteger.
	self assert: (renamer nameBasedOnType: stm) equals: '_smaInt'.
	stm := SFieldAccessMessage new returnType: #ByteString.
	self assert: (renamer nameBasedOnType: stm) equals: '_bytStr'.
	stm := SFieldAccessMessage new returnType: #Character.
	self assert: (renamer nameBasedOnType: stm) equals: '_character'.
	stm := SFieldAccessMessage new returnType: #Array.
	self assert: (renamer nameBasedOnType: stm) equals: '_array'.
	stm := SFieldAccessMessage new returnType: #True.
	self assert: (renamer nameBasedOnType: stm) equals: '_true'.
	stm := SFieldAccessMessage new returnType: #RTView.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtview'.
	stm := SFieldAccessMessage new returnType: #RTLineSegment.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtlSeg'.
	stm := SFieldAccessMessage new returnType: #RTSVGPath.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtsvgpath'.
	stm := SFieldAccessMessage new returnType: #RTPieBuilder.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtpBui'.
	stm := SFieldAccessMessage new returnType: #UndefinedObject.
	self assert: (renamer nameBasedOnType: stm) equals: '_var'.
	stm := SFieldAccessMessage new returnType: nil.
	self assert: (renamer nameBasedOnType: stm) equals: '_var'
]

{ #category : #tests }
SRenamerVariableTest >> testNameBasedOnTypeLiteral [
	| stm |
	stm := SLiteral new returnType: #SmallInteger.
	self assert: (renamer nameBasedOnType: stm) equals: '_smaInt'.
	stm := SLiteral new returnType: #ByteString.
	self assert: (renamer nameBasedOnType: stm) equals: '_bytStr'.
	stm := SLiteral new returnType: #Character.
	self assert: (renamer nameBasedOnType: stm) equals: '_character'.
	stm := SLiteral new returnType: #Array.
	self assert: (renamer nameBasedOnType: stm) equals: '_array'.
	stm := SLiteral new returnType: #True.
	self assert: (renamer nameBasedOnType: stm) equals: '_true'.
	stm := SLiteral new returnType: #UndefinedObject.
	self assert: (renamer nameBasedOnType: stm) equals: '_var'.
	stm := SLiteral new returnType: nil.
	self assert: (renamer nameBasedOnType: stm) equals: '_var'
]

{ #category : #tests }
SRenamerVariableTest >> testNameBasedOnTypeMessage [
	| stm |
	stm := SMessage new returnType: #SmallInteger.
	self assert: (renamer nameBasedOnType: stm) equals: '_smaInt'.
	stm := SMessage new returnType: #ByteString.
	self assert: (renamer nameBasedOnType: stm) equals: '_bytStr'.
	stm := SMessage new returnType: #Character.
	self assert: (renamer nameBasedOnType: stm) equals: '_character'.
	stm := SMessage new returnType: #Array.
	self assert: (renamer nameBasedOnType: stm) equals: '_array'.
	stm := SMessage new returnType: #True.
	self assert: (renamer nameBasedOnType: stm) equals: '_true'.
	stm := SMessage new returnType: #RTDraggableView.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtdVie'.
	stm := SMessage new returnType: #RTSpectrograph.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtspectrograph'.
	stm := SMessage new returnType: #RTUMLClassBuilder.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtuBui'.
	stm := SMessage new
		returnType: #RTMultiLinearColorForIdentity.
	self
		assert: (renamer nameBasedOnType: stm)
		equals: '_rtmLinColForIde'.
	stm := SMessage new returnType: #RTBorderAttachPoint.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtbAttPoi'.
	stm := SMessage new returnType: #UndefinedObject.
	self assert: (renamer nameBasedOnType: stm) equals: '_var'.
	stm := SMessage new returnType: nil.
	self assert: (renamer nameBasedOnType: stm) equals: '_var'
]

{ #category : #tests }
SRenamerVariableTest >> testRenameVarNamesFactoryMessage [
	| testCase |
	testCase := SSTestCase new
		addStatement:
			(SLiteral new
				returnType: #SmallInteger;
				value: 45);
		addStatement:
			(SFactoryMessage new
				returnType: 'SFoo';
				selector: #score:;
				args: #('_var0'));
		addStatement:
			(SMessage new
				receiverVarName: '_var1';
				selector: #return:;
				returnType: #SmallInteger;
				args: {'_var0'});
		addStatement:
			(SFieldAccessMessage new
				receiverVarName: '_var1';
				fieldName: #score;
				returnType: #SmallInteger);
		addStatement:
			(SLiteral new
				value: 'Sussy';
				returnType: #ByteString);
		addStatement:
			(SFactoryMessage new
				returnType: 'SStudent';
				selector: 'name:';
				args: #('_var4'));
		addStatement:
			(SFactoryMessage new
				returnType: 'SSTeacher';
				selector: #name:with:;
				args: #('_var4' '_var0'));
		addStatement:
			(SFieldAccessMessage new
				receiverVarName: '_var5';
				fieldName: #id;
				returnType: #UndefinedObject);
		yourself.
	renamer applyOn: testCase.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_smaInt0 := 45.' . '_sfoo1 := SFoo score: ''_smaInt0'' .'.
			'_smaInt2 := _sfoo1 return: ''_smaInt0'' .'.
			'_smaInt3 := _sfoo1 score.' . '_bytStr4 := ''Sussy''.'.
			'_sstudent5 := SStudent name: ''_bytStr4'' .'.
			'_ssteacher6 := SSTeacher name: ''_bytStr4'' with: ''_smaInt0'' .'.
			'_var7 := _sstudent5 id.'}
]

{ #category : #tests }
SRenamerVariableTest >> testRenameVarNamesFieldAccessMessage [
	| testCase |
	testCase := SSTestCase new
		addStatement:
			(SFieldAccessMessage new
				receiverVarName: '(SFoo score: 3)';
				fieldName: #score;
				returnType: #SmallInteger);
		addStatement:
			(SFactoryMessage new
				returnType: 'SFoo';
				selector: #score:;
				args: #('_var0'));
		addStatement:
			(SFieldAccessMessage new
				receiverVarName: '(SStudent new)';
				fieldName: #name;
				returnType: #ByteString);
		addStatement:
			(SFieldAccessMessage new
				receiverVarName: '_var1';
				fieldName: #score;
				returnType: #SmallInteger);
		addStatement:
			(SFieldAccessMessage new
				receiverVarName: '(SFoo score: 4.5)';
				fieldName: #score;
				returnType: #SmallFloat64);
		addStatement:
			(SFieldAccessMessage new
				receiverVarName: '(SFoo new)';
				fieldName: #returnBoolean;
				returnType: #False);
		addStatement:
			(SFieldAccessMessage new
				receiverVarName: '(SSTeacher new)';
				fieldName: #id;
				returnType: #UndefinedObject);
		yourself.
	renamer applyOn: testCase.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_smaInt0 := (SFoo score: 3) score.'.
			'_sfoo1 := SFoo score: ''_smaInt0'' .'.
			'_bytStr2 := (SStudent new) name.' . '_smaInt3 := _sfoo1 score.'.
			'_smaFlo4 := (SFoo score: 4.5) score.'.
			'_false5 := (SFoo new) returnBoolean.'.
			'_var6 := (SSTeacher new) id.'}
]

{ #category : #tests }
SRenamerVariableTest >> testRenameVarNamesLiteral [
	| testCase |
	testCase := SSTestCase new
		addStatement:
			(SLiteral new
				returnType: #SmallInteger;
				value: 45);
		addStatement:
			(SLiteral new
				returnType: #ByteString;
				value: 'hello');
		addStatement:
			(SLiteral new
				returnType: #Character;
				value: $f);
		addStatement:
			(SLiteral new
				returnType: #Array;
				value: {4 . 6 . 7 . 1});
		addStatement:
			(SLiteral new
				returnType: #True;
				value: true);
		addStatement:
			(SLiteral new
				returnType: #UndefinedObject;
				value: nil);
		yourself.
	renamer applyOn: testCase.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_smaInt0 := 45.' . '_bytStr1 := ''hello''.' . '_character2 := $f.'.
			'_array3 := #(4 6 7 1 ).' . '_true4 := true.' . '_var5 := nil.'}
]

{ #category : #tests }
SRenamerVariableTest >> testRenameVarNamesMessage [
	| testCase |
	testCase := SSTestCase new
		addStatement:
			(SMessage new
				receiverVarName: '(SFoo score: 3)';
				selector: #returnNum;
				returnType: #SmallInteger;
				args: #());
		addStatement:
			(SFactoryMessage new
				returnType: 'SFoo';
				selector: #score:;
				args: #('_var0'));
		addStatement:
			(SMessage new
				receiverVarName: '_var1';
				selector: #return:;
				returnType: #SmallInteger;
				args: {'_var0'});
		addStatement:
			(SMessage new
				receiverVarName: '(SFoo score: 23)';
				selector: #returnString;
				returnType: #ByteString;
				args: #());
		addStatement:
			(SMessage new
				receiverVarName: '(SFoo score: ''_var0'' )';
				selector: #returnCollection;
				returnType: #OrderedCollection;
				args: #());
		addStatement:
			(SMessage new
				receiverVarName: '(SFoo new)';
				selector: #returnFloat;
				returnType: #SmallFloat64;
				args: #());
		addStatement:
			(SMessage new
				receiverVarName: '(SSTeacher new)';
				selector: #id;
				returnType: #UndefinedObject;
				args: #());
		yourself.
	renamer applyOn: testCase.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_smaInt0 := (SFoo score: 3) returnNum.'.
			'_sfoo1 := SFoo score: ''_smaInt0'' .'.
			'_smaInt2 := _sfoo1 return: ''_smaInt0'' .'.
			'_bytStr3 := (SFoo score: 23) returnString.'.
			'_ordCol4 := (SFoo score: ''_smaInt0'' ) returnCollection.'.
			'_smaFlo5 := (SFoo new) returnFloat.'.
			'_var6 := (SSTeacher new) id.'}
]
