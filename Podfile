# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Callive' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Alamofire'
  pod 'ZKProgressHUD'
  pod 'IQKeyboardManagerSwift'
  pod 'SDWebImage'
  
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.6'
            config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
        end
    end
end

