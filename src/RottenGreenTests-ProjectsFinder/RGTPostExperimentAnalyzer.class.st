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

{ #category : #'as yet unclassified' }
RGTPostExperimentAnalyzer >> generateProjectMetadataFileForAllProjects [
	self generateSummaryFileNamed: 'all-projects-meta.csv' forFilesNamed: 'project-meta.csv' withCSVHeader: #('Project'
			'# Package'
			'# Classes'
			'# Test classes')
]

{ #category : #'as yet unclassified' }
RGTPostExperimentAnalyzer >> generateRottenHelpersCallsFileForAllProjects [
	self generateSummaryFileNamed: 'all-rotten-helpers-calls.csv' forFilesNamed: 'rotten-helpers-calls.csv' withCSVHeader: #('Project'
			'Helper called'
			'Helper called definition level'
			'Holding method')
]

{ #category : #'as yet unclassified' }
RGTPostExperimentAnalyzer >> generateRottenHelpersFileForAllProjects [
	self generateSummaryFileNamed: 'all-rotten-helpers.csv' forFilesNamed: 'rotten-helpers.csv' withCSVHeader: #('Project'
			'Package'
			'Method'
			'Max helper depth'
			'Primitives calls in test count'
			'All primitives calls involved in execution count'
			'Not-executed #assert: getting false literal as parameter'
			'Helpers calls in test count'
			'All helpers calls involved in execution count'
			'Test contains return'
			'Context dependent rotten assert count'
			'Is rotten'
			'Test case depth')
]

{ #category : #'as yet unclassified' }
RGTPostExperimentAnalyzer >> generateRottenTestsFileForAllProjects [
	self generateSummaryFileNamed: 'all-rotten-tests.csv' forFilesNamed: 'rotten-tests.csv' withCSVHeader: #('Project'
			'Package'
			'Method'
			'Max helper depth'
			'Primitives calls in test count'
			'All primitives calls involved in execution count'
			'Not-executed #assert: getting false literal as parameter'
			'Helpers calls in test count'
			'All helpers calls involved in execution count'
			'Test contains return'
			'Context dependent rotten assert count'
			'Is rotten'
			'Test case depth')
]

{ #category : #'as yet unclassified' }
RGTPostExperimentAnalyzer >> generateSummaryFileNamed: outputFileName forFilesNamed: inputDataFileName withCSVHeader: csvHeader [
	| csvData |
	csvData := OrderedCollection new.
	self folderWithResults do: [ :folderWithResults |
		folderWithResults / inputDataFileName readStreamDo: [ :readStream |
			(NeoCSVReader on: readStream)
				skipHeader;
				do: [ :row |
					csvData add: { folderWithResults basename } , row ] ] ] displayingProgress: 'Collecting data from folders...'.
	
	self resultsDirectory / outputFileName writeStreamDo: [ :writeStream |
		(NeoCSVWriter on: writeStream)
			nextPut: csvHeader;
			nextPutAll: csvData ]
]

{ #category : #accessing }
RGTPostExperimentAnalyzer >> resultsDirectory [
	^ resultsDirectory
]

{ #category : #accessing }
RGTPostExperimentAnalyzer >> resultsDirectory: anObject [
	resultsDirectory := anObject asFileReference
]
