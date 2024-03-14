#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint native_code.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'llama_cpp_dart'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter FFI plugin project.'
  s.description      = <<-DESC
A new Flutter FFI plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.compiler_flags = '-fPIC -O3','-pthread','-fno-objc-arc','-Ofast','-DGGML_USE_METAL', '-DGGML_USE_ACCELERATE', '-DACCELERATE_NEW_LAPACK','-DACCELERATE_LAPACK_ILP64'
  s.frameworks = 'Foundation','Accelerate','Metal','MetalKit','MetalPerformanceShaders'
  s.resource_bundles = {
    'llama_cpp_dart' => ['ggml-metal.metal']
  }
  s.dependency 'FlutterMacOS' 
  s.library = 'c++'
  s.platform = :osx, '12'
  s.public_header_files = 'Classes/../../src/llama.cpp/**/*.h'
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES',
    'HEADER_SEARCH_PATHS' => '"${SRCROOT}/../../llama_cpp_dart/src/llama.cpp/"'
  }
  s.swift_version = '5.9'
end
