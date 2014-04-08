require 'pp'
require 'json'

companies = JSON.parse(IO.read('merged.json'))

merged = []

def find haystack, company
    haystack.each do |c|
        if c["company"].eql?(company["company"])
            return c
        end
    end
    return nil
end

companies.each do |company|
    theCompany = find(merged, company)
    if not theCompany.nil?

        #add the apps in
        theCompany['apps'] = theCompany['apps'] + company['apps']
    else
        #create a new 
        merged << company
    end
end

File.open('global_merged.json', 'w') do |f|
    f.write(merged.to_json)
end
