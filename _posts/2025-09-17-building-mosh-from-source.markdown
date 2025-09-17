# Building mosh from source on Ubuntu 24.04

| Metadata   | Value            |
| ---------- | ---------------- |
| Date       | 2025-09-17         |
| Categories | mosh, ssh, terminal, linux, ubuntu |

---

*SUMMARY: How to build Mosh from source on Ubuntu 22.04 or 24.04.*

## Why build Mosh from source

[Mosh](https://mosh.org) (or Mobile Shell) is an open source project for using
terminal emulators on-the-go.  It's especially useful if you want to be mobile
but also desire your terminal session to stay connected across network
transitions and seamlessly reconnect when network conditions improve.

Unfortunately the project seems to have stalled out as of late, and many
features and bug fixes seem to be stuck on an unreleased version of the code.
Since the project hasn't seen movement for about 2 years, it's also got some
bitrot, so it needs some finessing in order to build it on a modern platform
like Ubuntu 24.04.

## Basics

Basics needed for building should be something like this:

```sh
sudo apt install build-essential clang cmake git automake autoconf automake libssl-dev
```

## Build and install older protobuf release

Mosh depends on an older release protobuf, modern versions on Ubuntu will not work.
First, fetch the source:

```sh
git clone https://github.com/protocolbuffers/protobuf \
  --single-branch --branch 25.x --depth 1
```

Configure it:

```sh
cd protobuf
git submodule update --init --recursive
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/protobuf25 \
  -DCMAKE_BUILD_TYPE=Release -Dprotobuf_BUILD_TESTS=OFF
```

Finally, build and install:

```sh
cmake --build .. --parallel
sudo cmake --install ..
```

## Build and install Mosh

Fetch Mosh source:

```sh
git clone https://github.com/mobile-shell/mosh --single-branch --depth 1
```

Configure the build:

```sh
cd mosh
./autogen.sh
PKG_CONFIG_PATH=/opt/protobuf25/lib/pkgconfig \
  PATH=/opt/protobuf25/bin:$PATH \
  ./configure --prefix /opt/mosh \
    CFLAGS="-I/opt/protobuf25/include -L/opt/protobuf25/lib" \
    CXXFLAGS="-I/opt/protobuf25/include -L/opt/protobuf25/lib" \
    LDFLAGS="-L/opt/protobuf25/lib"
```

Run the build and install:

```sh
make
sudo make install
```

## Conclusion

Luckily mosh does not seem to dynamically link to anything except system
libraries (so we don't need to tweak things like the dynamic lib search path):

```text
❯ ldd /opt/mosh/bin/mosh*

/opt/mosh/bin/mosh:
 not a dynamic executable

/opt/mosh/bin/mosh-client:
 linux-vdso.so.1 (0x00007b9763220000)
 libtinfo.so.6 => /lib/x86_64-linux-gnu/libtinfo.so.6 (0x00007b97631d2000)
 libcrypto.so.3 => /lib/x86_64-linux-gnu/libcrypto.so.3 (0x00007b9762600000)
 libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007b9762be4000)
 libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007b9762200000)
 libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007b9762517000)
 libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007b9762bb6000)
 libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007b9761e00000)
 /lib64/ld-linux-x86-64.so.2 (0x00007b9763222000)

/opt/mosh/bin/mosh-server:
 linux-vdso.so.1 (0x00007aa77a36e000)
 libtinfo.so.6 => /lib/x86_64-linux-gnu/libtinfo.so.6 (0x00007aa77a320000)
 libcrypto.so.3 => /lib/x86_64-linux-gnu/libcrypto.so.3 (0x00007aa779600000)
 libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007aa77a304000)
 libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007aa779200000)
 libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007aa77a21b000)
 libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007aa77a1eb000)
 libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007aa778e00000)
 /lib64/ld-linux-x86-64.so.2 (0x00007aa77a370000)
```

After this you should have a functioning `mosh-server` binary that you can
use with whatever client you desire:

```text
❯ /opt/mosh/bin/mosh-server --version

mosh-server (mosh 1.4.0) [build 1105d48]
Copyright 2012 Keith Winstein <mosh-devel@mit.edu>
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
```
