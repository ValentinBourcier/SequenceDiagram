Class {
	#name : #SequenceMessageFragment,
	#superclass : #SequenceFragment,
	#instVars : [
		'from',
		'to'
	],
	#category : #SequenceDiagram
}

{ #category : #accessing }
SequenceMessageFragment >> from [

	^ from
]

{ #category : #accessing }
SequenceMessageFragment >> from: anObject [

	from := anObject
]

{ #category : #rendering }
SequenceMessageFragment >> renderIn: aSequenceDiagram [
	"aSequenceDiagram renderMessageFragment: self"
]

{ #category : #accessing }
SequenceMessageFragment >> to [

	^ to
]

{ #category : #accessing }
SequenceMessageFragment >> to: anObject [

	to := anObject
]
