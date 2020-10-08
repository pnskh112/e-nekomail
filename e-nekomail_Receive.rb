 #!/usr/bin/env ruby
 # encoding: UTF-8
 # # coding: UTF-8
 # # -*- coding: UTF-8 -*-
 #*******************************************************************************
 # e-nekodeliver_Receive.rb
 #
 #    概要        ： e-ネコセキュアデリバー　受信
 #
 #    履歴        ：2020/08/31 Create by 
 #
 #*******************************************************************************

 require 'watir-webdriver'
 require 'date'

 #### 各パラメータ
 # 接続先のURL
 send_url = "https://i-securedeliver.jp/sd/dypass88/jsf/login/user/login.jsf"
 # ログインユーザID
 j_username = "XXXhogeXXX"
 # 2020/08/31
 j_password = "---hoge---"
 # 保存するZIPディレクトリ
#  receive_dir = "/home/dycsales/data/download/csv/received/"
 receive_dir = "/home/vagrant/watir_src/Ruby/"

 # インプットタグ検索（frame2つの中）
 def searchInputTagIn2frame(browser,flame1,flame2,id1,id2)
    frame = browser.frame(:name => flame1 ).frame(:name => flame2 )
    frame.input(:id => id1 ).present? ? frame.input(:id => id1 ) : frame.input(:id => id2 )
 end
 # text_field検索
 def searchTextField(browser,id1,id2)
    browser.text_field(:id => id1).present? ? browser.text_field(:id => id1) : browser.text_field(:id => id2)
 end
 # textarea検索
 def searchTextArea(browser,id1,id2)
    browser.textarea(:id => id1).present? ? browser.textarea(:id => id1) : browser.textarea(:id => id2)
 end
 # textarea検索
 def searchTextAreaByName(browser,id1,id2)
    browser.textarea(:name => id1).present? ? browser.textarea(:name => id1) : browser.textarea(:name => id2)
 end
 # aタグ検索(id候補３つ)
 def searchATag3id(browser,id1,id2,id3)
    if browser.a(:id => id1).present? then
        browser.a(:id => id1)
    elsif browser.a(:id => id2).present? then
        browser.a(:id => id2)
    elsif browser.a(:id => id3).present? then
        browser.a(:id => id3)
    end
 end
 # aタグ検索(id候補２つ)
 def searchATag(browser,id1,id2)
    browser.a(:id => id1).present? ? browser.a(:id => id1) : browser.a(:id => id2)
 end
 # aタグ検索（frame1つの中）
 def searchATagInframe(browser,flame,id1,id2)
    frame = browser.frame(:name => flame )
    frame.a(:id => id1 ).present? ? frame.a(:id => id1 ) : frame.a(:id => id2 )
 end
 # aタグ検索（frame1つの中）
 def searchATagIn2frame(browser,flame1,flame2,id1,id2)
   frame = browser.frame(:name => flame1).frame(:name => flame2 )
   frame.a(:id => id1 ).present? ? frame.a(:id => id1 ) : frame.a(:id => id2 )
 end

 ######### メイン処理開始

 #ブラウザをfirefoxに変更
 # profile = Selenium::WebDriver::Chrome::Profile.new
 profile = Selenium::WebDriver::Firefox::Profile.new
 profile['download.prompt_for_download'] = false
 profile['download.default_directory'] = receive_dir

 #ブラウザをfirefoxに変更
 # browser = Watir::Browser.new :chrome, profile: profile
 browser = Watir::Browser.new :firefox, profile: profile
 browser.goto send_url
 browser.wait
 sleep(3)

 ######### ログイン
 browser.frame(:name => "contents").table(:class => "loginform2").text_field( :name => "j_username" ).set(j_username)
 browser.frame(:name => "contents").table(:class => "loginform2").text_field( :name => "j_password" ).set(j_password)

 # ログインボタン押下
 aTag = searchATagInframe(browser , "contents" , "j_idt66:singleButtonId" , "j_idt54:singleButtonId")
 aTag.click

 browser.wait
 sleep(2)


 # 受信一覧を選択
 #  browser.execute_script("jsf.util.chain(this,event,'refreshToolAndPagerFrame(getClickedTabs(\'tabForm:j_idt29:inboxButton\', \'tabForm:j_idt29:inboxButtonText\'));selectTab(\'tabForm:j_idt29:inboxButton\');','mojarra.jsfcljs(document.getElementById(\'tabForm\'),{\'tabForm:j_idt29:inboxLinkId\':\'tabForm:j_idt29:inboxLinkId\',\'targetPage\':\'/jsf/user/letter/inbox/contents.jsf\',\'companyAbbreviation\':\'dypass88\',\'loginUrlType\':\'SD_NORMAL_USER_LOGIN\'},\'\')');return false")
 aTag = searchATagIn2frame(browser,"contents","letterTabs","tabForm:j_idt29:inboxLinkId","tabForm:j_idt29:inboxLinkId")
 aTag.click

 ######### ログアウト
 browser.frame(:name => "header").p(:id => "form:j_idt36:j_idt72:singleButtonPId").click

 # 一度waitでコケたので3秒スリープに変更
 sleep(3)
 # browser.wait

 ######### ブラウザ終了
 browser.close

 exit 0

