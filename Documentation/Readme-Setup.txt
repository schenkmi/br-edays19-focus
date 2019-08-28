

Add buildroot

git clone git://git.buildroot.net/buildroot
rm -rf buildroot/.git
git add --force --all buildroot/

git commit -m "buildroot master from 2019.08.16 12:50" buildroot
git push


git add --force --all focus-external/
git commit -m "external br tree for RPI4,3,2" focus-external/

git push


cd buildroot
make BR2_EXTERNAL=../focus-external rpi4_defconfig

make

git clone https://github.com/schenkmi/br-edays19-focus.git


cd Downloads
wget http://ftp.fau.de/eclipse/technology/epp/downloads/release/2019-06/R/eclipse-cpp-2019-06-R-linux-gtk-x86_64.tar.gz
cd ~
tar xzvf Downloads/eclipse-cpp-2019-06-R-linux-gtk-x86_64.tar.gz


