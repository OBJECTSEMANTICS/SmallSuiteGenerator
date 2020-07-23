Extension { #name : #RBMessageNode }

{ #category : #'*SmallSuiteGenerator' }
RBMessageNode >> accept: aProgramNodeVisitor [
	^ aProgramNodeVisitor visitMessageNode: self
]
