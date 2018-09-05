require 'erb'

#htmlファイルに書き込む
def write_html(wordcounts,wordarticles)

  #erbテンプレートファイルを読み込み
  file = open("../view/Order_by_trend.html.erb","r")
  erb = ERB.new(file.read,nil,'-')

  #erb.resultメソッドでhtmlに変換
  #f.putsでファイルに出力
	#bindingはerbライブラリ側の変数、使用するとerb.result内のスコープがローカル(write_html)と一緒になる？
  File.open("../Trendword.html","w"){|f|
    f.puts(erb.result(binding))
  }
end