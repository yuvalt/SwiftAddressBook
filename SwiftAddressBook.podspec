Pod::Spec.new do |s|
  s.name             = "SwiftAddressBook"
  s.version          = "0.6.2"
  s.summary          = "Strong Typed ABAddressBook wrapper written in Swift 2.0"
  s.description      = <<-DESC
                       It is tedious and requires very much reading in the documentation if you want to understand the ABAddressBook in iOS. To provide a solution, this wrapper uses Swift, which is strong-typed (unlike c). It also circumvents the use of unsafe c-pointers when accessing ABAddressBook from Swift, by directly casting them to the correct type. All properties, previously only available via the correct key, can now be accessed conveniently via variables.
                       DESC
  s.homepage         = "https://github.com/SocialbitGmbH/SwiftAddressBook"
  s.license          = 'Apache 2.0'
  s.author           = { "Tassilo Karge" => "tassilo.karge@socialbit.de" }
  s.source           = { :git => "https://github.com/SocialbitGmbH/SwiftAddressBook.git", :tag => s.version }
  s.social_media_url = 'https://twitter.com/socialbit_de'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.module_name = 'SwiftAddressBook'
  s.source_files = 'Pod/Classes/**/*'

  s.frameworks = ['AddressBook', 'AddressBookUI']
end
