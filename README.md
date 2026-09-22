# 熊の前（KUMA NO MAE）

クマの出没情報を共有し、地域の安全を支えるマップサービス。

日本の地域住民や訪問者が、クマの出没場所・日時・危険度を地図で確認し、目撃情報を投稿できるWebアプリケーションです。情報の閲覧から通報、コミュニティでの交流、管理者による情報管理までをつなぎます。

## 発表資料

**[プロジェクト発表資料を見る](https://hiro7899.github.io/KumanoMae)**

上記はHTML形式の発表資料です。Java・Servletで動作するWebアプリケーション本体とは異なります。

- 開発期間：2026年9月1日 ～ 9月23日
- チーム名：熊の前
- 発表者：ジョン・グァノ

## 主な機能

### 出没マップ

- Google Maps上で出没情報を表示
- クマのアイコンと凡例で危険度を可視化
- 地域・期間・危険度による絞り込み
- 検索結果に応じたマーカーと出没情報一覧の更新

| 区分 | 表示 | 内容 |
| --- | --- | --- |
| DANGER | 危険 | クマの目撃など、危険度の高い情報 |
| WARNING | 警戒 | 足跡・痕跡などの情報 |
| CAUTION | 注意 | 鳴き声・気配などの注意情報 |
| CLEAR | 解除 | 危険が解除された状態 |

### 目撃情報・コミュニティ

- 目撃情報の一覧・詳細表示と通報
- 位置情報・画像を含む情報共有
- コミュニティ投稿の作成・編集・削除
- コメントの作成・削除、いいねの切り替え

### 会員・マイページ

- 新規登録、ログイン、ログアウト
- ID・メールアドレスの重複確認
- メール認証とアカウント復旧
- パスワード再設定
- プロフィール・設定画面

### 管理者

- 目撃情報の承認・却下・危険解除
- 会員管理
- コミュニティ投稿の表示・非表示・削除、コメント管理
- 管理操作の履歴保存

## 開発メンバー

| メンバー | 役割 | 担当 |
| --- | --- | --- |
| ジョン・グァノ | チームリーダー／バックエンド | チーム管理、データベース設計、バックエンド全体 |
| キム・スリム | フロントエンド | 会員管理・地図の設計と実装 |
| パク・ジョンウク | フロントエンド | トップページ・マイページの設計と実装 |
| キム・ビョンギュ | フロントエンド | 掲示板・管理者ページの設計と実装 |

## 技術構成

| 分野 | 使用技術 |
| --- | --- |
| フロントエンド | HTML、CSS、JavaScript、Bootstrap、JSP、JSTL |
| バックエンド | Java 17、Servlet、JDBC |
| データベース | Oracle、JNDI DataSource |
| 地図 | Google Maps JavaScript API |
| ライブラリ | Gson、JavaMail、BCrypt |
| 開発環境 | Eclipse、Apache Tomcat 9、Git、GitHub |

## アプリケーション構成

Servlet MVCを基本とし、リクエストの処理、業務ロジック、データアクセス、画面表示を分離しています。

```text
ブラウザー → Controller → Service → DAO / SQL → Oracle
                  ↓
             JSP または JSON
                  ↓
              画面の表示・更新
```

- **Controller**：URLに応じた処理の振り分けと画面遷移
- **Service**：入力検証、権限確認、各機能の業務処理
- **DAO / SQL**：JDBCを利用したデータの取得・保存
- **DTO**：各層の間でのデータの受け渡し
- **JSP / JavaScript / CSS**：画面構成、操作、表示スタイル

## ディレクトリ構成

```text
KumanoMae/
├── index.html                 # 発表資料の入口
├── presentation/              # 発表用CSS・JavaScript・画像
└── src/main/
    ├── java/com/jsl/
    │   ├── controller/
    │   ├── service/
    │   ├── dao/
    │   ├── dto/
    │   ├── sql/
    │   └── util/
    └── webapp/
        ├── index.jsp          # アプリケーションのトップ画面
        ├── WEB-INF/views/     # JSP画面
        └── resources/         # アプリ用CSS・JavaScript・画像
```

## 実行環境について

アプリケーション本体を実行するには、Java 17・Tomcat 9・Oracleと、必要なテーブルおよびビューの準備が必要です。Eclipseの既存プロジェクトとして読み込み、接続先に合わせて設定してください。

- DB接続：`src/main/webapp/META-INF/context.xml.example`を参考に、`jdbc/kumanomae`のDataSourceを設定
- メール：`src/main/webapp/WEB-INF/classes/mail.properties.example`を参考に送信設定を準備
- Google Maps：実行環境のAPIキー設定を準備
- 画像アップロード：実行環境に合った保存先を設定

認証情報やAPIキーは各自の環境で管理し、公開リポジトリには含めないでください。

発表資料は、ルートの`index.html`と`presentation`フォルダーを同じ階層に置いて開けます。埋め込まれたYouTube動画の視聴にはインターネット接続が必要です。

## ソースコード

[GitHub — hiro7899/KumanoMae](https://github.com/hiro7899/KumanoMae)
