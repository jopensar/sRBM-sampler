# sRBM-sampler
A simple and fast method for sampling from sparse high-dimensional pairwise Markov networks.

### About ###

sRBM-sampler is an R implementation of the Gibbs sampler introduced in Pensar et al (2020) for sampling from sparse high-dimensional pairwise Markov networks over binary variables. The idea behind the sampler is to transform the Markov network into a corresponding sparse Restricted Boltzmann Machine (sRBM) with edge-specific Gaussian auxiliary varibles, from which samples can be generated efficiently using a block-Gibbs approach. For more details about the sampler, see

[Pensar, J., Xu, Y., Puranen, S., Pesonen, M., Kabashima, Y., Corander, J. High-dimensional structure learning of binary pairwise Markov networks: A comparative numerical study, _Computational Statistics & Data Analysis_, 2020, 141:62-76.](https://arxiv.org/abs/1901.04345)

Please cite the above paper when using this method (modified or as is).

### Usage ###
See the included script read_me.R for step-by-step instructions on how to use the code. 

The original MATLAB version of the sampler can be found at [https://bitbucket.org/jopensar/srbm-sampler/](https://bitbucket.org/jopensar/srbm-sampler/).
