require 'ostruct'
require_relative 'translator'

class DropDown
  BLANK_OPTION = OpenStruct.new(name: nil, value: nil)

  def title_key
    raise NotImplementedError
  end

  def option_keys
    raise NotImplementedError
  end

  def locale
    raise NotImplementedError
  end

  def translator
    @translator ||= Translator.new(locale)
  end

  def title
    translated_title(title_key)
  end

  def translated_title(title_key)
    translator.t('titles.' + title_key) unless title_key.empty?
  end

  def options
    translated_options(option_keys)
  end

  private

  def translated_options(option_keys, options = {})
    option_keys_to_open_structs(option_keys).tap do |option_structs|
      option_structs.sort_by!(&:name)        unless options[:sort] == false
      option_structs.insert(0, BLANK_OPTION) unless options[:blank] == false
    end
  end

  def selected_option_key
    nil
  end

  def option_keys_to_open_structs(option_keys)
    selected_by_default = true if option_keys.size == 1

    option_keys.map do |option_key|
      OpenStruct.new.tap do |option|
        option.name     = translator.t('options.' + option_key)
        option.value    = option_key
        option.selected = true if selected_by_default || option_key == selected_option_key
      end
    end
  end

  def options_wrapper(options = {})
    yield.tap do |option_structs|
      option_structs.first.selected = true   if option_structs.size == 1
      option_structs.insert(0, BLANK_OPTION) unless options[:blank] == false
    end
  end
end
