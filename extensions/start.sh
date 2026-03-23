#!/bin/sh
# 强制指定普通用户有权限读写的专属目录
export OPENCLAW_STATE_DIR="/home/node/.openclaw"
mkdir -p "$OPENCLAW_STATE_DIR"

# 自动生成配置文件：解锁 Host 限制 + 注入满血版 AnyRouter 模型
cat << EOF > "$OPENCLAW_STATE_DIR/openclaw.json"
{
  "gateway": {
    "controlUi": {
      "dangerouslyAllowHostHeaderOriginFallback": true
    }
  },
  "models": {
    "mode": "merge",
    "providers": {
      "anyrouter": {
        "baseUrl": "https://anyrouter.top",
        "apiKey": "sk-r8dPIJL0Q5xHARyrIyLMrjsvUiVyPcEbTSqmCe3qdaEmQS7T",
        "api": "anthropic-messages",
        "models": [
          {
            "id": "claude-opus-4-6",
            "name": "Claude Opus 4.6",
            "reasoning": true,
            "input": ["text"],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 200000,
            "maxTokens": 8192
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "anyrouter/claude-opus-4-6"
      }
    }
  }
}
EOF

# 执行最终的启动命令，大门向公网敞开！
node openclaw.mjs gateway --allow-unconfigured --bind lan
