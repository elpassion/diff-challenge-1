class Translator
  def initialize(locale = nil)
    @locale = locale || :en
  end

  def t(string)
    "#{string} (locale=#{@locale})"
  end
end
