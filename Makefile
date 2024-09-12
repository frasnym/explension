model:
	flutter packages pub run build_runner build

launcher-icons:
	flutter pub run flutter_launcher_icons

appbundle:
	flutter build appbundle --no-tree-shake-icons

debug-symbols:
	cd /Users/nyomanfrastyawan/Documents/dev/explension/explension/build/app/intermediates/merged_native_libs/release/out/lib/ && zip -r Archive.zip .
	mv /Users/nyomanfrastyawan/Documents/dev/explension/explension/build/app/intermediates/merged_native_libs/release/out/lib/Archive.zip /Users/nyomanfrastyawan/Documents/dev/explension/explension

run-on-chrome:
	flutter run -d chrome

.PHONY: model launcher-icons appbundle run-on-chrome