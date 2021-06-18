# coding: utf-8
require 'net/http'
require 'uri'
require 'json'

class Sbpub

  attr_accessor :sid
  attr_accessor :json
  attr_accessor :export_from, :publish_to
  attr_accessor :for_publish

  def initialize
    @sid = nil
    @json = nil
    @export_from = 'hkondo'
    @publish_to = 'import-test-dev'
    @csrf_token = nil
    @publish_tag = '#publish_to'
    @nopub_tag = '#no_publish'
    @root = 'https://scrapbox.io'
    @for_publish = []
  end

  def __get_request (path)
    url = "#{@root}#{path}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = url.start_with?('https') ? true : false
    req = Net::HTTP::Get.new(uri.request_uri)
    req.add_field('Cookie', "connect.sid=#{@sid};")
    res = http.request(req)
    return res
  end

  def __post_request (path, name, value, filename, type)
    url = "#{@root}#{path}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = url.start_with?('https') ? true : false
    req = Net::HTTP::Post.new(uri.request_uri)

    data = [ [ 'import-file', value, { filename: 'importing.json' } ] ]
    req.set_form(data, "multipart/form-data")

    req.add_field('Cookie', "connect.sid=#{@sid};")
    req.add_field('X-CSRF-TOKEN', @csrf_token)
    res = http.request(req)
    return res
  end

  def _update_csrf_token
    r = __get_request('/api/users/me')
    if r.code == '200'
      @csrf_token = JSON.parse(r.body)['csrfToken']
    else
      # TODO: reset old @csrf_token and raise runtime error.
    end
    @csrf_token
  end

  def _export_all_pages_from
    r = __post_request("/api/page-data/export/#{@export_from}.json",
                       '', '', '', ''
                      )
    if r.code == '200'
      @json = r.body
    else
      # TODO: raise runtime error.
    end
  end

  def _publish_extracted_pages_to
    pages = { 'pages' => @for_publish }
    json = JSON.pretty_generate(pages)
    r = __post_request("/api/page-data/import/#{@publish_to}.json",
                       'import-file', json, 'importing.json',
                       'application/json'
                      )
    if r.code == '200'
      #
    else
      # TODO: raise runtime error.
      puts r.code
      puts r.message
      puts r.body
      exit
    end
  end

  def _extract_to_publish
    # @publish_tag が含まれ，かつ @nopub_tag が含まれていない page を
    # for_publish につなぐ
    project = JSON.parse(@json)
    project['pages'].each do |page|
      to_publish = false
      page['lines'].each do |line|
        lx = { :project => project,
               :page    => page,
               :line    => nil
             }
        if line.kind_of? String
          # if line is String, it is only a text content.
          lx[:text] = line
        elsif line.kind_of? Hash
          # line is Hash, it contains not only text content,
          # but created and updated meta data.
          lx[:text] = line['text']
          lx[:created] = line['created']
          lx[:updated] = line['updated']
        else
          # TODO: broken or unknown format of json.
          # TODO: raise runtime error.
        end
        to_publish = true if lx[:text].include?(@publish_tag)
        if lx[:text].include?(@nopub_tag)
          # @nopub_tag が含まれているので，このページは publish しては
          # ならないことが確定する．これ以上はページを評価しなくてよい．
          to_publish = false
          break
        end
      end
      if to_publish
        @for_publish << page
      end
    end
  end

end
