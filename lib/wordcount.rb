#記事の格納された多重ハッシュを受け取って各タイトルを形態素解析
#戻り値はwordountとword_belong_to_titles
#固有名詞のみ集計
#引数articlesは多重ハッシュ: {"company" => { "title1" => "link1", ・・・}・・・}
def analizing(articles)

  #単語と出現回数のハッシュ: {word => number ・・・　}
  wordcounts = {}
  #単語とその単語が属している記事のハッシュ: {word => [[company,title1,link1],[sankei,title2,link2],・・・]  ・・・}
  wordarticles = {}

  articles.each {|company,one_company_articles|
    one_company_articles.each{|title,link|
      words = extract_words(title)
      word_count(wordcounts,words) unless words.empty?
      word_belong_to_titles(wordarticles,words,title,link,company)
    }
  }

  wordcounts = Hash[wordcounts.sort_by{|key,value| -value }]
  [wordcounts,wordarticles]
end

#形態素解析で固有名詞のみ抽出
#戻り値は固有名詞の配列[固有名詞１,固有名詞２]
def extract_words(title)
  words = []
  mecab = Natto::MeCab.new
  mecab.enum_parse(title).each{|word|
    #品詞が固有名詞の単語だけwordsに格納
    words << word.surface unless word.feature.match("固有名詞").nil?
  }
  #重複を取り除く
  words.uniq
end
#単語の出現回数を計算
def word_count(wordcounts,words)
  words.each{|word|
    num = wordcounts[word]
    if num.nil?
      wordcounts[word] = 1
    else
      wordcounts[word] += 1
    end
  }
  wordcounts
end
#単語が属する記事タイトルをハッシュで関連づけ
#戻り値はハッシュ: {"word" => [title1,title2,title3]・・・}
def word_belong_to_titles(wordarticles,words,title,link,company)
  words.each{|word|
    titles = wordarticles[word]
    if titles.nil?
      wordarticles[word] = [[company,title,link]]
    else
      wordarticles[word] << [company,title,link]
    end
  }
  wordarticles
end














