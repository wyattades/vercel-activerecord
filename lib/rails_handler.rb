class Request
  def initialize(req)
    @req = req
  end

  def headers
    @req
  end

  def query
    @req.query
  end

  def body
    @req.body
  end
end

class Response
  def initialize(res)
    @res = res
  end

  def headers
    @res
  end

  def set_header(k, v)
    @res[k] = v
  end
end

module HandlerMethods
  def init_vars(req, res)
    @req = req
    @res = res
    @params = @request = @response = nil
  end

  def params
    @params ||=
      begin
        params = @req.query.dup
        if @req.content_type&.include?('application/json')
          json_body =
            begin
              @req.body&.then(&JSON.method(:parse))
            rescue StandardError
              nil
            end
          puts 'DEBUG json_body:', json_body
          params.merge!(json_body) if json_body.is_a?(Hash)
        end

        puts 'DEBUG params:', params
        puts 'DEBUG query:', @req.query
        puts 'DEBUG body:', @req.body

        params
      end
  end

  def request
    @request ||= Request.new(@req)
  end

  def response
    @response ||= Response.new(@res)
  end

  def render(html: nil, text: nil, json: nil, status: 200)
    ct, body = nil, nil
    if !json.nil?
      ct = :json
      body = json.to_json
    elsif !text.nil?
      ct = :plain
      body = text
    elsif !html.nil?
      ct = :html
      body = html
    end

    @res['Content-Type'] = content_type_header(ct)
    @res.status = status
    @res.body = body
  end

  def render_error(error, status: 500)
    STDERR.puts 'render_error:', error

    case content_type_sym
    when :json
      render json: { message: err.message }, status: status
    when :html
      render html:
               "<html><body><h1>Error #{status}</h1><p>#{err.message}</p></body></html>",
             status: status
    when :text
      render text: err.message, status: status
    end
  end

  ContentTypes = {
    json: 'application/json',
    text: 'text/plain',
    html: 'text/html',
  }

  private def content_type_sym
    ct = @req.content_type
    if ct
      HandlerMethods::ContentTypes.each { |k, v| return k if ct.include?(v) }
    end
    :html
  end

  private def content_type_header(sym)
    HandlerMethods::ContentTypes[sym] | HandlerMethods::ContentTypes[:html]
  end
end

def init_handler
  self.extend HandlerMethods

  self.class.const_set(
    :Handler,
    Proc.new do |req, res|
      init_vars(req, res)

      begin
        handler
      rescue => err
        render_error(err)
      end
    end,
  )
end
