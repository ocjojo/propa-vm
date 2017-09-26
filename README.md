# propa-vm

Vagrant Konfiguration zur Bearbeitung der [PP Übung](http://pp.ipd.kit.edu/lehre/WS201617/paradigmen/uebung/index.php?lang=de) für alle in der Vorlesung behandelten Sprachen.



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
