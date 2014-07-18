# roughly a direct port of UICKeychainStore
class RMKeychainStore
  attr_accessor :defaultService, :service, :itemsToUpdate, :accessGroup

  def self.keyChainStoreWithService(service)
    self.alloc.initWithService(service)
  end

  def self.keyChainStoreWithService(service, accessGroup)
    self.alloc.initWithService(service, accessGroup)
  end

  def initialize()
    @defaultService ||= NSBundle.mainBundle.bundleIdentifier
    @service = @defaultService
    self.initWithService(@defaultService)
  end

  def initWithService(service, access_group = nil)
    #super
    if service.nil?
      @service = @defaultService
    else
      @service = service
    end
    @accessGroup = access_group
    @itemsToUpdate = {}
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

  def dataForKey(key, service: service)
    self.dataForKey(key,service:service,accessGroup:nil)
  end

  def dataForKey(key, service: service, accessGroup: accessGroup)
    return nil if key.blank?
    service = @defaultService if service.blank?
    query = {}
    query[KSecClass]       = KSecClassGenericPassword
    query[KSecMatchLimit]  = KSecMatchLimitOne
    query[KSecReturnData]  = KCFBooleanTrue
    query[KSecAttrService] = service
    query[KSecAttrGeneric] = key
    query[KSecAttrAccount] = key

    if !(UIDevice.currentDevice.model =~ /simulator/i).nil?
      NSLog "Don't set access groups for the simulator"
      query[KSecAttrAccessGroup] = accessGroup unless accessGroup.blank?
    end

    data = Pointer.new(:object)
    status = SecItemCopyMatching(query, data)
    if status != ErrSecSuccess
      return nil
    end
    return_data = NSData.dataWithData(data)
    data = nil
    return_data
  end

  def setData(data, forKey: key)
    self.setData(data, forKey: key, service: @default_service, accessGroup: nil)
  end

  def setData(data, forKey: key, service: service)
    self.setData(data, forKey: key, service: service, accessGroup: nil)
  end

  def setData(data, forkey: key, service: service, accessGroup: accessGroup)
    return false if key.blank?
    service ||= @default_service
    query = {}
    query[KSecClass]       = KSecClassGenericPassword
    query[KSecAttrService] = service
    query[KSecAttrGeneric] = key
    query[KSecAttrAccount] = key
    if !(UIDevice.currentDevice.model =~ /simulator/i).nil?
      NSLog "Don't set access groups for the simulator"
      query[KSecAttrAccessGroup] = accessGroup unless accessGroup.blank?
    end
    status = SecItemCopyMatching(query, nil)
    if status == ErrSecSuccess
      if data.nil?
        self.removeItemForKey(key, service: service, accessGroup: accessGroup)
      else
        attributesToUpdate = {}
        attributesToUpdate[KSecValueData] = data
        status = SecItemCopyMatching(query, attributesToUpdate)
        if status != ErrSecSuccess
          return false
        end
      end
    elsif status == ErrSecItemNotFound
      attributes = {}
      attributes[KSecClass]       = KSecClassGenericPassword
      attributes[KSecAttrService] = service
      attributes[KSecAttrGeneric] = key
      attributes[KSecAttrAccount] = key
      if true
        #TODO: The conditional here needs to be replaced with a check to verify
        # we're on iOS, or OSX 10.9 or greater.
        attributes[KSecAttrAccessible] = KSecAttrAccessibleAfterFirstUnlock
      end
      attributes[KSecValueData] = data
      if !(UIDevice.currentDevice.model =~ /simulator/i).nil?
        NSLog "Don't set access groups for the simulator"
        query[KSecAttrAccessGroup] = accessGroup unless accessGroup.blank?
      end
      status = SecItemAdd(attributes, nil)
      if status != ErrSecSuccess
        return nil
      end
    else
      return nil
    end
    true
  end

  def setString(string, forKey: key)
    self.setData(string.dataUsingEncoding(NSUTF8StringEncoding), forKey: key)
  end

  def stringForKey(key)
    data = self.dataForKey(key)
    if data.blank?
      nil
    else
      NSString.alloc.initWithData(data, encoding:NSUTF8StringEncoding)
    end
  end

  def setData(data, forKey: key)
    return nil if key.blank?
    if data.nil?
      self.removeItemForKey(key)
    else
      @items_to_update[key] = data
    end
  end

  def removeItemForKey(key)
    self.removeItemForKey(key, service: @default_service, accessGroup: nil)
  end

  def removeItemForKey(key, service: service)
    self.removeItemForKey(key, service: service, accessGroup: nil)
  end

  def removeItemForKey(key, service: service, accessGroup: accessGroup)
    return false if key.blank?
    service ||= @default_service
    itemsToDelete = {}
    itemsToDelete[KSecClass]       = KSecClassGenericPassword
    itemsToDelete[KSecAttrService] = service
    itemsToDelete[KSecAttrGeneric] = key
    itemsToDelete[KSecAttrAccount] = key
    if !(UIDevice.currentDevice.model =~ /simulator/i).nil?
      NSLog "Don't set access groups for the simulator"
      itemsToDelete[KSecAttrAccessGroup] = accessGroup unless accessGroup.blank?
    end
    status = SecItemDelete(itemToDelete)
    if status != ErrSecSuccess && status != ErrSecItemNotFound
      return false
    end
    true
  end

  def itemsForService(service, accessGroup: accessGroup)
    service ||= @default_service
    query = {}
    query[KSecClass]       = KSecClassGenericPassword
    query[KSecMatchLimit]  = KSecMatchLimitOne
    query[KSecReturnData]  = KCFBooleanTrue
    query[KSecAttrService] = service
    query[KSecAttrGeneric] = key
    query[KSecAttrAccount] = key
    if !(UIDevice.currentDevice.model =~ /simulator/i).nil?
      NSLog "Don't set access groups for the simulator"
      query[KSecAttrAccessGroup] = accessGroup unless accessGroup.blank?
    end
    result = Pointer.new(:object)
    status = SecItemCopyMatching(query, result)
    if status == ErrSecSuccess || status == ErrSecItemNotFound
      result
    else
      nil
    end
  end

  def removeAllItems
    self.removeAllItemsForService(@default_service, accessGroup: nil)
  end

  def removeAllItemsForService(service)
    self.removeAllItemsForService(service, accessGroup: nil)
  end

  def removeAllItemsForService(service, accessGroup: accessGroup)
    items = self.itemsForService(service, accessGroup: accessGroup)
    items.each do |item|
      itemToDelete = NSMutableDictionary.alloc.initWithDictionary(item)
      itemToDelete[KSecClass] = KSecClassGenericPassword
    end
    status = SecItemDelete(itemToDelete)
    if status != ErrSecSuccess
      return false
    end
    return true
  end

  def removeItemForKey(key)
    if @items_to_update[key]
      @items_to_update.remove!(key)
    else
      self.removeItemForKey(key, service: service, accessGroup: accessGroup)
    end
  end

  def removeAllitems
    @items_to_update = {}
    self.removeAllItemsForService(service, accessGroup: accessGroup)
  end

  def synchronize
    @items_to_update.each do |item|
      self.setData(@items_to_update[key], forKey: key, service: @service)
    end
    @items_to_update = {}
  end

  def description
    items = self.itemsForService(service, accessGroup: @access_group)
    list = {}
    items.each do |attributes|
      attrs = {}
      attributes[KSecAttrService] = "Service"
      attributes[KSecAttrAccount] = "Account"
      if !(UIDevice.currentDevice.model =~ /simulator/i).nil?
        NSLog "Don't set access groups for the simulator"
        attributes[KSecAttrAccessGroup] = "AccessGroup"
      end
      attributes[KSecValueData] = attributes
      string = NSString.alloc.initWithData(data, encoding:NSUTF8StringEncoding)
      if string
        attrs['Value'] = string
      else
        attrs['Value'] = data
      end
      list.merge!(attrs)
    end
    list
  end
end
