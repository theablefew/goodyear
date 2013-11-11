module Goodyear
  module QueryCache

    def store
     @query_cache ||= setup_store!
    end

    def cache_query(query)
      result =
        if store.exist? query && Rails.application.config.goodyear_perform_caching
          ActiveSupport::Notifications.instrument "cache.query.elasticsearch", name: self.name
          store.fetch query
        else
          res = yield
          store.write(query, res) if Rails.application.config.goodyear_perform_caching
          res
        end
      result.dup
    end

    private

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
