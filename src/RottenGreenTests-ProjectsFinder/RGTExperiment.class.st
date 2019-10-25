Class {
	#name : #RGTExperiment,
	#superclass : #Object,
	#category : #'RottenGreenTests-ProjectsFinder'
}

{ #category : #'as yet unclassified' }
RGTExperiment class >> notAnalysableBecauseTravisInvalid [
	^ { '/Users/julien/Documents/GIT/Papers/2019-tse-rottentests/Experiment/Pharo/_projects/Cruiser/_rotten_versions.csv'.
'/Users/julien/Documents/GIT/Papers/2019-tse-rottentests/Experiment/Pharo/_projects/filetree/_rotten_versions.csv'.
 '/Users/julien/Documents/GIT/Papers/2019-tse-rottentests/Experiment/Pharo/_projects/hermes/_rotten_versions.csv'.
'/Users/julien/Documents/GIT/Papers/2019-tse-rottentests/Experiment/Pharo/_projects/phanide/_rotten_versions.csv'.
'/Users/julien/Documents/GIT/Papers/2019-tse-rottentests/Experiment/Pharo/_projects/pharo-talents/_rotten_versions.csv'.
'/Users/julien/Documents/GIT/Papers/2019-tse-rottentests/Experiment/Pharo/_projects/PharoCompatibility/_rotten_versions.csv'.
'/Users/julien/Documents/GIT/Papers/2019-tse-rottentests/Experiment/Pharo/_projects/Scale/_rotten_versions.csv'.
'/Users/julien/Documents/GIT/Papers/2019-tse-rottentests/Experiment/Pharo/_projects/st-st/_rotten_versions.csv'}
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
RGTExperiment >> extractPharoVersionsFromTravisConfigFiles [
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
