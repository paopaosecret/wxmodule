#!/bin/bash

# ${SRCROOT} 它是工程文件所在的目录

CI_PATH="${SRCROOT}/../Shell/Source_Debug_CI"
LOCAL_SDK_PATH="${SRCROOT}/SDK"
source ${CI_PATH}/source_debug.config

FRAMEWORK_NAME=${target_framework}
NINJA_TARGET=${build_target}
SOURCES_DEBUG=${source_debug}

NINJA_BUILD_DIR=${sdk_project_path}/out/ipa_debug
target_framework=TXLiteAVSDK_Professional

framework_type="smart_no_vod"
if [ "$target_framework" = "TXLiteAVSDK_Professional" ];then
    framework_type="professional"
fi


function NinjaBuildFramework() {
    if [ -f "${CI_PATH}/user_path.sh" ]
    then
        source ${CI_PATH}/user_path.sh
    else
        echo "error: 没有找到user_path.sh，请确认是否运行了setup_project.sh"
        rm -rf ${NINJA_BUILD_DIR}
        exit 1
    fi
    
    echo "note: args.gn存在，修改变量参数"
    sed -i "" -E "s/framework_type = .*/framework_type = \"${framework_type}\"/" ${NINJA_BUILD_DIR}/args.gn
        
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
        rm -rf ${NINJA_BUILD_DIR}
        exit 1
    fi
    # 删除SDK目录下的framework
    rm -rf $LOCAL_SDK_PATH/${FRAMEWORK_NAME}.framework
    
    if [ ! -d "${FRAMEWORK_NAME}.framework" ]
        # 库存在
        cp -rf Static/${FRAMEWORK_NAME}.framework ${LOCAL_SDK_PATH}/
    then
        # 库存在
        cp -rf ${FRAMEWORK_NAME}.framework ${LOCAL_SDK_PATH}/
    fi

    if [[ ! -d ${LOCAL_SDK_PATH}/${FRAMEWORK_NAME}.framework ]]; then
        echo "error: cp ${FRAMEWORK_NAME}.framework failed"
        exit 1
    fi
    RENAME_SDK
}

function RENAME_SDK() {
    path=${LOCAL_SDK_PATH}
    SDK_NAME=$FRAMEWORK_NAME
    new_name="TXLiteAVSDK_Framework"
    rm -rf $LOCAL_SDK_PATH/${new_name}.framework
    mv "$path/$SDK_NAME.framework/$SDK_NAME" "$path/$SDK_NAME.framework/$new_name"
    mv "$path/$SDK_NAME.framework" "$path/$new_name.framework"
    plistPath="$path/$new_name.framework/Info.plist"
    /usr/libexec/PlistBuddy -c "Set :CFBundleExecutable $new_name" "$plistPath"
    /usr/libexec/PlistBuddy -c "Set :CFBundleName $new_name" "$plistPath"
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

if [ ${SOURCES_DEBUG} == true ]
then
    NinjaBuildFramework
else
    echo "**************** 需要手动copy ${FRAMEWORK_NAME}.framework 到 SDK 目录下 ******************"
fi

echo "**************** end ******************"
