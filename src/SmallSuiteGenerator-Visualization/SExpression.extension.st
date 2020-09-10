Extension { #name : #SExpression }

{ #category : #'*SmallSuiteGenerator-Visualization' }
SExpression >> mutantColor [
   ^ self mutated 
		ifTrue: [ Color r: 0.9726295210166178 g: 0.0 b: 0.0 ] 
		ifFalse: [ Color gray ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SExpression >> stmColor [
  
]
