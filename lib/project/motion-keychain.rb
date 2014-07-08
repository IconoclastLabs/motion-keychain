class MotionKeychain
  class << self
    SERVICE = NSBundle.mainBundle.bundleIdentifier
    STORE = UICKeyChainStore.keyChainStoreWithService(SERVICE)

    def store
      STORE
    end

    def get(key)
      STORE.stringForKey(key.to_s)
    end

    def set(key, value)
      STORE.setString(value, forKey: key.to_s)
      STORE.synchronize
      {key: value}
    end

    def remove(key)
      STORE.removeItemForKey(key.to_s)
      STORE.synchronize
      true
    end
  end
end
