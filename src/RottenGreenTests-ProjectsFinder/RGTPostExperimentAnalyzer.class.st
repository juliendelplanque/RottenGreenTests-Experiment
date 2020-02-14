Class {
	#name : #RGTPostExperimentAnalyzer,
	#superclass : #Object,
	#instVars : [
		'experimentFolder',
		'resultsDirectory'
	],
	#category : #'RottenGreenTests-ProjectsFinder'
}

{ #category : #copying }
RGTPostExperimentAnalyzer >> copyAllResultFilesToResultsDirectory [
	self folderWithResults do: [ :folderWithResults |
		folderWithResults / 'rotten-tests.csv' copyTo: self resultsDirectory / (folderWithResults basename , '-rotten-tests.csv').
		folderWithResults / 'rotten-helpers.csv' copyTo: self resultsDirectory / (folderWithResults basename , '-rotten-helpers.csv').
		folderWithResults / 'rotten-helpers-calls.csv' copyTo: self resultsDirectory / (folderWithResults basename , '-rotten-helpers-calls.csv') ] displayingProgress: ('Copying results to {1}' format: { self resultsDirectory pathString })
]

{ #category : #testing }
RGTPostExperimentAnalyzer >> directoryHasResults: directory [
	"Returns true if the directory provided as argument contains results of the experiment.
	 Else returns false.
	"
	^ directory fileNames includesAll: #('rotten-tests.csv' 'rotten-helpers.csv' 'rotten-helpers-calls.csv')
]

{ #category : #accessing }
RGTPostExperimentAnalyzer >> experimentFolder [
	^ experimentFolder
]

{ #category : #accessing }
RGTPostExperimentAnalyzer >> experimentFolder: anObject [
	experimentFolder := anObject asFileReference
]

{ #category : #accessing }
RGTPostExperimentAnalyzer >> folderWithResults [
	^ self experimentFolder directories
		select: [ :d | self directoryHasResults: d ]
]

{ #category : #accessing }
RGTPostExperimentAnalyzer >> folderWithoutResults [
	^ self experimentFolder directories reject: [ :d |
		self directoryHasResults: d ]
]

{ #category : #accessing }
RGTPostExperimentAnalyzer >> resultsDirectory [
	^ resultsDirectory
]

{ #category : #accessing }
RGTPostExperimentAnalyzer >> resultsDirectory: anObject [
	resultsDirectory := anObject asFileReference
]
