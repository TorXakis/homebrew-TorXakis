#!/bin/bash

z3_version="4.8.7"
cvc4_version="1.7"

script_path=$(readlink -f "$0")
script_dir=$(dirname "$script_path")
script_name=$(basename "$script_path")


# by default use internal smt solver
# first lowercase variable before comparison
TORXAKIS_USE_INTERNAL_SMT_SOLVER=$(echo "$TORXAKIS_USE_INTERNAL_SMT_SOLVER" | tr '[:upper:]' '[:lower:]')
if ! [[ "$TORXAKIS_USE_INTERNAL_SMT_SOLVER" == "false" || "$TORXAKIS_USE_INTERNAL_SMT_SOLVER" == "0" ]]
then     
  brew_prefix=$(brew --prefix)
  export PATH="${brew_prefix}/Cellar/cvc4@${cvc4_version}/${cvc4_version}/bin/:${brew_prefix}/Cellar/z3@${z3_version}/${z3_version}/bin/:$PATH"    
fi



if [[ ! -f /etc/protocols ]]
then
  printf "ERROR: missing /etc/protocols file which must be installed to run ${script_name}!\n"
  printf "For most linux distributions this can be fixed by installing the 'tftp' package\n"
  exit 0
fi 

exec "${script_dir}/wrapped_${script_name}" "$@"
