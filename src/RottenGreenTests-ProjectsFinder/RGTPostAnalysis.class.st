Class {
	#name : #RGTPostAnalysis,
	#superclass : #Object,
	#category : #'RottenGreenTests-ProjectsFinder'
}

{ #category : #parsing }
RGTPostAnalysis >> parseResultsIn: aDirectory [
	^ (aDirectory childrenMatching: '*-rotten-tests.csv') reject: [ :f | f basename beginsWith: 'all' ] thenCollect: [ :csvFile |
		|expName expData|
		expName := csvFile basename allButLast: '-rotten-tests.csv' size.
		expData := RTGExperimentData new
						name: expName;
						yourself.
		expData
			parseTestsDataIn: csvFile;
			parseHelpersDataIn: aDirectory / (expName , '-rotten-helpers.csv');
			parseHelperCallsDataIn: aDirectory / (expName , '-rotten-helpers-calls.csv');
			parseProjectIn: (aDirectory / 'all-projects-meta.csv') ]
]

{ #category : #analysis }
RGTPostAnalysis >> postAnalysisOfDirectory: aDirectory [
	| results |
	results := (self parseResultsIn: aDirectory) sort: [ :a :b | a name < b name ].
	(aDirectory / 'post-analysis.csv')
		ensureDelete;
		writeStreamDo: [ :s |
			(NeoCSVWriter on: s)
				nextPut: RTGExperimentData headerArrayForCSVExport;
				nextPutAll: (results collect: #asArrayForCSVExport) ]
]
