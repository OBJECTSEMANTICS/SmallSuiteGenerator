Class {
	#name : #SRenamerVariableTest,
	#superclass : #TestCase,
	#instVars : [
		'renamer'
	],
	#category : #'SmallSuiteGeneratorTest-Refactorization'
}

{ #category : #running }
SRenamerVariableTest >> setUp [
	renamer := SRenamerVariable
]

{ #category : #tests }
SRenamerVariableTest >> testNameBasedOnTypeConstructorStatement [
	| stm |
	stm := SConstructorStatement new theClassName: 'SmallInteger'.
	self assert: (renamer nameBasedOnType: stm) equals: '_smaInt'.
	stm := SConstructorStatement new theClassName: 'ByteString'.
	self assert: (renamer nameBasedOnType: stm) equals: '_bytStr'.
	stm := SConstructorStatement new theClassName: 'Character'.
	self assert: (renamer nameBasedOnType: stm) equals: '_character'.
	stm := SConstructorStatement new theClassName: 'Array'.
	self assert: (renamer nameBasedOnType: stm) equals: '_array'.
	stm := SConstructorStatement new theClassName: 'False'.
	self assert: (renamer nameBasedOnType: stm) equals: '_false'.
	stm := SConstructorStatement new theClassName: 'SSTeacher'.
	self assert: (renamer nameBasedOnType: stm) equals: '_ssteacher'.
	stm := SConstructorStatement new theClassName: 'SStudent'.
	self assert: (renamer nameBasedOnType: stm) equals: '_sstudent'.
	stm := SConstructorStatement new theClassName: 'SFoo'.
	self assert: (renamer nameBasedOnType: stm) equals: '_sfoo'.
	stm := SConstructorStatement new theClassName: 'RTView'.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtview'.
	stm := SConstructorStatement new theClassName: 'RTAMItem'.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtamitem'.
	stm := SConstructorStatement new theClassName: 'RTBorderAttachPoint'.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtbAttPoi'.
	stm := SConstructorStatement new theClassName: 'RTCalendarBuilder'.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtcBui'.
	stm := SConstructorStatement new theClassName: 'UndefinedObject'.
	self assert: (renamer nameBasedOnType: stm) equals: '_var'.
	stm := SConstructorStatement new theClassName: nil.
	self assert: (renamer nameBasedOnType: stm) equals: '_var'
]

{ #category : #tests }
SRenamerVariableTest >> testNameBasedOnTypeFieldStatement [
	| stm |
	stm := SFieldStatement new returnTypeName: #SmallInteger.
	self assert: (renamer nameBasedOnType: stm) equals: '_smaInt'.
	stm := SFieldStatement new returnTypeName: #ByteString.
	self assert: (renamer nameBasedOnType: stm) equals: '_bytStr'.
	stm := SFieldStatement new returnTypeName: #Character.
	self assert: (renamer nameBasedOnType: stm) equals: '_character'.
	stm := SFieldStatement new returnTypeName: #Array.
	self assert: (renamer nameBasedOnType: stm) equals: '_array'.
	stm := SFieldStatement new returnTypeName: #True.
	self assert: (renamer nameBasedOnType: stm) equals: '_true'.
	stm := SFieldStatement new returnTypeName: #RTView.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtview'.
	stm := SFieldStatement new returnTypeName: #RTLineSegment.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtlSeg'.
	stm := SFieldStatement new returnTypeName: #RTSVGPath.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtsvgpath'.
	stm := SFieldStatement new returnTypeName: #RTPieBuilder.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtpBui'.
	stm := SFieldStatement new returnTypeName: #UndefinedObject.
	self assert: (renamer nameBasedOnType: stm) equals: '_var'.
	stm := SFieldStatement new returnTypeName: nil.
	self assert: (renamer nameBasedOnType: stm) equals: '_var'
]

{ #category : #tests }
SRenamerVariableTest >> testNameBasedOnTypeMethodStatement [
	| stm |
	stm := SMethodStatement new returnTypeName: #SmallInteger.
	self assert: (renamer nameBasedOnType: stm) equals: '_smaInt'.
	stm := SMethodStatement new returnTypeName: #ByteString.
	self assert: (renamer nameBasedOnType: stm) equals: '_bytStr'.
	stm := SMethodStatement new returnTypeName: #Character.
	self assert: (renamer nameBasedOnType: stm) equals: '_character'.
	stm := SMethodStatement new returnTypeName: #Array.
	self assert: (renamer nameBasedOnType: stm) equals: '_array'.
	stm := SMethodStatement new returnTypeName: #True.
	self assert: (renamer nameBasedOnType: stm) equals: '_true'.
	stm := SMethodStatement new returnTypeName: #RTDraggableView.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtdVie'.
	stm := SMethodStatement new returnTypeName: #RTSpectrograph.
	self
		assert: (renamer nameBasedOnType: stm)
		equals: '_rtspectrograph'.
	stm := SMethodStatement new returnTypeName: #RTUMLClassBuilder.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtuBui'.
	stm := SMethodStatement new
		returnTypeName: #RTMultiLinearColorForIdentity.
	self
		assert: (renamer nameBasedOnType: stm)
		equals: '_rtmLinColForIde'.
	stm := SMethodStatement new returnTypeName: #RTBorderAttachPoint.
	self assert: (renamer nameBasedOnType: stm) equals: '_rtbAttPoi'.
	stm := SMethodStatement new returnTypeName: #UndefinedObject.
	self assert: (renamer nameBasedOnType: stm) equals: '_var'.
	stm := SMethodStatement new returnTypeName: nil.
	self assert: (renamer nameBasedOnType: stm) equals: '_var'
]

{ #category : #tests }
SRenamerVariableTest >> testNameBasedOnTypePrimitiveStatement [
	| stm |
	stm := SPrimitiveStatement new returnTypeName: #SmallInteger.
	self assert: (renamer nameBasedOnType: stm) equals: '_smaInt'.
	stm := SPrimitiveStatement new returnTypeName: #ByteString.
	self assert: (renamer nameBasedOnType: stm) equals: '_bytStr'.
	stm := SPrimitiveStatement new returnTypeName: #Character.
	self assert: (renamer nameBasedOnType: stm) equals: '_character'.
	stm := SPrimitiveStatement new returnTypeName: #Array.
	self assert: (renamer nameBasedOnType: stm) equals: '_array'.
	stm := SPrimitiveStatement new returnTypeName: #True.
	self assert: (renamer nameBasedOnType: stm) equals: '_true'.
	stm := SPrimitiveStatement new returnTypeName: #UndefinedObject.
	self assert: (renamer nameBasedOnType: stm) equals: '_var'.
	stm := SPrimitiveStatement new returnTypeName: nil.
	self assert: (renamer nameBasedOnType: stm) equals: '_var'
]

{ #category : #tests }
SRenamerVariableTest >> testRenameVarNamesConstructorStatement [
	| testCase |
	testCase := STestCase new
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: #SmallInteger;
				value: 45);
		addStatement:
			(SConstructorStatement new
				theClassName: 'SFoo';
				selector: #score:;
				args: #('_var0'));
		addStatement:
			(SMethodStatement new
				receiverVarName: '_var1';
				selector: #return:;
				returnTypeName: #SmallInteger;
				args: {'_var0'});
		addStatement:
			(SFieldStatement new
				receiverVarName: '_var1';
				fieldName: #score;
				returnTypeName: #SmallInteger);
		addStatement:
			(SPrimitiveStatement new
				value: 'Sussy';
				returnTypeName: #ByteString);
		addStatement:
			(SConstructorStatement new
				theClassName: 'SStudent';
				selector: 'name:';
				args: #('_var4'));
		addStatement:
			(SConstructorStatement new
				theClassName: 'SSTeacher';
				selector: #name:with:;
				args: #('_var4' '_var0'));
		addStatement:
			(SFieldStatement new
				receiverVarName: '_var5';
				fieldName: #id;
				returnTypeName: #UndefinedObject);
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
SRenamerVariableTest >> testRenameVarNamesFieldStatement [
	| testCase |
	testCase := STestCase new
		addStatement:
			(SFieldStatement new
				receiverVarName: '(SFoo score: 3)';
				fieldName: #score;
				returnTypeName: #SmallInteger);
		addStatement:
			(SConstructorStatement new
				theClassName: 'SFoo';
				selector: #score:;
				args: #('_var0'));
		addStatement:
			(SFieldStatement new
				receiverVarName: '(SStudent new)';
				fieldName: #name;
				returnTypeName: #ByteString);
		addStatement:
			(SFieldStatement new
				receiverVarName: '_var1';
				fieldName: #score;
				returnTypeName: #SmallInteger);
		addStatement:
			(SFieldStatement new
				receiverVarName: '(SFoo score: 4.5)';
				fieldName: #score;
				returnTypeName: #SmallFloat64);
		addStatement:
			(SFieldStatement new
				receiverVarName: '(SFoo new)';
				fieldName: #returnBoolean;
				returnTypeName: #False);
		addStatement:
			(SFieldStatement new
				receiverVarName: '(SSTeacher new)';
				fieldName: #id;
				returnTypeName: #UndefinedObject);
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
SRenamerVariableTest >> testRenameVarNamesMethodStatement [
	| testCase |
	testCase := STestCase new
		addStatement:
			(SMethodStatement new
				receiverVarName: '(SFoo score: 3)';
				selector: #returnNum;
				returnTypeName: #SmallInteger;
				args: #());
		addStatement:
			(SConstructorStatement new
				theClassName: 'SFoo';
				selector: #score:;
				args: #('_var0'));
		addStatement:
			(SMethodStatement new
				receiverVarName: '_var1';
				selector: #return:;
				returnTypeName: #SmallInteger;
				args: {'_var0'});
		addStatement:
			(SMethodStatement new
				receiverVarName: '(SFoo score: 23)';
				selector: #returnString;
				returnTypeName: #ByteString;
				args: #());
		addStatement:
			(SMethodStatement new
				receiverVarName: '(SFoo score: 4.5)';
				selector: #returnCollection;
				returnTypeName: #OrderedCollection;
				args: #());
		addStatement:
			(SMethodStatement new
				receiverVarName: '(SFoo new)';
				selector: #returnFloat;
				returnTypeName: #SmallFloat64;
				args: #());
		addStatement:
			(SMethodStatement new
				receiverVarName: '(SSTeacher new)';
				selector: #id;
				returnTypeName: #UndefinedObject;
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
			'_ordCol4 := (SFoo score: 4.5) returnCollection.'.
			'_smaFlo5 := (SFoo new) returnFloat.'.
			'_var6 := (SSTeacher new) id.'}
]

{ #category : #tests }
SRenamerVariableTest >> testRenameVarNamesPrimitiveStatement [
	| testCase |
	testCase := STestCase new
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: #SmallInteger;
				value: 45);
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: #ByteString;
				value: 'hello');
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: #Character;
				value: $f);
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: #Array;
				value: {4 . 6 . 7 . 1});
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: #True;
				value: true);
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: #UndefinedObject;
				value: nil);
		yourself.
	renamer applyOn: testCase.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_smaInt0 := 45.' . '_bytStr1 := ''hello''.' . '_character2 := $f.'.
			'_array3 := #(4 6 7 1 ).' . '_true4 := true.' . '_var5 := nil.'}
]
