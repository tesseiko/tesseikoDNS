# Tool for utilizing cloudflared quick tunnels

Expose SSH via [Cloudflare Quick Tunnels](https://developers.cloudflare.com/tunnel/get-started/quick-tunnels/) and get notified on Telegram.

## Prerequisites

* `cloudflared` installed and in PATH
* A running sshd
* A telegram Bot

## Configuration

Edit config file:

```
# Machine identifier (for your own reference)
SERVER_NAME=

# Telegram bot API token from @BotFather
TOKEN=""

# Chat ID to receive tunnel addresses
CHAT_ID=""
```

## Installation

`sudo make install`

If you want to edit your config after installation, edit the tesseikoDNS.conf file in this directory and run `sudo make config` (recommended) or directly edit your /etc/tesseikoDNS/tesseikoDNS.conf

## Usage

You can execute `tesseikoDNS` directly or start it as a systemd service:

`systemctl start tesseikoSSHDNS.service`

or

`systemctl enable --now tesseikoSSHDNS.service`

## Telegram Bot Setup

1. Open Telegram and search for @BotFather (verified blue checkmark).
2. Send /newbot.
3. Follow the prompts to create your bot.
4. Copy the HTTP API Token provided.
5. Add your bot to the target Telegram group.
6. Find your Chat ID:
    - Send a message to the group.
    - Open the Telegram **desktop** application and navigate to the group.
    - Right-click any message in the group and select **Copy Message/Post Link**.
    - Paste the link. If it looks like https://t.me/c/194xxxx987/11, the core number after /c/ is the chat ID (add -100 at the beginning for supergroups/channels, e.g., -100194xxxx987)

## License

GPLv3. See [LICENSE](LICENSE).
