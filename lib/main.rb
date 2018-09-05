require_relative './site.rb'
require_relative './analizing.rb'
require_relative './write_html.rb'
require 'bundler'
#Bundlerが管理してるGemをrequire
Bundler.require


#新聞社ごとに分けた、記事のタイトルとリンクの多重ハッシュ：{"company" => {"title1" => "link1"・・・}}
articles = {}
#サイトインスタンスを格納する配列
sites = []
#urlの最後は/で終わる
sites << Nikkei.new("https://www.nikkei.com/","日経新聞")
sites << Sankei.new("https://www.sankei.com","産経新聞")
sites << Yomiuri.new("https://www.yomiuri.co.jp/","読売新聞")
sites << Tokyo.new("http://www.tokyo-np.co.jp/","東京新聞")
sites << Asahi.new("https://www.asahi.com/","朝日新聞")
sites << Mainichi.new("https://mainichi.jp/","毎日新聞")
sites << Chunichi.new("http://www.chunichi.co.jp/","中日新聞")
sites << Tosupo.new("https://www.tokyo-sports.co.jp/","東京スポーツ")
sites << Bunshun.new("http://bunshun.jp/list/magazine/shukan-bunshun","週刊文春オンライン")
sites << YahooEntame.new("https://news.yahoo.co.jp/hl?c=ent","Yahooエンタメ総合")
sites << Livedoor.new("http://news.livedoor.com","livedoor")

#Parallelで並列化
#対象サイトをスクレイピングしてarticlesに保存
Parallel.each(sites,in_threads: 4){|site|
  articles[site.site_name] = site.scraping
}

#MeCabで形態素解析
#解析結果はanalizingメソッド後、trendoword.wordbounts　と　trendword.wordarticles でアクセス可
trendword = MeCabAnalize.new(articles)
trendword.analizing


#erbでhtmlファイルに出力
write_html(trendword.wordcounts,trendword.wordarticles)

