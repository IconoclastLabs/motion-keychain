# motion-keychain

#### Securely store data in RubyMotion.

The motion-keychain gem is a simple wrapper for Keychain on iOS and OS X. Makes using Keychain APIs as easy as NSUserDefaults.

## Installation

Add this line to your application's Gemfile:

    gem 'motion-keychain'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install motion-keychain

## Usage

Store secure data:
```ruby
  # Storing securely under key 'password'
  MotionKeychain.set('password', @password.text)
```

Retrieve secure data:
```ruby
  # Retreiving 'password' content from keychain
  @password.text = MotionKeychain.get('password')
```

Wipe secure data:
```ruby
  # User is logging out
  MotionKeychain.remove('password')
```


## TODO

* Remove cocoapod dependency and move to pure RubyMotion implementation.
* Automatically add the correct app entitlements.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
