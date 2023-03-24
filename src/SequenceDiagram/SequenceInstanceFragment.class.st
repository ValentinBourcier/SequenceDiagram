Class {
	#name : #SequenceInstanceFragment,
	#superclass : #SequenceFragment,
	#instVars : [
		'instances'
	],
	#category : #SequenceDiagram
}

{ #category : #accessing }
SequenceInstanceFragment >> instances [

	^ instances
]

{ #category : #accessing }
SequenceInstanceFragment >> instances: anObject [

	instances := anObject
]

{ #category : #rendering }
SequenceInstanceFragment >> renderIn: aSequenceDiagram [
	aSequenceDiagram renderInstanceFragment: self 
]
