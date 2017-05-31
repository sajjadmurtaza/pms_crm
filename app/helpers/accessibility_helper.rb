module AccessibilityHelper

  def form_submit_button(title, form)
    content_tag :a, title, class: 'ui blue button', data:{behavior: 'submit-form', form: form}
  end

  def page_classes
    "#{params[:controller].gsub('/', '_')} #{params[:controller].gsub('/', '_')}_#{params[:action]}"
  end

  def page_title
    @page_title || t("#{params[:controller]}_#{params[:action_name]}")
  end

  def day_name(day)
    ::I18n.t('date.day_names')[day % 7]
  end

  def label_with_icon(label, icon)
   label.blank? ? '' : (content_tag(:i, nil, class: "ui icon #{icon}")+label).html_safe
  end

  def you_are_here_info(condition = true)
    condition ? "<span class = 'hidden-for-sighted'>You are here</span>".html_safe : ""
  end

  def empty_element_tag
    @empty_element_tag ||= ApplicationController.new.render_to_string(partial: "accessibility/empty_element_tag").html_safe
  end

  def active_link_to(caption, url, css_klass)
    link_to caption, url, class: "#{css_klass} #{current_page?(url) ? 'active' : ''}"
  end

  # Return true if the difference between two colors
  # matches the W3C recommendations for readability
  # See http://www.wat-c.org/tools/CCA/1.1/
  def colors_diff_ok?(color_1, color_2)
    cont, bright = find_color_diff color_1, color_2
    (cont > 500) && (bright > 125) # Acceptable diff according to w3c
  end

  def color_contrast(color)
    _, bright = find_color_diff 0x000000, color
    (bright > 128)
  end

  # Returns the locale :en for the given menu item if the user locale is
  # different but equals the English translation
  #
  # Returns nil if user locale is :en (English) or no translation is given,
  # thus, assumes English to be the default language. Returns :en iff a
  # translation exists and the translation equals the English one.
  def menu_item_locale(menu_item)
    return nil if english_locale_set?

    caption_content = menu_item.instance_variable_get(:@caption)
    locale_label = caption_content.is_a?(Symbol) ? caption_content : :"label_#{menu_item.name.to_s}"

    (!locale_exists?(locale_label) || equals_english_locale(locale_label)) ? :en : nil
  end

  private

  # Return the contranst and brightness difference between two RGB values
  def find_color_diff(c1, c2)
    r1, g1, b1 = break_color c1
    r2, g2, b2 = break_color c2
    cont_diff = (r1-r2).abs+(g1-g2).abs+(b1-b2).abs # Color contrast
    bright1 = (r1 * 299 + g1 * 587 + b1 * 114) / 1000
    bright2 = (r2 * 299 + g2 * 587 + b2 * 114) / 1000
    brt_diff = (bright1 - bright2).abs # Color brightness diff
    [cont_diff, brt_diff]
  end

  # Break a color into the R, G and B components
  def break_color(rgb)
    r = (rgb & 0xff0000) >> 16
    g = (rgb & 0x00ff00) >> 8
    b = rgb & 0x0000ff
    [r, g, b]
  end

  def locale_exists?(key, locale=I18n.locale)
    I18n.t(key, locale: locale, raise: true) rescue false
  end

  def english_locale_set?
    I18n.locale == :en
  end

  def equals_english_locale(key)
    key.is_a?(Symbol) ? (I18n.t(key) == I18n.t(key, locale: :en)) : false
  end

  def in_words(int)
    numbers_to_name = {
        1000000 => "million",
        1000 => "thousand",
        100 => "hundred",
        90 => "ninety",
        80 => "eighty",
        70 => "seventy",
        60 => "sixty",
        50 => "fifty",
        40 => "forty",
        30 => "thirty",
        20 => "twenty",
        19=>"nineteen",
        18=>"eighteen",
        17=>"seventeen",
        16=>"sixteen",
        15=>"fifteen",
        14=>"fourteen",
        13=>"thirteen",
        12=>"twelve",
        11 => "eleven",
        10 => "ten",
        9 => "nine",
        8 => "eight",
        7 => "seven",
        6 => "six",
        5 => "five",
        4 => "four",
        3 => "three",
        2 => "two",
        1 => "one"
    }
    str = ""
    numbers_to_name.each do |num, name|
      if int == 0
        return str
      elsif int.to_s.length == 1 && int/num > 0
        return str + "#{name}"
      elsif int < 100 && int/num > 0
        return str + "#{name}" if int%num == 0
        return str + "#{name} " + in_words(int%num)
      elsif int/num > 0
        return str + in_words(int/num) + " #{name} " + in_words(int%num)
      end
    end
  end
end