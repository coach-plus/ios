platform :ios, '9.0'

use_frameworks!

def all_pods
  pod 'Locksmith'
  pod 'SkyFloatingLabelTextField', '~> 2.0.0'
  pod 'IQKeyboardManagerSwift', '4.0.6'
  pod 'FontAwesome.swift'
  pod 'Alamofire', '~> 4.4'
  pod 'SwiftyJSON'
  pod 'MBProgressHUD', '~> 1.0.0'
  pod 'RKDropdownAlert'
  pod 'JSONWebToken'
  pod 'Hero'
  pod 'SwiftyUserDefaults'
  pod 'NibDesignable'
  pod 'SwiftDate', '~> 4.0'
  pod 'AlamofireImage', '~> 3.1'
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