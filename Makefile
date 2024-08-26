.PHONY: generate-model run-on-chrome

generate-model:
	flutter packages pub run build_runner build

run-on-chrome:
	flutter run -d chrome