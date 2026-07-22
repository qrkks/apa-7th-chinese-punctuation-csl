# APA 7 中文全角引用括号

简体中文 | [English](README.en.md)

这是一个非官方 CSL 样式：保留 APA 第 7 版的参考文献表和著者规则，仅将
中文正文中夹注引用的外层括号改为全角括号。

```text
（Hu & Bentler, 1999）
（Dunn et al., 2014; Hu & Bentler, 1999）
```

本项目与美国心理学会（American Psychological Association）不存在隶属或
官方认可关系。

## 安装

可以直接下载 `apa-7th-chinese-punctuation.csl`，也可以克隆整个仓库，同时获得
CSL 样式和 Pandoc 空格过滤器：

```powershell
git clone https://github.com/qrkks/apa-7th-chinese-punctuation-csl.git
```

## 修改内容

本项目仅本地化正文夹注引用的外层括号：

- 外层括号由 `()` 改为 `（）`；
- 著者、年份和定位信息之间仍使用 APA 英文逗号 `, `；
- 同一引用簇中的多篇文献仍使用 APA 英文分号 `; `。

括号将引用内容与中文正文隔开，而括号内部仍是 APA 英文著者—年份表达，因此
保留英文标点。参考文献表与官方 APA CSL 完全一致，并由自动化测试保证。

## Quarto

建议同时使用 CSL 和引用空格过滤器。请根据本仓库相对于 QMD 项目的实际位置
调整路径；例如二者位于同级目录时：

```yaml
csl: ../apa-7th-chinese-punctuation-csl/apa-7th-chinese-punctuation.csl
filters:
  - ../apa-7th-chinese-punctuation-csl/filters/zh-citation-spacing.lua
```

Markdown 原文保持格式无关的通用写法，包括引用标记前的正常空格：

```markdown
中文正文 [@hu1999]。
```

Pandoc 会将这个源空格表示为独立于 `Cite` 的节点，CSL 本身无法控制它。Lua
过滤器只删除括号式引用紧邻的前后空格，不修改叙述式引用、普通括号、公式或
参考文献表。

输出英文文档时，改用标准 APA CSL 并停用该过滤器即可，无需修改 QMD 原文。
绝对路径也可以使用，但将文档项目和本仓库放在同级目录并采用相对路径更便于
迁移。

## Zotero

用 Zotero 打开 `apa-7th-chinese-punctuation.csl` 并确认安装。样式名称显示为
**APA 7th edition (Chinese full-width parentheses)**。

## 从官方 APA 更新

固定版本的官方 APA 源文件保存在 `vendor/apa.csl`。日常构建可离线、可复现：

```powershell
./scripts/build-style.ps1
./tests/test-style.ps1 -SkipRemoteCheck
```

如需显式刷新官方源文件并重新生成派生样式：

```powershell
./scripts/update-upstream.ps1
./tests/test-style.ps1
```

更新脚本从 CSL 官方仓库稳定的 `v1.0.2` 标签下载 APA CSL。构建脚本只修改
样式元数据和正文引用的外层括号；如果上游预期结构发生变化，脚本会停止。
默认测试还会联网确认 vendored 快照与固定的官方源文件一致；离线时可使用
`-SkipRemoteCheck`。

## 许可与署名

生成的样式派生自官方 APA CSL，继续采用 CC BY-SA 3.0 许可。原作者和贡献者
保留在 CSL 元数据中，`qrkks` 列为本变体的维护者。
