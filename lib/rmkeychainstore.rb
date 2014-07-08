# roughly a direct port of UICKeychainStore
class RMKeychainStore
  attr_accessor :default_service, :service, :items_to_update

  def self.keyChainStoreWithService(service)
    self.alloc.initWithService(service)
  end

  def self.keyChainStoreWithService(service, accessGroup)
    self.alloc.initWithService(service, accessGroup)
  end

  def initialize()
    @default_service ||= NSBundle.mainBundle.bundleIdentifier
    self.initWithService(@default_service)
  end

  def initWithService(service)
    self.initWithService(service, nil)
  end

  def initWithService(service, access_group)
    super
    @service = @defalt_service if service.nil?
    @items_to_update = {}
    self
  end

  def stringForKey(key)
    self.stringForKey(key, service: self.defaultService, accessGroup: nil)
  end

  def stringForKey(key, service: service)
    self.stringForKey(key,service:service,accessGroup:nil)
  end

  def stringForKey(key, service:service, accessGroup: accessGroup)
    if self.dataForKey(key, service: service, accessGroup: accessGroup)
      NSString.alloc.initWithData(data, encoding:NSUTF8StringEncoding)
    else
      nil
    end
  end

  def setString(value, forKey: key)
    self.setString(value, forKey:key, service:self.defaultService, accessGroup:nil)
  end

  def setString(value, forKey:key, service:service )
    self.setString(value, forKey: key, service: service, accessGroup:nil)
  end

  def setString(value, forKey: key, service: service, accessGroup: accessGroup)
    data = value.dataUsingEncoding(NSUTF8StringEncoding)
    self.setData(data,forKey:key,service:service,accessGroup:accessGroup)
  end

  def dataForKey(key)
    self.dataForKey(key,service:self.defaultService,accessGroup:nil)
  end

  def dataForKey(key, service: service,
    self.dataForKey(key,service:service,accessGroup:nil)
  end

  def dataForKey(key, service: service, accessGroup: accessGroup)
    return nil if key.blank?
    service = @defaultService if service.blank?
    query = {}

    query[KSecClass] = self.class.sec_class
    query.setObject((__bridge id)KSecClassGenericPassword,forKey:(__bridge id)KSecClass)
    query.setObject((__bridge id)KCFBooleanTrue,forKey:(__bridge id)KSecReturnData)
    query.setObject((__bridge id)KSecMatchLimitOne,forKey:(__bridge id)KSecMatchLimit)
    query.setObject(service,forKey:(__bridge id)KSecAttrService)
    query.setObject(key,forKey:(__bridge id)KSecAttrGeneric)
    query.setObject(key,forKey:(__bridge id)KSecAttrAccount)
    #if !TARGET_IPHONE_SIMULATOR   && defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    unless accessGroup.blank?
      query.setObject(accessGroup,forKey:(__bridge id)KSecAttrAccessGroup)
    end
    #endif
    data = nil
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &data)
    if status != errSecSuccess
      return nil
    end
    ret = NSData.dataWithData((__bridge NSData *)data)
    if data
      CFRelease(data)
    end
    return ret
  end

end
