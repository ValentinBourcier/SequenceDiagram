Class {
	#name : #BaselineOfSequenceDiagram,
	#superclass : #BaselineOf,
	#category : #BaselineOfSequenceDiagram
}

{ #category : #baselines }
BaselineOfSequenceDiagram >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec
			package: 'SequenceDiagram';
			package: 'SequenceDiagram-Tests'
			with: [ spec requires: 'SequenceDiagram' ] ]
]
