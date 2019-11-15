Class {
	#name : #SSTypeCollectorClass,
	#superclass : #S2Class,
	#category : #'SmallSuiteGenerator-Profiler'
}

{ #category : #hooks }
SSTypeCollectorClass class >> spyClassForMethod [
	 ^ SSTypeCollectorMethod
]

{ #category : #converting }
SSTypeCollectorClass >> fillTypesOn: aTypeInfo [
	| aTypeClass instanceMethods classMethods |
	aTypeClass := STypeClassInfo newFrom: self className "and: aTypeInfo".
	instanceMethods := (self methods reject: #isTest)
		select: #wasExecuted.
	classMethods := (self metaclassSpy methods reject: #isTest)
		select:
			[ :clsMethod | clsMethod wasExecuted and: [ clsMethod isValidReturnTypeWithReceiver ] ].
	aTypeClass
		addMethods: (instanceMethods collect: #asTypeInfo);
		addClassMethods: (classMethods collect: #asTypeInfo).
	aTypeInfo addClassInfo: aTypeClass
]
