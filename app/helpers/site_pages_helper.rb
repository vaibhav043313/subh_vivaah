# frozen_string_literal: true

module SitePagesHelper
  def site_page_shell_class
    "min-h-screen flex flex-col bg-[var(--color-bg)]"
  end

  def site_page_main_class
    "flex-1 py-6 pb-12"
  end

  def site_page_title_class(mb: "mb-2")
    "#{mb} text-[clamp(1.5rem,3vw,2rem)] font-bold tracking-tight text-neutral-950".squish
  end

  # Use `mb:` when the default bottom margin (mb-7) should change — avoids conflicting Tailwind utilities.
  def site_page_lead_class(mb: "mb-7")
    "#{mb} max-w-xl leading-relaxed text-[var(--color-muted)]".squish
  end

  def site_prose_card_class
    "card max-w-2xl p-6 text-[15px] leading-[1.65] text-neutral-700 sm:px-[1.65rem] " \
      "[&_h2]:mt-7 [&_h2]:mb-2.5 [&_h2]:text-lg [&_h2]:font-bold [&_h2]:text-neutral-950 " \
      "[&_p]:mb-4 [&_ul]:mb-4 [&_ul]:list-disc [&_ul]:pl-5"
  end

  def site_prose_inline_class
    "max-w-2xl text-[15px] leading-[1.65] text-neutral-700"
  end

  def site_form_card_class
    "card flex max-w-md flex-col gap-4 p-6 sm:px-[1.65rem] sm:py-6"
  end

  def site_form_field_class
    "[&_label]:mb-1.5 [&_label]:block [&_label]:text-xs [&_label]:font-semibold " \
      "[&_input]:w-full [&_input]:rounded-[var(--radius-sm)] [&_input]:border [&_input]:border-[var(--color-border-strong)] " \
      "[&_input]:px-2.5 [&_input]:py-2.5 [&_input]:text-[15px] [&_input]:font-[inherit] " \
      "[&_textarea]:min-h-32 [&_textarea]:w-full [&_textarea]:resize-y [&_textarea]:rounded-[var(--radius-sm)] " \
      "[&_textarea]:border [&_textarea]:border-[var(--color-border-strong)] [&_textarea]:px-2.5 [&_textarea]:py-2.5 " \
      "[&_textarea]:text-[15px] [&_textarea]:font-[inherit] " \
      "[&_select]:w-full [&_select]:rounded-[var(--radius-sm)] [&_select]:border [&_select]:border-[var(--color-border-strong)] " \
      "[&_select]:bg-[var(--color-bg)] [&_select]:px-2.5 [&_select]:py-2.5 [&_select]:text-[15px] [&_select]:font-[inherit]"
  end

  def site_form_errors_class
    "mb-4 max-w-md rounded-[var(--radius-sm)] border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-900"
  end

  def site_data_table_class
    "w-full border-collapse text-sm " \
      "[&_th]:border-b [&_th]:border-[var(--color-border)] [&_th]:px-3 [&_th]:py-2.5 [&_th]:text-left " \
      "[&_th]:text-xs [&_th]:font-semibold [&_th]:uppercase [&_th]:tracking-wider [&_th]:text-neutral-600 " \
      "[&_td]:border-b [&_td]:border-[var(--color-border)] [&_td]:px-3 [&_td]:py-2.5 [&_td]:text-left"
  end

  def site_notif_list_class
    "card m-0 list-none px-5 py-0"
  end

  def site_notif_item_class
    "flex flex-wrap items-start gap-x-4 gap-y-3 border-b border-[var(--color-border)] py-4 last:border-b-0 " \
      "data-[notification-unread=true]:bg-gradient-to-r data-[notification-unread=true]:from-neutral-50 " \
      "data-[notification-unread=true]:to-transparent data-[notification-unread=true]:-mx-2 " \
      "data-[notification-unread=true]:px-2"
  end
end
