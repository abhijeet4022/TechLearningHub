# GitHub SSH Setup Guide

## Clone Using SSH (Preferred for long-term use)

### Step-by-Step on Windows:

#### 1. Check if you already have SSH keys:
Open Git Bash and run:

```bash
ls -al ~/.ssh
```

If you see files like `id_rsa` or `id_ed25519`, skip to step 3.

#### 2. Generate a new SSH key (if needed):

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Press Enter to accept defaults.

#### 3. Copy your SSH public key:

```bash
clip < ~/.ssh/id_ed25519.pub
```

This copies the key to your clipboard.

#### 4. Add the key to GitHub:

- Go to https://github.com/settings/ssh/new
- Paste the copied key and click Add SSH Key

#### 5. Test the connection:

```bash
ssh -T git@github.com
```

You should see:

```
Hi abhijeet707071! You've successfully authenticated
```

#### 6. Clone using SSH:

```bash
git clone git@github.com:abhijeet707071/shell-script.git
```