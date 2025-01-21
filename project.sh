echo "Select one of the following option to execute appropriate tasks"
echo "1 - First time project loading"
echo "2 - Switched working branches or clear build data"
echo "3 - Run build runner"
echo "4 - Run build watcher"
echo "5 - Run automation test cases"
echo "6 - Run unit test cases"
echo "7 - Build fresh android apk - Debug"
echo "8 - Build fresh android apk - Profile"
echo "9 - Build fresh android apk - Release"
echo "10 - Build fresh android aab - Release [For playstore]"
echo "11 - Build fresh ios ipa"
read "choice"

cleanBuild() {
  flutter clean
  flutter pub get
}

cleanProject() {
  cd customPackage/OptimizedGestureDetector || exit
  cleanBuild
  cd ../mp_chart || exit
  cleanBuild
  cd ../flutter_full_pdf_viewer || exit
  cleanBuild
  cd ../.. || exit
  cleanBuild
}

runBuildRunnerModeWatch() {
  flutter pub run build_runner watch --delete-conflicting-outputs
}

runBuildRunnerModeBuild() {
  flutter pub run build_runner build --delete-conflicting-outputs
}

if [ -z "$choice" ];then
    echo "choice cannot be null"
    exit 1
fi
if [ "$choice" == 1 ] || [ "$choice" == 2 ];then
    cleanProject
elif [ "$choice" == 3 ];then
    runBuildRunnerModeBuild
elif [ "$choice" == 4 ];then
    runBuildRunnerModeWatch
elif [ "$choice" == 5 ];then
    source test_driver/integration_tests.sh
elif [ "$choice" == 6 ];then
    echo "yet to implement"
elif [ "$choice" == 7 ] || [ "$choice" == 8 ] || [ "$choice" == 9 ] || [ "$choice" == 10 ];then
    cleanProject
    if [ "$choice" == 7 ]; then
        flutter build apk --debug
    elif [ "$choice" == 8 ]; then
        flutter build apk --profile
    elif [ "$choice" == 9 ]; then
        flutter build apk
    else
        flutter build appbundle
    fi
elif [ "$choice" == 11 ];then
    cleanProject
    flutter build ipa
else
    echo "Invalid choice"
    exit 1
fi