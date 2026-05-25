require 'feedjira'
require 'fileutils'
require 'net/http'
require 'uri'
require 'nokogiri'  # Adicionado para parsing HTML
require 'open-uri'  # Adicionado para fetching páginas

feed_url = 'https://geoengineeringwatch.org/feed/'  # Feed válido

def yaml_quote(value)
  string = value.to_s
  string = string.gsub('\\', '\\\\').gsub('"', '\\"')
  "\"#{string}\""
end

def slugify(text)
  text.to_s.downcase
      .gsub(/[^a-z0-9\s-]/, '')
      .gsub(/\s+/, '-')
      .gsub(/-+/, '-')
      .gsub(/\A-|-\z/, '')
end

def fetch_content(url, max_redirects = 5)
  raise ArgumentError, 'Muitos redirecionamentos' if max_redirects == 0
  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = (uri.scheme == 'https')
  request = Net::HTTP::Get.new(uri)
  request['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
  response = http.request(request)

  if [301, 302].include?(response.code.to_i)
    location = response['location']
    puts "Redirecionando para: #{location}"
    return fetch_content(location, max_redirects - 1)
  end

  unless response.code == '200'
    raise "Erro HTTP: #{response.code} - #{response.message}"
  end

  unless response.content_type.include?('xml') || response.content_type.include?('rss') || response.content_type.include?('atom')
    raise "Tipo de conteúdo inválido: #{response.content_type}"
  end

  response.body
end

def fetch_full_details(page_url)
  begin
    doc = Nokogiri::HTML(URI.open(page_url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'))
    content = doc.css('.article-content').inner_html.strip  # Seletor para corpo principal; ajuste se necessário
    content.empty? ? nil : content
  rescue => e
    puts "Erro ao fetch detalhes de #{page_url}: #{e.message}"
    nil
  end
end

begin
  content = fetch_content(feed_url)
  feed = Feedjira.parse(content)
  feed.entries.each do |entry|
    full_details = fetch_full_details(entry.url)  # Fetch detalhes completos
    body = ""
    body += "#{entry.summary}\n\n" if entry.summary  # Adiciona summary como intro
    body += full_details if full_details  # Adiciona detalhes completos
    body = entry.summary if body.empty?  # Fallback se nada disponível

    slug = slugify(entry.title)
    slug = 'rss-entry' if slug.empty?
    filename = "_posts/#{entry.published.strftime('%Y-%m-%d')}-#{slug}.md"
    FileUtils.mkdir_p(File.dirname(filename))
    front_matter = <<~YAML
      ---
      layout: page
      title: #{yaml_quote(entry.title)}
      date: #{entry.published}
      website: #{yaml_quote(entry.url)}
      categories: [rss]
      tags: [rss]
      image:
        path: 'assets/solid/rss.svg'
      faicon: fa-rss
      ---
    YAML
    File.write(filename, "#{front_matter}\n#{body}\n\n[<i class='fas fa-link'></i>Link](#{entry.url})")
  end
  puts "Importação concluída. #{feed.entries.size} entradas processadas."
rescue Feedjira::NoParserAvailable => e
  puts "Erro de parsing: #{e.message}. Conteúdo não é XML válido. Trecho:"
  puts content[0..500]
rescue => e
  puts "Erro: #{e.message}"
end
