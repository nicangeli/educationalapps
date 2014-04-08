require 'pp'
require 'json'

companies = JSON.parse(IO.read('merged.json'))


def find haystack, needle
    found = []
    haystack.each do |c|
        if c["title"].eql?(needle["title"])
            found << c
        end
    end
    return found
end


companies.each do |company|
    apps = company["apps"]
    apps.each do |app|
        found = find(apps, app)
        if found.length > 1
            app['stores'] = ['google', 'ios']
        end
        apps.delete(found[1])
    end
end


File.open('global_merged.json', 'w') do |f|
    f.write(companies.to_json)
end
