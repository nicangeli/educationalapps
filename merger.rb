require 'pp'
require 'json'
require 'io/console'

merged = JSON.parse(IO.read('merged.json'))

google = JSON.parse(IO.read('google.json'))

gapps = []

def search haystack, needle
    haystack.each do |a|
        if a['subtitle'].eql?(needle)
            return true
        end
    end
    return false
end

def get haystack, needle
    haystack.each do |a|
        if a[:company].eql?(needle)
            return a
        end
    end
end

google.each do |app|
    unless search(merged, app['subtitle'])
        a = {}
        a[:company] = app['subtitle']
        a[:email] = app['email']
        a[:apps] = []
        merged << a
    end
end

google.each do |app|
    company = get(merged, app['subtitle'])
    company[:apps].push(app)
end

File.open('merged2.json', 'w') do |f|
    f.write(merged.to_json)
end

#ios.each do |app|
 #   unless search(merged, app['author'])
 #       a = {}
 #       a[:company] = app['author']
 #       a[:email] = app['email']
 #       a[:apps] = []
 #       apple_apps << a
 #   end
#end

#ios.each do |app|
#    company = get(apple_apps, app['author'])
#    company[:apps].push(app)
#end

#File.open('merged.json', 'w') do |f|
#    f.write(apple_apps.to_json)
#end

