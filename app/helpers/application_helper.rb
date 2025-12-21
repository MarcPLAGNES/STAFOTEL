module ApplicationHelper
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
end
