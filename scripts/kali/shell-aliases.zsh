# Add to ~/.zshrc

alias kairos-up='cd ~/tools/kairos-report-engine && docker compose up -d'
alias kairos-down='cd ~/tools/kairos-report-engine && docker compose down'
alias kairos-status='cd ~/tools/kairos-report-engine && docker compose ps'
alias kairos-logs='cd ~/tools/kairos-report-engine && docker compose logs -f'
alias kairos-backup='~/scripts/kairos-backup-safe.sh'

alias bh-up='bloodhound-cli up'
alias bh-down='bloodhound-cli down'
alias bh-status='bloodhound-cli running'

alias htb='cd ~/labs/htb'
alias hacksmarter='cd ~/labs/hacksmarter'
alias tcm='cd ~/labs/tcm'
alias tools='cd ~/tools'
alias engagements='cd ~/engagements'

alias kali-update='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y'
