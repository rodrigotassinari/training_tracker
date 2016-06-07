module MarkdownHelper

  # http://www.webcodegeeks.com/web-development/render-markdown-rails-redcarpet-smartypants/
  # https://github.com/vmg/redcarpet#and-its-like-really-simple-to-use
  def markdownify(content)
    @renderer ||= Redcarpet::Render::HTML.new(
      filter_html: true,
      no_styles: true,
      safe_links_only: true
    )
    @markdown ||= Redcarpet::Markdown.new(
      @renderer, {
      autolink: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
      footnotes: true,
      highlight: true,
      no_intra_emphasis: true,
      space_after_headers: true,
      strikethrough: true,
      tables: true,
      underline: false,
    })
    @markdown.render(content).html_safe
  end

end
