Class {
	#name : #RGTAnalyzePostAnalysisHelpersCSV,
	#superclass : #Object,
	#instVars : [
		'csvFile'
	],
	#category : #'RottenGreenTests-ProjectsFinder'
}

{ #category : #private }
RGTAnalyzePostAnalysisHelpersCSV >> analyze [
	^ (self extractDataPerProject collect: [ :data |
		((data groupedBy: #third) associations collect: [ :assoc |
			assoc key abs -> assoc value size ]) asOrderedDictionary ]) associations collect: [ :assoc |
				|dict newDict|
				dict := assoc value.
				newDict := OrderedDictionary new.
				0 to: 4 do: [ :key |
					newDict at: key put: (dict at: key ifAbsent: [ 0 ]) ].
				assoc key -> newDict ]
]

{ #category : #accessing }
RGTAnalyzePostAnalysisHelpersCSV >> csvFile [
	^ csvFile
]

{ #category : #accessing }
RGTAnalyzePostAnalysisHelpersCSV >> csvFile: anObject [
	csvFile := anObject asFileReference
]

{ #category : #private }
RGTAnalyzePostAnalysisHelpersCSV >> extractDataPerProject [
	^ self csvFile readStreamDo: [ :readStream |
		((NeoCSVReader on: readStream)
			addField;
			addField;
			addIntegerField;
			addField;
			skipHeader;
			upToEnd) groupedBy: #first ]
]
