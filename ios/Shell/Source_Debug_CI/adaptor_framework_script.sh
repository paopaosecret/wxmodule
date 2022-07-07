#!/bin/sh
# 该脚本为xcode中调用的脚本，不能自己在终端进行调用


## configs
FRAMEWORK_NAME=$1
NINJA_TARGET=$2
FRAMEWORK_DYNAMIC=false
SHELL_DIR=$(cd "$(dirname $0)"; pwd)
NINJA_BUILD_DIR=${PROJECT_DIR}/../../../out/sources_debug-iphoneos
LOCAL_SDK_DIR=${PROJECT_DIR}/../SDK


if [ "$3" == "true" ]
then
    echo "使用动态库 ${FRAMEWORK_NAME}"
    FRAMEWORK_DYNAMIC=true
fi

source ${PROJECT_DIR}/source_debug.config
if [ ${source_debug} == true ]
then
    echo "note: 开启源码调试"
    SOURCES_DEBUG=true
elif [ ${source_debug} == false ]
then
    echo "note: 使用本地framework"
    SOURCES_DEBUG=false
else
    echo "error: source_debug.config文件格式错误，请对照说明修改正确"
    exit 1
fi

function NinjaBuildFramework() {
    if [ -f "${SHELL_DIR}/user_path.sh" ]
    then
        source ${SHELL_DIR}/user_path.sh
    else
        echo "error: 没有找到user_path.sh，请确认是否运行了setup_project.sh"
        exit 1
    fi
    
    PATH=${USER_PATH}

    echo "enter ${NINJA_BUILD_DIR} build ${FRAMEWORK_NAME} framework"
    cd ${NINJA_BUILD_DIR}

    ninja --version
    if [ $? != 0 ]
    then
        echo "error: ninja: command no found"
        exit 1
    fi

    # 加锁，防止两个target的ninja并行编译
    Lock

    # 外录屏静态库需要base的一个.o, 所以先编一次base
    env -i PATH="${USER_PATH}" LANG="zh_CN.UTF-8" TMPDIR="$TMPDIR" ICECC_VERSION="$ICECC_VERSION" ICECC_CLANG_REMOTE_CPP="$ICECC_CLANG_REMOTE_CPP" ninja -C . base
    env -i PATH="${USER_PATH}" LANG="zh_CN.UTF-8" TMPDIR="$TMPDIR" ICECC_VERSION="$ICECC_VERSION" ICECC_CLANG_REMOTE_CPP="$ICECC_CLANG_REMOTE_CPP" ninja -C . ${NINJA_TARGET}
    UnLock

    if [ $? != 0 ]
    then
        echo "error: ${FRAMEWORK_NAME}.framework 编译失败, 请检查错误并修复"
        exit 1
    fi

    if [ ${FRAMEWORK_DYNAMIC} == true ]
    then
        cp -rf ${FRAMEWORK_NAME}.framework ${BUILT_PRODUCTS_DIR}/
    else
        cp -rf Static/${FRAMEWORK_NAME}.framework ${BUILT_PRODUCTS_DIR}/
    fi

}

function CopyLocalFramework() {
    echo "note: enter ${LOCAL_SDK_DIR} copy ${FRAMEWORK_NAME} framework"

    if [ ! -d ${LOCAL_SDK_DIR}/${FRAMEWORK_NAME}.framework ]
    then
        echo "note: 检测到 ${LOCAL_SDK_DIR}/${FRAMEWORK_NAME}.framework 不存在. 开始下载${FRAMEWORK_NAME}.framework"
        DOWNLOAD_SDK_SHELL=${PROJECT_DIR}/../CI/download_framework.sh
        DOWNLOAD_SDK_TARGET=${FRAMEWORK_NAME#TXLiteAVSDK_}
        $DOWNLOAD_SDK_SHELL $DOWNLOAD_SDK_TARGET
        if [ $? != 0 ]
        then
            echo "error: ${FRAMEWORK_NAME}.framework 下载失败, 请检查错误并修复"
            exit 1
        fi
    fi

    cp -rf ${LOCAL_SDK_DIR}/${FRAMEWORK_NAME}.framework ${BUILT_PRODUCTS_DIR}/
}


function Lock() {
    RUNNING=true
    while [ ${RUNNING} == true ]
    do
        shlock -p $$ -f /tmp/frameworks.lock
        if [ $? == 0 ]
        then
            RUNNING=false
        else
            sleep 0.5
        fi
    done
}

function UnLock() {
    rm  /tmp/frameworks.lock
}

echo "******** ${FRAMEWORK_NAME} *******"
rm -rf ${BUILT_PRODUCTS_DIR}/${FRAMEWORK_NAME}.framework

if [ ${SOURCES_DEBUG} == true ]
then
    NinjaBuildFramework
else
    CopyLocalFramework
fi

echo "**************** end ******************"
