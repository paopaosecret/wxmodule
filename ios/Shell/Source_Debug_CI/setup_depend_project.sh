#!/bin/bash
shell_dir=$(cd "$(dirname $0)"; pwd)
source ${shell_dir}/source_debug.config

project_dir="$shell_dir/../../"
PROJECT_NAME="DependProject.xcodeproj"
APP_DIR="$project_dir/AppSourceDebugHookProject/DependProject"
CI_DIR="$shell_dir"

WORKSPACE_DIR="$sdk_project_path"
APP_PROJECT_DIR="$APP_DIR/$PROJECT_NAME"


SDK_PROJECT_DIR="${sdk_project_path}/out/ipa_debug/all.xcodeproj"
ARGS_DIR="${sdk_project_path}/out/ipa_debug/args.gn"

export PATH="$PATH:${depot_tools_path}"

function GenerateSDKProject() {
    cd ${WORKSPACE_DIR}
    ./setup_env.sh

mkdir -p out/ipa_debug

cat > out/ipa_debug/args.gn << EOF
# 可切换debug和release模式，Debug很多检查，但影响性能。Release没有检查性能更好。两者皆可断点调试
# 通用编译参数，只设置 is_debug参数即可：
# Debug:   is_debug = true
# Release: is_debug = false
# 修改之后，直接在xcode运行编译即可

is_debug = true

# 各个版本的公版参数
# 目前支持：trtc, live, smart, smart_no_vod, professional
# 如果需要自定义参数，则自行修改即可
declare_args() {
    framework_type = "smart_no_vod"
}

enable_dsyms = !is_debug
enable_stripping = enable_dsyms
is_official_build = !is_debug
is_chrome_branded = is_official_build
use_xcode_clang = true
use_clang_coverage = false
is_component_build = false
target_cpu = "arm64"
target_os = "ios"
enable_build_liteav_targets=true
build_with_dynamic_ffmpeg = true
build_with_dynamic_soundtouch = true
build_with_prebuilt_liteav = false

if (framework_type == "trtc") {
} else if (framework_type == "live") {
    build_trtc_cloud=true
    build_leb_player=true
    build_rtmp_pusher=true
    build_trtc_pusher=true
    build_trtc_player=true
    enable_rtmp_over_quic=true
} else if (framework_type == "smart") {
    build_rtmp_pusher=true
    enable_rtmp_over_quic=true
} else if (framework_type == "smart_no_vod") {
    build_rtmp_pusher=true
    build_trtc_pusher=true
    build_trtc_player=true
    enable_rtmp_over_quic=true
    build_rtmp_room = true
    build_trtc_room = true
    enable_rtmp_encrypt = true
    compatible_quic_protocol = true
    enable_live_license_check=false
    is_use_x264 = false
    is_use_openh264 = false
    use_ffmpeg_audio_codec = false
    disable_software_video_decoder = true
    disable_software_video_encoder = true
    build_leb_player=true
    build_with_dynamic_ffmpeg = false
    build_with_dynamic_soundtouch = true
} else if (framework_type == "professional") {
    build_trtc_cloud=true
    build_leb_player=true
    build_rtmp_pusher=true
    build_trtc_pusher=true
    build_trtc_player=true
    enable_rtmp_over_quic=true
    build_vod_player=true
    build_ugc=true
}
EOF

gn gen out/ipa_debug --ide=xcode --xcode-build-system=new

}

function AddSDKProjectToApp() {
    export SDK_PROJECT_DIR=${SDK_PROJECT_DIR}
    export APP_PROJECT_DIR=${APP_PROJECT_DIR}
    export ARGS_DIR=${ARGS_DIR}

    cp -rf $CI_DIR/depend_project_template.pbxproj ${APP_PROJECT_DIR}/project.pbxproj

    cd $CI_DIR
    ruby -I BuildLibs add_sub_project.rb
}

function GenerateUserPath() {
    source ~/.bash_profile
    echo "USER_PATH=\"${PATH}\"" > $CI_DIR/user_path.sh
}

GenerateSDKProject
GenerateUserPath
AddSDKProjectToApp

