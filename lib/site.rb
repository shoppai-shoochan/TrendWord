require 'open-uri'

class Site
  #引数のsource_urlは最後に/を付けること
  def initialize(source_url,site_name)
    #スクレイピング対象ページのurl
    @source_url = source_url
    #スクレイピング対象ページの名前（会社名）
    @site_name = site_name
    #記事を格納：{'title1' => 'link1','title2' => 'link2' ・・・}
    @articles = {}
  end


  attr_reader :source_url,:site_name
  attr_accessor :site_charset,:articles


  #サイト独自で実装する場合はサブクラスでオーバーライド
  #戻り値はハッシュにすること。{'title1' => 'link1','title2' => 'link2' ・・・}
  def scraping
    parse(get_html_openuri)
  end


  #open-uriでhtmlを取得
  def get_html_openuri
    charset = nil
    #html取得
    open(@source_url){|f|
      charset = f.charset
      #charsetをサブクラス定義した時はそれを使う
      @site_charset = @site_charset|| charset
      f.read
    }
  end


  #seleniumでhtmlを取得
  #戻り値はサイトのhtml
  def get_html_selenium
    #Selenium::WebDriver::Chrome.driver_path = "/usr/local/bin/chromedriver"
    driver = Selenium::WebDriver.for :chrome
    driver.get @source_url
    driver.page_source
  end


  #HP内の記事（タイトルとリンク)を大まかに取得
  def parse(html)
    doc = Nokogiri::HTML.parse(html,nil,@site_charset)
    #新聞HPは多くの記事がhタグとulタグ以下にある
    head = ['//h1','//h2','//h3','//ul']
    head.each{|head|
      doc.xpath(head).each {|h|
        unless h.css('a').empty?
          h.css('a').each do |a|
            @articles[space_filling_title(a.inner_text)] = relative_to_absolute(a.attribute('href').value)
          end
        end
      }
    }
    @articles
  end


  #記事タイトル名の前後の空白文字を削除
  def space_filling_title(title)
    reg = /^[　\s]*(.*)[　\s]*$/
    title.gsub(reg,'\1')
  end


  #記事リンクの相対パスを絶対パスに変換
  def relative_to_absolute(link)
    # /もしくは./で始まるパスの先頭部分を削除
    reg = /^\/|^.\/|/
    absolute = link.gsub(reg,'')
    # /wで始まるパスにはhttps/を
    absolute = 'https:/' + absolute unless absolute.match(/^\/w/).nil?
    # httptで始まるパス以外には@site_souceを付
    absolute = @source_url + absolute if absolute.match(/^http/).nil?
    absolute
  end
end


#日経新聞トップページ
class Nikkei < Site
end

#産経新聞トップページ
class Sankei < Site
end

#読売新聞トップページ
class Yomiuri < Site
end

#東京新聞トップページ
class Tokyo < Site
  def scraping
    parse(get_html_selenium)
  end
end

#朝日新聞トップページ
class Asahi < Site
end

#毎日新聞トップページ
class Mainichi < Site
end

#中日新聞トップページ
class Chunichi < Site
  def scraping
    parse(get_html_selenium)
  end
end

#東スポトップページ
class Tosupo < Site
end
