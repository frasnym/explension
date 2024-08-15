.PHONY: generate-model run-chrome

generate-model:
	flutter packages pub run build_runner build

run-chrome:
	flutter run -d chrome