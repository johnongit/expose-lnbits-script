# Purpose
This script is a ready to use way to expose publicly your private lnbits instance (eg: umbrel).

The script will install expose client and launch a tunnel to my personal expose instance.

# Usage

Ssh to your umbrel.
> ssh umbrel@umbrel.local

Clone the repository.
> git clone https://github.com/johnongit/expose-lnbits-script
> expose-lnbits-script

Install composer and expose
> sudo ./expose.sh install

Configure expose and start expose
> sudo ./expose.sh configure <my-subdomain> <access-token>

This will create a new subdomain in your expose instance on https://my-subdomain.exp.openchain.fr

# Contact

Twitter: https://twitter.com/johnOnChain
Lnbits: https://lnb.openchain.fr/lnticket/CpmVU6c5P2cVFMr8QRVB5t


# Expose

https://expose.dev/docs/server/starting-the-server