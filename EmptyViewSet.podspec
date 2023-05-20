#
# Be sure to run `pod lib lint EmptyViewSet.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'EmptyViewSet'
    s.version          = '0.1.1'
    s.summary          = '空数据视图'
    
    s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC
    
    s.homepage         = 'https://github.com/kaioser/EmptyViewSet'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'yangxiongkai' => 'yangxiongkai@126.com' }
    s.source           = { :git => 'https://github.com/kaioser/EmptyViewSet.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '13.0'
    s.swift_version = '5.0'
    s.source_files = 'EmptyViewSet/Classes/**/*'    
    s.frameworks = 'Network'
    
end
