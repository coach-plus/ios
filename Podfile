platform :ios, '10.0'

use_frameworks!

def all_pods
  pod 'Locksmith'
  pod 'SkyFloatingLabelTextField', '~> 3.7.0'
  pod 'IQKeyboardManagerSwift'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'MBProgressHUD', :git => 'https://github.com/ph4r05/MBProgressHUD.git', :branch => 'master'
  pod 'NotificationBannerSwift'
  pod "JWTDecode"
  pod 'Hero'
  pod 'SwiftyUserDefaults'
  pod 'NibDesignable', :git => 'https://github.com/dzzh/NibDesignable.git', :branch => 'great-swift4'
  pod 'SwiftDate'
  pod 'DZNEmptyDataSet'
  pod 'ImagePicker'
  pod 'XLPagerTabStrip'
  pod 'SwiftIcons'
  pod 'RSKImageCropper'
  pod 'TextFieldEffects'
  pod 'MMDrawerController'
  pod "PromiseKit"
  pod 'Kingfisher', '~> 5.3.1'
  pod 'RxSwift',    '~> 5.1.0'
  pod 'RxCocoa',    '~> 5.1.0'
  pod 'Eureka', '~> 4.3.1'
  pod 'SwiftGen', '~> 6.0'
  pod 'YPImagePicker'
  pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '4.3.1'
  pod 'DatePickerDialog', '~> 3.0'
end

target 'CoachPlus' do
  all_pods

  target 'CoachPlusTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CoachPlusUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'CoachPlusDev' do
  all_pods
end

target 'CoachPlusBeta' do
  all_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['SwiftIcons', 'NibDesignable', 'ImagePicker'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
    
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-CoachPlus/Pods-CoachPlus-acknowledgements.plist', 'Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
    installer.aggregate_targets.each do |aggregate_target|
      aggregate_target.xcconfigs.each do |config_name, config_file|
        xcconfig_path = aggregate_target.xcconfig_path(config_name)
        config_file.save_as(xcconfig_path)
      end
    end
end
