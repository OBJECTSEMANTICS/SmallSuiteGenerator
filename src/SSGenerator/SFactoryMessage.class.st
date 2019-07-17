Class {
	#name : #SFactoryMessage,
	#superclass : #SAbstractMessage,
	#category : #'SSGenerator-Nodes'
}

{ #category : #accessing }
SFactoryMessage class >> default: aClassName [
	^ self new
		receiver:
			(SVariable new
				varName: aClassName;
				returnType: aClassName;
				yourself);
		selector: #new;
		returnType: aClassName;
		yourself
]

{ #category : #creation }
SFactoryMessage class >> method: aMethodTypeInfo previousStatements: statements [
	^ self new
	receiver: (SVariable new
				varName: aMethodTypeInfo returnType;
				returnType: aMethodTypeInfo returnType;
				yourself);
		returnType: aMethodTypeInfo returnType;
		selector: aMethodTypeInfo selector;
		args: (self args: aMethodTypeInfo with: statements);
		yourself
]

{ #category : #testing }
SFactoryMessage >> isFactoryMessage [
	^ true
]
