#!/bin/bash
echo "**************** begin copy_ipa ******************"
# ${SRCROOT} 它是工程文件所在的目录
CI_PATH="${SRCROOT}/../Shell/Source_Debug_CI"
LOCAL_SDK_PATH="${SRCROOT}/SDK"
TEMP_PATH="${SRCROOT}/../Shell/Source_Debug_CI/Temp"
#资源文件夹
ASSETS_PATH="${SRCROOT}/../APP"
#ipa包路径
TARGET_IPA_PATH="${ASSETS_PATH}/*.ipa"

source ${CI_PATH}/source_debug.config

FRAMEWORK_NAME="TXLiteAVSDK_Framework"
#新建Temp文件夹
rm -rf ${TEMP_PATH}
mkdir -p ${TEMP_PATH}

#----------------------------------------
# 1. 解压IPA到Temp下
unzip -oqq "$TARGET_IPA_PATH" -d "$TEMP_PATH"
app_path="$TEMP_PATH/Payload/"*.app
app_name=$(basename $app_path .app)
app_path="$TEMP_PATH/Payload/$app_name.app"
#SDK路径
TXFFmpeg_Path="$LOCAL_SDK_PATH/TXFFmpeg.xcframework/ios-arm64_armv7/TXFFmpeg.framework"
TXSoundTouch_Path="$LOCAL_SDK_PATH/TXSoundTouch.xcframework/ios-arm64_armv7/TXSoundTouch.framework"
TXLiteAVSDK_Path="$LOCAL_SDK_PATH/$FRAMEWORK_NAME.framework"
App_Frameworks_Path="$TEMP_PATH/Payload/$app_name.app/Frameworks"
    
echo "**************** begin 替换SDK ******************"
if [ -d ${BUILT_PRODUCTS_DIR}/InjectionFramework.framework ]
then
    echo "InjectionFramework.framework 已存在，直接copy"
    cp -rf ${BUILT_PRODUCTS_DIR}/InjectionFramework.framework "$TEMP_PATH/Payload/"*.app/Frameworks
else
    echo "InjectionFramework.framework 不存在"
fi
    
#本地存在TXFFmpeg
if [ -d $TXFFmpeg_Path ]
then
    echo "本地存在TXFFmpeg"
        /usr/bin/codesign --force --sign  "$EXPANDED_CODE_SIGN_IDENTITY" $TXFFmpeg_Path
else
    echo "本地不存在TXFFmpeg"
fi

#本地存在TXSoundTouch
if [ -d $TXSoundTouch_Path ]
then
    echo "本地存在TXSoundTouch"
    /usr/bin/codesign --force --sign "$EXPANDED_CODE_SIGN_IDENTITY" $TXSoundTouch_Path
else
    echo "本地不存在TXSoundTouch"
fi

#本地存在TXLiteAVSDK
if [ -d $TXLiteAVSDK_Path ]
then
    echo "本地存在TXLiteAVSDK_Path"
    /usr/bin/codesign --force --sign "$EXPANDED_CODE_SIGN_IDENTITY" $TXLiteAVSDK_Path
else
    echo "本地不存在TXLiteAVSDK"
fi

echo "**************** begin 注入InjectionFramework ******************"
cd $app_path
chmod +x $app_name
${CI_PATH}/yololib $app_name Frameworks/InjectionFramework.framework/InjectionFramework

echo "**************** begin Frameworks 重签名 ******************"
cd $App_Frameworks_Path
#对ipa里main的库进行重新签名
/usr/bin/codesign --force --sign "$EXPANDED_CODE_SIGN_IDENTITY" *.dylib
/usr/bin/codesign --force --sign "$EXPANDED_CODE_SIGN_IDENTITY" *.framework
# 拿到解压的临时的APP的路径
TEMP_APP_PATH=$(set -- "$TEMP_PATH/Payload/"*.app;echo "$1")


echo "**************** begin 将解压出来的.app拷贝进入工程下 ******************"
#----------------------------------------
# 将解压出来的.app拷贝进入工程下
# BUILT_PRODUCTS_DIR 工程生成的APP包的路径
# TARGET_NAME target名称
TARGET_APP_PATH="$BUILT_PRODUCTS_DIR/$TARGET_NAME.app"
echo "app路径:$TARGET_APP_PATH"

rm -rf "$TARGET_APP_PATH"
mkdir -p "$TARGET_APP_PATH"
cp -rf "$TEMP_APP_PATH/" "$TARGET_APP_PATH"

#----------------------------------------
# 删除Temp目录 和 taget目录的extension和WatchAPP.个人证书没法签名Extention
rm -rf "$TEMP_PATH/"
rm -rf "$TARGET_APP_PATH/PlugIns"
rm -rf "$TARGET_APP_PATH/Watch"

#----------------------------------------
# 更新info.plist文件 CFBundleIdentifier
#  设置:"Set : KEY Value" "目标文件路径"
#key="key:CFBundleIdentifier"
bundleId=$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$TARGET_APP_PATH/Info.plist")
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $PRODUCT_BUNDLE_IDENTIFIER" "$TARGET_APP_PATH/Info.plist"
/usr/libexec/PlistBuddy -c "Add :Ipa_CFBundleIdentifier string $bundleId" "$TARGET_APP_PATH/Info.plist"

echo "**************** end copy_ipa ******************"
