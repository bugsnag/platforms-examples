using System.Linq;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.Callbacks;

public class Builder : MonoBehaviour {

    static void Build(string folder, BuildTarget target)
    {
        BuildPlayerOptions opts = new BuildPlayerOptions();
        var scenes = EditorBuildSettings.scenes.Where(s => s.enabled).Select(s => s.path).ToArray();
        opts.scenes = scenes;
        opts.locationPathName = folder;
        opts.target = target;
        opts.options = BuildOptions.Development;
        BuildPipeline.BuildPlayer(opts);
    }

    public static void MacOS()
    {
        Build("build/MacOS/UnityExample", BuildTarget.StandaloneOSX);
    }

    public static void Win64()
    {
        Build("build/Windows/UnityExample.exe", BuildTarget.StandaloneWindows64);
    }

    public static void WebGL()
    {
        Build("build/WebGL/UnityExample", BuildTarget.WebGL);
    }

    private static void EnableAndroidSymbolUpload()
    {
        PlayerSettings.SetScriptingBackend(BuildTargetGroup.Android, ScriptingImplementation.IL2CPP);
        EditorUserBuildSettings.androidCreateSymbols = AndroidCreateSymbols.Public;
    }

    // Generates the APK
    public static void AndroidBuild()
    {
        EnableAndroidSymbolUpload();
        Debug.Log("Building Android app...");
        PlayerSettings.SetApplicationIdentifier(BuildTargetGroup.Android, "com.bugsnag.example.unity.android");

        var opts = CommonOptions("UnityExample.apk");
        opts.target = BuildTarget.Android;
        opts.options &= ~BuildOptions.Development;

    #if UNITY_2022_1_OR_NEWER
        PlayerSettings.insecureHttpOption = InsecureHttpOption.AlwaysAllowed;
    #endif

        var result = BuildPipeline.BuildPlayer(opts);
        Debug.Log("Result: " + result);
    }

    public static void AndroidBuildAAB()
    {
        EnableAndroidSymbolUpload();
        EditorUserBuildSettings.buildAppBundle = true;
        Debug.Log("Building Android app bundle...");
        PlayerSettings.SetApplicationIdentifier(BuildTargetGroup.Android, "com.bugsnag.example.unity.android");

        var opts = CommonOptions("UnityExample.aab");
        opts.target = BuildTarget.Android;
        opts.options &= ~BuildOptions.Development;

    #if UNITY_2022_1_OR_NEWER
        PlayerSettings.insecureHttpOption = InsecureHttpOption.AlwaysAllowed;
    #endif

        var result = BuildPipeline.BuildPlayer(opts);
        Debug.Log("Result: " + result);
    }

    // Generates the IPA
    public static void IosBuild()
    {
        Debug.Log("Building iOS app...");
        PlayerSettings.SetApplicationIdentifier(BuildTargetGroup.iOS, "com.bugsnag.example.unity.ios");
        PlayerSettings.iOS.appleDeveloperTeamID = "7W9PZ27Y5F";
        PlayerSettings.iOS.appleEnableAutomaticSigning = true;
        PlayerSettings.iOS.allowHTTPDownload = true;

        var opts = CommonOptions("UnityExample");
        opts.target = BuildTarget.iOS;

        var result = BuildPipeline.BuildPlayer(opts);
        Debug.Log("Result: " + result);
    }

    private static BuildPlayerOptions CommonOptions(string outputFile)
    {
        var scenes = EditorBuildSettings.scenes.Where(s => s.enabled).Select(s => s.path).ToArray();

        PlayerSettings.defaultInterfaceOrientation = UIOrientation.Portrait;
        BuildPlayerOptions opts = new BuildPlayerOptions();
        opts.scenes = scenes;
        opts.locationPathName = Application.dataPath + "/../" + outputFile;
        opts.options = BuildOptions.None;

        return opts;
    }
}
#endif
