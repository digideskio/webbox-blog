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

module Jekyll
  class FontawesomeCircleTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @icon = text
    end

    def render(context)
      "<span class=\"fa-stack fa-lg\"><i class=\"fa fa-circle fa-stack-2x\"></i><i class=\"fa fa-#{@icon} fa-stack-1x fa-inverse\"></i></span>"
    end
  end
end

Liquid::Template.register_tag('fa_icon', Jekyll::FontawesomeTag)
Liquid::Template.register_tag('fa_icon_circle', Jekyll::FontawesomeCircleTag)
