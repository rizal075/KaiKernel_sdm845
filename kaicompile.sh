#!/bin/sh

DEFCONFIG="kaikernel_defconfig"
CLANGDIR="/workspace/KaiKernel_sdm_845/clang-19"

#
rm -rf compile.log

#
mkdir -p out
mkdir out/KaiKernel
mkdir out/KaiKernel/SE_OC
mkdir out/KaiKernel/NSE_OC


#
export KBUILD_BUILD_USER=Kaiyaa77
export KBUILD_BUILD_HOST=Yuu507
export PATH="$CLANGDIR/bin:$PATH"

#
make O=out ARCH=arm64 $DEFCONFIG

#
MAKE="./makeparallel"

#
START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

rve () {
make -j$(nproc --all) O=out LLVM=1 \
ARCH=arm64 \
CC=clang \
LD=ld.lld \
AR=llvm-ar \
AS=llvm-as \
NM=llvm-nm \
OBJCOPY=llvm-objcopy \
OBJDUMP=llvm-objdump \
STRIP=llvm-strip \
CROSS_COMPILE=aarch64-linux-gnu- \
CROSS_COMPILE_ARM32=arm-linux-gnueabi-
}
        #SE Overclock
        cp KaiKernel/SE/* arch/arm64/boot/dts/qcom/
        cp KaiKernel/OC/818/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
        cp KaiKernel/OC/818/gpucc-sdm845.c drivers/clk/qcom/
        rve
        if [ $? -ne 0 ]
        then
            echo "Build failed"
        else
            echo "Build succesful"
            cp out/arch/arm64/boot/Image.gz-dtb out/KaiKernel/SE_OC/Image.gz-dtb
            
            #NSE Overclock
            cp KaiKernel/NSE/* arch/arm64/boot/dts/qcom/
            cp KaiKernel/OC/818/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
            cp KaiKernel/OC/818/gpucc-sdm845.c drivers/clk/qcom/
            rve
            if [ $? -ne 0 ]
            then
                echo "Build failed"
            else
                echo "Build succesful"
                cp out/arch/arm64/boot/Image.gz-dtb out/KaiKernel/NSE_OC/Image.gz-dtb
    fi
fi

END=$(date +"%s")
DIFF=$(($END - $START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
