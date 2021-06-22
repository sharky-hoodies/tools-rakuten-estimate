# 楽天ショッピング 見積計算ツールの量産手法

## 1. 概要

- 見積ツールを埋め込みたい対象商品のデータを csv で準備
- ↑ を元に exec.sh で対象商品ごとの HTML を生成
- 出力された HTML を FTP で楽天 GOLD に手動でアップロード

## 2. 前提

- 楽天ショッピングに出店済（アルミ商品に特化しているが、カスタマイズは容易）
- 楽天 GOLD 申請済
- FTP クライアントインストール済
- 見積計算ツールは用途にあわせて作成 -> template.html

## 3. CSV -> target-items.csv

- (1)商品 ID: 商品型番はファイル名にする
- (2)横幅 MAX(mm): 入力時の validation に使用
- (3)横幅 MIN(mm): 入力時の validation に使用
- (4)縦幅 MAX(mm): 入力時の validation に使用
- (5)縦幅 MIN(mm): 入力時の validation に使用
- (6)購入金額: RMS 管理画面で登録した金額(今後は全て税抜きになるはず)
- (7)板厚(mm): アルミ商品の板厚(金額には影響しないが、表示に使用)

### 3-1. 注意点

- Excel 経由で csv 変換した際は改行コードに注意(LF に変換したほうがよい)

## 4. template.html

- Replacer: TARGET_TEMPLATE_SIZE_W_MAX <- csv.横幅 MAX(mm)
- Replacer: TARGET_TEMPLATE_SIZE_W_MIN <- csv.横幅 MIN(mm)
- Replacer: TARGET_TEMPLATE_SIZE_V_MAX <- csv.縦幅 MAX(mm)
- Replacer: TARGET_TEMPLATE_SIZE_V_MIN <- csv.縦幅 MIN(mm)
- Replacer: TARGET_TEMPLATE_PRICE <- csv.購入金額
- Replacer: TARGET_TEMPLATE_THICKNESS <- csv.板厚(mm)

## 5. メモ

### 5-1. 楽天 GOLD へ FTP 接続

```
$ ftp -vi
ftp> passive   -> passiveモードでないとだめらしい
ftp> open ftp.rakuten.ne.jp 16910
ftp> asc       -> ファイルアップはascモードで
ftp> quit
```

## 99. FIXME

1. CSV 作成を自動化したかった
   - HACK: [スプレッドのハイパーリンクから URL を抽出する方法](https://liginc.co.jp/509121)
   - Google スプレッドシートの IMPORTXML 関数で、商品 WEB ページから必要情報を取得が可能([参考](https://liginc.co.jp/509121))
   - 実際は、楽天商品ページドメイン(item.rakuten.co.jp)のみスクレイピング不可だった
2. RMS の商品情報を見積ツールでそのまま利用したい
   - 現状、購入金額を変更したい場合は GOLD の HTML を編集する必要がある
   - できれば RMS の入力値をそのまま参考にしたいが、方法が分からない
   - 案としては、HTML のスクリプトで[楽天商品検索 API](https://webservice.rakuten.co.jp/api/ichibaitemsearch/)を埋め込み購入金額を取得できれば自動で反映される
     - ただその場合は API のリクエスト上限に注意が必要なのと、そもそも iframe が利用できなくなる可能性があるので割りにあわなさそう
3. iframe が利用できなくなる可能性がある
   - そうなれば、GOLD を利用したデザインやツールはほとんど NG になる
