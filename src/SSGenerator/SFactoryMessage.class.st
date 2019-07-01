Class {
	#name : #SFactoryMessage,
	#superclass : #SAbstractMessage,
	#category : #SSGenerator
}

{ #category : #accessing }
SFactoryMessage class >> default: aClass [
	^ self new
		receiver:
			(SVariable new
				nameVar: aClass name;
				returnType: aClass name;
				yourself);
		selector: #new;
		returnType: aClass name;
		yourself
]

{ #category : #creation }
SFactoryMessage class >> method: aMethodTypeInfo previousStatements: statements [
	^ self new
	receiver: (SVariable new
				nameVar: aMethodTypeInfo returnType;
				returnType: aMethodTypeInfo returnType;
				yourself);
		returnType: aMethodTypeInfo returnType;
		selector: aMethodTypeInfo selector;
		args: (self args: aMethodTypeInfo with: statements);
		yourself
]
