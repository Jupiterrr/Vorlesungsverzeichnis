# https://gist.github.com/bcoe/6505434
module ElasticSearchHelpers
  # sanitize a search query for Lucene. Useful if the original
  # query raises an exception, due to bad adherence to DSL.
  # Taken from here:
  #
  # http://stackoverflow.com/questions/16205341/symbols-in-query-string-for-elasticsearch
  #
  def self.sanitize_string(str)
    # Escape special characters
    # http://lucene.apache.org/core/old_versioned_docs/versions/2_9_1/queryparsersyntax.html#Escaping Special Characters
    escaped_characters = Regexp.escape('\\+-&|!(){}[]^~*?:\/')
    str = str.gsub(/([#{escaped_characters}])/, '\\\\\1')

    # AND, OR and NOT are used by lucene as logical operators. We need
    # to escape them
    ['AND', 'OR', 'NOT'].each do |word|
      escaped_word = word.split('').map {|char| "\\#{char}" }.join('')
      str = str.gsub(/\s*\b(#{word.upcase})\b\s*/, " #{escaped_word} ")
    end

    # Escape odd quotes
    quote_count = str.count '"'
    str = str.gsub(/(.*)"(.*)/, '\1\"\3') if quote_count % 2 == 1
    str = str.gsub(/[\(\)]/, '*')
    str
  end
end