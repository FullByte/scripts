#!/bin/bash

# Install Cheat Sheet Tools
sudo apt update && sudo apt -y upgrade && sudo apt -y
tldr rlwrap xsel
tldr -u
curl https://cht.sh/:cht.sh | sudo tee /usr/local/bin/cht.sh
chmod +x /usr/local/bin/cht.sh
mkdir ~/.bash.d
curl https://cheat.sh/:bash_completion > ~/.bash.d/cht.sh
echo '\n### cheat.sh ###' >> ~/.bashrc
echo '. ~/.bash.d/cht.sh' >> ~/.bashrc
mkdir ~/.zsh.d
curl https://cheat.sh/:zsh > ~/.zsh.d/_cht
echo 'fpath=(~/.zsh.d/ $fpath)' >> ~/.zshrc

# Install Navi
sudo apt update && sudo apt -y upgrade && sudo apt -y install cargo ftf
cargo install --locked navi
# Config bash
echo '\n### NAVI ###' >> ~/.bashrc
echo 'alias navi="~/.cargo/bin/navi"' >> ~/.bashrc
echo 'eval "\$(navi widget bash)"' >> ~/.bashrc
# Config zsh
echo '\n### NAVI ###' >> ~/.zshrc
echo 'alias navi="~/.cargo/bin/navi"' >> ~/.zshrc
echo 'eval "\$(navi widget zsh)"' >> ~/.zshrc
# Install own cheatsheet
git clone "https://github.com/FullByte/navi-cheatsheet" "$(navi info cheats-path)/FullByte__navi-cheatsheet"
(crontab -l 2>/dev/null; echo "0 11 * * * bash -c 'cd \"$(navi info cheats-path)/FullByte__navi-cheatsheet\" && /usr/local/bin/git pull -q origin master'") | crontab -
# Install other cheatsheets
git clone "https://github.com/infosecstreams/cheat.sheets" "$(navi info cheats-path)/infosecstreams__cheat.sheets"
(crontab -l 2>/dev/null; echo "0 11 * * * bash -c 'cd \"$(navi info cheats-path)/infosecstreams__cheat.sheets\" && /usr/local/bin/git pull -q origin master'") | crontab -
