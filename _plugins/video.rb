module Jekyll
  class VideoTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @site, @code = text.split ' '
    end

    def render(context)
      case @site
      when "tumblr"
        "<iframe src=\"http://www.tumblr.com/video/webboxio/#{@code}/768\" 
          id=\"tumblr_video_iframe_#{@code}\"
          class=\"tumblr_video_iframe\" width=\"100%\"
          height=\"405\"
          style=\"display:block;background-color:transparent;overflow:hidden;\"
          allowTransparency=\"true\" frameborder=\"0\"
          scrolling=\"no\"
          webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe><br>"

      when "youtube"
        "<iframe width='100%' height='405' src='http://www.youtube.com/embed/#{@code}'
          frameborder='0'
          style='display: block'
          webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe><br>"

      when "vimeo"
        "<iframe src=\"//player.vimeo.com/video/#{@code}\" 
          width=\"100%\" 
          height=\"405\"
          frameborder=\"0\"
          style='display: block'
          webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe><br>"
      end
    end
  end
end

Liquid::Template.register_tag('video', Jekyll::VideoTag)
