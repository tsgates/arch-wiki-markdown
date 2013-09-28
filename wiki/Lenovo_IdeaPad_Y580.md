Lenovo IdeaPad Y580
===================

The Lenovo IdeaPad Y580 started shipping in June 2012. It is a fairly
powerful machine, but it has its own compatibility issues. The purpose
of this article is to help with setting up Arch Linux on this machine.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Ethernet                                                           |
| -   3 UEFI                                                               |
| -   4 Dual-Boot With Windows 8                                           |
| -   5 DISPLAY                                                            |
|     -   5.1 NVIDIA Card                                                  |
|     -   5.2 Nvidia Bumblebee support                                     |
|     -   5.3 Driver                                                       |
|     -   5.4 nvidia-utils PKGBUILD                                        |
|     -   5.5 CUDA Toolkit                                                 |
|     -   5.6 Configurations                                               |
|     -   5.7 Testing it                                                   |
|                                                                          |
| -   6 Other Distributions                                                |
+--------------------------------------------------------------------------+

Installation
------------

Install Arch on the machine if you have not done it already. Read
Installation Guide for more information.

Ethernet
--------

If you cannot get ethernet working, you can get a ethernet connection
with the help of the driver alx. This driver is not yet part of the
Linux kernel, and that is why your ethernet card is not recognized at
first. The links from QCA upstream alx source files works for current
3.8.x kernels. This sources is found to work for both AR8161 and AR8162
ethernet devices. Copy the tarball to a flash drive, boot the live cd,
mount the flash drive, cd to the directory with the tarball and use:

    tar -xjvf compat*
    cd compat*
    ./scripts/driver-select alx 
    make
    sudo make install   

After this, load the module (modprobe alx) and you should be able to get
ethernet working easily. As a alternative you can install dkms-alx from
AUR and it will recompile the module every reboot after a kernel
upgrade.

The machine comes with Windows and some Lenovo partitions that may be
important if you need to recover the Windows install.

In case you do not need to restore the machine to their original state,
you can just delete the existing partition. Other way, backup the
partions before erasing them

Also, this laptop can use UEFI. If you want to use it, you need to a GPT
partition (see below).

UEFI
----

Even thought its easier to switch from UEFI to legacy mode BIOS in this
laptop and install Arch Linux on mSATA SSD and without disturbing
factory installed windows 8 located on the HDD, this section will guide
you to install Arch Linux with UEFI. UEFI is complicated and so proper
understanding is advised before you start.

Read these pages: Rod smith's UEFI guide Unified Extensible Firmware
Interface and GRUB2.

Among other things, you need a gpt partition and grub2.

To install Arch on the SSD drive, you need at least two partitions: one
small (100 MB) boot partition, and another partition for /. To partition
the drives, you can use cgdisk, which you can get by installing the
package gpttools.

You should also create a third partition (with about 1GB) for EFI. This
partition needs to be of EFI system type (code ef00 on gdisk) and it
should be formatted as FAT32. If the partition is /dev/sda2, use:

    mkfs.vfat -F32 /dev/sda3  

After you have your base system up and running, install the grub 2
firmware:

    pacman -S grub2-efi-x86_64

Mount the system partition at /boot/efi:

    mkdir /boot/efi
    mount -t vfat /dev/sda3 /boot/efi

Install grub2 efi app (grubx64.efi) to /boot/efi/EFI/arch_grub, and its
modules to /boot/efi/EFI/grub/x86_64-efi:

    grub-install --directory=/usr/lib/grub/x86_64-efi --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --boot-directory=/boot/efi/EFI --recheck --debug
    mkdir -p /boot/efi/EFI/grub/locale
    cp /usr/share/locale/en@quot/LC_MESSAGES/grub.mo /boot/efi/EFI/grub/locale/en.mo

The grub2 wiki page says to copy the app to other places. This is
probably not necessary, but you may want to use:

    mkdir /boot/efi/EFI/tools
    cp /boot/efi/EFI/arch_grub/grubx64.efi /boot/efi/shellx64.efi
    cp /boot/efi/EFI/arch_grub/grubx64.efi /boot/efi/EFI/shellx64.efi
    cp /boot/efi/EFI/arch_grub/grubx64.efi /boot/efi/EFI/tools/shellx64.efi   

Now comes the part where the grub2 page is not very clear. You need to
add the system to the UEFI menu (the menu that shows up when you press
F12 at boot). To do this, you need an UEFI shell. The Y580 does not come
with a shell built in, but you can put one in a flash drive and boot
from it. To do this, get a bootable flash drive, create a partition (1GB
is enough) and format it as FAT32. Assuming that the partition is
/dev/sdc1, type the following:

    mount /dev/sdc1 /media
    mkdir -p /media/efi/boot
    cd /media/efi/boot
    wget https://edk2.svn.sourceforge.net/svnroot/edk2/trunk/edk2/ShellBinPkg/UefiShell/X64/Shell.efi
    mv Shell.efi bootx64.efi
    cd /
    umount /media  

The code creates a directory /efi/boot in the flash drive, downloads the
shell, copies it to /efi/boot and renames it as bootx64.efi. The shell
is downloaded from the link given here:
https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface#UEFI_Shell.
Note that you need a 2.0 shell, otherwise you will not be able to add an
entry to the menu.

Note that it is also possible to simply place the UEFI shell in your
UEFI system partition if you do not have a flash drive at hand:

    wget https://edk2.svn.sourceforge.net/svnroot/edk2/trunk/edk2/ShellBinPkg/UefiShell/X64/Shell.efi
    mkdir -p /boot/efi/EFI/boot
    mv Shell.efi /boot/efi/EFI/boot/bootx64.efi

This will cause the ideapad UEFI firmware to automatically add a new
boot option named "EFI HDD Device" which will by default come first.

Now reboot, go to the BIOS (press F2), enable UEFI and exit, then press
F12 and the flash drive should show up in the menu (you want to choose
the UEFI entry). Now you should be in the UEFI shell. There is quite a
lot that you can do, but be careful because a mistake can seriously
compromise the machine. This guide may be worth looking at:
http://software.intel.com/en-us/articles/uefi-shell/

For now, you just need the command bcfg. To add Arch to the first entry
of the menu, use:

    bcfg boot add 0 fs1:\EFI\arch_grub\grubx64.efi "Arch Linux"  

The command assumes that the system partition is installed on the first
drive. This partition has the loader (grubx64.efi) and this little
program is what loads grub2. If you add Arch to the first entry, you can
boot to it without pressing F12.

To see the menu entries, use:

    bcfg boot dump -v

To delete, say the 3rd entry:

    bcfg boot rm 3

Once you are happy with the menu entries, reboot and you should be able
to boot into Arch.

Dual-Boot With Windows 8
------------------------

To avoid problems with the Arch install, put Windows on the second drive
(this means that the second drive should also have a GUID partition
table, since Windows 8 only works with one).

Windows 8 uses UEFI, so you can press F12 to choose between Arch and
Windows, or just adjust this at the BIOS. Another option is to use the
Windows program EasyBCD and add Arch to the Windows boot loader. In this
example, Windows is going to be added to grub2.

To do this, from Arch, mount the Windows system partition and find its
UUID:

    mount /dev/sdb1 /mnt
    grub-probe --target=fs_uuid /media/EFI/Microsoft/Boot/bootmgfw.efi   

Take note of the output (something like 1ce5-7f28). Now copy the output
of:

    grub-probe --target=hints_string /media/EFI/Microsoft/Boot/bootmgfw.efi

Then, add something like this to /etc/grub.d/0_custom:

    menuentry "Microsoft Windows 8 x86_64 UEFI-GPT" {
        insmod part_gpt
        insmod fat
        insmod search_fs_uuid
        insmod chain
        search --fs-uuid --no-floppy --set=root --hint-bios=hd0,gpt1 --hint-efi=hd0,gpt1 --hint-baremetal=ahci0,gpt1 1ce5-7f28
        chainloader /efi/Microsoft/Boot/bootmgfw.efi
    }

Finally generate the grub2 configuration file (grub.cfg):

    grub-mkconfig -o /boot/efi/EFI/grub/grub.cfg

Now you should be able to see an entry for Windows 8 on grub2.

The Y580 has a huge 1TB second drive, making it easy to install other
OS. With grub2, you can install other distros, and then run
grub-mkconfig to add the new entry. To make this easier, install
os-prober so that grub2 can find other OS automatically (it does not
work for Windows 8):

    pacman -S os-prober

DISPLAY
-------

Since the arrival of 3.7.X series kernel, this machine boots into black
screen. You will have to add acpi_backlight=vendor to kernel command
line to boot into a visible display. You can alternatively increase the
screen brightness during every boot also, since the screen brightness is
set to 0 wrongly by the kernel acpi by default.

> NVIDIA Card

The Y580 uses NVIDIA's Optimus technology, which is not officially
supported on Linux yet. A possible solution is to install Bumblebee
(https://wiki.archlinux.org/index.php/Bumblebee) and to access the card
with optirun. However, you can still use CUDA, which is good if you use
apps like Blender or if you develop CUDA C programs.

> Nvidia Bumblebee support

In Linux currently bumblebee is the easiest option for a optimus like
solution. For this laptop you will need bbswitch, Bumblebee, nvidia from
official Arch repos. After installation of these packages you will need
to add your user name to bumblebee group.You have to start the
bumblebeed service manually. A short guide given here bumblebee.

> Driver

To compile and run CUDA programs, you need a NVIDIA driver and the
cuda-toolkit. Any driver with version 295.59 or higher will work.
Template:Note: The only exception being the 302.17

As of 10/24/2012, the newest driver is 304.60. To install it, you need a
modified version of the package nvidia-utils from extra. The easiest way
to do this is to install the package nvidia-utils-custom from the AUR:
https://aur.archlinux.org/packages.php?ID=60991.

Alternatively, you can use ABS and patch the package yourself. If you
are not familiar with the process, read the wiki:
https://wiki.archlinux.org/index.php/Arch_Build_System. The exact way to
rebuild a package depends on your own preferences, one way is to
download the source code (in this case, the driver, obtained here:
ftp://download.nvidia.com/XFree86/Linux-x86_64/304.60/NVIDIA-Linux-x86_64-304.60-no-compat32.run),
copy it to the build directory, edit the PKGBUILD, and then run makepkg.

Edit the PKGBUILD of nvidia-utils. You may need to change the pkgver,
the source item, and the md5sum. The most important thing is that
nvidia-utils conflicts with libgl, but if you uninstall libgl, Gnome
only starts in fallback mode (not sure about other DE). Because of this,
you need to modify the PKGBUILD, so that it either does not install
certain libraries (libglx.so, libGL.so) or that it installs them in
another location. With the PKGBUILD below, those libraries are not
installed (note the commented lines for the GLX extension module, and
the empty 'conflicts' line).

> nvidia-utils PKGBUILD

    # $Id$
    # Maintainer: Thomas Baechler <thomas@archlinux.org>
    # Contributor: James Rayner <iphitus@gmail.com>
    pkgbase=nvidia-utils
    pkgname=('nvidia-utils' 'opencl-nvidia')
    pkgver=304.60
    pkgrel=1
    arch=('i686' 'x86_64')
    url="http://www.nvidia.com/"
    license=('custom')
    options=('!strip')

    if [ "$CARCH" = "i686" ]; then
        _arch='x86'
        _pkg="NVIDIA-Linux-${_arch}-${pkgver}"
        source=("ftp://download.nvidia.com/XFree86/Linux-${_arch}/${pkgver}/${_pkg}.run")
        md5sums=('42b9887076b2ebcf1af5ee13bc332ccb')
    elif [ "$CARCH" = "x86_64" ]; then
        _arch='x86_64'
        _pkg="NVIDIA-Linux-${_arch}-${pkgver}-no-compat32"
        source=("ftp://download.nvidia.com/XFree86/Linux-${_arch}/${pkgver}/${_pkg}.run")
        md5sums=('7248399a125808e3bbc9c66da99a098d')
    fi

    create_links() {
        # create soname links
        while read -d '' _lib; do
            _soname="$(dirname "${_lib}")/$(readelf -d "${_lib}" | sed -nr 's/.*Library soname: \[(.*)\].*/\1/p')"
            [[ -e "${_soname}" ]] || ln -s "$(basename "${_lib}")" "${_soname}"
            [[ -e "${_soname/.[0-9]*/}" ]] || ln -s "$(basename "${_soname}")" "${_soname/.[0-9]*/}"
        done < <(find "${pkgdir}" -type f -name '*.so*' -print0)
    }

    build() {
        cd "${srcdir}"
        sh "${_pkg}.run" --extract-only
    }

    package_opencl-nvidia() {
        pkgdesc="OpenCL implemention for NVIDIA"
        depends=('libcl' 'zlib')
        optdepends=('opencl-headers: headers necessary for OpenCL development')
        cd "${srcdir}/${_pkg}"

        # OpenCL
        install -D -m644 nvidia.icd "${pkgdir}/etc/OpenCL/vendors/nvidia.icd"
        install -D -m755 "libnvidia-compiler.so.${pkgver}" "${pkgdir}/usr/lib/libnvidia-compiler.so.${pkgver}"
        install -D -m755 "libnvidia-opencl.so.${pkgver}" "${pkgdir}/usr/lib/libnvidia-opencl.so.${pkgver}"

        create_links
    }

    package_nvidia-utils() {
        pkgdesc="NVIDIA drivers utilities and libraries."
        depends=('xorg-server' 'libxvmc')
        optdepends=('gtk2: nvidia-settings' 'pkg-config: nvidia-xconfig'
                    'opencl-nvidia: OpenCL support')
        conflicts=('')
        provides=('libgl')
        cd "${srcdir}/${_pkg}"

        # X driver
        install -D -m755 nvidia_drv.so "${pkgdir}/usr/lib/xorg/modules/drivers/nvidia_drv.so"
        # GLX extension module for X
        #install -D -m755 "libglx.so.${pkgver}" "${pkgdir}/usr/lib/xorg/modules/extensions/libglx.so.${pkgver}"
        #ln -s "libglx.so.${pkgver}" "${pkgdir}/usr/lib/xorg/modules/extensions/libglx.so"	# X does not find glx otherwise
        # OpenGL library
        #install -D -m755 "libGL.so.${pkgver}" "${pkgdir}/usr/lib/libGL.so.${pkgver}"
        # OpenGL core library
        install -D -m755 "libnvidia-glcore.so.${pkgver}" "${pkgdir}/usr/lib/libnvidia-glcore.so.${pkgver}"
        # XvMC
        install -D -m644 libXvMCNVIDIA.a "${pkgdir}/usr/lib/libXvMCNVIDIA.a"
        install -D -m755 "libXvMCNVIDIA.so.${pkgver}" "${pkgdir}/usr/lib/libXvMCNVIDIA.so.${pkgver}"
        # VDPAU
        install -D -m755 "libvdpau_nvidia.so.${pkgver}" "${pkgdir}/usr/lib/vdpau/libvdpau_nvidia.so.${pkgver}"
        # nvidia-tls library
        install -D -m755 "tls/libnvidia-tls.so.${pkgver}" "${pkgdir}/usr/lib/libnvidia-tls.so.${pkgver}"
        install -D -m755 "libnvidia-cfg.so.${pkgver}" "${pkgdir}/usr/lib/libnvidia-cfg.so.${pkgver}"

        install -D -m755 "libnvidia-ml.so.${pkgver}" "${pkgdir}/usr/lib/libnvidia-ml.so.${pkgver}"
        # CUDA
        install -D -m755 "libcuda.so.${pkgver}" "${pkgdir}/usr/lib/libcuda.so.${pkgver}"
        install -D -m755 "libnvcuvid.so.${pkgver}" "${pkgdir}/usr/lib/libnvcuvid.so.${pkgver}"

        # nvidia-xconfig
        install -D -m755 nvidia-xconfig "${pkgdir}/usr/bin/nvidia-xconfig"
        install -D -m644 nvidia-xconfig.1.gz "${pkgdir}/usr/share/man/man1/nvidia-xconfig.1.gz"
        # nvidia-settings
        install -D -m755 nvidia-settings "${pkgdir}/usr/bin/nvidia-settings"
        install -D -m644 nvidia-settings.1.gz "${pkgdir}/usr/share/man/man1/nvidia-settings.1.gz"
        install -D -m644 nvidia-settings.desktop "${pkgdir}/usr/share/applications/nvidia-settings.desktop"
        install -D -m644 nvidia-settings.png "${pkgdir}/usr/share/pixmaps/nvidia-settings.png"
        sed -e 's:__UTILS_PATH__:/usr/bin:' -e 's:__PIXMAP_PATH__:/usr/share/pixmaps:' -i "${pkgdir}/usr/share/applications/nvidia-settings.desktop"
        # nvidia-bug-report
        install -D -m755 nvidia-bug-report.sh "${pkgdir}/usr/bin/nvidia-bug-report.sh"
        # nvidia-smi
        install -D -m755 nvidia-smi "${pkgdir}/usr/bin/nvidia-smi"
        install -D -m644 nvidia-smi.1.gz "${pkgdir}/usr/share/man/man1/nvidia-smi.1.gz"

        install -D -m644 LICENSE "${pkgdir}/usr/share/licenses/nvidia/LICENSE"
        ln -s nvidia "${pkgdir}/usr/share/licenses/nvidia-utils"
        install -D -m644 README.txt "${pkgdir}/usr/share/doc/nvidia/README"
        install -D -m644 NVIDIA_Changelog "${pkgdir}/usr/share/doc/nvidia/NVIDIA_Changelog"
        ln -s nvidia "${pkgdir}/usr/share/doc/nvidia-utils"

        create_links
    }

It is not necessary to patch other packages. If you want, you can also
install nvidia-custom (https://aur.archlinux.org/packages.php?ID=60981)
and opencl-nvidia-custom
(https://aur.archlinux.org/packages.php?ID=61443) from the AUR, but they
are not much different from the official ones (nvidia and opencl-nvidia
from extra).

If you rebuild nvidia-utils yourself, you may want to add it to the
IgnorePkg line of your /etc/pacman.conf, so that the next system update
does not break your system.

> CUDA Toolkit

Install the package from community
(https://www.archlinux.org/packages/community/x86_64/cuda/).

> Configurations

You need to load the acpi-handle-hack module first, then the nvidia
module. Depending on your system, this may be enough, but it may be
necessary to create devices for CUDA. One way to accomplish this is to
add the following to your /etc/rc.local:

    /sbin/modprobe acpi-handle-hack
    /sbin/modprobe nvidia

    if [ "$?" -eq 0 ]; then

    # Count the number of NVIDIA controllers found.

    N3D=`lspci | grep -i NVIDIA | grep "3D controller" | wc -l`

    NVGA=`lspci | grep -i NVIDIA | grep "VGA compatible controller" | wc -l`

    N=`expr $N3D + $NVGA - 1`

    for i in `seq 0 $N`; do
    mknod -m 666 /dev/nvidia$i c 195 $i
    done

    mknod -m 666 /dev/nvidiactl c 195 255
    else
    exit 1

If you are using systemd, you can get the /etc/rc.local loaded at boot
by adding a new service. Create the following file:

    #/etc/systemd/system/rc-local.service

    [Unit]
    Description=/etc/rc.local Compatibility

    [Service]
    Type=oneshot
    ExecStart=/etc/rc.local
    TimeoutSec=0
    StandardInput=tty
    RemainAfterExit=yes

    [Install]
    WantedBy=multi-user.target

Then make this service load at boot with:

    systemctl enable rc-local.service

> Testing it

The cuda package includes both the cuda-toolkit and sdk. Before testing
it, reboot and it should be working. To compile and run deviceQuery from
the sdk:

    cd /opt/cuda/samples/1_Utilities/deviceQuery
    make
    ./deviceQuery

Alternatively, you can compile your own code and run it. To compile, say
hello.cu, use:

    nvcc hello.cu

Now you can run the executable:

    ./a.out

If this works without errors, you are all set!

Other Distributions
-------------------

1.The above setup not only works only with Arch Linux and it may be even
easier with other distros. For example, with Ubuntu 12.04 or Linux Mint
13, install the acpi-handle-hack module and then get the official
nvidia-current (no need to patch it) package:

    apt-get install nvidia-current

2. For Debian wheezy you shall need the lenovo-hack as described above
and additional packages from suwako repos which has dkms-bbswtich
bumblebee and bumblebee-nvidia.The easiest option is available from
Debian. No need to blacklist anything. The ethernet alx driver is
included in Debian kernel since linux-image-3.2.39.1.

3. For Fedora, RHEL 6.X series and its clones the external repos from
ncsu.edu with installation of non-free nvidia from their non-free repos
at bumblebee-nvidia is necessary. Installing nvidia from rpmfusion shall
break your X. You will have to edit the connected monitor section to
"CRT-0" from "FDP" in Fedora 18 in case if the default configuration
does not work. You will have to blacklist nouvea drivers at kernel
command line to (xdriver=vesa nouveau.modeset=0
rd.driver.blacklist=nouveau).

4. Starting from 3.8.5 kernel you will not need to patch the kernel for
proper acpi handling for any distro.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_IdeaPad_Y580&oldid=254807"

Category:

-   Lenovo
