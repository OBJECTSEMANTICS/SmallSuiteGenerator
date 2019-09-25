Class {
	#name : #STypeMethodInfo,
	#superclass : #STypeObjectInfo,
	#instVars : [
		'selector',
		'returnType',
		'argTypes',
		'isQuick',
		'isDeprecated',
		'receiver'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #'as yet unclassified' }
STypeMethodInfo class >> selectorsFilter [
	^ (self selectors
		select: [ :aSelector | aSelector beginsWith: 'isSimpleTyped' ])
		
]

{ #category : #'accessing structure variables' }
STypeMethodInfo class >> type: aAssoc [
	| aValue |
	aValue := aAssoc value.
	^ self new
		selector: aAssoc key;
		receiver: (SMultiTypeInfo new: aValue first);
		returnType: (SMultiTypeInfo new: aValue second);
		argTypes: (aValue third collect: [ :aType | SMultiTypeInfo new: aType ]);
		isQuick: aValue fourth";
		isDeprecated: aValue fifth"
]

{ #category : #adding }
STypeMethodInfo >> addType: aType [
	argTypes do: [ :arg | arg type: aType ].
	returnType type: aType
]

{ #category : #'as yet unclassified' }
STypeMethodInfo >> allArgTypes [
	argTypes ifNil: [ ^ #() ].
	^ argTypes flatCollect: [ :arg | arg types ]
]

{ #category : #'as yet unclassified' }
STypeMethodInfo >> allReceivers [
	^ receiver types
]

{ #category : #accessing }
STypeMethodInfo >> argTypes [
	^ argTypes
]

{ #category : #accessing }
STypeMethodInfo >> argTypes: anObject [
	argTypes := anObject
]

{ #category : #copying }
STypeMethodInfo >> copy [
	| copy |
	copy := self class instance.
	copy
		selector: selector;
		
		isQuick: isQuick;
		isDeprecated: isDeprecated;
		returnType: returnType copy;
		argTypes: argTypes copy;
		receiver: receiver copy.
	^ copy
]

{ #category : #'as yet unclassified' }
STypeMethodInfo >> dataCSV [
	^ Array with: selector
		withAll: (OrderedCollection new add: receiver types asArray;
		add: receiver commonSuperclass;
		add:
			(argTypes
				ifNil: [ #() ]
				ifNotNil: [ (argTypes collect: [ :argType | argType types asArray ]) asArray ]);
		add: (argTypes ifNil: [''] ifNotNil: [argTypes collect: [:argType | argType commonSuperclass]]);
		add: returnType types asArray;
		add: returnType commonSuperclass; yourself)
]

{ #category : #initialization }
STypeMethodInfo >> initialize [
	argTypes := #().
	isQuick := false.
	returnType := SMultiTypeInfo new.
	receiver := SMultiTypeInfo new.
	isDeprecated := false
]

{ #category : #accessing }
STypeMethodInfo >> isDeprecated [
	^ isDeprecated
]

{ #category : #accessing }
STypeMethodInfo >> isDeprecated: anObject [
	isDeprecated := anObject
]

{ #category : #testing }
STypeMethodInfo >> isFromReceiver: aClassName [
	^ receiver types includes: aClassName
]

{ #category : #accessing }
STypeMethodInfo >> isQuick [
	^ isQuick
]

{ #category : #accessing }
STypeMethodInfo >> isQuick: aBoolean [
	isQuick := aBoolean
]

{ #category : #metrics }
STypeMethodInfo >> isSimpleTyped [
	"
	- one type of receiver only one type for each argument
	"

	^ (Array with: receiver hasOnlyOneType
	with: returnType hasOnlyOneType
	with: (argTypes isNil or: [ argTypes allSatisfy: #hasOnlyOneType ]))
		allSatisfy: #yourself
]

{ #category : #metrics }
STypeMethodInfo >> isSimpleTyped10 [
	"
	
	"

	^ (Array
		with: receiver hasOnlyOneType
		with:
			(returnType hasOnlyOneType not
				and: [ returnType commonSuperclass = 'Object' ])
		with:
			(argTypes notNil
				and: [ argTypes anySatisfy: [ :t | t hasOnlyOneType not ] ])
		with:
			(argTypes notNil
				and: [ argTypes
						allSatisfy: [ :t | 
							t hasOnlyOneType
								or: [ t isBlockSymbol not and: [ t commonSuperclass = 'Object' ] ] ] ]))
		allSatisfy: #yourself
]

{ #category : #metrics }
STypeMethodInfo >> isSimpleTyped11 [
	"
	
	"

	^ (Array
		with: receiver hasOnlyOneType not
		with:
			returnType hasOnlyOneType not
		with: (argTypes isNil or: [ argTypes allSatisfy: #hasOnlyOneType ])
		with: (receiver equals: returnType ) not)
		allSatisfy: #yourself
]

{ #category : #metrics }
STypeMethodInfo >> isSimpleTyped12 [
	"
	
	"

	^ (Array
		with: (receiver hasOnlyOneType not and: [ receiver commonSuperclass ~= 'Object' ])
		with: returnType hasOnlyOneType not
		with:
			(argTypes notNil
				and: [ argTypes anySatisfy: [ :t | t hasOnlyOneType not ] ])
		with:
			(argTypes notNil
				and: [ argTypes
						allSatisfy: [ :t | 
							t hasOnlyOneType
								or: [ t isBlockSymbol not and: [ t commonSuperclass = 'Object' ] ] ] ]))
		allSatisfy: #yourself
]

{ #category : #metrics }
STypeMethodInfo >> isSimpleTyped2 [
	"
	- this guy return the type that he receive 
	"

	^ (Array with: receiver hasOnlyOneType not
	with: returnType hasOnlyOneType not
	with: (receiver equals: returnType)
	with: (argTypes isNil or: [ argTypes allSatisfy: #hasOnlyOneType ]))
		allSatisfy: #yourself
]

{ #category : #metrics }
STypeMethodInfo >> isSimpleTyped3 [
	"
	- this guy return the type that he receive 
	"

	^ (Array with: receiver hasOnlyOneType not
	with: (receiver commonSuperclass ~= 'Object')
	with: returnType hasOnlyOneType
	with: (argTypes isNil or: [ argTypes allSatisfy: #hasOnlyOneType ]))
		allSatisfy: #yourself
]

{ #category : #metrics }
STypeMethodInfo >> isSimpleTyped4 [
	"
	
	"

	^ (Array with: receiver hasOnlyOneType
	with: returnType hasOnlyOneType
	with: (argTypes notNil
		and: [ argTypes anySatisfy: [ :t | t hasOnlyOneType not ] ])
	with: (argTypes notNil
		and: [ argTypes
				allSatisfy: [ :t | t hasOnlyOneType or: [ t isBlockSymbol ] ] ]))
		allSatisfy: #yourself
]

{ #category : #metrics }
STypeMethodInfo >> isSimpleTyped5 [
	"
	
	"

	^ (Array
		with: receiver hasOnlyOneType
		with: returnType hasOnlyOneType
		with:
			(argTypes notNil
				and: [ argTypes anySatisfy: [ :t | t hasOnlyOneType not ] ])
		with:
			(argTypes notNil
				and: [ argTypes
						allSatisfy: [ :t | 
							t hasOnlyOneType
								or: [ t isBlockSymbol not and: [ t commonSuperclass = 'Object' ] ] ] ]))
		allSatisfy: #yourself
]

{ #category : #metrics }
STypeMethodInfo >> isSimpleTyped6 [
	"
	
	"

	^ (Array
		with: receiver hasOnlyOneType
		with: returnType hasOnlyOneType
		with:
			(argTypes notNil
				and: [ argTypes anySatisfy: [ :t | t hasOnlyOneType not ] ])
		with:
			(argTypes notNil
				and: [ argTypes
						allSatisfy: [ :t | t hasOnlyOneType or: [ t commonSuperclass ~= 'Object' ] ] ]))
		allSatisfy: #yourself
]

{ #category : #metrics }
STypeMethodInfo >> isSimpleTyped7 [
	"
	
	"

	^ (Array
		with: receiver hasOnlyOneType
		with:
			(returnType hasOnlyOneType not
				and: [ returnType commonSuperclass = 'Object' ])
		with: (argTypes isNil or: [ argTypes allSatisfy: #hasOnlyOneType ]))
		allSatisfy: #yourself
]

{ #category : #metrics }
STypeMethodInfo >> isSimpleTyped8 [
	"
	
	"

	^ (Array
		with: receiver hasOnlyOneType
		with:
			(returnType hasOnlyOneType not
				and: [ returnType commonSuperclass ~= 'Object' ])
		with: (argTypes isNil or: [ argTypes allSatisfy: #hasOnlyOneType ]))
		allSatisfy: #yourself
]

{ #category : #metrics }
STypeMethodInfo >> isSimpleTyped9 [
	"
	
	"

	^ (Array
		with:
			(receiver hasOnlyOneType not
				and: [ receiver commonSuperclass ~= 'Object' ])
		with:
			(returnType hasOnlyOneType not
				and: [ returnType commonSuperclass ~= 'Object' ])
		with:
			(argTypes notNil
				and: [ argTypes anySatisfy: [ :t | t hasOnlyOneType not ] ])
		with:
			(argTypes notNil
				and: [ argTypes
						allSatisfy: [ :t | t hasOnlyOneType or: [ t commonSuperclass ~= 'Object' ] ] ]))
		allSatisfy: #yourself
]

{ #category : #testing }
STypeMethodInfo >> isWithReturnType: aClassName [
	^ returnType types includes: aClassName
]

{ #category : #'as yet unclassified' }
STypeMethodInfo >> joinWith: otherTypeMethod [
	argTypes ifNotNil: [argTypes
		with: otherTypeMethod argTypes
		do: [ :argType :otherArgType | argType joinWith: otherArgType ].  ].
	
	returnType joinWith: otherTypeMethod returnType
]

{ #category : #accessing }
STypeMethodInfo >> receiver [
	^ receiver
]

{ #category : #accessing }
STypeMethodInfo >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
STypeMethodInfo >> returnType [
	^ returnType
]

{ #category : #accessing }
STypeMethodInfo >> returnType: anObject [
	returnType := anObject
]

{ #category : #accessing }
STypeMethodInfo >> selector [
	^ selector
]

{ #category : #accessing }
STypeMethodInfo >> selector: anObject [
	selector := anObject
]
