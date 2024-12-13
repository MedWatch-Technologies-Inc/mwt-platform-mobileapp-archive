# Health Gauge

Health Gauge Summary

## Prerequisites

The following are the dependencies needed on the system to execute the code

* Android Studio / Intellij idea / Vs Code
* Xcode
* Flutter 2.2.0 or above

## Documentation [WIP]

You can generate documentation for the project by  running following command locally in the root of the project repository.

## Flutter commands

A small script ***project.sh*** has been made using the following commands:

1. Project initialisation

		flutter clean && flutter pub get
		
2. Flutter generate Json and Retrofit files

	1. Just building the generated files once

			flutter pub run build_runner build --delete-conflicting-outputs

	2. Generating and modifying the files simultaneously

			flutter pub run build_runner watch --delete-conflicting-outputs


## Changelog
You can refer to the following document for changelog: [Changelog.md](documentations/markdown/Changelog.md)