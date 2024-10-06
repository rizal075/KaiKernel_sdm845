#!/bin/sh

DEFCONFIG="kaikernel_defconfig"
CLANGDIR="/workspaces/KaiKernel_sdm_845/neutron-clang"

#
rm -rf compile.log

#
mkdir -p out
mkdir out/KaiKernel
mkdir out/KaiKernel/SE_OC818
mkdir out/KaiKernel/NSE_OC818
mkdir out/KaiKernel/SE_OC840
mkdir out/KaiKernel/NSE_OC840


#
export KBUILD_BUILD_USER=Kaiyaa77
export KBUILD_BUILD_HOST=Yuu507
export PATH="$CLANGDIR/bin:$PATH"

#
make O=out ARCH=arm64 $DEFCONFIG

#
MAKE="./makeparallel"

rve () {
make -j$(nproc --all) O=out LLVM=1 LLVM_IAS=1 \
ARCH=arm64 \
CC=clang \
LD=ld.lld \
AR=llvm-ar \
AS=llvm-as \
NM=llvm-nm \
STRIP=llvm-strip \
OBJCOPY=llvm-objcopy \
OBJDUMP=llvm-objdump \
READELF=llvm-readelf \
HOSTCC=clang \
HOSTCXX=clang++ \
HOSTAR=llvm-ar \
HOSTLD=ld.lld \
CROSS_COMPILE=aarch64-linux-gnu- \
CROSS_COMPILE_ARM32=arm-linux-gnueabi-
}
        #SE Overclock 818
        cp KaiKernel/SE/* arch/arm64/boot/dts/qcom/
        cp KaiKernel/OC/818/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
        cp KaiKernel/OC/818/gpucc-sdm845.c drivers/clk/qcom/
        rve 2>&1 | tee -a compile.log
        if [ $? -ne 0 ]
        then
            echo "Build failed"
        else
            echo "Build succesful"
            cp out/arch/arm64/boot/Image.gz-dtb out/KaiKernel/SE_OC818/Image.gz-dtb
            
            #NSE Overclock 818
            cp KaiKernel/NSE/* arch/arm64/boot/dts/qcom/
            cp KaiKernel/OC/818/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
            cp KaiKernel/OC/818/gpucc-sdm845.c drivers/clk/qcom/
            rve
            if [ $? -ne 0 ]
            then
                echo "Build failed"
            else
                echo "Build succesful"
                cp out/arch/arm64/boot/Image.gz-dtb out/KaiKernel/NSE_OC818/Image.gz-dtb

                 #SE Overclock 840
                 cp KaiKernel/SE/* arch/arm64/boot/dts/qcom/
                 cp KaiKernel/OC/840/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
                 cp KaiKernel/OC/840/gpucc-sdm845.c drivers/clk/qcom/
                 rve
                 if [ $? -ne 0 ]
                 then
                     echo "Build failed"
                 else
                 echo "Build succesful"
                 cp out/arch/arm64/boot/Image.gz-dtb out/KaiKernel/SE_OC840/Image.gz-dtb
            
                    #NSE Overclock 840
                    cp KaiKernel/NSE/* arch/arm64/boot/dts/qcom/
                    cp KaiKernel/OC/840/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
                    cp KaiKernel/OC/840/gpucc-sdm845.c drivers/clk/qcom/
                    rve
                    if [ $? -ne 0 ]
                    then
                        echo "Build failed"
                    else
                    echo "Build succesful"
                    cp out/arch/arm64/boot/Image.gz-dtb out/KaiKernel/NSE_OC840/Image.gz-dtb

            fi
        fi
    fi
fi
