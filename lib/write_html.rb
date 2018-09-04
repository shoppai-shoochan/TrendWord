require 'erb'

#htmlファイルに書き込む
def write_html(wordcounts,wordarticles)

  file = open("../view/Order_by_trend.html.erb","r")
  erb = ERB.new(file.read)

  File.open("../Trendword.html","w"){|f|
    f.puts(erb.result)
  }
end