reminder
use stow for setting up this dotfiles repo
```bash
stow .
```

Save:
```
dconf dump /org/gnome/terminal/ > ~/gterminal.preferences
```

Install:
```
cat ~/gterminal.preferences | dconf load /org/gnome/terminal/legacy/profiles:/
```
