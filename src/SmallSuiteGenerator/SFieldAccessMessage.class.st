"
SFieldAccessMessage is a node which represents method calls that return an instance variable of a class.

For example: 
	1.	
		_var1 x.
	
		_var1 -> Receiver which points to Point's factoryMessage.
		#x -> selector of the method
"
Class {
	#name : #SFieldAccessMessage,
	#superclass : #SAbstractMessage,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'instance creation' }
SFieldAccessMessage class >> newFromReceiver: aReceiver andMethod: aMethod [
	^ SFieldAccessMessage new
		returnType: aMethod returnType type;
		selector: aMethod selector;
		receiver: aReceiver;
		yourself 
]

{ #category : #visitor }
SFieldAccessMessage >> accept: aSSVisitor [
	^ aSSVisitor visitFieldAccessMessage: self.
]

{ #category : #actions }
SFieldAccessMessage >> changeOn: aTestCase [
	aTestCase addAlternativeFieldAccessMessage: self.
]

{ #category : #actions }
SFieldAccessMessage >> insertOn: aTestCase [
	^ aTestCase addFieldAccessMessage: self selector from: self receiver returnType.
]

{ #category : #'as yet unclassified' }
SFieldAccessMessage >> stmColor [
  ^ Color r: 1.0 g: 0.20039100684261973 b: 0.6001955034213099
"Color r: 1.0 g: 0.12512218963831867 b: 0.4780058651026393"
"Color r: 0.7595307917888563 g: 0.17497556207233628 b: 0.7380254154447703"
"Color r: 0.40762463343108507 g: 0.0039100684261974585 b: 0.20234604105571846"
]
