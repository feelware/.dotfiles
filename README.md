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

### install extra drivers if necessary

- https://github.com/lutris/docs/blob/master/InstallingDrivers.md
- https://github.com/doitsujin/dxvk/issues/3191

---

inspired by https://github.com/paoloose/dotfiles
