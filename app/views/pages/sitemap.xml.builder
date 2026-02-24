xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  @static_paths.each do |path|
    xml.url do
      xml.loc url_for(path)
      xml.changefreq "weekly"
      xml.priority(path == root_path ? "1.0" : "0.7")
    end
  end

  @services.each do |service|
    xml.url do
      xml.loc service_url(service)
      xml.lastmod service.updated_at&.strftime("%Y-%m-%d")
      xml.changefreq "weekly"
      xml.priority "0.8"
    end
  end

  @jobs.each do |job|
    xml.url do
      xml.loc job_url(job)
      xml.lastmod job.updated_at&.strftime("%Y-%m-%d")
      xml.changefreq "daily"
      xml.priority "0.8"
    end
  end

  @tips.each do |tip|
    xml.url do
      xml.loc tip_url(tip)
      xml.lastmod tip.updated_at&.strftime("%Y-%m-%d")
      xml.changefreq "monthly"
      xml.priority "0.6"
    end
  end
end
