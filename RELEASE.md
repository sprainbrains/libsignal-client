# Making a libsignal release

## 0. Make sure all CI tests are passing on the latest commit

Check GitHub to see if the latest commit has all tests passing. If not, fix the tests before releasing!

## 1. Update the library version

The first version component should always be 0, to indicate that Signal does not promise stability between releases of the library.

A change is "breaking" if it will require updates in any of the Signal client apps or server components, or in external Rust clients of libsignal-protocol, zkgroup, poksho, attest, device-transfer, or signal-crypto. If there are any breaking changes, increase the second version component and reset the third to 0. Otherwise, increase the third version component.

```
bin/update_versions.py 0.x.y
cargo check --workspace # make sure Cargo.lock is updated
```

## 2. Record the code size for the Java library

On GitHub, under the Java tests for the most recent commit, copy the code size computed in the "java/check_code_size.py" step into a new entry in java/code_size.json.

## 3. Commit the version change and tag with release notes

```
git commit -am 'Bump to version v0.x.y'
git tag -a v0.x.y
```

Take a look at a past release for examples of the format:

```
v0.8.3

- Fixed several issues running signal-crypto operations on 32-bit
  platforms.
- Removed custom implementation of AES-GCM-SIV, AES, AES-CTR, and
  GHash in favor of the implementations from RustCrypto. The interface
  presented to Java, Swift, and TypeScript clients has not changed.
- Updated several Rust dependencies.
- Java: Exposed the tag size for Aes256GcmDecryption.
```

(You might think repeating the version number in the summary field is redundant, but GitHub shows it as a title.)

## 4. Push the version bump and tag to GitHub

Note that both the tag *and* the branch need to be pushed.

## 5. Submit to package repositories as needed

### Android: Sonatype

1. Wait for the "Publish JNI Artifacts to GitHub Release" action to complete. These artifacts, though not built reproducibly, will be included in the `libsignal-client` and `libsignal-server` jars to support running on macOS and Windows as well.
2. Set the environment variables `SONATYPE_USERNAME`, `SONATYPE_PASSWORD`, `KEYRING_FILE`, `SIGNING_KEY`, and `SIGNING_KEY_PASSSWORD`.
3. Run `make -C java publish_java` to build through Docker.

Note that Sonatype is pretty slow; even after the build completes it might take a while for it to show up.

### Node: NPM

In the signalapp/libsignal repository on GitHub, run the "Publish to NPM" action. Use the tag you just made as the "Git Tag" and leave the "NPM Tag" as "latest".

### iOS: Let the iOS team know

They build all their CocoaPods on a dedicated build server, including libsignal.
