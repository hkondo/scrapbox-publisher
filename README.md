# scrapbox-publisher

(日本語の説明が後半にあります)

Scan any scrapbox project and copy the pages with a specific tag to
another scrapbox project. It is intended to be used to copy a daily
report drafted in a private project to a public project.

This tool is similar to scrapbox-duplicator
https://github.com/tkgshn/Scrapbox-Duplicator .

The ruby interpreter is required to run the program.

** DISCLAIMER **
This is a tool I made to understand the scrapbox API. It has been
tested in a few normal situations, so use it at your own risk.


## How to use
For example, you can run this command as follows:

$ env SCRAPBOX_SID='value of connect.sid cookie' ruby -I. scrapbox-publisher.rb --export-from source_prj --publish_to destination_prj

When the above command is executed successfully, the pages in the
source_prj project will be scanned, and the pages with the #publish_to
tag will be copied into destination_prj. However, pages with the
#no_publish tag will not be copied even if they have the #publish_to
tag.

The value of "connect.sid" should be taken from the cookie of the web
browser when you are logged in to scrapbox.

This web page is a good reference on how to extract connect.sid from chrome:
https://scrapbox.io/nishio/Scrapbox%E3%81%AEprivate%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E3%81%AEAPI%E3%82%92%E5%8F%A9%E3%81%8F (in Japanese).


## ACKNOWLEDGEMENT
Thanks to Nota, Inc. for developing scrapbox.



scrapboxのプロジェクトをスキャンして，特定のタグを持つページを別の
scrapbox プロジェクト内にコピーします．非公開プロジェクトで下書きした
日報等を公開プロジェクトにコピーするような使い方を想定しています．

このツールは
scrapbox-duplicator https://github.com/tkgshn/Scrapbox-Duplicator にと
てもよく似ています．

このツールの実行には ruby インタプリタが必要です．

** 免責事項 **
これは scrapbox API を理解するために作ったツールです．いくつかの正常な
状況でテストしただけのものですので，御自身の責任でお使いください．


## つかいかた
たとえば，このツールは次のように実行できます．

$ env SCRAPBOX_SID='value of connect.sid cookie' ruby -I. scrapbox-publisher.rb --export-from source_prj --publish_to destination_prj

上記のコマンドが正常に実行されると，source_prj プロジェクト内のページ
がスキャンされ，#publish_to タグが付与されたページが destination_prj
にコピーされます．ただし，#no_publish タグが付与されたページは，たとえ
#publish_to タグが付与されていたとしてもコピーされません．

value of connect.sid は，scrapbox にログインしたウェブブラウザの
cookie から取り出してください．

このページは chromeから connect.sid を取り出す方法を説明しています(日本語です)．
https://scrapbox.io/nishio/Scrapbox%E3%81%AEprivate%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E3%81%AEAPI%E3%82%92%E5%8F%A9%E3%81%8F


## 謝辞
scrapbox を開発している Nota, Inc のみなさんに感謝いたします．
