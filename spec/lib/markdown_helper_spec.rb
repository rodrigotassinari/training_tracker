require 'rails_helper'

require 'markdown_helper'

class TestHelper
  include MarkdownHelper
end

RSpec.describe MarkdownHelper do
  subject { TestHelper.new }

  describe 'markdownify' do
    it 'returns a simple text' do
      input = %{hello world!}
      output = %{<p>hello world!</p>\n}
      expect(subject.markdownify(input)).to eq(output)
    end
    it 'returns formatted text' do
      input = %{hello **world**!}
      output = %{<p>hello <strong>world</strong>!</p>\n}
      expect(subject.markdownify(input)).to eq(output)
    end
    it 'does not allow html to be inputed' do
      input = %{<i>hello</i> <b>world</b>!}
      output = %{<p>hello world!</p>\n}
      expect(subject.markdownify(input)).to eq(output)
    end
    it 'creates html links automatically' do
      input = %{hello world! visit http://google.com or www.google.com.br now.}
      output = %{<p>hello world! visit <a href=\"http://google.com\">http://google.com</a> or <a href=\"http://www.google.com.br\">www.google.com.br</a> now.</p>\n}
      expect(subject.markdownify(input)).to eq(output)
    end
    it 'creates mailto links automatically' do
      input = %{hello world! contact john@dow.com now}
      output = %{<p>hello world! contact <a href=\"mailto:john@dow.com\">john@dow.com</a> now</p>\n}
      expect(subject.markdownify(input)).to eq(output)
    end
    it 'does not allow unsafe link protocols' do
      input = %{hello world! visit udp://google.com or xhr://google.com.br now.}
      output = %{<p>hello world! visit udp://google.com or xhr://google.com.br now.</p>\n}
      expect(subject.markdownify(input)).to eq(output)
    end
    it 'allows text highligthing' do
      input = %{hello ==world==!}
      output = %{<p>hello <mark>world</mark>!</p>\n}
      expect(subject.markdownify(input)).to eq(output)
    end
    it 'allows text strike-thoughing' do
      input = %{hello ~~world~~!}
      output = %{<p>hello <del>world</del>!</p>\n}
      expect(subject.markdownify(input)).to eq(output)
    end
    it 'allows text underlining' do
      input = %{hello _world_!}
      output = %{<p>hello <em>world</em>!</p>\n}
      expect(subject.markdownify(input)).to eq(output)
    end
    it 'allows tables to be used' do
      input = <<-EOF
Well, this is a table:

| Col One | Col Two |
| :------ | :-----: |
| One     | 2       |
| Three   | 4       |

End of the text.
EOF
      output = %{<p>Well, this is a table:</p>\n\n<table><thead>\n<tr>\n<th style=\"text-align: left\">Col One</th>\n<th style=\"text-align: center\">Col Two</th>\n</tr>\n</thead><tbody>\n<tr>\n<td style=\"text-align: left\">One</td>\n<td style=\"text-align: center\">2</td>\n</tr>\n<tr>\n<td style=\"text-align: left\">Three</td>\n<td style=\"text-align: center\">4</td>\n</tr>\n</tbody></table>\n\n<p>End of the text.</p>\n}
      expect(subject.markdownify(input)).to eq(output)
    end
  end

end
