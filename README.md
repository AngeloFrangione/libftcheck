# libftcheck

Simple testeur de libft qui utilise des tests externes automatiquement pour lancer en intro d'une soutenance.

Il permet de rapidement mettre le doigt sur des possibles erreurs et d'avoir le temps d'en discuter.

* Clang Static Analyzer
* 42FileChecker
* Libftest

Il vérifie rapidement à la fin la présence de `(void)` qui, en dehors de prototypes de fonctions, sont souvent utilisés de façon erronée.