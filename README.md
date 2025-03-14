# dotfiles

config for my ubuntu desktop setup

## setup

```bash
sudo apt install -y curl
curl -s https://raw.githubusercontent.com/feelware/.dotfiles/refs/heads/main/setup.sh | bash
```

## next steps

### import gpg key (for gnu pass)

send key (from host that has it):

```bash
gpg --export-secret-keys <key-id> | ssh stevan@<requestor-ip> gpg --import
```

### get password store:

```bash
scp stevan@<owner-ip>:~/.password-store ~
```

### copy obsidian vault:

```bash
scp stevan@<owner-ip>:~/vault ~
```

---

inspired by https://github.com/paoloose/dotfiles
