# Desmos.jl
Generate Desmos script (JSON) with Julia language.

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://hyrodium.github.io/Desmos.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://hyrodium.github.io/Desmos.jl/dev)
[![Build Status](https://github.com/hyrodium/Desmos.jl/workflows/CI/badge.svg)](https://github.com/hyrodium/Desmos.jl/actions?query=workflow%3ACI+branch%3Amain)
[![codecov](https://codecov.io/gh/hyrodium/Desmos.jl/branch/main/graph/badge.svg?token=dJBiR91dCD)](https://codecov.io/gh/hyrodium/Desmos.jl)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

## First example
```julia
using Desmos, JSON
state = @desmos begin
    @expression cos(x) color=RGB(1,0,0)
    @expression sin(x) color=RGB(0,0,1)
    tan(x)
end
clipboard(JSON.json(state, 4))
```

https://user-images.githubusercontent.com/7488140/227839138-7aabfb64-3be1-4ef6-88f8-543c9fc5421a.mp4

See [documentation](https://hyrodium.github.io/Desmos.jl/dev/) for more information.

## Desmos Text I/O
Note that this package requires [Desmos Text I/O extension](https://github.com/hyrodium/DesmosTextIO).

[![](https://raw.githubusercontent.com/hyrodium/desmos-text-io/main/logo.svg)](https://github.com/hyrodium/DesmosTextIO)

* [Chrome Web Store](https://chrome.google.com/webstore/detail/desmos-text-io/ndjdcebpigpfidnilppdpcdkibidfmaa)
* [Firefox ADD-ONS](https://addons.mozilla.org/en-US/firefox/addon/desmos-text-i-o/)

## 開発メモ
- 現在の Demos.jl 0.1.0-DEV では古いJSON.jlのバージョン(v1以前)に対応している
- 新しい開発では、desmosが出力するJSONの構造をそのまま保ったまま`DesmosState`型に保持している
- 古い実装は`src/Desmos.jl`に、新しい実装の一部が`src/types.jl`にある
- 今後の実装では、`src/Desmos.jl`に実装していた機能を新しく`src/types.jl`に合わせて実装することになる

### 新しい実装の方針（v0.2.0に向けて）

#### 目標
- JSON.jl v1.x（StructUtils.jl使用）への移行
- DesmosのJSON構造を直接反映した型システム
- よりシンプルで保守性の高いコードベース

#### 実装済み（`src/types.jl`）
- ✅ 基本的な型定義（DesmosExpression, DesmosTable, DesmosImage, DesmosText, DesmosFolder）
- ✅ DesmosState構造とJSON serialization
- ✅ HTML表示機能（Jupyter/VSCode notebook対応）

#### 実装予定（優先順位順）

1. **マクロ層の再実装**
   - [ ] `@desmos`マクロ：既存のDSL構文をそのまま維持
   - [ ] `@expression`, `@variable`, `@table`, `@image`, `@note`, `@folder`マクロ
   - [ ] Julia式→LaTeX変換（Latexify.jlの活用）
   - [ ] `$`記法による動的値の埋め込み

2. **ユーティリティ関数**
   - [ ] 色の処理（RGB → Desmosカラー文字列変換）
   - [ ] 画像のbase64エンコーディング（FileIO.jl, ImageIO.jl使用）
   - [ ] ID自動採番システム

3. **テストとドキュメント**
   - [ ] 既存テストケースの移行
   - [ ] 新しい型システムに対応したテスト追加
   - [ ] ドキュメントの更新

#### 互換性方針
- ユーザー向けAPIは可能な限り維持（`@desmos`マクロの構文は同じ）
- 内部実装の変更によりJSON出力が若干変わる可能性あり
- v0.2.0でbreaking changeとしてリリース予定
