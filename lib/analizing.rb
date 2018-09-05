class MeCabAnalize

  attr_accessor :wordcounts,:wordarticles


  #初期化時にハッシュを受け取ること
  def initialize(articles)
    #新聞社ごとの、タイトルとリンクの多重ハッシュ：{"company" => {"title1" => "link1","title2" => "link2"・・・},・・・}
    @articles = articles
    #単語と出現回数のハッシュ: {"word1"=> "number1","word2" => "number2",・・・　}
    @wordcounts = {}
    #単語とその単語が属している記事のハッシュ: {"word" => [["company1","title1","link1"],["company2","title2","link2"],・・・]  ・・・}
    @wordarticles = {}
  end


  #@articlesから、@wordcountsと@wordarticlesを作成
  def analizing
    @articles.each {|company,one_company_articles|
      one_company_articles.each{|title,link|
        #MeCabで形態素解析、wordsには固有名詞の配列が入る
        words = extract_words_using_mecab(title)
        @wordcounts = word_count(words,@wordcounts) unless words.empty?
        @wordarticles = word_belong_to_titles(company,words,title,link,@wordarticles) unless words.empty?
      }
    }
    #ハッシュ{"word" => 出現回数 } を降順にソート
    @wordcounts = Hash[@wordcounts.sort_by{|key,value| -value }]
  end


  #MeCabの形態素解析で固有名詞のみ抽出
  #戻り値は固有名詞の配列[固有名詞１,固有名詞２]
  def extract_words_using_mecab(title)
    words = []
    #MeCabを利用
    mecab = Natto::MeCab.new
    mecab.enum_parse(title).each{|word|
      #品詞が固有名詞の単語だけwordsに格納
      words << word.surface unless word.feature.match("固有名詞").nil?
    }
    #重複を取り除く
    words.uniq
  end


  #単語の出現回数を計算
  #戻り値はwordounts
  def word_count(words,wordcounts)
    words.each{|word|
      #@wordcountsのkeyに、既にwordがあるかどうか？
      num = wordcounts[word]
      if num.nil?
				#なければ1を代入
        wordcounts[word] = 1
      else
				#あれば+1
        wordcounts[word] += 1
      end
    }
    wordcounts
  end


  #単語と、単語が属する記事の配列を、ハッシュで格納
  #戻り値はwordarticles
  def word_belong_to_titles(company,words,title,link,wordarticles)
    words.each{|word|
      #wordarticlesのkeyに、既にwordがあるかどうか
      titles = wordarticles[word]
      if titles.nil?
				#なければ記事を代入
        wordarticles[word] = [[company,title,link]]
      else
				#あれば記事を追加
        wordarticles[word] << [company,title,link]
      end
    }
    wordarticles
  end
end













