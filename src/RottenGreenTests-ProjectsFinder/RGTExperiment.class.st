Class {
	#name : #RGTExperiment,
	#superclass : #Object,
	#category : #'RottenGreenTests-ProjectsFinder'
}

{ #category : #accessing }
RGTExperiment class >> notAnalysableBecauseTravisInvalid [
	"This method returns the name of the projects that can not be analysed because their travis config does not provide a specific pharo version or they do not run in Pharo."
	^ #('Cruiser' 'filetree' 'hermes' 'phanide' 'pharo-talents' 'PharoCompatibility' 'Scale' 'st-st')
]

{ #category : #cloning }
RGTExperiment >> cloneGitRepositories [
	self selectAllProjectsWithBaselineAndTravisConfig
		do: [ :p | 
			| shellCmd |
			shellCmd := 'cd ''{1}''; git clone ''{2}'''
				format:
					{self projectsClonesDirectory.
					p sshUrl pathString}.
			LibC uniqueInstance system: shellCmd ]
		displayingProgress: 'Cloning projects to analyse.'
]

{ #category : #'information retrieval' }
RGTExperiment >> extractMajorVersionForProject [
	^ self projectsClonesDirectory children iterator
		| #isDirectory selectIt
		| [ :fileRef | self class notAnalysableBecauseTravisInvalid includes: fileRef basename ] rejectIt
		| [ :fileRef | 
			|majorVersion plateform architecture|
			majorVersion := fileRef / '_rotten_versions.csv' readStreamDo: [ :stream |
				(((NeoCSVReader on: stream)
					skipHeader;
					upToEnd) sort: [ :array | (array second splitOn: $.) first asInteger ] asSortFunction , [ :array | (array second splitOn: $.) second asInteger ] asSortFunction) first ].
			plateform := (majorVersion first matchesRegex: '.+\d\d')
								ifTrue: [ majorVersion first allButLast: 2 ]
								ifFalse: [ majorVersion first ].
			architecture := (majorVersion first endsWith: '32')
									ifTrue: [ '32' ]
									ifFalse: [ '64' ].
			fileRef / '_rotten_major_version.csv' writeStreamDo: [ :writeStream |
				(NeoCSVWriter on: writeStream)
					nextPut: #('Plateform' 'Architecture' 'Pharo version');
					nextPut: { plateform . architecture . majorVersion second reject: [ :c | c = $. ] } ] ] doIt
		> NullAddableObject
		
]

{ #category : #'information retrieval' }
RGTExperiment >> extractPharoVersionsFromTravisConfigFiles [
	"Extract informations related to Pharo version in which the project run and stores them in the directory of the project
	 in _rotten_versions.csv file."
	self projectsClonesDirectory children iterator
		| #isDirectory selectIt
		| [ :fileRef | fileRef / '.travis.yml' ] collectIt
		| [ :travisFile | |versionStrings|
			versionStrings := travisFile contents allRegexMatches: '(Pharo|Moose)\d?\d?\-\d\.\d'.
			versionStrings := versionStrings collect: [ :versionString | (versionString splitOn: $-) collect: #trimmed thenReject: #isEmpty ].
			travisFile parent / '_rotten_versions.csv' writeStreamDo: [ :writeStream |
				(NeoCSVWriter on: writeStream)
					nextPut: #('Architecture' 'Pharo version');
					nextPutAll: versionStrings ]
			] doIt
		> NullAddableObject
]

{ #category : #accessing }
RGTExperiment >> projectsCSVFromGithubQueryFile [
	^ '/Users/julien/Documents/GIT/Papers/2019-tse-rottentests/Experiment/Pharo/projects.csv'
		asFileReference
]

{ #category : #accessing }
RGTExperiment >> projectsClonesDirectory [
	^ '/Users/julien/Documents/GIT/Papers/2019-tse-rottentests/Experiment/Pharo/_projects' asFileReference
]

{ #category : #'project selection' }
RGTExperiment >> selectAllProjectsWithBaselineAndTravisConfig [
	^ self projectsCSVFromGithubQueryFile
		readStreamDo: [ :stream | 
			| toProcess |
			toProcess := ((NeoCSVReader on: stream)
				separator: $;;
				skipHeader;
				upToEnd)
				reject: [ :array | RGTProject blacklist includes: array fourth ]
				thenCollect: [ :array | 
					| tokens |
					tokens := array fourth splitOn: $/.
					RGTProject username: tokens first projectName: tokens second ].
			toProcess
				select: [ :project | 
					project tryToRetrieveBaselinePath.
					project hasBaselinePath and: [ project hasTravisConfig ] ] ]
]
