## Startlensモバイルアプリ（カメラ）

### アプリ概要

Startlensアプリケーションにおける事業者が利用するカメラアプリ。

これまでWebアプリから撮影した観光地の画像をアップロードするUXでしたが、モバイルアプリを利用することで撮影した写真を直接S3へアップロードし、Startlensの管理者側webアプリから情報を修正できるようになります。

### ターゲットユーザー

- StartlensのWebアプリ（http://www.admin.startlens.jp/admin/signin) に登録している観光事業者
   - デモアカウント　Email:info@startlens.com, Password: startlens
   - 上記のデモアカウントを利用してiOSアプリケーションでログイン可能


## 開発環境

XCode:  12.4

Swift:   5.3.2

## アプリ画面

![screen_sample_v1](https://user-images.githubusercontent.com/42575165/109423078-7d527f00-7a21-11eb-9703-30796e1c0281.png)


![screen_sample_v1_2](https://user-images.githubusercontent.com/42575165/109423096-8ba09b00-7a21-11eb-937c-fd5d74226d43.png)


## 機能

- JWTトークンを利用したログイン認証機能 (※ AppStoreへは公開せずTestFlightのみの利用により一般向けの新規会員登録やパスワードリセット機能は実装未定)
- 撮影した写真の一覧表示
- 新規対象物の名称及び説明の登録
- カメラによる撮影機能
- 撮影した画像のリサイズ、回転処理及びプレビュー機能
- バックエンドのRailsAPIへの新規対象物送信機能


## APIサーバー

- https://github.com/yuta252/startlens_web_backend


## 使用素材

- [Unsplash](https://unsplash.com/)
