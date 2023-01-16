---
title: "Signing GitHub commits on Mac OS"
date: 2023-01-15
# weight: 1
# aliases: ["/first"]
tags: ["git", "github"]
author: "Me"
# author: ["Me", "You"] # multiple authors
showToc: true
TocOpen: true
draft: false
hidemeta: false
comments: false
description: "Configure Mac OS to sign git commits with gpg, upload your public key to GitHub, and use the same key to verify commits for both your personal and work email addresses."
canonicalURL: "https://canonical.url/to/page"
disableHLJS: true # to disable highlightjs
disableShare: false
disableHLJS: false
hideSummary: false
searchHidden: true
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: true
ShowRssButtonInSectionTermList: true
UseHugoToc: true
cover:
    image: "/images/signed-commits-macos/github-signed-commits-macos.png" # image path/url
    alt: "<alt text>" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: false # only hide on current single page
editPost:
    URL: "https://github.com/<path_to_repo>/content"
    Text: "Suggest Changes" # edit text
    appendFilePath: true # to append file path to Edit link
---

## Use homebrew to install the tools

```shell
brew install gnupg pinentry-mac
```

## Configure gpg

Start by creating configuration files for gpg and pinentry-mac. These files will be used to configure gpg and pinentry-mac to use the same keychain as your Mac OS keychain.

```shell
mkdir ~/.gnupg
touch ~/.gnupg/gpg-agent.conf
touch ~/.gnupg/gpg.conf
```

Add the following to `~/.gnupg/gpg-agent.conf`:

```shell
default-cache-ttl 34560000
max-cache-ttl 34560000
pinentry-program /opt/homebrew/bin/pinentry-mac
```

The TTL values above are set to 400 days. You can set them to whatever you want, but you will be prompted for your passphrase based on your configured TTL values.

The location for `pinentry-mac` may be different depending on where you installed it. You can find the location by running `which pinentry-mac`. On Apple Silicon you will usually use `/opt/homebrew/bin/pinentry-mac`, and on Intel Macs you will usually use `/usr/local/bin/pinentry-mac`.

Add the following to `~/.gnupg/gpg.conf`:

```shell
use-agent
```

Add the following to `~/.zshrc`:

```shell
export GPG_TTY=$(tty)
gpgconf --launch gpg-agent
```

In order for these changes to take effect, you will need to restart your terminal or run `source ~/.zshrc`.

## Generate a new key

```shell
gpg --full-generate-key
```

Anwer the questions as follows:


| Question | Answer |
| --- | --- |
| Kind of key: | 4 RSA |
| Key size: | 4096 |
| Key expires: | 2y (or however long you want the key to last) |
| Real name: | your GitHub username |
| Email address: | your GitHub email address |
| Comment: | (leave blank) |

When prompted for a key passphrase enter a strong passphrase.


## Add your work email address to your key

Retrieve your key id:

```shell
gpg --list-secret-keys --keyid-format SHORT
```
The sequence of characters after `rsa4096` is your key id.


```shell
gpg --edit-key <your key id>

gpg> adduid
```

Follow the prompts to add your work email address. Once completed you can confirm your second email address was added by running `gpg --list-keys`.

![list-keys](/images/signed-commits-macos/list-keys.png)

## Configure git to use gpg

Retrieve your key id:

```shell
gpg --list-secret-keys --keyid-format SHORT
```
The sequence of characters after `rsa4096` is your key id.

Update your git configuration to use your key id:

```shell
git config --global user.signingkey <your key id>
git config --global commit.gpgsign true
git config --global tag.gpgsign true
```

## Export your public key and add it to your GitHub account settings

```shell
gpg --armor --export <your key id>
```

Navigate to your GitHub account settings, click on `SSH and GPG keys`, and click on `New GPG key`. Paste the public key into the text box and click `Add GPG key`.

## Verify your commits
