module Netflix
  module ResponseErrorDecorator
    def get(*args)
      response = super(*args)
      response_or_raise_error(response)
    end
    def delete(*args)
      response = super(*args)
      response_or_raise_error(response)
    end
    def post(*args)
      response = super(*args)
      response_or_raise_error(response)
    end
    def put(*args)
      response = super(*args)
      response_or_raise_error(response)
    end
    
    private
    def response_or_raise_error(response)
      if response && response.is_a?(Net::HTTPSuccess)
        response
      else
        raise Error.for(response)
      end
    end
  end
end