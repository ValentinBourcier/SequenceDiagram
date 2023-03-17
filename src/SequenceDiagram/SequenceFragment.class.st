Class {
	#name : #SequenceFragment,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #SequenceDiagram
}

{ #category : #accessing }
SequenceFragment >> name [

	^ name
]

{ #category : #accessing }
SequenceFragment >> name: anObject [

	name := anObject
]

{ #category : #rendering }
SequenceFragment >> renderIn: aSequenceDiagram [
	self subclassResponsibility
]
