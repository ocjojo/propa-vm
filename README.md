# propa-vm

Vagrant Konfiguration zur Bearbeitung der [PP Übung](http://pp.ipd.kit.edu/lehre/WS201617/paradigmen/uebung/index.php?lang=de) für alle in der Vorlesung behandelten Sprachen.

## Installation

```bash
git clone git@github.com:ocjojo/propa-vm.git
cd propa-vm
vagrant up
```
Der erste Start dauert einige Minuten und downloaded mehrere 100mb.

## Nutzung

```bash
# Starte Vagrant
vagrant up
# Verbinde zur box
vagrant ssh
# Das lokale /code Verzeichnis ist zu ~/code gemapped
# e.g. mit test.hs in code:
cd code
ghci
> :l test
```

## Sprachen

- Haskell: `ghci` oder `ghc`
- Prolog: `swipl`

### Prolog
`swipl` um prolog repl zu starten

```prolog
%lade Datei test.pl
[test].
```
