package com.example.wxmodule.hooklogic;

import android.os.Bundle;
import android.util.Log;

import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.List;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XC_MethodReplacement;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

public class HookClass implements IXposedHookLoadPackage {
    private static final String TAG = "WXHook";

    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) throws Throwable {
        Log.i(TAG, "HookLogic-->" + " current package:" + lpparam.packageName);
        String pkgName = lpparam.packageName;
        // hook 微信
        if (pkgName.contains("com.tencent.mm") || pkgName.equals("com.tencent.liteav.demo") || pkgName.equals("com.tencent.mobileqq")) {
            Log.i(TAG, "HookLogic-->" + "handleLoadPackage: hook liteav app.");
//            hookJSAdapter(lpparam);
            hookLive(lpparam);
            hookTRTC(lpparam);
        }
    }

    private void hookJSAdapter(XC_LoadPackage.LoadPackageParam lpparam) {
        hookClassSpecificMethod("com.tencent.live2.jsplugin.pusher.V2TXLivePusherJSAdapter", "V2TXLivePusherJSAdapter", lpparam, mHookPusherJSAdapterMethodList);
        hookClassSpecificMethod("com.tencent.live2.jsplugin.player.V2TXLivePlayerJSAdapter", "V2TXLivePlayerJSAdapter", lpparam, mHookPlayerJSAdapterMethodList);
    }

    private void hookLive(XC_LoadPackage.LoadPackageParam lpparam) {
        hookClassAllMethod("com.tencent.live2.impl.V2TXLivePlayerImpl", "V2TXLivePlayerImpl", lpparam);
        hookClassAllMethod("com.tencent.live2.impl.V2TXLivePusherImpl", "V2TXLivePusherImpl", lpparam);
    }

    private void hookTRTC(XC_LoadPackage.LoadPackageParam lpparam) {
        hookClassAllMethod("com.tencent.liteav.trtc.TRTCCloudImpl", "TRTCCloudImpl", lpparam);
    }

    private void hookClassAllMethod(String className, String classTag, XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            //TODO 1、根据全先限定类名获取类的Class对象
            Class clazz = XposedHelpers.findClassIfExists(className, lpparam.classLoader);
            Log.i(TAG, "hookClassAllMethod: find class success. clazz:" + clazz);
            //TODO 2、获取Class声明的任何权限的方法，包括私有方法
            Method[] methods = clazz.getDeclaredMethods();
            Log.i(TAG, "hookClassAllMethod: find methods: " + Arrays.toString(methods));
            //TODO 3、遍历方法并hook
            for (final Method method : methods) {
                Log.i(TAG, "hookClassAllMethod: find method params.  method:" + method.toString() + " paramsType:" + Arrays.toString(method.getParameterTypes()));
                //TODO 4、构建单个方法需要的参数
                int paramSize = method.getParameterTypes().length;
                Object[] params = new Object[paramSize + 1];
                System.arraycopy(method.getParameterTypes(), 0, params, 0, paramSize);

                //TODO 5、方法的最后一个参数为hook回调
                params[paramSize] = new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        super.beforeHookedMethod(param);
                        StringBuilder sb = new StringBuilder();
                        sb.append("params: 【");
                        for (Object arg : param.args) {
                            if (arg != null) {
                                sb.append("「" + arg.toString() + "」");
                            } else {
                                sb.append("「" + null + "」");
                            }
                        }
                        sb.append("】");
                        Log.i(TAG, "[Hook-" + classTag + "-" + method.getName() + "]" + " instance(" + (param.thisObject == null ? "static" : param.thisObject.hashCode()) + ") " + sb.toString());

                    }
                };
                //TODO 6、对单个方法进行真正的hook
                XposedHelpers.findAndHookMethod(clazz, method.getName(), params);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(TAG, "[Hook-" + classTag + "hook fail. e :" + e.getMessage());
        }
    }

    /**
     * hook类中特定的方法
     *
     * @param className 类全限定类名
     * @param classTag 类的tag,用于过滤日志
     * @param lpparam xposed参数
     * @param methodList 需要hook的方法名列表
     */
    private void hookClassSpecificMethod(String className, String classTag, XC_LoadPackage.LoadPackageParam lpparam,
                                         List<String> methodList) {
        try {
            //TODO 1、根据全先限定类名获取类的Class对象
            Class clazz = XposedHelpers.findClassIfExists(className, lpparam.classLoader);
//            Log.i(TAG, "hookClassAllMethod: find class success. clazz:" + clazz);
            //TODO 2、获取Class声明的任何权限的方法，包括私有方法
            Method[] methods = clazz.getDeclaredMethods();
//            Log.i(TAG, "hookClassAllMethod: find methods: " + Arrays.toString(methods));
            //TODO 3、遍历方法并hook
            for (final Method method : methods) {
//                Log.i(TAG, "hookClassAllMethod: find method params.  method:" + method.toString() + " paramsType:" + Arrays.toString(method.getParameterTypes()));
                //TODO 4、构建单个方法需要的参数
                int paramSize = method.getParameterTypes().length;
                Object[] params = new Object[paramSize + 1];
                System.arraycopy(method.getParameterTypes(), 0, params, 0, paramSize);

                //TODO 5、方法的最后一个参数为hook回调
                params[paramSize] = new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        super.beforeHookedMethod(param);
                        StringBuilder sb = new StringBuilder();
                        sb.append("params: 【");
                        for (Object arg : param.args) {
                            if (arg != null) {
                                sb.append("「" + arg.toString() + "」");
                            } else {
                                sb.append("「" + null + "」");
                            }
                        }
                        sb.append("】");
                        Log.i(TAG, "[Hook-" + classTag + "-" + method.getName() + "]" + " instance(" + (param.thisObject == null ? "static" : param.thisObject.hashCode()) + ") " + sb.toString());

                    }
                };
                //TODO 6、对单个方法进行真正的hook
                if (methodList.contains(method.getName())) {
                    XposedHelpers.findAndHookMethod(clazz, method.getName(), params);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(TAG, "[Hook-" + classTag + "hook fail. e :" + e.getMessage());
        }
    }

    // 定义需要hook V2TXLivePusherJSAdapter 的方法名
    private List<String> mHookPusherJSAdapterMethodList = Arrays.asList(
            "initLivePusher",
            "updateLivePusher",
            "operateLivePusher",
            "onPushEvent"
    );

    // 定义需要hook V2TXLivePlayerJSAdapter 的方法名
    private List<String> mHookPlayerJSAdapterMethodList = Arrays.asList(
            "initLivePlayer",
            "updateLivePlayer",
            "operateLivePlayer",
            "onPlayEvent"
    );

    private void  hookExampleDemo(XC_LoadPackage.LoadPackageParam lpparam){
                if("com.example.xposedtestapp".equals(lpparam.packageName)){
            try {
                XposedHelpers.findAndHookMethod("com.example.xposedtestapp.MainActivity", lpparam.classLoader, "getInfo", int.class, String.class, new XC_MethodReplacement() {

                    @Override
                    protected Object replaceHookedMethod(XC_MethodHook.MethodHookParam param) throws Throwable {
                        XposedBridge.log("HookLogic-->" + "param arg1:" + param.args[0]);
                        XposedBridge.log("HookLogic-->" + "param arg1:" + param.args[1]);
                        return "hookCoder，arg[0] = " + 20 + ", args[1] = " + "李四";
                    }
                });
            } catch (Throwable t) {
                Log.i(TAG, "HookLogic-->" + " exception");
            }

            try {
                XposedHelpers.findAndHookMethod("com.example.xposedtestapp.MainActivity", lpparam.classLoader, "getInfo", int.class, Bundle.class, new XC_MethodReplacement() {

                    @Override
                    protected Object replaceHookedMethod(XC_MethodHook.MethodHookParam param) throws Throwable {
                        XposedBridge.log("HookLogic-->" + "param arg1:" + param.args[0]);
                        XposedBridge.log("HookLogic-->" + "param arg1:" + param.args[1]);
                        return "hookCoder，arg[0] = " + 20 + ", args[1] = " + "李四";
                    }
                });
            } catch (Throwable t) {
                Log.i(TAG, "HookLogic-->" + " exception");
            }
        }

        if("com.tencent.liteav.demo".equals(lpparam.packageName) || "com.tencent.mm".equals(lpparam.packageName)){
            XposedBridge.log("HookLogic-->" + " com.tencent.liteav.demo ｜｜ com.tencent.mm");
            try {
                XposedHelpers.findAndHookMethod("com.tencent.live2.jsplugin.pusher.V2TXLivePusherJSAdapter", lpparam.classLoader, "onPushEvent", int.class, Bundle.class, new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(XC_MethodHook.MethodHookParam param) throws Throwable {
                        XposedBridge.log("HookLogic-->" + "onPushEvent event:" + param.args[0]);
                        XposedBridge.log("HookLogic-->" + "onPushEvent param:" + param.args[1]);
                    }

                });
            } catch (Throwable t) {
                XposedBridge.log("HookLogic-->" + " exception");
                XposedBridge.log(t);
            }

            try {
                Class<?> classAdapter = XposedHelpers.findClassIfExists("com.tencent.live2.jsplugin.pusher.V2TXLivePusherJSAdapter", lpparam.classLoader);
                if(classAdapter == null){
                    XposedBridge.log("HookLogic-->" + "没有找到类：com.tencent.live2.jsplugin.pusher.V2TXLivePusherJSAdapter");
                }
                XposedHelpers.findAndHookMethod(classAdapter, "updateLivePusher", Bundle.class, new XC_MethodHook() {

                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        try{
                            XposedBridge.log("HookLogic--> updateLivePusher param:" + param.args[0]);
                        }catch (Exception e){
                            XposedBridge.log("HookLogic--> hook updateLivePusher（）方法异常");
                            e.printStackTrace();
                        }
                    }
                });
            } catch (Throwable t) {
                XposedBridge.log("HookLogic-->" + " exception");
                XposedBridge.log(t);
            }
        }
    }
}
