newlab() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: newlab <platform> <name>"
        echo "Example: newlab htb Cicada"
        return 1
    fi

    local platform="$1"
    local name="$2"
    local dir="$HOME/labs/$platform/$name"

    mkdir -p "$dir"/{scans,loot,screenshots,notes,files}
    cd "$dir" || return
    echo "[+] Lab created: $dir"
}
