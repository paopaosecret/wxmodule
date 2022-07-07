
## 注意事项

Hook工程：AppHookProject
1. 拖ipa到App目录下，如果没有看到App目录，请新建App文件夹
2. 用xcode打开AppHookProject/AppHookProject.xcodeproj
3. 在Singing&Capabilitles里面修改为自己的签名
4. run起来

Hook&source_debug工程：AppSourceDebugHookProject
1. 拖ipa到App目录下，如果没有看到App目录，请新建App文件夹
2. 用xcode打开AppSourceDebugHookProject/AppHookProject.xcodeproj
3. 在Singing&Capabilitles里面修改为自己的签名
4. 修改工程总的source_debug.config配置
4. run起来

## 常见错误
1. 检查签名
2. 检查CI目录下的权限
3. clean build folder，再次运行
