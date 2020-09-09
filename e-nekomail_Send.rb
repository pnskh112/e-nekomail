
 #!/usr/bin/env ruby
 # encoding: UTF-8
 # # coding: UTF-8
 # # -*- coding: UTF-8 -*-
 #*******************************************************************************
 # e-nekomail_Send.rb
 #
 #*******************************************************************************

 require 'watir-webdriver'
 require 'date'

 #### 各パラメータ
 # 接続先のURL
 send_url = "https://i-securedeliver.jp/sd/dypass88/jsf/login/user/login.jsf"
 # ログインユーザID
 j_username = "dypass88-admin"
 # 2020/08/31
 j_password = "BpTPKjjeKO"
 # 送信するZIPファイル名
 # send_file = "/home/dycsales/data/download/csv/yamato_senddata.zip"
 send_file = "/home/vagrant/watir_src/Ruby/testmailaddress.txt"
 # ログファイル名
 #  logfile = "/home/dycsales/data/logs/delive_export_logs/e-nekomail_Send_" + Time.now.strftime("%Y%m%d_%H%M%S") + ".log"
 logfile = "/home/vagrant/watir_src/Ruby/logs/delive_export_logs/e-nekomail_Send_" + Time.now.strftime("%Y%m%d_%H%M%S") + ".log"
 # メソッド定義

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
 def searchATag(browser,id1,id2,id3)
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

 ######### メイン処理開始

 ###### Log出力
 file = File.open(logfile,"a")
 file.write("[" + Time.now.strftime("%Y/%m/%d %H:%M:%S") + "] e-nekomail_Send.rb Start! \n" )
 file.close


 #ブラウザをfirefoxに変更
#  profile = Selenium::WebDriver::Chrome::Profile.new
 profile = Selenium::WebDriver::Firefox::Profile.new
 profile['download.prompt_for_download'] = false
 profile['browser.upload.dir'] = '/home/vagrant/watir_src/Ruby'


 #ブラウザをfirefoxに変更
#  browser = Watir::Browser.new :chrome, profile: profile
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

 # if browser.text.include? "既にログインされています"
 # 	###### Log出力
 # 	file = File.open(logfile,"a")
 # 	file.write("[" + Time.now.strftime("%Y/%m/%d %H:%M:%S") + "] e-nekomail_Send.rb (error) 既にログインされています \n" )
 # 	file.write("[" + Time.now.strftime("%Y/%m/%d %H:%M:%S") + "] e-nekomail_Send.rb End! \n" )
 # 	file.close
 # 	######### ブラウザ終了
 # 	browser.close 	
 # 	exit 2
 # end

 ######### お届け便->新規送信
 inputTag = searchInputTagIn2frame( browser , "contents","listContents","actionsForm:j_idt29:j_idt51:inputButtonId","actionsForm:j_idt29:j_idt126:inputButtonId")
 inputTag.click
 sleep(3)
  
 # 別ウインドウに切り替え
 browser.window(:title => "Compose - IMAGE WORKS SECURE DELIVER").use do
 # 日本語に切り替えている場合　及びChromeが自動で日本語選択している場合
 # browser.window(:title => "新規送信 - IMAGE WORKS SECURE DELIVER").use do

    # メールタイトル
    textField = searchTextField(browser,"dialogForm:j_idt1089:j_idt1101:j_idt1159:j_idt1160:inputTextId","dialogForm:j_idt1116:j_idt1128:j_idt1186:j_idt1187:inputTextId")
    textField.set("配送データ送信")

    # 宛先
    textArea = searchTextArea(browser,"dialogForm:j_idt1116:j_idt1128:j_idt1262:receiverDisplayName:receiverDisplayName","dialogForm:j_idt1089:j_idt1101:j_idt1235:receiverDisplayName:receiverDisplayName")
    textArea.set("s.takeuchi@leafnet.jp")    

    # メール本文
    textArea = searchTextAreaByName(browser,"dialogForm:j_idt1116:j_idt1128:j_idt1460:j_idt1461:j_idt1461","dialogForm:j_idt1089:j_idt1101:j_idt1429:j_idt1430:j_idt1430")
    textArea.set("配送データを添付致します") 

    # 添付ファイル
    puts "添付ファイル"
    if browser.div(:id => "fileListDisplayArea").present? then
        puts "fileListDisplayArea" 
    else
        puts "none"
    end

    # browser.input(:class => "fileSelectBtn").set(send_file)
    # browser.input(:class => "fileSelectBtn").click
    browser.execute_script("document.getElementsByClassName('fileSelectBtn')[0].value = '/home/vagrant/watir_src/Ruby/testmailaddress.txt';")
    browser.input(:class => "fileSelectBtn").click
    # browser.text_field(:id => "fileSelect").set(send_file)
    # browser.text_field(:id => "fileSelect").set(send_file)
    browser.send_keys("/home/vagrant/watir_src/Ruby/testmailaddress.txt")
    browser.send_keys :enter

    browser.execute_script("
        var str = '/home/vagrant/watir_src/Ruby/testmailaddress.txt';
        if(navigator.clipboard){
            console.log(str);
            navigator.clipboard.writeText(str);

            navigator.clipboard.readText()
                document.dispatchEvent( new KeyboardEvent( 'keydown', { keyCode: 86 , ctrlKey: true , key: 'V' }) );
                pasteArea.textContent = text;
                console.log(document.dispatchEvent( new KeyboardEvent( 'keydown', { keyCode: 86 , ctrlKey: true , key: 'V' }) ))
            );
        }
    ")


    # 送信ボタン押下
    aTag = searchATag(browser,"dialogForm:j_idt2268:j_idt2278:buttonId","dialogForm:j_idt1914:j_idt1922:buttonId","dialogForm:j_idt1917:j_idt1925:buttonId")
    aTag.click

    # ブラウザ遷移を待つ
    browser.wait

    # 送信ボタン押下
    aTag = searchATag(browser,"confirmForm:j_idt473:j_idt474:buttonId","confirmForm:j_idt446:j_idt447:buttonId")
    aTag.click

    # ブラウザ遷移(送信完了)を待つ
    browser.wait

    # 送信ボタン押下
    aTag = searchATag(browser,"confirmForm:j_idt473:j_idt474:buttonId","confirmForm:j_idt446:j_idt447:buttonId")
    aTag.click
end

######### ログアウト
# これをコメントアウトすればログアウトできる（はず）
# browser.frame(:name => "header").p(:id => "form:j_idt36:j_idt72:singleButtonPId").click

######### ブラウザ終了
# browser.close

###### Log出力
file = File.open(logfile,"a")
file.write("[" + Time.now.strftime("%Y/%m/%d %H:%M:%S") + "] e-nekomail_Send.rb End! \n" )
file.close

exit 0
