module Jekyll
  class FontawesomeTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @icon = text
    end

    def render(context)
      "<i class=\"fa fa-#{@icon}\"></i>"
    end
  end
end

Liquid::Template.register_tag('fa_icon', Jekyll::FontawesomeTag)
