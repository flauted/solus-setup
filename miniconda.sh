# Relatively quiet install of conda. Mostly OS indep. 
#
# Instructions gathered from https://conda.io/docs/user-guide/install/linux.html and
# https://conda.io/docs/user-guide/install/macos.html#install-macos-silent

filename=Miniconda3-latest-Linux-x86_64.sh
wget https://repo.continuum.io/miniconda/"$filename" -O /tmp/miniconda.sh
bash /tmp/miniconda.sh -b -p $HOME/miniconda
# Note: the following line isn't necessary a wonderful idea...
echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> $HOME/.bashrc
source $HOME/.bashrc
rm /tmp/miniconda.sh
