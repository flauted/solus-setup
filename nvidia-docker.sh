# Apr 23 2018
# Dylan Flaute
#
# Solus 3.9.9.9, Nvidia driver 390.48 with GTX 1080.
# No CUDA, Cudnn, etc. in native env.
#
# Full disclosure
# ---------------
# Cuda 9.1 WITHOUT compiler in a NON-ACTIVE conda env
# Tried to accomplish this install yesterday. Don't BELIEVE anything I did interacted, but...
#
# Overview of task
# ----------------
# Install nvidia-docker2 on Solus; Docker was pre-installed. That left the task of
# getting nvidia-container-runtime and registering. This was partially constructed from the base/Dockerfile's,
# the hook/Dockerfile's, the runtime/Dockerfile's, and adzy2k6's instructions on
# nvidia-container-runtime issue #9.
#
# You'll be downloading runc source (the 'normal' docker runtime), downloading nvidia-container-runtime,
# applying an nvidia-enabling patch from ncr to runc, and building hooked runc with Go. Then you'll copy
# the 'new runc' and the hook into an execable location (/usr/bin). After that, you'll need
# to build libnvidia-container. We'll build that in an Ubuntu docker image and copy the produced lib out to
# usr/lib. Finally, we'll register the new runtime with the docker daemon and restart the daemon.
#
# Warning
# -------
# As the author of these instructions, I wouldn't run them again as a script. Some things were re-arranged
# in retrospect and never tested! I also did some things that I wouldn't appreciate a script doing on my 
# system (namely, making a dir directly under / and changing the owner).


# Already had these three installed. You'll definitely need git and golang. In retrospect, not
# sure you'll need wget.
eopkg it wget
eopkg it git
eopkg it golang

# We're going to do quite a bit in $GOPATH.
export GOPATH=/go
mkdir -p $GOPATH
chown $USER:root /go  # NOTE: This isn't necessarily a safe thing to do!!!!

# I don't even have a /usr/local(/go/bin), but I did have it in my path. 
# Included here for completeness
export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

# Believe I may have pre-installed these deps with eopkg.
# libseccomp-dev
# libapparmor-dev
# libselinux1-dev

go get github.com/LK4D4/vndr

mkdir -p $GOPATH/src/github.com/opencontainers/runc
cd $GOPATH/src/github.com/opencontainers/runc

git clone https://github.com/docker/runc.git .
git fetch https://github.com/opencontainers/runc.git
# Disclosure: Started with 4fc5 and executed a few of the following steps before reverting.
RUNC_COMMIT=b2567b37d7b75eb4cf325b77297b140ea686ce8f
git checkout $RUNC_COMMIT

# We're going to get nvidia-container-runtime now to get the patches
# Disclosure: Executed most of this without patch before realizing that I wasted my time, then came back here.
cd /tmp  # Solus seems to auto-clear /tmp at least on reboot FYI
git clone https://github.com/NVIDIA/nvidia-container-runtime.git

# SHOULD copy a file called 0001-<*>.patches. Mind the slashes and stars.
cp /tmp/nvidia-container-runtime/runtime/runc/$RUNC_COMMIT/* /tmp/patches/runc/
git apply /tmp/patches/runc/*
# I didn't do this and honestly don't know what it does. But it's in the Dockerfiles
# if [ -f vendor.conf ]; then vendr; fi  

# Now we're going to make runc + nvidia magic patch
eopkg it gcc
eopkg it pkg-config
eopkg it g++  # doubt this did anything for me, but I did do it!
# Thanks Ikey! https://solus-project.com/forums/viewtopic.php?t=7128
eopkg it -c system.devel
cd $GOPATH/src/github.com/opencontainers/runc
make BUILDTAGS=""

cp -r nvidia-container-runtime/hook/nvidia-container-runtime-hook/ $GOPATH/src/
go get -v nvidia-container-runtime-hook

# Copy new binaries into executable location.
cp $GOPATH/src/github.com/opencontainers/runc/runc /usr/bin/nvidia-container-runtime
cp $GOPATH/bin/nvidia-container-runtime-hook /usr/bin/nvidia-container-runtime-hook
# Don't believe that copying to $GOPATH sufficed despite being on path. Must need to be in system path.
# But disclosure: I did most of this with both binaries in my $GOPATH/bin and copied them to /usr/bin very late.
# cp $GOPATH/src/github.com/opencontainers/runc/runc $GOPATH/bin/runc

# May have to change .toml's ldconfig to /sbin/ldconfig. I didn't and default of @/sbin/ldconfig was fine.
# Don't know toml. Maybe that's expected; don't care enough to find out :)
cp /tmp/nvidia-container-runtime/hook/config.toml.ubuntu /tmp/nvidia-container-runtime/hook/config.toml.solus

# Now we get to install libnvidia-container from the instructions at that repo.
# The ubuntu docker image directions work. (Only A LITTLE suspicious...)
cd /tmp
git clone https://github.com/NVIDIA/libnvidia-container.git
cd /tmp/libnvidia-container
# make install  # Needs b(sd)make :( didn't figure out how to get that on Solus
make docker-ubuntu:16.04 TAG=beta.1
cd /tmp/libnvidia-container/dist/ubuntu16.04/libnvidia-container_1.0.0_amd64/usr/lib/x86_64-linux-gnu
cp libnvidia-container.so /usr/lib/libnvidia-container.so
# Here I tried to do the verification on the libnvidia-container README, had problems, and restarted
# the docker daemon with
# sudo pkill -SIGHUP dockerd

# Because magic symlinks are ALWAYS a great idea...
cd /usr/lib64
ln -s libEGL_nvidia.so.1 libEGL_nvidia.so.0

# You'll need to register the docker runtime and restart the docker daemon. That should be simple
# unless you're trying to do all this in a container. Then you wouldn't have access to
# the daemon. Just a note from experience doing other things inside containers.
#
# From the container runtime README:
# Register new runtime:
sudo tee /etc/docker/daemon.json <<EOF
{
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF
# Restart daemon
sudo pkill -SIGHUP dockerd

# Enjoy! :D
docker run --runtime=nvidia nvidia/cuda nvidia-smi
