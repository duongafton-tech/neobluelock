# Blue Lock Rival - Auto Farm Neo Ego 2.0

Auto farm script for Blue Lock Rival on Roblox. Automatically completes Neo Ego tasks (Score, Assist, Tackle, Pass, Distance), collects XP, and claims rewards. No key required.

## Features
- ✅ Auto complete 5 tasks in priority order
- ✅ Auto collect XP orbs
- ✅ Auto claim rewards
- ✅ Auto reset task list after completion
- ✅ Toggle ON/OFF with F9
- ✅ Basic anti-cheat bypass
- ✅ Respawn handler (auto-reapply after death)

## Requirements
- Roblox Executor (Delta X, KANZ, Synapse X, Krnl, Xeno, etc.)
- Blue Lock Rival game (Roblox)

## Installation
1. Copy the script from `main.lua`
2. Open your executor and inject into Roblox
3. Paste the script and click Execute

## Usage
- Script starts automatically after execution
- Press **F9** to toggle Auto Farm ON/OFF
- Check executor console for status messages

## Configuration
Edit the `CONFIG` table at the top of the script to customize:

| Setting | Default | Description |
|---------|---------|-------------|
| `Speed` | 60 | Walk speed |
| `JumpPower` | 150 | Jump power |
| `TeleportDistance` | 30 | Max distance to teleport to ball |
| `AutoClaimReward` | true | Auto claim rewards |
| `AutoCollectXP` | true | Auto collect XP orbs |
| `TaskInterval` | 1.0 | Delay between tasks (seconds) |
| `AutoResetTasks` | true | Auto reset task list after completion |
| `ToggleKey` | Enum.KeyCode.F9 | Key to toggle ON/OFF |

## Run directly from GitHub
Instead of copying, execute the script directly from this repository:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/duongafton-tech/neobluelock/main/main.lua"))()
