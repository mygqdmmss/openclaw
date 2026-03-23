#!/bin/sh
# 找到 Railway 分配的数据存储路径
STATE_DIR=${OPENCLAW_STATE_DIR:-/data/.openclaw}
mkdir -p "$STATE_DIR"

# 自动生成配置文件：解锁 Host 限制 + 注入满血版 AnyRouter 模型
cat << EOF > "$STATE_DIR/openclaw.json"
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
