# sysconfigs

Ich baue gerade alles um. Bereits (wieder) funktionierend:

- home-manager: trillian

---

[TOC]

## Einstieg

Nix deckt eine große Bandbreite ab:

- Paketmanager:
  - Nix alleine benutzt sich wie ein normaler imperativer Paketmanager, wie z.B. APT.
  - Ermöglicht deklarative Development-Environments
- Systemkonfiguration:
  - NixOS: Konfigurationsmodule die aus Nix eine eigenständige voll-deklarative Linux-Distri machen.
  - nix-darwin: Konfigurationsmodule, analog zu NixOS, deklarative Systemkonfiguration für macOS.
  - system-manager: Konfigurationsmodule, analog zu NixOS, deklarative Systemkonfiguration für systemd-Linux-Distributionen
- Nutzerkonfiguration:
  - home-manager: Konfigurationsmodule, um alle Nutzer-Aspekte zu konfigurieren.

Nix läuft auf macOS und den mmeisten Linux-Distributionen. Native Windows- und FreeBSD-Unterstützung ist in Arbeit. Nix sollte als Daemon installiert werden, kann aber auch ohne installiert werden. (Auf die Nachteile gehe ich hier nicht ein.) Die instzallierten Pakete landen in /nix/store.

NixOS, nix-darwin und system-manager, als auch home-manager können separat betrieben. In diesem Fall updatet man System und Nutzer getrennt voneinander. Man kann allerdings auch home-manager in der jeweiligen Systemkonfiguration einhängen. Beide Varianten sind gleich gut. Die meisten Nix-User binden den home-manager in die System-Konfig ein.

---

## Nix installieren

(macOS, Linux und Win/WSL)

Ich verwende hier den [DetSys Nix Installer](https://zero-to-nix.com/start/install). Erstens, weil es einfacher zu deinstallieren ist und zweitens, weil die experimentellen Funktionen "nix-command" und "flakes" standardmäßig aktiv sind. Nix kann natürlich auch mit dem [original installer](https://nixos.org/download/) installiert werden. Dann müssen aber die beiden experimentellen Funktionen manuell aktiviert werden.

```shell
# Nur macOS: xcode command line tools installieren
xcode-select --install

# Installation via DetSys Installer, disable sending telemetry via --diagnostic-endpoint
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --diagnostic-endpoint=""

# Neue Shell öffnen
exec $SHELL

# Optional: Nix-Installation testen
nix-shell -p nix-info --run "nix-info -m"
```

### macOS: Behebung des Problems mit dem fehlenden Nix-Hook nach System-Updates

Leider überschreibt macOS bei Aktualisierungen immer die Datei /etc/zshrc. Das ist insofern ein Problem, als der Hook für Nix hier steht (und stehen muss). Um dieses Problem zu umgehen, kann man einen launchd-Job verwenden, der bei jedem Systemstart prüft, ob dieser Hook noch vorhanden ist und ihn ggf. neu schreibt:

- Kopiere die Datei [./darwin/org.nixos.darwin.check-zshrc-nix-hook.plist](./darwin/org.nixos.darwin.check-zshrc-nix-hook.plist) nach `/Library/LaunchDaemons/`
- Setze den korrekten Nutzer und Zugriffsrechte:
  ```shell
  sudo chown root:wheel /Library/LaunchDaemons/org.nixos.darwin.check-zshrc-nix-hook.plist
  sudo chmod u=rw,go=r /Library/LaunchDaemons/org.nixos.darwin.check-zshrc-nix-hook.plist
  ```

- Lade den launchd job:
  ```shell
  sudo launchctl load /Library/LaunchDaemons/org.nixos.darwin.check-zshrc-nix-hook.plist
  ```

### Regulare Nutzung

Using Nix only as a package manager is very like using imperative package manager like apt.

**Paket suchen**

```shell
nix search <search string>
```

**Paket installieren**

```shell
nix profile install <package>
```

**Installierte Pakete auflisten**

```shell
nix profile list
```

**Paket deinstallieren**

```shell
nix profile remove <package>
```

**Pakete updaten**

```shell
nix profile update <package>
```

**Alte Pakete aufräumen (alle)**

Aufgrund der Funktionsweise von Nix, bleiben alte Paketversionen nach einem Update erhalten (was Rollbacks erst ermöglicht). Der Nachteil ist allerdings, daß man von Zeit zu Zeit die älteren Pakete entfernen sollte. Über die Zeit können sonst einige GB zusammenkommen.

```shell
nix-collect-garbage -d
```

**Alte Pakete aufräumen (älter als n)**

```shell
# Beispiel für period: 14d (14 Tage)
nix-collect-garbage --delete-older-than <period>
```

### Nix deinstallieren

Wenn Nix über das ursprüngliche Installationsprogramm installiert wurde, ist manuelle Arbeit erforderlich. Mehr dazu im [Nix-Handbuch](https://nix.dev/manual/nix/2.22/installation/uninstall). Wenn das DetSys-Installationsprogramm verwendet wurde, ist es einfach:

```shell
# wenn der launchd job `check-zshrc-nix-hook.plist` installiert wurde:
sudo launchctl bootout system/org.nixos.darwin.check-zshrc-nix-hook
sudo rm /Library/LaunchDaemons/org.nixos.darwin.check-zshrc-nix-hook.plist

# wenn der DetSys Installer benutzt wurde:
/nix/nix-installer uninstall
```



---

## Dieses Repo klonen

(macOS, Linux, NixOS, Windows/WSL)

### Repo klonen

Grundsätzlich kann das Repo in einem beliebigen Ordner liegen, Je nach Nutzung böten sich aber folgende Ordner an: `@TODO`

- für home-manager (stand-alone): `~/.config/home-manager`
- für nix-darwin (incl. home-manager): `~/.config/nix-darwin` oder `/etc/nix-darwin`
- für system-manager (incl. home-manager): `@TODO`
- für NixOS (incl. home-manager): `/etc/nixos`

```shell
git clone git@github.com:mbrasch/sysconfigs.git <destination>
```

> :warning: z.B. wenn man die gewünschte Konfig auf der jeweiligen Maschine niemals ändern möchte (also immer nur die aktuellste Git-Version), kann man auch auf das Clonen des Repos verzichten.
>
> In dem Fall setzt man anstelle des Punktes (z.B. `home-manager switch --flake .#<config-name>`) die Git-Adresse ein (z.B. `home-manager switch --flake github:mbrasch/sysconfigs#<config-name>`).
>
> :warning: eigentlich selbstredend, aber vorsichtshalber sei erwähnt: dazu muß allerdings schon die Konfig für die jeweilige Machine Git-Repo angelegt sein

### Konfiguration anpassen

 :warning: Sofern noch nicht geschehen: zuerst sollte die Datei `./flake.nix` an die eigenen Bedürfnisse angepasst werden:

- `username` und `system` in `homeConfigurations.<username>`
- `hostname` in `darwinConfiguration.<hostname>`



---

## home-manager (stand-alone)

(macOS, Linux, NixOS, Windows/WSL)

> :warning: When using home-manager stand-alone, you have to configure nix via /etc/nix.nix.conf. (home-manager is only for user configuration.)

### Installation

```shell
# build configuration
nix build .#homeConfigurations.<username>.activationPackage [--refresh]

# apply configuration
./result/activate
```

Falls man bei `nix build` direkt von einem Git-Repo baut und der Build abbricht und man eine Änderung an der Konfig auf dem Git vornimmt, kann man Nix zwingen die Konfig neu aus dem Repo zu laden:

```shell
nix flake update --flake github:mrasch/sysconfigs
```



### Regulare Nutzung

**Flake updaten**

```shell
nix flake update github:mbrasch/sysconfigs#mbrasch
```

**Konfiguration neu bauen**

```shell
# wenn die Config in ~/.config/home-manager liegt
home-manager switch

# wenn die Config in einem beliebigen anderen Ordner liegt
home-manager switch [--flake .#<config>]
```

**Alle Pakete auflisten, die in `home-manager-path` installiert sind**

```shell
home-manager packages
```

**Alle home-manager Generationen auflisten**

```shell
home-manager generations
```

**Zu einer vorherigen Generation wechseln**

```shell
# list generations
home-manager generations
# copy the full store path of the desired generation out of the list
# paste it to the terminal and tab-autocomplete it to the activation script
/nix/store/<some-hash>/activate
```

**Generationen via IDs entfernen**

```shell
# get the IDs via generations subcommand
home-manager remove-generations <id 1> <id 2> …
```

**Generations älter als n Tage oder vor einem spezifischen Tag entfernen**

```shell
home-manager expire-generations [ -n days | yyyy-mm-dd ]
```

### home-manager deinstallieren

remove home manager from the user environment. this will

- remove all managed files from the home directory,         
- remove packages installed through Home Manager from the user profile, and         
- remove all Home Manager generations and make them available for immediate garbage collection.         

```shell
home-manager uninstall
```



---

## nix-darwin (optional mit home-manager)

(macOS)

### Installation

```shell
# build and install the base configuration
nix run nix-darwin -- switch --flake ".#trillian"

# delete this, otherwise darwin-rebuild will fail to create a symlink
# to the generated nix config
sudo rm /etc/nix/nix.conf

# create "/run" for nix-darwin and force applying
echo 'run\tprivate/var/run' | sudo tee -a /etc/synthetic.conf
/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t

# finally run apply the bootstrap configuration
./result/sw/bin/darwin-rebuild switch --flake .#trillian

# open new shell
exec $SHELL
```



```shell
nix build ".#darwinConfigurations.aarch64-darwin.trillian.system"
sudo ./result/activate-user
```



### Regulare Nutzung

**apply configuration changes**

```shell
darwin-rebuild switch --flake github:mbrasch/sysconfigs#trillian
```



---

## NixOS

(NixOS)

### bootstrap

```shell

```

### regular use

**apply configuration changes**

```shell
nixos-rebuild switch --flake github:mbrasch/sysconfigs#mbrasch
```



---

## system-manager (optional mit home-manager)

(Linux, Windows/WSL)
