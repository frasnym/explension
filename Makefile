generate-model:
	flutter packages pub run build_runner build

run-on-chrome:
	flutter run -d chrome

generate-launcher-icons:
	flutter pub run flutter_launcher_icons

appbundle:
	flutter build appbundle --no-tree-shake-icons

.PHONY: generate-model run-on-chrome generate-launcher-icons appbundle