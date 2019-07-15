platform :ios, "9.0"
use_frameworks!
source "https://github.com/CocoaPods/Specs.git"


target "PileLayout" do
    pod "SnapKit"
    pod "Then"
end



# disable bitcode in every sub-target
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings["ENABLE_BITCODE"] = "NO"
            config.build_settings["SWIFT_VERSION"] = "4.0"
        end
    end
end
