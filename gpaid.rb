require 'rubygems'
require 'mechanize'
require 'pp'
require 'json'
require 'uri/http'
require 'whois'
require 'public_suffix'

agent = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}

page = agent.get('http://localhost:8000/paid.html')

page_links = []
page.links.each do |link|
      cls = link.attributes.attributes['class']
      page_links << link if cls && cls.value == 'title'
end

apps = []

page_links.each do |app_link|
    begin
        app = app_link.click
        title = app.search('.document-title')
        subtitle = app.search('.primary')
        installs = app.search('.content')[2].text.strip
        score = app.search('.score')
        email = app.link_with(:text => "Email Developer")
        devSite = app.link_with(:text => "Visit Developer's Website")

        company = Hash.new
        company[:title] = title.text.strip
        company[:subtitle] = subtitle.text.strip
        company[:score] = score.text.strip
        company[:email] = email.href.strip
        company[:site] = devSite.href.strip
        company[:installs] = installs
        company[:type] = 'Paid'

        begin
            d = company[:email].split('@')[1]
            uri = URI.parse(d)
            domain = PublicSuffix.parse(d)
            domain = domain.domain.to_s
            w = Whois.whois(domain)
            p = w.parser
            admin = p.admin_contacts
            registrant = p.registrant_contacts
            company[:admin_phone] = admin[0].phone
            company[:registrant_phone] = registrant[0].phone
            #app[:number] = admin[0].email || registrant[0].email 
        rescue
        end


        apps << company
    rescue
    end
end

File.open('gpaid.json', 'w') do |f|
    f.write(apps.to_json)
end
