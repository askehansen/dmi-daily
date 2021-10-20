class Comment < ApplicationRecord
  BASE = "https://www.dmi.dk/"
  URL = "https://www.dmi.dk/meteorologens-kommentar/"
  
  def self.latest
    order(created_at: :desc).first
  end

  def self.fetch
    response = HTTP.get(URL)
    html = Oga.parse_html(response.body)
    
    comment = new
    comment.title = html.at_css(".csc-header h1").text.strip
    comment.body = parse_body(html.at_css(".article-content-old"))

    comment
  end

  def self.parse_body(body)
    body.css("img").each do |img|
      src = img.attribute("src").value

      img.attribute("src").value = if src.starts_with?("/")
        src.gsub(/\A\//, BASE)
      elsif src.starts_with?("http")
        src
      else
        "#{URL}#{src}"
      end
    end

    body.to_s
  end

  def same_as?(other)
    return false unless other
    [title, body] == [other.title, other.body]
  end

end