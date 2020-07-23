Extension { #name : #RBSequenceNode }

{ #category : #'*SmallSuiteGenerator' }
RBSequenceNode >> accept: aProgramNodeVisitor [
	^ aProgramNodeVisitor visitSequenceNode: self
]
