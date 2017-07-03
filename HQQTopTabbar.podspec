
Pod::Spec.new do |s|
  s.name             = 'HQQTopTabbar'
  s.version          = '1.0.0'
  s.summary          = 'A short description of HQQTopTabbar.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/huangqiangqiang/HQQTopTabbar'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'huangqiangqiang' => 'huangqiangqiang@lianluo.com' }
  s.source           = { :git => 'https://github.com/huangqiangqiang/HQQTopTabbar.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'HQQTopTabbar/Classes/**/*'

end
