#!/bin/bash
shell_dir=$(cd "$(dirname $0)"; pwd)
source ${shell_dir}/source_debug.config

WORKSPACE_API_HEADER_LIVE="$sdk_project_path/sdk/api/live/apple"
WORKSPACE_API_HEADER_TRTC="$sdk_project_path/sdk/api/trtc/apple"
function modify_header() {
    echo "modify $1"
    path="$WORKSPACE_API_HEADER_LIVE/$1"
    define_str=$2

    if [ `grep -c "$define_str" $path` -ne '0' ];then
        echo "The File Has $define_str"
    else
        echo "The File Has No $define_str"
        old_str="\/\/  Copyright"
        new_str="$define_str \n $old_str"
        sed -i "" -E "s/${old_str}/${new_str}/" $path
    fi
    
}

modify_header TXLiveBase.h "#define TXLiveBase TXLiveBaseRefactor"

modify_header V2TXLivePusher.h "#define V2TXLivePusher V2TXLivePusherRefactor"

modify_header V2TXLivePlayerObserver.h "#define V2TXLivePlayer V2TXLivePlayerRefactor"
modify_header V2TXLivePlayer.h "#define V2TXLivePlayer V2TXLivePlayerRefactor"

modify_header TXLivePlayer.h "#define TXLivePlayer TXLivePlayerRefactor"


function modify_header_TXLivePush() {
    echo "modify $1"
    path="$WORKSPACE_API_HEADER_LIVE/$1"
    define_str=$2

    if [ `grep -c "$define_str" $path` -ne '0' ];then
        echo "The File Has $define_str"
    else
        echo "The File Has No $define_str"
        old_str="\/\/ Copyright"
        new_str="$define_str \n $old_str"
        sed -i "" -E "s/${old_str}/${new_str}/" $path
    fi
    
}
modify_header_TXLivePush TXLivePush.h "#define TXLivePush TXLivePushRefactor"

function modify_header_TRTCCloud() {
    echo "modify $1"
    path="$WORKSPACE_API_HEADER_TRTC/$1"
    define_str=$2

    if [ `grep -c "$define_str" $path` -ne '0' ];then
        echo "The File Has $define_str"
    else
        echo "The File Has No $define_str"
        old_str="NS_ASSUME_NONNULL_BEGIN"
        new_str="$define_str \n $old_str"
        sed -i "" -E "s/${old_str}/${new_str}/" $path
    fi
}
modify_header_TRTCCloud TRTCCloud.h "#define TRTCCloud TRTCCloudRefactor"
