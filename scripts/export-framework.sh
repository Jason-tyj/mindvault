#!/usr/bin/env bash
# export-framework.sh — MindVault 框架单向导出脚本（白名单模式）
# 从私有知识库中仅抽取通用框架、结构、模板与脚本，导出到开源公开仓库目录。
# 绝不复制任何个人日志、真实CRM、真实健康档案、私有项目与凭据。

set -euo pipefail

VAULT="$(cd "$(dirname "$0")/../.." && pwd)"
DEST="${1:-$HOME/Projects/mindvault}"
TEMPLATE_DIR="$DEST/vault-template"

echo "🚀 开始导出 MindVault 框架..."
echo "  • 源目录 (私库): $VAULT"
echo "  • 目标目录 (公开库): $DEST"

rm -rf "$TEMPLATE_DIR"
mkdir -p "$TEMPLATE_DIR"
mkdir -p "$DEST/scripts"
mkdir -p "$DEST/docs"
mkdir -p "$DEST/examples"

# 1. 顶层入口协议（CLAUDE / AGENTS）
cp "$VAULT/CLAUDE.md" "$DEST/CLAUDE.md"
cp "$VAULT/AGENTS.md" "$DEST/AGENTS.md"
cp "$VAULT/CLAUDE.md" "$TEMPLATE_DIR/CLAUDE.md"
cp "$VAULT/AGENTS.md" "$TEMPLATE_DIR/AGENTS.md"

# 2. 核心脚本（只复制通用扫描脚本和示例清单；私有 privacy-blocklist.txt 永不导出）
cp "$VAULT/90-System/Scripts/sync-agents-md.sh" "$DEST/scripts/sync-agents-md.sh"
cp "$VAULT/90-System/Scripts/check-privacy.sh" "$DEST/scripts/check-privacy.sh"
cp "$VAULT/90-System/Scripts/export-framework.sh" "$DEST/scripts/export-framework.sh"
cp "$VAULT/90-System/Scripts/privacy-blocklist.example.txt" "$DEST/scripts/privacy-blocklist.example.txt"
chmod +x "$DEST/scripts/"*.sh

mkdir -p "$TEMPLATE_DIR/90-System/Scripts"
cp "$VAULT/90-System/Scripts/sync-agents-md.sh" "$TEMPLATE_DIR/90-System/Scripts/sync-agents-md.sh"
cp "$VAULT/90-System/Scripts/check-privacy.sh" "$TEMPLATE_DIR/90-System/Scripts/check-privacy.sh"
cp "$VAULT/90-System/Scripts/privacy-blocklist.example.txt" "$TEMPLATE_DIR/90-System/Scripts/privacy-blocklist.example.txt"
chmod +x "$TEMPLATE_DIR/90-System/Scripts/"*.sh

# 3. 模板库文件
mkdir -p "$TEMPLATE_DIR/03-Resources/Templates"
cp "$VAULT/03-Resources/Templates/Area 工作台模板.md" "$TEMPLATE_DIR/03-Resources/Templates/"
cp "$VAULT/03-Resources/Templates/Project 项目卡模板.md" "$TEMPLATE_DIR/03-Resources/Templates/"
cp "$VAULT/03-Resources/Templates/Resource 资料索引模板.md" "$TEMPLATE_DIR/03-Resources/Templates/"
cp "$VAULT/03-Resources/Templates/Daily 建档骨架.md" "$TEMPLATE_DIR/03-Resources/Templates/"

# 4. 各顶层目录结构
DIRECTORIES=(
  "00-Inbox" "00-Inbox/Clippings" "00-Inbox/Scratch"
  "01-Areas"
  "02-Projects"
  "03-Resources" "03-Resources/Templates" "03-Resources/Prompts" "03-Resources/SOP"
  "04-Archive" "04-Archive/Inbox-Clippings"
  "10-Logs" "10-Logs/Daily" "10-Logs/Monthly"
  "20-CRM" "20-CRM/Context"
  "90-System" "90-System/Tasks" "90-System/Skills" "90-System/AgentOS"
)

for dir in "${DIRECTORIES[@]}"; do
  mkdir -p "$TEMPLATE_DIR/$dir"
  touch "$TEMPLATE_DIR/$dir/.gitkeep"
done

# 5. 复制无私有信息的 instruction
cp "$VAULT/00-Inbox/instruction.md" "$TEMPLATE_DIR/00-Inbox/instruction.md"
cp "$VAULT/00-Inbox/Clippings/instruction.md" "$TEMPLATE_DIR/00-Inbox/Clippings/instruction.md"
cp "$VAULT/00-Inbox/Scratch/instruction.md" "$TEMPLATE_DIR/00-Inbox/Scratch/instruction.md"
cp "$VAULT/03-Resources/instruction.md" "$TEMPLATE_DIR/03-Resources/instruction.md"
cp "$VAULT/03-Resources/Templates/instruction.md" "$TEMPLATE_DIR/03-Resources/Templates/instruction.md"
cp "$VAULT/04-Archive/Inbox-Clippings/instruction.md" "$TEMPLATE_DIR/04-Archive/Inbox-Clippings/instruction.md"
cp "$VAULT/10-Logs/instruction.md" "$TEMPLATE_DIR/10-Logs/instruction.md"
cp "$VAULT/10-Logs/Daily/instruction.md" "$TEMPLATE_DIR/10-Logs/Daily/instruction.md"
cp "$VAULT/10-Logs/Monthly/instruction.md" "$TEMPLATE_DIR/10-Logs/Monthly/instruction.md"
cp "$VAULT/90-System/instruction.md" "$TEMPLATE_DIR/90-System/instruction.md"
cp "$VAULT/90-System/Tasks/instruction.md" "$TEMPLATE_DIR/90-System/Tasks/instruction.md"

# 6. 生成通用的 Area / Project / Archive / CRM instruction
cat << 'EOF' > "$TEMPLATE_DIR/01-Areas/instruction.md"
# 01-Areas · 长期责任领域

长期持续投入、需要持续维护标准的业务与生活领域。没有固定截止日期。

| 文件夹 | 说明 |
| --- | --- |
| **业务管理/** | 长期业务线与运营主线 |
| **技术规划/** | 架构演进与技术栈治理 |
| **团队建设/** | 人员梯队、组织协同与培养 |
| **个人健康/** | 体能训练、体检档案与健康管理 |

每个子文件夹内包含一份 `instruction.md`（定义领域边界与规则）与 `index.md`（当前主线与工作台）。
EOF

cat << 'EOF' > "$TEMPLATE_DIR/02-Projects/instruction.md"
# 02-Projects · 在建项目

有明确交付成果、截止日期与验收标准的项目。

- 每个项目设立一个独立子文件夹；
- 命名规范：`YYYYMM-序号-项目名`（例如：`202611-01-系统重构`）；
- 项目卡规范：子目录下建立 `index.md`（使用 [[03-Resources/Templates/Project 项目卡模板|项目卡模板]]）；
- 项目交付或终止时，整体移入 `04-Archive/` 归档。
EOF

cat << 'EOF' > "$TEMPLATE_DIR/04-Archive/instruction.md"
# 04-Archive · 归档区

已完成或搁置的项目、历史日志与原始素材的冷存储区。

| 文件夹 | 说明 |
| --- | --- |
| **已归档项目/** | 从 02-Projects/ 迁入的已完结项目 |
| **Inbox-Clippings/** | 处理完毕的剪藏原文（只读回溯池） |
| **Inbox-Scratch/** | 已闭环的历史草稿与报告 |
EOF

cat << 'EOF' > "$TEMPLATE_DIR/20-CRM/instruction.md"
# 20-CRM · 关系与协作网络

用于维护人脉网络、团队组织角色及 Owner 私有环境配置。

- `contact.md`：团队与外部联系人总表；
- `Context/instance.md`：本地执行机、代理及编队环境覆盖配置（私有，不进版本库）；
- `Context/user.md`：Owner 背景画像、核心目标与决策偏好。
EOF

cat << 'EOF' > "$TEMPLATE_DIR/20-CRM/contact.md.template"
# 通讯录与协作角色表

| 姓名 | 组织/部门 | 职务/角色 | 关注领域 | 协作关系 |
| --- | --- | --- | --- | --- |
| 张三 (示例) | 核心业务部 | 负责人 | 业务运营 | 业务对接 |
| 李四 (示例) | 技术架构组 | 架构师 | 基础平台 | 技术支持 |
EOF

cat << 'EOF' > "$TEMPLATE_DIR/90-System/AgentOS/instruction.md"
# AgentOS · 个人智能体操作系统

多智能体编队协同体系的配置与说明。

- 编队角色规范见根目录 [[CLAUDE|CLAUDE.md]] 与 [[charter|charter.md]]；
- 各角色的具体调度由 `90-System/Tasks/` 中的任务卡驱动；
- 本地机器参数与定制模型绑定见 `20-CRM/Context/instance.md`。
EOF

# 7. 空白工作台与变更日志
cat << 'EOF' > "$TEMPLATE_DIR/10-Logs/wiki-log.md"
# wiki-log · 库级变更日志

只追加，不改旧条。格式与规则见 [[instruction]] 与 [[CLAUDE]]「稳定页、引用与变更传播」。类型限定：`ingest` / `query` / `lint` / `fix` / `rule`。
EOF

cat << 'EOF' > "$TEMPLATE_DIR/20-CRM/Context/instance.md.template"
# 实例与执行环境配置 (Instance & Runtime Config)

> 复制本文件为 `instance.md` 并填写您的本地个性化配置（该文件受隐私保护，永不提交到公共 Git 仓库）。

## 1. Owner 身份与背景索引
- **详细画像与职场角色**：见 [[user|20-CRM/Context/user.md]]
- **个人发展与决策准则**：见 [[个人发展与决策准则|20-CRM/Context/个人发展与决策准则.md]]
- **核心主线**：填写本年度核心目标与管理关注

## 2. 本地执行机与环境配置
- **默认执行面**：本地工作站 (如 macOS / Linux / Cloud VM)
- **设备标识 (machineId)**：填写您的设备唯一标识或留空
- **本地工具 CLI 路径**：
  - Codex CLI: `~/.local/bin/codex`
  - Antigravity / Claude CLI: `~/.local/bin/agy`
- **网络与代理配置**：
  - 代理环境变量（若需要）：`export http_proxy=... https_proxy=...`
- **备份与暂存路径**：
  - 本地快照备份根目录：`~/Backups/MindVault/`

## 3. 活跃编队实例绑定
| Bot 角色 | 平台 / 模型 | 专属职责与绑定资源 |
| --- | --- | --- |
| **参谋长** | 如 Claude 3.5 / GPT-4o | 入口/工作台；统筹跨域对齐与审批流 |
| **情报官** | 如 Perplexity / Gemini | 行业日更；事实核查与一手溯源台 |
| **质检师** | 如 Claude / GPT-4o | 交付终检；MindVault 周巡检 (A1–A9 只检不修) |
| **工具型/外包** | 本地 CLI Agent | 本地终端复杂代码或文档工程处理 |

## 4. 本地自动化例程 (Local Daemons & Cron)
- 记录本地定时任务或守护进程。
EOF

cat << 'EOF' > "$TEMPLATE_DIR/20-CRM/Context/user.md.template"
# Owner 画像与背景

### 职场角色
- **当前职务**：{{您的职位/角色}}
- **负责领域**：{{业务方向/技术团队}}

### 决策风格与沟通偏好
- 言简意赅、目标导向、结论先行。
- 逻辑漏洞直接指出，不廉价附和。

### 年度核心目标
- 目标 1：...
- 目标 2：...
EOF

# 8. 复制通用任务卡并脱敏路径
sed "s|$VAULT|{{VAULT_PATH}}|g" \
  "$VAULT/90-System/Tasks/vault-weekly-sop.md" > "$TEMPLATE_DIR/90-System/Tasks/vault-weekly-sop.md"

sed "s|$VAULT|{{VAULT_PATH}}|g" \
  "$VAULT/90-System/Tasks/vault-curator-inbox-daily.md" > "$TEMPLATE_DIR/90-System/Tasks/vault-curator-inbox-daily.md"

# 9. 执行隐私脱敏静态安全扫描
# 用私库中的 blocklist 扫描导出目录，这样公开脚本不再自带私有特征词，仍能检出泄漏。
echo "🔒 执行导出产物安全扫描..."
"$VAULT/90-System/Scripts/check-privacy.sh" \
  --blocklist "$VAULT/20-CRM/Context/privacy-blocklist.txt" \
  "$DEST"

echo ""
echo "🎉 框架导出成功！公开仓库就绪于：$DEST"
