require 'erb'

#htmlファイルに書き込む
def write_html(wordcounts,wordarticles)

  #erbテンプレートファイルをオープン
  file = open("../view/Order_by_trend.html.erb","r")
  erb = ERB.new(file.read)

  #erb.resultメソッドでhtmlに変換
  #f.putsでファイルに出力
  File.open("../Trendword.html","w"){|f|
    f.puts(erb.result(binding))
  }
end