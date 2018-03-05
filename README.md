# Homebrew tap for TorXakis

This repository is the homebrew tap of `TorXakis`. 

For macOS systems we provide a homebrew package. If you don't have the `homebrew` package manager installed on your macOS
system follow the installation instruction on the [homebrew homepage](https://brew.sh/).


### Install `TorXakis` on macOS ###

To install `TorXakis` using this tap, use the following commands:

```sh
brew tap torxakis/torxakis
brew install torxakis
```
Homebrew will fetch a pre-build binary and do a quick installation.
Homebrew will also install [SMT][1] solver [Z3][3] as runtime dependency of the  `TorXakis` package.

To install the latest HEAD source of `TorXakis`, use the following commands: 

```sh
brew tap torxakis/torxakis
brew install --HEAD torxakis
```
There is no binary pre-build for the latest source, therefore homebrew will build and install `TorXakis` from that latest source itself.


### Howto use `TorXakis` with CVC4 instead of Z3 on macOS

To install [CVC4][2], use the following commands: 

```sh
brew tap cvc4/cvc4
brew install cvc4
```

Currently there are no binary bottles for [CVC4][2], so the installation is done from source instead and can take a long time.
 
TorXakis can be configured by using a configuration file `.torxakis.yaml`.
The configuration file is expected either

* in the working directory or
* in the home directory.

The working directory has precedence over the latter. An example of a `.torxakis.yaml` file can be found in the `TorXakis` github repository at this [page][5].
   
To configure `TorXakis` to use [CVC4][2] instead of [Z3][3] we use the `~/.torxakis.yaml` configuration file to change the default [SMT][1] solver being used, which we can create  using the following commands:

```sh
echo 'selected-solver: "cvc4" ' > ~/.torxakis.yaml
```

From now on `TorXakis` will use [CVC4][2]  instead of [Z3][3].
 



[1]: https://en.wikipedia.org/wiki/Satisfiability_modulo_theories
[2]: http://cvc4.cs.stanford.edu/
[3]: https://github.com/Z3Prover/z3
[4]: http://formulae.brew.sh/formula/antlr@3
[5]: https://github.com/TorXakis/TorXakis/blob/develop/.torxakis.yaml
