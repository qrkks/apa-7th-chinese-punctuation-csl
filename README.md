# APA 7 中文全角引用括号

简体中文 | [English](README.en.md)

这是一个非官方 CSL 变体：保留 APA 第 7 版的著者—日期规则和参考文献格式，
仅将文内引用生成的圆括号改为中文全角括号。配套 Lua 过滤器处理中文引用边界
处的源空格。

```text
夹注引用：（Hu & Bentler, 1999）
多篇引用：（Dunn et al., 2014; Hu & Bentler, 1999）
叙述式引用：Hu & Bentler （1999）
```

叙述式引用中的著者与年份括号之间保留 APA 生成的一个空格。过滤器保留
叙述式引用前的源空格和引用内部间隔，只删除引用后、继续中文正文前的源空格。
本项目与美国心理学会（American Psychological Association）不存在隶属或
官方认可关系。

## 安装

### 只在 Zotero 中使用

[打开并下载 CSL 样式](./apa-7th-chinese-punctuation.csl)，然后用 Zotero 打开该
文件并确认安装。样式名称显示为
**APA 7th edition (Chinese full-width parentheses)**。

Lua 过滤器只用于 Pandoc/Quarto，不会随 Zotero CSL 样式一起安装，也不会在
Zotero 中运行。

### 在 Quarto / Pandoc 中使用

需要同时使用 [CSL 样式](./apa-7th-chinese-punctuation.csl)和
[中文引用空格过滤器](./filters/zh-citation-spacing.lua)。可以分别下载，也可以
克隆整个仓库：

```powershell
git clone https://github.com/qrkks/apa-7th-chinese-punctuation-csl.git
```

正式版本还可以从 [GitHub Releases](https://github.com/qrkks/apa-7th-chinese-punctuation-csl/releases/latest)
下载。

## 修改内容

本项目只本地化文内引用生成的圆括号：

- 圆括号由 `()` 改为 `（）`；
- 著者、年份和定位信息之间仍使用 APA 英文逗号 `, `；
- 同一引用簇中的多篇文献仍使用 APA 英文分号 `; `；
- 参考文献表与官方 APA CSL 保持完全一致。

括号将引用内容与中文正文隔开，而括号内部仍是 APA 英文著者—年份表达，因此
保留英文标点。自动化测试会检查括号、内部标点、叙述式引用、参考文献表和
上游来源的一致性。

## Quarto 配置

请根据本仓库相对于 QMD 项目的实际位置调整路径；例如二者位于同级目录时：

```yaml
csl: ../apa-7th-chinese-punctuation-csl/apa-7th-chinese-punctuation.csl
filters:
  - ../apa-7th-chinese-punctuation-csl/filters/zh-citation-spacing.lua
```

Markdown 原文保持格式无关的通用写法，包括引用标记前后的正常空格：

```markdown
中文正文 [@hu1999]。
引用后还有正文 [@hu1999] 继续。
叙述式引用 @hu1999 指出……
```

Pandoc 会将源空格表示为独立于 `Cite` 的节点，CSL 本身无法控制它。Lua 过滤器
删除括号式引用紧邻的前后 `Space` 节点；对于叙述式引用，只删除引用后的源
空格，并保留引用前和著者—年份内部的间隔。普通括号、公式和参考文献表不受
影响。

输出英文文档时，改用标准 APA CSL 并停用该过滤器即可，无需修改 QMD 原文。
绝对路径也可以使用，但将文档项目和本仓库放在同级目录并采用相对路径更便于
迁移。

## 构建与上游更新

官方 APA 源文件保存在 `vendor/apa.csl`，其版本分支、精确 commit 和 SHA-256
记录在 `vendor/upstream.json`。日常构建固定使用该快照，可离线、可复现：

```powershell
./scripts/build-style.ps1
./tests/test-style.ps1 -SkipRemoteCheck
```

如需从 CSL 官方仓库稳定的 `v1.0.2` **版本分支**显式获取新快照，并重新记录
commit、哈希和生成派生样式：

```powershell
./scripts/update-upstream.ps1
./tests/test-style.ps1
```

构建脚本只修改样式元数据、生成文件说明和文内引用的圆括号；如果上游预期
结构发生变化，脚本会停止。默认测试会联网确认 vendored 文件与已记录的精确
上游 commit 一致；离线时可使用 `-SkipRemoteCheck`。

## 许可与署名

- [`vendor/apa.csl`](./vendor/apa.csl) 和生成的
  [`apa-7th-chinese-punctuation.csl`](./apa-7th-chinese-punctuation.csl)
  采用 [CC BY-SA 3.0](./LICENSES/CC-BY-SA-3.0.txt)；
- `filters/`、`scripts/`、`tests/`、GitHub Actions 和项目文档采用
  [MIT License](./LICENSES/MIT.txt)。

原 APA CSL 作者和贡献者保留在 CSL 元数据中，`qrkks` 列为本变体的维护者。
完整的文件许可边界见 [`LICENSE`](./LICENSE)。
