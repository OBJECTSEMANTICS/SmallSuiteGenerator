Extension { #name : #Pharo2VWClassNameMapper }

{ #category : #'*SmallSuiteGenerator-Exporter' }
Pharo2VWClassNameMapper >> classNameMapping [
	 ^classNameMapping ifNil: [ classNameMapping := {(TestCase -> ('Smalltalk.SUnit' -> 'TestCase')) . 
        (Object -> ('Core' -> 'Object')) . 
        (TBehavior -> ('Core' -> 'Behavior')) . 
        (Color -> ('Core' -> 'ColorValue')) . 
        (RBProgramNodeVisitor -> ('Refactory.Browser' -> 'RBProgramNodeVisitor')) . 
        (SObject -> ('SmallSuiteGenerator' -> 'SObject')) . 
        (SSPerson -> ('SmallSuiteGenerator' -> 'SSPerson')) . 
        (SmallFloat64 -> ('Core' -> 'Float')) . 
        (Random -> ('Core' -> 'MinimumStandardRandom'))} asDictionary ]
]
