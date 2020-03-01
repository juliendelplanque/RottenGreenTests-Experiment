Class {
	#name : #RGTAnalyzePostAnalysisCSV,
	#superclass : #Object,
	#instVars : [
		'csvFile'
	],
	#category : #'RottenGreenTests-ProjectsFinder'
}

{ #category : #private }
RGTAnalyzePostAnalysisCSV >> analyze [
	^ self extractProjectNameToCategoriesCount
		inject: #((0 0) (0 0) (0 0) (0 0)) into: [ :result :projectData |
			result + {
				{ projectData second . projectData second = 0 ifTrue: [ 0 ] ifFalse: [ 1 ]}.
				{ projectData third . projectData third = 0 ifTrue: [ 0 ] ifFalse: [ 1 ]}.
				{ projectData fourth . projectData fourth = 0 ifTrue: [ 0 ] ifFalse: [ 1 ]}.
				{ projectData fifth . projectData fifth = 0 ifTrue: [ 0 ] ifFalse: [ 1 ]}.
			 } ]
]

{ #category : #accessing }
RGTAnalyzePostAnalysisCSV >> csvFile [
	^ csvFile
]

{ #category : #accessing }
RGTAnalyzePostAnalysisCSV >> csvFile: anObject [
	csvFile := anObject asFileReference
]

{ #category : #private }
RGTAnalyzePostAnalysisCSV >> extractProjectNameToCategoriesCount [
	^ self csvFile readStreamDo: [ :readStream |
		((NeoCSVReader on: readStream)
			addField;
			addField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			addIntegerField;
			skipHeader;
			upToEnd) collect: [ :array |
				{ array first } , (array last: 4) ] ]
]
