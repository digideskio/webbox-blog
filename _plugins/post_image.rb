module Jekyll
  class PostImageTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @image = text
    end

    def render(context)
      "assets/post_images/#{@image}"
    end
  end
end

Liquid::Template.register_tag('post_image', Jekyll::PostImageTag)
