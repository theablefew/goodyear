module Tire
  class Index
    def store(*args)
      document, options = args

      id       = get_id_from_document(document)
      type     = get_type_from_document(document)
      index    = get_index_from_document(document)
      document = convert_document_to_json(document)

      options ||= {}
      params    = {}

      if options[:percolate]
        params[:percolate] = options[:percolate]
        params[:percolate] = "*" if params[:percolate] === true
      end

      params[:parent]  = options[:parent]  if options[:parent]
      params[:routing] = options[:routing] if options[:routing]
      params[:replication] = options[:replication] if options[:replication]
      params[:version] = options[:version] if options[:version]

      params_encoded = params.empty? ? '' : "?#{params.to_param}"

      url_with_index = index.blank? ? self.url : self.url.gsub(name, index)
      url  = id ? "#{url_with_index}/#{type}/#{Utils.escape(id)}#{params_encoded}" : "#{url_with_index}/#{type}/#{params_encoded}"

      @response = Configuration.client.post url, document
      MultiJson.decode(@response.body)
    ensure
      curl = %Q|curl -X POST "#{url}" -d '#{document}'|
      logged([type, id].join('/'), curl)
    end


    def get_index_from_document(document)
      ind = case
        when document.is_a?(Hash)
          document[:_index] || document['_index']
        when document.respond_to?(:_index)
          document._index rescue nil
      end

      return ind if ind.to_s != @name.to_s
    end

  end
end
