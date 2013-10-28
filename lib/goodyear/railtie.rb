module Goodyear
  class Railtie < Rails::Railtie
    ActiveSupport::Notifications.subscribe 'query.elasticsearch' do |name, start, finish, id, payload|
      Rails.logger.debug(["#{payload[:name]}".bright, "(#{((finish.to_time - start.to_time) * 1000).to_s(:rounded, precision: 5, strip_insignificant_zeros: true)}ms)",payload[:query], id].join(" ").color(:yellow))
    end 

    ActiveSupport::Notifications.subscribe 'cache.query.elasticsearch' do |name, start, finish, id, payload|
      Rails.logger.debug(["#{payload[:name]}".bright, "CACHE".color(:magenta).bright ,"(#{((finish.to_time - start.to_time) * 1000).to_s(:rounded, precision: 5, strip_insignificant_zeros: true)}ms)",id].join(" ").color(:yellow))
    end

    initializer 'goodyear.set_defaults' do
      config.goodyear_cache_store = :redis_store
      config.goodyear_expire_cache_in = 1.minute
    end

  end

end
