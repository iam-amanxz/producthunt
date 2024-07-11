watch:
	dart run build_runner watch --delete-conflicting-outputs

feature:
	mkdir -p lib/features/$(feature)/data/datasources
		touch lib/features/$(feature)/data/datasources/$(feature)_local_datasource.dart
		touch lib/features/$(feature)/data/datasources/$(feature)_remote_datasource.dart
	mkdir -p lib/features/$(feature)/data/models
		touch lib/features/$(feature)/data/models/$(feature)_model.dart
	mkdir -p lib/features/$(feature)/data/repositories
		touch lib/features/$(feature)/data/repositories/$(feature)_repository_impl.dart
	mkdir -p lib/features/$(feature)/domain/entities
		touch lib/features/$(feature)/domain/entities/$(feature)_entity.dart
	mkdir -p lib/features/$(feature)/domain/repositories
		touch lib/features/$(feature)/domain/repositories/$(feature)_repository.dart
	mkdir -p lib/features/$(feature)/domain/usecases
	mkdir -p lib/features/$(feature)/presentation/blocs
	mkdir -p lib/features/$(feature)/presentation/pages
	mkdir -p lib/features/$(feature)/presentation/widgets

icon:
	flutter pub run flutter_launcher_icons

release:
	flutter build apk --release
	flutter devices
	adb install build/app/outputs/flutter-apk/app-release.apk

.PHONY: watch feature