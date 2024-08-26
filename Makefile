.PHONY: generate-model run-on-chrome generate-launcher-icons

generate-model:
	flutter packages pub run build_runner build

run-on-chrome:
	flutter run -d chrome

generate-launcher-icons:
	flutter pub run flutter_launcher_icons