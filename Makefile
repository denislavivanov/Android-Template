all: link compile sign clean

SDK_VERSION = 23
API_DIR = '$(ANDROID_SDK_ROOT)/platforms/android-$(SDK_VERSION)/android.jar'

compile:
	@javac -encoding utf8 -cp .:src:$(API_DIR) src/*.java
	@d8 --lib $(API_DIR) src/*.class
	@zip -ur bin/output.apk classes.dex

link:
	@aapt2 compile --dir res/ -o bin/
	@aapt2 link -o bin/output.apk -I $(API_DIR) bin/*.flat --java . --manifest AndroidManifest.xml

sign:
	@apksigner sign --ks store.keystore --ks-pass pass:test1234 bin/output.apk

adb:
	@adb start-server

install:
	@adb -s <device-id> install -r bin/output.apk

clean:
	rm bin/*.flat bin/*.idsig src/*.class