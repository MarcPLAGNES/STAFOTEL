module ApplicationHelper
  def business_name
    DEFAULT_META["business_name"].presence || "STAFOTEL"
  end

  def business_type
    DEFAULT_META["business_type"].presence || "LocalBusiness"
  end

  def meta_title
    base = @meta_title || DEFAULT_META["meta_title"]
    brand = "STAFOTEL"
    base&.include?(brand) ? base : [base, brand].compact.join(" | ")
  end

  def meta_description
    @meta_description || DEFAULT_META["meta_description"]
  end

  def meta_image
    @meta_image || DEFAULT_META["meta_image"]
  end

  def facebook_page
    @facebook_page || DEFAULT_META["facebook_page"]
  end

  def instagram_profile
    @instagram_profile || DEFAULT_META["instagram_profile"]
  end

  def local_business_schema
    same_as_urls = [facebook_page, instagram_profile].select(&:present?)

    schema = {
      "@context" => "https://schema.org",
      "@type" => business_type,
      "name" => business_name,
      "url" => canonical_url.presence || request&.base_url,
      "image" => meta_image_url,
      "description" => meta_description,
      "telephone" => DEFAULT_META["business_phone"],
      "email" => DEFAULT_META["business_email"],
      "address" => {
        "@type" => "PostalAddress",
        "streetAddress" => DEFAULT_META["business_street"],
        "postalCode" => DEFAULT_META["business_postal_code"],
        "addressLocality" => DEFAULT_META["business_city"],
        "addressCountry" => DEFAULT_META["business_country"]
      },
      "areaServed" => DEFAULT_META["business_area_served"],
      "sameAs" => same_as_urls
    }

    if schema["address"].values.excluding("PostalAddress").all?(&:blank?)
      schema.delete("address")
    end

    schema.delete("sameAs") if same_as_urls.empty?
    schema.compact
  end

  def canonical_url
    return "" unless request

    uri = URI.parse(request.original_url)
    uri.query = nil
    uri.fragment = nil
    uri.to_s
  end

  def meta_image_url
    image_path = meta_image
    return "" if image_path.blank?

    return image_path if image_path.start_with?("http://", "https://")

    return "" unless request

    URI.join(request.base_url, image_path).to_s
  end
end
