class YaMemCacheStore < ActiveSupport::Cache::MemCacheStore

  TABLE_NAME = "yamemcachestore.table"
  LOCK_NAME = "yamemcachestore.lock"
  LOCK_TIMEOUT = 5

  attr_accessor :ttl, :lock_timeout
  
  def initialize(*args)
    options = (args.last.is_a?(Hash)) ? args.last : { }
    self.ttl = options.delete(:ttl) || 0    
    self.lock_timeout = options.delete(:lock_timeout) || YaMemCacheStore::LOCK_TIMEOUT
    
    super(*args)
    
    unless @data.get(YaMemCacheStore::TABLE_NAME)
      self.storage_table= { }
    end
    
  end

  # write a given entry to the memcache store
  # pass :with_lock if you wish to lock the key while
  # writing
  # pass :lock_timeout if you wish to use a specific
  # lock timeout with your given write lock
  # 
  def write(key, value, options = nil)
    options ||= { }
    options[:expires_in] ||= self.ttl
    no_table_entry = options.delete(:no_table_entry)
    if with_lock = options.delete(:with_lock)
      lock_timeout = options.delete(:lock_timeout)
      if lock(key, lock_timeout)
        response = super(key, value, options)
        unlock(key)
      end
    else
      response = super(key, value, options)
    end
    unless no_table_entry
      add_to_table(key)
    end
    return response 
  end


  # deletes any keys that match the given regex
  # you may pass ignore_locks to this function if
  # you wish to ignore any existing locks
  def delete_matched(matcher, options = nil)
    options ||= { }
    ignore_locks = options.delete(:ignore_locks)
    table = self.storage_table
    toremove = []
    self.storage_table= table.delete_if do |k, v|
      if k =~ matcher
        self.delete(k, :ignore_locks => ignore_locks)
        toremove << k
        true
      end
    end
    return toremove
  end

  # deletes a given entry, unless a lock currently exists for it
  # if you pass :ignore_locks to this method, any existing locks
  # will be deleted along with the value itself
  def delete(key, options = nil)
    options ||= { }
    ignore_locks = options.delete(:ignore_locks)
    has_lock = lock_exists?(key)
    if ignore_locks && has_lock
      unlock(key)
    end
    if ignore_locks || !has_lock
      resp = super(key, options)
    else
      return false
    end
  end

  # locks a given memcache entry
  # second parameter is the time in seconds a lock
  # will be valid; if nil, the default value for the
  # class will be used, which may be specified at initialization
  # if no value was specified, the amount is 5 seconds
  def lock(key, timeout = nil)
    @data.add(lock_for(key),
              1,
              YaMemCacheStore::LOCK_TIMEOUT,
              false)
  end


  # unlocks a given memcache entry
  def unlock(key)
    @data.delete(lock_for(key))
  end

  protected

  def lock_for(key)
    "#{key}.#{YaMemCacheStore::LOCK_NAME}"
  end

  def lock_exists?(key)
    !@data.get(lock_for(key)).nil?
  end

  def add_to_table(key)
    table = self.storage_table
    unless table[key]
      table[key] = true      
      if lock(key)
        self.storage_table= table
        unlock(key)
      end
    end
  end

  def storage_table()
    @data.get(YaMemCacheStore::TABLE_NAME) || { }
  end

  def storage_table=(t)
    self.write(YaMemCacheStore::TABLE_NAME,
               t,
               :expires_in => 0,
               :no_table_entry => true,
               :with_lock => true)
  end


end
