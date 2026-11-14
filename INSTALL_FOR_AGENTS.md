# INSTALL_FOR_AGENTS.md

> **Instruction for AI Assistants**: This document is an executable blueprint for autonomous coding agents (Claude Code, OpenAI Codex, Cursor, Aider, Antigravity, etc.) to bootstrap a new **MindVault** knowledge base in seconds.

---

## Agent System Prompt & Task Objective

You are acting as a **Knowledge Base Systems Architect**. Your task is to initialize a clean, fully-functioning **MindVault: Multi-Agent Personal Knowledge OS** inside a target directory specified by the user.

### Execution Boundaries & Safeguards
1. **Target Directory**: The user specifies the target path. If not provided, ask: *"Please specify the target directory where MindVault should be initialized."*
2. **Non-Destructive**: Never overwrite or delete existing user files. If the target directory exists and is non-empty, create a new subfolder named `MindVault/` within it or request confirmation.
3. **No Fabricated Facts**: Do not invent fake diary logs, meeting notes, personal contacts, or private credentials. All initialization must strictly use structural templates and empty skeletons.
4. **Tool Verification**: Ensure `scripts/sync-agents-md.sh` has executable permissions (`chmod +x`).

---

## Step-by-Step Initialization Procedure

### Step 1: Copy or Build the Directory Skeleton
If running inside the `mindvault` repository, copy the contents of `vault-template/` to the target directory:
```bash
cp -R vault-template/* /path/to/target/
```
If generating from scratch, establish the following numbered directory tree:
```text
MindVault/
├── 00-Inbox/
│   ├── instruction.md
│   ├── Clippings/ (with .gitkeep and instruction.md)
│   └── Scratch/ (with .gitkeep and instruction.md)
├── 01-Areas/ (with instruction.md and .gitkeep)
├── 02-Projects/ (with instruction.md and .gitkeep)
├── 03-Resources/
│   ├── instruction.md
│   ├── Prompts/ (.gitkeep)
│   ├── SOP/ (.gitkeep)
│   └── Templates/
│       ├── instruction.md
│       ├── Area 工作台模板.md
│       ├── Project 项目卡模板.md
│       ├── Resource 资料索引模板.md
│       └── Daily 建档骨架.md
├── 04-Archive/
│   ├── instruction.md
│   └── Inbox-Clippings/ (with instruction.md and .gitkeep)
├── 10-Logs/
│   ├── instruction.md
│   ├── wiki-log.md
│   ├── Daily/ (with instruction.md and .gitkeep)
│   └── Monthly/ (with instruction.md and .gitkeep)
├── 20-CRM/
│   ├── instruction.md
│   ├── contact.md
│   └── Context/
│       ├── instance.md (copied from instance.md.template)
│       └── user.md (copied from user.md.template)
└── 90-System/
    ├── instruction.md
    ├── AgentOS/ (instruction.md and charter.md)
    ├── Tasks/ (instruction.md, vault-weekly-sop.md, vault-curator-inbox-daily.md)
    ├── Skills/ (.gitkeep)
    └── Scripts/ (sync-agents-md.sh, check-privacy.sh)
```

### Step 2: Establish Agent System Protocols
Ensure the root directory contains:
- `CLAUDE.md`: The single source of truth for agent behavior and vault conventions.
- `AGENTS.md`: Synchronized from `CLAUDE.md` using `scripts/sync-agents-md.sh`.

### Step 3: Initialize the Append-Only Wiki-Log
Create `10-Logs/wiki-log.md` with the following initial header:
```markdown
# wiki-log · 库级变更日志

只追加，不改旧条。格式与规则见 [[instruction]] 与 [[CLAUDE]]「稳定页、引用与变更传播」。类型限定：`ingest` / `query` / `lint` / `fix` / `rule`。

## [YYYY-MM-DD] rule | Agent | 初始化 MindVault 知识操作系统架构
- 改动：[[CLAUDE]], [[AGENTS]], [[10-Logs/wiki-log]]
- 原因：完成知识库冷启动与核心架构初始化。
```

### Step 4: Verify Consistency
Run the synchronization check script:
```bash
./90-System/Scripts/sync-agents-md.sh --check
```
Verify that the exit code is `0`.

---

## Completion Report to User

Once initialized, report back to the user with the following summary:
1. **Path Initialized**: Output the absolute directory path.
2. **Next Steps for Owner**:
   - Instruct the user to open `20-CRM/Context/instance.md` to configure their local workstation paths, preferred models, and private settings.
   - Instruct the user to fill out their core focus areas in `20-CRM/Context/user.md`.
   - Open the directory in [Obsidian](https://obsidian.md).
