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
RGTExperiment >> extractBaselineFromSmalltalkCIConfigFiles [
	self projectsClonesDirectory children iterator
		| #isDirectory selectIt
		| [ :fileRef | 
			fileRef basename = 'GraceInPharo'
				ifTrue: [ fileRef / '.smalltalk.Unit.ston' ]
				ifFalse: [ fileRef / '.smalltalk.ston' ] ] collectIt
		| #exists selectIt
		| [ :smalltalkCIFile | |baselineMatches|
			baselineMatches := smalltalkCIFile contents allRegexMatches: '\#baseline\s*\:\s*[^,]+'.
			baselineMatches := baselineMatches collect: [ :matchString | { (matchString splitOn: $') second } ].
			smalltalkCIFile parent / '_rotten_baselines.csv' writeStreamDo: [ :writeStream |
				(NeoCSVWriter on: writeStream)
					nextPut: #('Baseline');
					nextPutAll: baselineMatches ]
			] doIt
		> NullAddableObject
]

{ #category : #'information retrieval' }
RGTExperiment >> extractMajorVersionForProject [
	^ self projectsClonesDirectory children iterator
		| #isDirectory selectIt
		| [ :fileRef | self class notAnalysableBecauseTravisInvalid includes: fileRef basename ] rejectIt
		| [ :fileRef | 
			|majorVersion plateform architecture pharo_version|
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
			pharo_version := majorVersion second .
			fileRef / '_rotten_major_version.csv' writeStreamDo: [ :writeStream |
				(NeoCSVWriter on: writeStream)
					nextPut: #('Plateform' 'Architecture' 'Pharo version' );
					nextPut: { plateform . architecture . pharo_version } ] ] doIt
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

{ #category : #'as yet unclassified' }
RGTExperiment >> generateImagesAndVMDownloadScript [
	self rootDirectoryForImages directories
		do: [ :directory | 
			| metadataRaw |
			metadataRaw := self projectsClonesDirectory / directory basename
				/ '_rotten_major_version.csv'
				readStreamDo: [ :readStream | 
					(NeoCSVReader on: readStream)
						skipHeader;
						next ].
			directory / 'download.sh'
				writeStreamDo: [ :writeStream | 
					writeStream
						nextPutAll:
							((self generateShellScriptToBuildImageFrom: metadataRaw) lines
								joinUsing: String lf) ].
			directory / 'rtf_install.st'
				writeStreamDo: [ :writeStream | 
					writeStream
						nextPutAll: 'Metacello new
	repository: ''github://juliendelplanque/RottenTestsFinder:v1.5.0/src'';
	baseline: ''RottenTestsFinder'';
	onConflictUseIncoming;
	load.' ] ]
]

{ #category : #'as yet unclassified' }
RGTExperiment >> generateImagesDirectories [
	self projectsClonesDirectories do: [ :directory |
		(self rootDirectoryForImages / directory basename) ensureCreateDirectory ]
]

{ #category : #'as yet unclassified' }
RGTExperiment >> generateShellScriptToBuildImageFrom: metadataRaw [
	^ '#!/usr/bin/env bash

# Set sane environment for bash scripts. ---------------------------------------
set -e
set -o pipefail
set -C
set -u

curl https://get.pharo.org/{architecture}/{image_version}+vm | bash'
		format:
			{('image_version' -> (metadataRaw third copyWithout: $.)).
			('architecture' -> metadataRaw second).
			('vm_version' -> ('vm' , metadataRaw third))} asDictionary
]

{ #category : #accessing }
RGTExperiment >> projectsCSVFromGithubQueryFile [
	^ '/Users/julien/Documents/GIT/Papers/2019-tse-rottentests/Experiment/Pharo/projects.csv'
		asFileReference
]

{ #category : #'as yet unclassified' }
RGTExperiment >> projectsClonesDirectories [
	^ self projectsClonesDirectory directories reject: [ :d | self class notAnalysableBecauseTravisInvalid includes: d basename ]
]

{ #category : #accessing }
RGTExperiment >> projectsClonesDirectory [
	^ '/Users/julien/Documents/GIT/Papers/2019-tse-rottentests/Experiment/Pharo/_projects' asFileReference
]

{ #category : #accessing }
RGTExperiment >> rootDirectoryForImages [
	^ '/Users/julien/Documents/GIT/Papers/2019-tse-rottentests/Experiment/Pharo/_pharo_images'
		asFileReference
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
