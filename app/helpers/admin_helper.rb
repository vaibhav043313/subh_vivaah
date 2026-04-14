# frozen_string_literal: true

module AdminHelper
  def admin_nav_class(name)
    "admin-nav__link#{' is-active' if controller_name == name.to_s}"
  end

  def admin_pagination(page:, total_pages:)
    return if total_pages <= 1

    content_tag(:nav, class: "admin-pagination", aria: { label: "Pagination" }) do
      safe_join([
        (link_to("← Previous", url_for(page: page - 1), class: "admin-pagination__link") if page > 1),
        content_tag(:span, "Page #{page} of #{total_pages}", class: "admin-pagination__meta"),
        (link_to("Next →", url_for(page: page + 1), class: "admin-pagination__link") if page < total_pages)
      ].compact, " ")
    end
  end
end
