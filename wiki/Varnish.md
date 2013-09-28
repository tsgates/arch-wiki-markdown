Varnish
=======

Varnish Cache is a web application accelerator also known as a caching
HTTP reverse proxy. You install it in front of any server that speaks
HTTP and configure it to cache the contents.

Multiple backends
-----------------

By default, varnish comes configured in /etc/conf.d/varnish to use
localhost:8080 as the only backend:

    /etc/conf.d/varnish

    VARNISHD_OPTS="-a 0.0.0.0:80 \
                   -b localhost:8080 \
                   -T localhost:6082 \
                   -s malloc,64M
                   -u nobody -g nobody"

    VARNISH_CFG="/etc/varnish/default.vcl"

Also, the VARNISH_CFG file is not loaded on varnish instalation nor
service startup. So in case you want multiple backends from a VCL file,
you need to edit /etc/varnish/default.vcl with at least one backend and
call:

    $ /etc/rc.d/varnish reload

> Manual VCL load

If the previous VCL configuration reload failed, try loading the VCL
file manually:

1.  Connect to the varnish console:

        $ varnishadm -T localhost:6082

2.  Load the default VCL. Make sure it has at least one backend:

        varnish> vcl.load default /etc/varnish/default.vcl

3.  Make it active:

        varnish> vcl.use default

4.  Start the child proccess (optional):

        varnish> start

Retrieved from
"https://wiki.archlinux.org/index.php?title=Varnish&oldid=240582"

Category:

-   Web Server
