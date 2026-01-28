+++
title = "Getting Started with .NET 5 on Linux!"
date = "2015-04-02T01:53:20Z"
draft = false
+++

### Disclaimer

I haven't seriously written any .NET since college... I try to avoid Windows like the plague... But with the news (kind old news by now) that CoreCLR is now under the MIT license and Linux support is a priority I can't help but be interested (so many great game engines with C# bindings... F# is awesome... blah blah...)

So here's a quickstart to getting setup... It's not a guideline to C# or F# or building any kind of application. Just the answer to "how the hell do I get this on my machine?"

## DO IT.

First step, [install Mono](http://www.mono-project.com/docs/getting-started/install/linux).

The new .NET has an awesome build tool... It's *going* to be called the DNVM (Dot Net Version Manager) but at the time of this writing it's not stable yet... An older code-named version of the DNVM is called the KVM (confusing yet?).

If it's much past the writing of this, maybe check out Microsoft's [example projects](https://github.com/aspnet/home) and check the updated instructions. For now though, if you want the stable kvm do the following:

```shell
curl https://raw.githubusercontent.com/aspnet/Home/master/kvminstall.sh | sh && source ~/.k/kvm/kvm.sh
```

This will curl down an install script, run it, and then run a shell script that was installed to your home directory to launch the version manager. The install script handle adding the `source ~/.k/kvm/kvm.sh` to your `.bashrc` or `.zshrc` so as long as you're using bash or zshell you shouldn't have to run that manually again.

Next, get the latest version of the KRE (the runtime environment, soon to be called the DNRE).

```shell
kvm upgrade
```

That's it! You've got it. If you want to try out some example code clone down the Home project (linked above too).

```shell
git clone https://github.com/aspnet/Home.git
```

The examples run on a web server named Kestrel. To get it running:

```shell
cd Home/
kpm restore # kpm is the package manager
cd samples/HelloMvc
k kestrel
```

**IF YOU HIT AN ERROR ABOUT LIBUV**:

Install gyp through your package manager and then

```shell
wget http://dist.libuv.org/dist/v1.0.0-rc1/libuv-v1.0.0-rc1.tar.gz
tar -xvf libuv-v1.0.0-rc1.tar.gz
cd libuv-v1.0.0-rc1/
./gyp_uv.py -f make -Duv_library=shared_library
make -C out
sudo cp out/Debug/lib.target/libuv.so /usr/lib/libuv.so.1.0.0-rc1
sudo ln -s libuv.so.1.0.0-rc1 /usr/lib/libuv.so.1
```

Then try running `k kestrel` again.

BAM! You're up and running. The web app is running at `http://localhost:5004`
