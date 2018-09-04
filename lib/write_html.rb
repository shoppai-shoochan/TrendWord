#require 'erb'

#htmlファイルに書き込む
def write_html(wordcounts,wordarticles)


  file = open("../view/Order_by_trend.html.erb","r")
  erb = ERB.new(file.read)

  #このerb.resultメソッド内では何故かスコープがトップレベル(main.rb)と一緒
  File.open("../Trendword.html","w"){|f|
    f.puts(erb.result(binding))
  }
end