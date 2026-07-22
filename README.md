# APA 7 中文文内引用适配

简体中文 | [English](README.en.md)

这是一个面向中文正文的非官方 APA 第 7 版文内引用适配方案。CSL 变体保留
APA 的著者—日期规则和参考文献格式，并将文内引用圆括号改为中文全角括号；
配套 Lua 过滤器统一处理引用边界空格、叙述式年份括号间距和作者连接符。

```text
夹注引用：（Hu & Bentler, 1999）
多篇引用：（Dunn et al., 2014; Hu & Bentler, 1999）
叙述式引用：Hu 和 Bentler（1999）
```

叙述式引用中的 `&` 改为“和”，但不增删“和”两侧的空格；是否采用盘古空格由
用户自己的排版工具决定。年份全角左括号前不留空格。空格过滤器保留叙述式
引用前的源空格，只删除引用后、继续中文正文前的源空格。
本项目与美国心理学会（American Psychological Association）不存在隶属或
官方认可关系。

## 安装

### 只在 Zotero 中使用

[打开并下载 CSL 样式](./apa-7th-chinese-punctuation.csl)，然后用 Zotero 打开该
文件并确认安装。样式名称显示为
**APA 7th edition (Chinese full-width parentheses)**。

Zotero 单独安装该 CSL 时只获得中文全角引用括号。Lua 过滤器仅用于
Pandoc/Quarto，不会随 CSL 一起安装，也不会在 Zotero 中运行。在 Zotero 中制作
叙述式引用时，可在正文中输入带“和”的作者短语，再插入省略作者的年份引用。

### 在 Quarto / Pandoc 中使用

需要同时使用 [CSL 样式](./apa-7th-chinese-punctuation.csl)和
[中文文内引用过滤器](./filters/zh-citation.lua)。可以分别下载，也可以克隆整个
仓库：

```powershell
git clone https://github.com/qrkks/apa-7th-chinese-punctuation-csl.git
```

正式版本还可以从 [GitHub Releases](https://github.com/qrkks/apa-7th-chinese-punctuation-csl/releases/latest)
下载。

## 修改内容

本项目本地化文内引用的括号及叙述式连接符：

- 圆括号由 `()` 改为 `（）`；
- 著者、年份和定位信息之间仍使用 APA 英文逗号 `, `；
- 同一引用簇中的多篇文献仍使用 APA 英文分号 `; `；
- 叙述式引用中的作者连接符由 `&` 改为“和”，夹注引用仍使用 `&`；
- 参考文献表与官方 APA CSL 保持完全一致。

括号将引用内容与中文正文隔开，而括号内部仍是 APA 英文著者—年份表达，因此
保留英文标点。自动化测试会检查括号、内部标点、叙述式引用、参考文献表和
上游来源的一致性。

## Quarto 配置

请根据本仓库相对于 QMD 项目的实际位置调整路径；例如二者位于同级目录时：

```yaml
csl: ../apa-7th-chinese-punctuation-csl/apa-7th-chinese-punctuation.csl
citeproc: false
filters:
  - ../apa-7th-chinese-punctuation-csl/filters/zh-citation.lua
```

Markdown 原文保持格式无关的通用写法，包括引用标记前后的正常空格：

```markdown
中文正文 [@hu1999]。
引用后还有正文 [@hu1999] 继续。
叙述式引用 @hu1999 指出……
```

Pandoc 会将源空格表示为独立于 `Cite` 的节点，CSL 本身无法控制它。统一过滤器
先删除夹注引用紧邻的前后 `Space` 节点；对于叙述式引用，保留引用前的源空格并
删除引用后的源空格。随后过滤器执行 citeproc，删除所有叙述式引用年份括号前的
内部 `Space`，并只把连接两位个人作者的独立 `&` 改为“和”。“和”左右已有的
空格保持不变；机构作者名称、夹注引用、普通括号、公式和参考文献表不受影响。

`citeproc: false` 用于关闭 Quarto 稍后执行的默认 citeproc；统一过滤器会在正确
阶段自行调用 Pandoc citeproc，因此用户无需管理多个过滤器的执行顺序。

直接调用 Pandoc 时同样需要保持处理顺序：

```powershell
pandoc input.qmd --lua-filter=filters/zh-citation.lua `
  --bibliography=references.bib --csl=apa-7th-chinese-punctuation.csl `
  -o output.docx
```

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
