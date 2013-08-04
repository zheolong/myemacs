myemacs
=======

emacs 24.3 and my configuration

How to get started
------------------

## Getting Started ##

### install emacs ###

1.Download [emacs-24.3.tar.gz](http://ftp.gnu.org/pub/gnu/emacs/emacs-24.3.tar.gz)

2.`tar -xzvf emacs-24.3.tar.gz`

3.`sudo apt-get install build-essential`

  `sudo apt-get install build-dep emacs`

4.`./configure && make && make install`

   if make shows error "automake's version is no compitable",please update your [automake](http://ftp.gnu.org/gnu/automake/)

### install texlive ###

1.Download [texlive2013.iso](http://mirrors.hustunique.com/CTAN/systems/texlive/Images/texlive2013.iso)

2.`mkdir /mnt/disk && mount -t iso9660 -o ro,loop,noauto /home/username/Downloads/texlive2013.iso /mnt/disk`

3.`sudo apt-get install perl-tk`

4.`/mnt/disk/install-tl --gui`

5. in file "/etc/profile" add

export PATH=/usr/local/texlive/2013/bin/x86_64-linux:$PATH;

(For i386 replace the x86\_64-linux with i386-linux)

MANPATH=/usr/local/texlive/2013/texmf/doc/man:$MANPATH; export MANPATH

INFOPATH=/usr/local/texlive/2013/texmf/doc/<info:$INFOPATH>; export INFOPATH

6. in file "/etc/manpath.config" add

 MANPATH\_MAP /usr/local/texlive/2013/bin/x86\_64-linux /usr/local/texlive/2013/texmf/doc/man

(For i386 replace the x86\_64-linux with i386-linux)

7. cp "./fonts" to "/usr/share/"

`sudo chmod 644 /usr/share/fonts/winfonts/*`

`sudo chmod 644 /usr/share/fonts/adobefonts/*`

`sudo mkfontscale`

`sudo mkfontdir`

`sudo fc-cache -fsv`

cp "./fonts/ctex-xecjk-winfonts.def" to "/usr/local/texlive/2013/texmf-dist/tex/latex/ctex/fontset"

### install or just make ###

cd  ~/.emacs.d/auctex-11.87 && make && make install

cd ~/.emacs.d/mylisps/cedet-1.1 && make

cd ~/.emacs.d/predictive && make
