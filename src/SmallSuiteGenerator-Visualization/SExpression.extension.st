Extension { #name : #SExpression }

{ #category : #'*SmallSuiteGenerator-Visualization' }
SExpression >> mutantColor [
  ^ self mutated ifTrue: [ Color r: 0.9726295210166178 g: 0.0 b: 0.0
	"Color r: 0.7038123167155426 g: 0.3841642228739003 b: 0.4310850439882698" "Color r: 0.40762463343108507 g: 0.0039100684261974585 b: 0.20234604105571846" ] ifFalse: [ Color gray ]
]

{ #category : #'*SmallSuiteGenerator-Visualization' }
SExpression >> stmColor [
  
]
