require 'json'

module Netflix
  module Error
    class ResponseError < StandardError
      def initialize(body, headers)
        @body = body
        @headers = headers
        body_obj = JSON.parse(body)
        message = body_obj["status"]["message"]
        super(message)
      end
    end
    #4xx level errors
    class ClientError < ResponseError
    end
    #5xx level errors
    class ServerError < ResponseError
    end
    #503 API Temporarily Unavailable
    class Maintenance < ServerError
    end
    #400
    class BadRequest < ClientError
    end
    #403
    class Forbidden < ClientError
    end
    #404
    class NotFound < ClientError
    end
    #401
    class Unauthorized < ClientError
    end
    #420 (?)
    class RateLimit < ClientError
    end
    
    CODEMAP = {400 => BadRequest, 403 => Forbidden, 404 => NotFound, 401 => Unauthorized, 420 => RateLimit, 503 => Maintenance}
    def self.for(response)
      #codemap = {400 => BadRequest, 403 => Forbidden, 404 => NotFound, 401 => Unauthorized, 420 => RateLimit}
      code = response.code.to_i
      (CODEMAP[code] || ResponseError).new(response.body, response.header)
      #codemap[code].new(response.body, response.header)
    end
  end
end