#
# Be sure to run `pod lib lint nutrition.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'nutrition'
  s.version          = '0.0.1'
  s.summary          = 'nutrition pod is for POC of a algorithms.dependency, this pod will be updated letter.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        This is a demonstration for poc of a algotithm. This pod willbe updated letter now this is it's first commit.
                        DESC

  s.homepage         = 'https://github.com/rhtarora/mealPod'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rohit Arora' => 'upworktinesh@gmail.com' }
  s.source           = { :git => 'https://github.com/rhtarora/MealMate-Swift.git', :tag => s.version.to_s }
  

  s.ios.deployment_target = '9.0'

  s.source_files = 'Classes/**/*.swift'
  s.swift_version = '5.0'
  s.platforms = {
      "ios": "9.0"
  }
#  s.source_files = 'nutrition/Classes/**/*'
  
  # s.resource_bundles = {
  #   'nutrition' => ['nutrition/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Alamofire', '~> 4.4'
  s.dependency 'SwiftyJSON'
end
