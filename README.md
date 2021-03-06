# libftcheck

Simple testeur de libft qui utilise des tests externes automatiquement pour lancer en intro d'une soutenance.

Il permet de rapidement mettre le doigt sur des possibles erreurs et d'avoir le temps d'en discuter.

* [Clang Static Analyzer](https://clang-analyzer.llvm.org/)
* [42FileChecker](https://github.com/jgigault/42FileChecker)
* [Libftest](https://github.com/jtoty/Libftest)

Il vérifie rapidement à la fin la présence de `(void)` qui, en dehors de prototypes de fonctions, sont souvent utilisés de façon erronée.

```
Usage : libftcheck.sh [options] git_repo (or path if --no-git)

options : -r | --reopen-report  Only open previously generated Static Analyzer
                                then quits
          -d | --no-sa-down     Do not download Clang Static Analyzer
          -s | --no-sa          Ignore Clang Static Analyzer tests
          -f | --no-fc          Ignore 42FileChecker tests
          -l | --no-lftest      Ignore Libftest tests
          -n | --no-clone       Do not clone 42FileChecker nor Libftest
          -c | --no-cleanall    Do not remove 42fc libftest libft and static_analyzer
          -g | --no-git         Copy the libft from a path on this machins
          -h | --help           Prints this
```
