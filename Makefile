encrypt:
	gpg -c .oh-my-zsh-custom/secret-aliases.zsh

decrypt:
	gpg --decrypt .oh-my-zsh-custom/secret-aliases.zsh.gpg > .oh-my-zsh-custom/secret-aliases.zsh