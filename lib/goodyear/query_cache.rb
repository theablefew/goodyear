module Goodyear
  module QueryCache

    def store
     @query_cache ||= setup_store!
    end

    def cache_query(query)
      cache_key = sha(query)
      Goodyear.force_cache
      result = if store.exist?(cache_key) && Goodyear.force_cache
          ActiveSupport::Notifications.instrument "cache.query.elasticsearch", name: self.name, query: query
          store.fetch cache_key
        else
          res = []
          ActiveSupport::Notifications.instrument "query.elasticsearch", name: self.name, query: query do
            res = yield
          end
          store.write(cache_key, res) if Goodyear.force_cache
          res
        end
      result.dup
    end


    private

    def sha(str)
      Digest::SHA256.new.hexdigest(str)
    end

    def setup_store!
     case Rails.application.config.goodyear_cache_store
     when :redis_store
       ActiveSupport::Cache::RedisStore
     when :memory_store
       ActiveSupport::Cache::MemoryStore
     else
       ActiveSupport::Cache::MemoryStore
     end.new(namespace: 'elasticsearch', expires_in: Rails.application.config.goodyear_expire_cache_in)
    end

  end
end
