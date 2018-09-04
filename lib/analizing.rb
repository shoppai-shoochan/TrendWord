class Analize

  attr_accessor :wordcounts,:wordarticles


  #初期化時にハッシュを受け取ること
  def initialize(articles)
    #新聞社ごとの、タイトルとリンクの多重ハッシュ：{"company" => {"title1" => "link1"・・・}}
    @articles = articles
    #単語と出現回数のハッシュ: {word => number ・・・　}
    @wordcounts = {}
    #単語とその単語が属している記事のハッシュ: {word => [[company,title1,link1],[sankei,title2,link2],・・・]  ・・・}
    @wordarticles = {}
  end


  #@articlesから、@wordcountsと@wordarticlesを作成
  def analizing
    @articles.each {|company,one_company_articles|
      one_company_articles.each{|title,link|
        #wordには固有名詞の配列が入る
        words = extract_words(title)
        word_count(words) unless words.empty?
        word_belong_to_titles(company,words,title,link)
      }
    }
    #ハッシュ{"word" => 出現回数 } を降順にソート
    @wordcounts = Hash[@wordcounts.sort_by{|key,value| -value }]
  end


  #形態素解析で固有名詞のみ抽出
  #戻り値は固有名詞の配列[固有名詞１,固有名詞２]
  def extract_words(title)
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
  def word_count(words)
    words.each{|word|
      #@wordcountsのkeyに、既にwordがあるかどうか？
      num = @wordcounts[word]
      if num.nil?
        @wordcounts[word] = 1
      else
        @wordcounts[word] += 1
      end
    }
  end


  #単語と、単語が属する記事タイトルの配列を、ハッシュで関連づける
  def word_belong_to_titles(company,words,title,link)
    words.each{|word|
      #wordarticlesのkeyに、既にwordがあるかどうか
      titles = @wordarticles[word]
      if titles.nil?
        @wordarticles[word] = [[company,title,link]]
      else
        @wordarticles[word] << [company,title,link]
      end
    }
  end
end













