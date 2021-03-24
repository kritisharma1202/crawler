require 'nokogiri'
require 'open-uri'

namespace :scraper do
  desc "TODO"
  task site: :environment do
    site_url='https://bbc.co.uk'
    base_url='https://bbc.co.uk'
    domain=base_url.split('//').second
    scrape_urls(site_url,base_url,domain)
    scraped_links=ScrapedLink.where("link LIKE ? AND is_scraped=false","#{base_url}%")
    loop do
      scraped_links.each do |scraped_link|
        site_url=scraped_link.link
        scrape_urls(site_url,base_url,domain)
        scraped_link.update(is_scraped: true)
      end
      scraped_links=ScrapedLink.where("link LIKE ? AND is_scraped=false","#{base_url}%")
      breake unless scraped_links.present?
    end
  end

end

def scrape_urls(site_url,base_url,domain)
  doc = Nokogiri::HTML(URI.open(site_url))
  tags = doc.xpath("//a")

  tags.each do |tag|
    url=tag.attributes["href"].try(:value)
    txt=tag.children.try(:text)

    if url.present? && txt.present? && !url.start_with?('#')
      if url.start_with?('/')
        url=base_url+url
      elsif url.include?(domain)
        url=url.split(domain).last
        url=base_url+url
      end
      link_obj=ScrapedLink.create(title: txt, link: url)
      puts link_obj.inspect
    end
  end

end
