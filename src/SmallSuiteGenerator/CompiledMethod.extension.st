Extension { #name : #CompiledMethod }

{ #category : #'*SmallSuiteGenerator' }
CompiledMethod >> fullClassName [
	^ self origin name
]

{ #category : #'*SmallSuiteGenerator' }
CompiledMethod >> mclass [
	^ self origin
]
