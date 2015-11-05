require 'httparty'
require 'csv'

class Job
  attr_reader :title, :location
  def initialize(title, location)
    @title, @location = title, location
  end
end

jobs = []

10.times do |i|
  page_num = i + 1
  result = HTTParty.get("http://careers.stackoverflow.com/jobs?searchTerm=software+engineer&location=94105&range=20&distanceUnits=Miles&pg=" + page_num.to_s)
  titles = result.scan(/<li class=\"employer\">\W+(.*?)\r/).map{|el| el[0]}
  locations = result.scan(/<li class=\"location\">\W+(.*?)\r/).map{|el| el[0].strip}
  titles.zip(locations).each do |title, location|
    jobs << Job.new(title, location)
  end
end


CSV.open("jobs.csv", "wb") do |csv|
  csv << ["Companies Hiring", "Location"]
  jobs.each do |job|
    csv << [job.title, job.location]
  end
end
