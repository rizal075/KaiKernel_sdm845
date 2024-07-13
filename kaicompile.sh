#!/bin/sh

# Many parts of this script were taken from @REIGNZ, @idkwhoiam322 and @raphielscape . Huge thanks to them.

# Some general variables
PHONE="beryllium"
ARCH="arm64"
SUBARCH="arm64"
DEFCONFIG=kaikernel_defconfig
COMPILER=clang
LINKER=""
COMPILERDIR="/workspace/KaiKernel_sdm_845/proton-clang"

# Outputs
mkdir out/KaiKernel
mkdir out/KaiKernel/SE
mkdir out/KaiKernel/NSE

# Export shits
export KBUILD_BUILD_USER=Kaiyaa77
export KBUILD_BUILD_HOST=Yuu507

# Speed up build process
MAKE="./makeparallel"

# Basic build function
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

Build () {
PATH="${COMPILERDIR}/bin:${PATH}" \
make -j$(nproc --all) O=out \
ARCH=${ARCH} \
CC=${COMPILER} \
CROSS_COMPILE=${COMPILERDIR}/bin/aarch64-linux-gnu- \
CROSS_COMPILE_ARM32=${COMPILERDIR}/bin/arm-linux-gnueabi- \
LD_LIBRARY_PATH=${COMPILERDIR}/lib
}

Build_lld () {
PATH="${COMPILERDIR}/bin:${PATH}" \
make -j$(nproc --all) O=out \
ARCH=${ARCH} \
CC=${COMPILER} \
CROSS_COMPILE=${COMPILERDIR}/bin/aarch64-linux-gnu- \
CROSS_COMPILE_ARM32=${COMPILERDIR}/bin/arm-linux-gnueabi- \
LD=ld.${LINKER} \
AR=llvm-ar \
NM=llvm-nm \
OBJCOPY=llvm-objcopy \
OBJDUMP=llvm-objdump \
STRIP=llvm-strip \
ld-name=${LINKER} \
KBUILD_COMPILER_STRING="Proton Clang"
}

# Make defconfig

make O=out ARCH=${ARCH} ${DEFCONFIG}
if [ $? -ne 0 ]
then
    echo "Build failed"
else
    echo "Made ${DEFCONFIG}"
fi

# Build starts here
if [ -z ${LINKER} ]
then
        #NEW-SE
        cp KaiKernel/TOUCH_FW/OLD/* firmware/
        cp KaiKernel/SE/* arch/arm64/boot/dts/qcom/
        cp KaiKernel/OC/gpucc-sdm845.c drivers/clk/qcom/
        cp KaiKernel/OC/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
        Build
else
        Build_lld
fi
        if [ $? -ne 0 ]
        then
            echo "Build failed"
            rm -rf out/KaiKernel/SE/*
        else
            echo "Build succesful"
            cp out/arch/arm64/boot/Image.gz-dtb out/KaiKernel/SE/Image.gz-dtb

            #NEW-NSE
            cp KaiKernel/NSE/* arch/arm64/boot/dts/qcom/
            Build
            if [ $? -ne 0 ]
            then
                echo "Build failed"
                rm -rf out/KaiKernel/NSE/*
            else
                echo "Build succesful"
                cp out/arch/arm64/boot/Image.gz-dtb out/KaiKernel/NSE/Image.gz-dtb
            fi
        fi

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"


