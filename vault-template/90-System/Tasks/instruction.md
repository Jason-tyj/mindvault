# 90-System/Tasks · 定时任务卡（Scheduled Task Specs）

Personal AI OS 定时任务的定义文件（SSOT）。**业务规则以本目录任务卡为准**；调度由情报官 / 质检师 / 参谋长（Grok Bot）routines 与 Codex 分平台承担（Hermes / OpenClaw 已卸），运行状态与标识见 [[index]]。

**编队登记 SSOT** = [[90-System/AgentOS/charter]] §6（活跃≤8，含 Codex；审批线、遗留席位）；本目录只登记定时任务平台归属，不另立编队名单。

## 定位

Vault 不跑定时器，本目录只存任务的权威定义。时间统一为 Asia/Singapore（UTC+8）。

**当前分工（2026-10-26）**：新闻×3→**情报官**；Vault 周巡检 + Inbox 日整理→**质检师**；CRM 联系人审计→**参谋长**。Hermes / OpenClaw / 龙虾已下线；旧 Codex Inbox automation 已 pause（≠ 新席位 Codex Bot）。各平台直接读写 MindVault；新闻流、周巡检、Inbox 不发飞书。

任务卡的「情报官执行约定」「质检师执行约定」「参谋长执行约定」或「Codex 当前执行约定」是对应任务的执行入口；Hermes / Codex 历史定义仅作追溯，不得执行旧通知、旧路由和旧模型命令。**禁止双跑**：同一业务任务不得同时在多平台 ACTIVE。

## 任务卡的 5 要素

每份任务卡（一个 `.md`）必须写清触发时间、执行模式、任务 prompt、输出目标、Vault 回写策略。

## 完整任务一览（7 个，更新至 2026-11-11）

### 日间推送（3 个新闻流）

| 文件 | 触发 | 执行平台 | 完成通知 | Vault 回写 |
| --- | --- | --- | --- | --- |
| [[news-ai-tech-daily]] ✅ | 每天约 12:30（±15min） | 情报官 routines | 会话简讯（有新增/异常才报） | `03-Resources/资讯流/AI科技/YYYY-MM.md` |
| [[news-medical-ai-daily]] ✅ | 每天约 13:00（±15min） | 情报官 routines | 会话简讯（有新增/异常才报） | `03-Resources/资讯流/医疗AI/YYYY-MM.md` |
| [[news-health-it-daily]] ✅ | 每天约 13:30（±15min） | 情报官 routines | 会话简讯（有新增/异常才报） | `03-Resources/资讯流/医疗信息化/YYYY-MM.md` |

### 系统运维（1 个）

| 文件 | 触发 | 模式 | 目标 | 说明 |
| --- | --- | --- | --- | --- |
| [[vault-weekly-sop]] ✅ | 周日 08:00 | 质检师 routines | 质检师会话简讯 + Vault 日志 | A1–A8 八项 + B 附录，只报告不修复；唯一写入为巡检日志 |

### Vault 日常维护（2 个）

| 文件 | 触发 | 模式 | 目标 | 说明 |
| --- | --- | --- | --- | --- |
| [[vault-curator-inbox-daily]] ✅ | 每天 22:00 | 质检师 routines | 质检师会话 + Vault 日志 | 提炼 Clippings → 沉淀到目标目录和 index；仅规则变化才改 instruction |
| [[crm-contact-audit]] ✅ | 周日 22:00 | 参谋长 routines | 参谋长会话 | 扫描 14 天 Daily Log，筛选频次 ≥3 天的新联系人，汇报候选清单 |

### 飞书工作区（1 个）

| 文件 | 触发 | 模式 | 目标 | 说明 |
| --- | --- | --- | --- | --- |
| [[feishu-workspace-daily]] ✅ | 每天 01:10 | 豆包本地 cron（Mac mini） | 当日 Daily | lark-cli 只读采集 + 五段式总结，写 `### 🦞 飞书工作区总结 · YYYY-MM-DD`；2026-11-11 转正 |

## 运行纪律

- 新任务先**跑两周验证**再固化（charter §9：未被日常验证的管道不投入自动化）
- 月度复盘统计各任务实际价值，低频/低质的砍掉

## 最新改动（2026-06-15）

1. **时间对齐**：医疗 AI 改为 13:00，医疗信息化改为 13:30（三档依次 12:30/13:00/13:30）
2. **回写机制**：推送飞书后，由 vault-curator 将简报追加到 `03-Resources/资讯流/` 对应子目录的当月文件
3. **推送内容**：飞书只发简短完成通知（几行摘要），简报全文仅存 Vault，不推飞书群
4. **龙虾流水线修正**：`lobster-daily-archive` 下游 prompt 原为错误的「患者随访」假设，已修正为「每日工作活动汇总」归档
5. **全量梳理**：新增 5 个现存定时任务的任务卡（openclaw晨检、vault-weekly-sop、lobster-collect-data、lobster-daily-archive、vault-curator-inbox-daily），共 8 个任务全部入 Vault

## 最新改动（2026-06-27）

1. **Vault 周巡检增强**：`vault-weekly-sop` 从五项结构检查升级为结构、状态、回写三类巡检。
2. **新增检查对象**：Area 工作台、Project 项目卡、Resources 提炼、Daily 回写、内容创作选题池、团队 AI 转型行动清单。
3. **运行原则不变**：周巡检只报告不自动修改，结果写入当日 Daily Log。

## 最新改动（2026-07-12）

1. **新增 CRM 联系人审计**：`crm-contact-audit` 每周日 22:00 扫描 14 天 Daily Log，筛选出现 ≥3 天的新联系人候选清单汇报给用户。
2. **入库规则**：业务意义明确 + 频次 ≥3 天 + 有实质交互 + 不在 contact.md。用户确认后才入库。

## 最新改动（2026-07-21）

1. **医疗AI Daily 筛选标准新增**：`news-medical-ai-daily` 新增第4条筛选标准「国际顶级研究型医院的AI落地（Mayo Clinic、克利夫兰诊所等）」。

## 最新改动（2026-08-30）

1. **暂停 5 个定时任务**（2026-08-30 08:58 暂停，未删除，job_id 保留可恢复）：
   - `news-ai-tech-daily`（job_id: 86b2866478ca）
   - `news-medical-ai-daily`（job_id: 7d6ab37686f2）
   - `news-health-it-daily`（job_id: 722ce399d6a6）
   - `vault-weekly-sop`（Vault 周巡检，job_id: 9ffad4a9ebe2）
   - `vault-curator-inbox-daily`（job_id: 944202b5f452）
2. 08:58 的暂停记录保留。随后 owner 确认将这五项迁入 Codex，完成通知改到 Codex、不再发飞书；五个独立任务均已创建并启用，完整映射见 [[index]]。
3. 所有迁移任务使用 gpt-5.6-terra / medium，直接运行于 MindVault 本地目录；新闻使用 Codex 内置 Web 搜索，Vault 回写不再依赖 Hermes。首次定时运行待验证。
4. 如需回滚，先暂停对应 Codex 任务，再经 owner 确认恢复 Hermes；不得直接双开。

## 最新改动（2026-10-25）

1. **三份新闻流迁至情报官（Grok Bot）**：`news-ai-tech-daily` / `news-medical-ai-daily` / `news-health-it-daily` 由情报官 routines（`AI科技日更` ~12:30、`医疗AI日更` ~13:00、`医疗信息化日更` ~13:30，flexible ±15min）执行；筛选、格式、覆盖窗口、回写路径、去重、Daily 工作记录、不发飞书等业务规则不变。
2. **Codex 同名 automation 已 pause**（owner 停）；Hermes 同名旧任务仍暂停。禁止双跑。
3. 任务卡「Codex 当前执行约定」改名为「情报官执行约定」；Codex / Hermes 段落保留为历史追溯。Inbox 仍由 Codex 执行。
4. **Vault 周巡检优化草案**：`vault-weekly-sop` 写入「质检师执行约定」与优化八项清单（结构/自洽/冲突优先；策展为附录；修好 Monthly 空转；新增双跑与边界冲突检查）。备份：`vault-weekly-sop.md.bak-20261025`。
5. **Vault 周巡检正式迁至质检师（live）**：owner 已删除 Codex `vault-9`；质检师 CreateRoutine（周日 08:00）接手；任务卡抬头改为质检师 live，「Codex 当前执行约定」改为「Codex 历史（已删除，仅追溯）」；同步 Tasks index / instruction 与 CLAUDE.md→AGENTS.md。禁止双跑。

## 最新改动（2026-10-26）

1. **下线 OpenClaw**：owner 确认卸载 OpenClaw 应用与数据后，删除任务卡 `openclaw晨检.md`；Hermes job `32d038808377` 已暂停。本目录不再登记该项。

## 最新改动（2026-10-26 · Hermes）

1. **下线 Hermes**：owner 确认停止并清除 Hermes 后，gateway / `~/.hermes` / LaunchAgents（含已 disabled 的 running-coach、vault-curator）已删除。
2. **crm-contact-audit** 已迁参谋长 routines（周日 22:00）；龙虾/晨检已下线。新闻流与 Vault 周巡检仍在情报官/质检师。

## 最新改动（2026-10-26 · 龙虾流水线）

1. **下线龙虾流水线**：owner 确认删除任务卡 `lobster-collect-data` / `lobster-daily-archive`（原 Hermes 01:10→01:20）。本目录不再登记。

## 最新改动（2026-10-26 · CRM）

1. **crm-contact-audit → 参谋长**：周日 22:00 由参谋长 routines 执行；候选清单进会话、不改 Vault；原 Hermes job 随平台已卸。

## 最新改动（2026-10-26 · Inbox→质检师）

1. **vault-curator-inbox-daily → 质检师**：每天约 22:00；Codex automation 已 PAUSED；任务卡改「质检师执行约定」。

## Daily 建档（全任务共用）

任意任务卡写入当日 Daily 时：文件不存在须先按 [[../../10-Logs/Daily/instruction|Daily/instruction]] 建齐五个一级节（今日日程→待办清理→运动→随手记→工作记录），再写「## 工作记录」下本任务段落；禁止半截建档。章程 v1.21。
