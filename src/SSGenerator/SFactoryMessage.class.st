Class {
	#name : #SFactoryMessage,
	#superclass : #SAbstractMessage,
	#category : #'SSGenerator-Nodes'
}

{ #category : #accessing }
SFactoryMessage class >> default: aClass [
	^ self new
		receiver:
			(SVariable new
				varName: aClass name;
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
				varName: aMethodTypeInfo returnType;
				returnType: aMethodTypeInfo returnType;
				yourself);
		returnType: aMethodTypeInfo returnType;
		selector: aMethodTypeInfo selector;
		args: (self args: aMethodTypeInfo with: statements);
		yourself
]

{ #category : #'as yet unclassified' }
SFactoryMessage >> insertRandomMessageWith: aTestCase [
	^ (aTestCase addFactoryMessage: (Smalltalk at: self returnType)) variable
]

{ #category : #testing }
SFactoryMessage >> isFactoryMessage [
	^ true
]
