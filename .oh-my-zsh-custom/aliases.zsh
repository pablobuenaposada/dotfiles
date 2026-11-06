# git commands
alias gca='git commit --amend --no-edit'
alias gpf='git push --force-with-lease origin HEAD'
alias pishrink='docker run -it --rm --platform linux/amd64 --privileged=true -v \$(pwd):/workdir pishrink'

# network
# disconnect all WireGuard tunnels (wg-quick and app), reset DNS to DHCP and flush DNS cache
vpndown() {
  local conf service i
  for conf in ~/.config/wireguard/*.conf; do
    sudo /opt/homebrew/bin/bash /opt/homebrew/bin/wg-quick down "$conf" 2>/dev/null
  done
  scutil --nc list | grep 'com.wireguard.macos' | grep -oE '[0-9A-F]{8}(-[0-9A-F]{4}){3}-[0-9A-F]{12}' | while read -r id; do
    scutil --nc stop "$id"
  done
  # wg-quick restores DNS from a background monitor after "down" returns, and with
  # stacked tunnels it restores another tunnel's DNS. stale monitors can also outlive
  # their tunnel, so kill them all and wait for them to exit before resetting DNS
  sudo pkill -f 'wg-quick up'
  for i in {1..20}; do
    pgrep -f 'wg-quick up' >/dev/null || break
    sleep 0.5
  done
  networksetup -listallnetworkservices | tail -n +2 | grep -v '^\*' | while read -r service; do
    sudo networksetup -setdnsservers "$service" empty 2>/dev/null
    sudo networksetup -setsearchdomains "$service" empty 2>/dev/null
  done
  sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
}
