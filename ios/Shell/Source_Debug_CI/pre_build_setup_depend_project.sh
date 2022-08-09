#!/bin/sh
# 编译framework的前置脚本
# 1、检查source debug是否存在
# 2、不存在的情况下执行脚本，生成xcporject

shell_dir=$(cd "$(dirname $0)"; pwd)

source ${shell_dir}/source_debug.config

cd ${shell_dir}

all_project_dir="${sdk_project_path}/out/ipa_debug/all.xcodeproj"
build_ninja_file="${sdk_project_path}/out/ipa_debug/build.ninja"

function init_ninja() {
    if [ -f ${build_ninja_file} ]; then
        echo "note: build.ninja 存在"
        ./modify_header.sh
        ./build_sdk.sh
    else
        echo "note: build.ninja 不存在，重新生成"
        rm -rf "${sdk_project_path}/out/ipa_debug"
        ./setup_depend_project.sh
        ./modify_header.sh
        ./build_sdk.sh
    fi
}

function init_project() {
    if [ -d ${all_project_dir} ]; then
        echo "note: SDK 工程已存在"
        init_ninja
    else
        echo "note: SDK 工程不存在，重新生成"
        rm -rf "${sdk_project_path}/out/ipa_debug"
        ./setup_depend_project.sh
        ./modify_header.sh
        ./build_sdk.sh
    fi
}

init_project
