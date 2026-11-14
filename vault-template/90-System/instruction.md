# 90-System · 系统文件

Vault 运转所需的配置与辅助文件。

## 子目录

| 文件夹 | 说明 |
| --- | --- |
| **AgentOS/** | 个人 AI OS 体系文件（[[90-System/AgentOS/charter\|charter.md]] 宪章 **v1.22**、[[90-System/AgentOS/ai-hospital-advisor\|ai-hospital-advisor.md]]；vault-curator/snippets 已迁 `04-Archive/AgentOS/`） |
| **Skills/** | 可版本化的 Codex / Agent Skill 源文件（当前暂无） |
| **Tasks/** | 定时任务定义（新闻×3→情报官；周巡检+Inbox→质检师；CRM→参谋长）。目录规则见 [[90-System/Tasks/instruction\|Tasks/instruction.md]]，运行状态见 [[90-System/Tasks/index\|Tasks/index.md]] |
| **Scripts/** | 含 `sync-agents-md.sh`（CLAUDE→AGENTS）、`feishu-daily-collect.sh`（飞书工作区日总结只读采集，见 [[90-System/Tasks/feishu-workspace-daily\|任务卡]]） |

## 说明

模板、脚本、样式、图标等系统资源统一放此目录，不作为知识内容管理。Hermes / OpenClaw 已于 2026-10-26 卸载，不再作为调度平台。

## 写入与备份规程（B10）

- **批量改写备份**：跨目录批量重写、系统规则变更或结构调整前，必须先在本地机器打包备份至快照目录（见 [[20-CRM/Context/instance|instance.md]]）。
- **写前重读与幂等**：写入前重新读取目标文件；各 Bot 仅在专属锚点或小节内操作，不覆盖他人刚写的内容。

## 敏感信息与误写处置（B11 · 撤回与清除分离）

- **事实错误撤回（Expire / Amend）**：稳定页或时间线中的陈述错误，采用追加新条目（`更正：……`）或重写当前结论，**保留历史事实与演进轨迹，不改旧时间线**。
- **敏感凭据清除（Purge）**：若不慎将密码、API Key、Token、私密证件号误写入库：
  1. **立即报备**：发现后第一时间报告 Jason，由 Jason 决定是否立即轮换/注销该凭据；
  2. **确认后清除**：从库中彻底删除或替换敏感文本（删除操作须 Jason 明确确认）；
  3. **副本联动排查**：清除库内后，必须同步检查与清理本地备份快照中含有该敏感信息的副本，防止随备份泄漏。
