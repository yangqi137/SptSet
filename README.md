# SptSet

GAP package for computing the classification of SPT and SET phases.

## Status

SptSet package is still work in progress. There are still planned functions missing.
Currently, it can be used to compute fermion SPT classification in 2D, and in 3D if the symmetry group is a direct product of bosonic symmetries and fermion parity. Since the package is still incomplete, we do not provide release packages, and recommend accessing the most current version by cloning the git repository.

## Installation

1. Clone this git repository.
1. Copy (or make a symbolic link) the entire repository under the pkg/ directory of your gap installation. Obviously these two steps can be combined together by directly cloning the repository under the pkg/ directory.

## Examples

After the package is installed, one can run the scripts under the examples/ directory in the package to do some computation. In particular, the scripts fspt_2d_ez.g and fspt_2d_s12.g were used to generate results in [arXiv:2005.06572](https://arxiv.org/abs/2005.06572).
