# Homebrew tap for TorXakis

This repository is the homebrew tap of `TorXakis`. 

For macOS systems we provide a homebrew package. If you don't have the `homebrew` package manager installed on your macOS
system follow the installation instruction on the [homebrew homepage](https://brew.sh/).

## Quickstart ##


### Install `TorXakis` on macOS ###

#### Install pre-build `TorXakis` ####

To install `TorXakis` using this tap, use the following commands:

```sh
brew tap torxakis/torxakis
brew install torxakis
```
Homebrew will fetch a pre-build binary and do a quick installation. 
Homebrew will also install **specific versions** of the [SMT][1] solvers [Z3][3] and [CVC4][2]  as runtime dependency of the  `TorXakis` package. 

If you just have the newest MacOS version installed for which no pre-build binary is installed yet, then homebrew will install the pre-build binary from the previous MacOS version. In case this gives problems, which is improbable, then you still do a build from source. 

#### Build `TorXakis` from source ####

Do a build from source with the commands: 

```sh
brew tap torxakis/torxakis
brew install --build-from-source torxakis
```

#### Build `TorXakis` from HEAD of development source ####

To install the latest HEAD source of `TorXakis`, use the following commands: 

```sh
brew tap torxakis/torxakis
brew install --HEAD torxakis
```
There is no binary pre-build for the latest source, therefore homebrew will build and install `TorXakis` from that latest source itself.

### First run of `TorXakis` ###

After installing TorXakis you can do a first run and see that it can initialize Z3 correctly:

```sh
$ torxakis

TXS >>  TorXakis :: Model-Based Testing

TXS >>  txsserver starting: "localhost" : 53382
TXS >>  Solver "z3" initialized : Z3 [4.8.7]
TXS >>  TxsCore initialized
TXS >>  input files parsed:
TXS >>  []
TXS >>
```

With homebrew you can also do a very basic test to check torxakis starts up and does a simple evaluation:

```sh
$ brew test torxakis
Testing torxakis
==> running basic test
==> printf "eval 33+7777777777777\nq" |torxakis  2>&1
==> test succesfull
```



## More info ##


### How to use `TorXakis` with CVC4 instead of Z3 on macOS ###

By default `TorXakis` uses the [Z3][3] tool, however we can configure it to use [CVC4][2] instead.

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
 
 
### Specific versions of SMT tools for compatibity  ###

`TorXakis` installs **specific versions** of  [Z3][3] and [CVC4][2] as runtime dependency to guarantee compatibility with the `TorXakis` tool. 

Normally when installing a package with homebrew it always the latest version of a package. Unfortunately Homebrew still doesn’t have an obvious builtin way of installing an older version. 

However there is an easy method to install older versions using versioned names, such as [formula@version][6], in your custom tap.
We use [this method][6] to install older versions of [CVC4][2]  and [Z3][3] when installing `TorXakis`. We therefore had to support the homebrew formula for older versions of [CVC4][2]  and [Z3][3] in our own `torxakis` tap. Currently we have the following specific versions as dependency for `TorXakis`:

* `torxakis/torxakis/cvc4@1.7` 
* `torxakis/torxakis/z3@4.8.7`  
 
We build both `x64` and `arm64` bottles for them for easy binary installation. For the `arm64` bottle for  [CVC4][2] we even needed to patch the source code to make the build succeed on the `arm64 ` architecture.

These older versions are installed as keg-only packages, which means that the SMT solvers are installed such that the tools are not included in the system path. Only the  `TorXakis` package uses them by setting the path of the tools in its own modified system path.

### How to use the latest versions of Z3 or CVC4 with `TorXakis` ###

#### Install the latest versions of Z3 or CVC4  #####

To install the latest version of [Z3][3], use the following command: 

```sh
brew install z3
```

To install the latest version of [CVC4][2], use the following commands: 

```sh
brew tap cvc4/cvc4
brew install cvc4/cvc4/cvc4
```

Notes: 

* currently [CVC4][2] nor its successor [CVC5][7] does not provide bottles for the `arm64 ` architecture, so we have to build the package from source when we install it. 
* for the `arm64 ` architecture for [CVC4][2] we probably also need to apply a patch to the source code before the build will succeed on that platform. 

#### Configure `TorXakis` to use latest version of Z3 or CVC4  ####

By setting the following environment variable

```sh
export TORXAKIS_USE_INTERNAL_SMT_SOLVER=false
```

we instruct `TorXakis` to not use its own specific versions of [CVC4][2]  and [Z3][3], but instead use the latest versions of these tools installed on the system path. 

#### Configure `TorXakis` to use specific executable path of Z3 or CVC4  ####

In the `~/.torxakis.yaml` configuration file we can also specify the executable path of the SMT solver used. 
 
Eg. to configure the use of `/opt/homebrew/Cellar/z3/4.8.15/bin/z3` use the `~/.torxakis.yaml` configuration file:

```sh
selected-solver: "z3"
available-solvers:
- solver-id: "z3"
  executable-name: "/opt/homebrew/Cellar/z3/4.8.15/bin/z3"
  flags:
  - "-smt2"
  - "-in"
```


[1]: https://en.wikipedia.org/wiki/Satisfiability_modulo_theories
[2]: https://cvc4.github.io
[3]: https://github.com/Z3Prover/z3
[4]: http://formulae.brew.sh/formula/antlr@3
[5]: https://github.com/TorXakis/TorXakis/blob/develop/.torxakis.yaml
[6]: https://docs.brew.sh/Versions
[7]: https://cvc5.github.io
