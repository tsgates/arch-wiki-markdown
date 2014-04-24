RepoSearch
==========

    #!/usr/bin/python

    # Colorized repository searches; also searches the AUR.

    import os
    import re
    import sys
    import urllib2

    OFFICIAL_QUERY = "http://archlinux.org/packages/search/\?q="
    AUR_QUERY = "http://aur.archlinux.org/packages.php?K="

    # Repos and colors
    repos = {"Core":'32',"Extra":'36',"Testing":'31',"community":'33',"unsupported":'35'}

    def strip_html(buffer):
        buffer = re.sub('<[^>]*>','',buffer)
        buffer = re.sub('(?m)^[ \t]*','',buffer)
        return buffer

    def cut_html(beg,end,buffer):
        buffer = re.sub('(?s).*' + beg,'',buffer)
        buffer = re.sub('(?s)' + end + '.*','',buffer)
        return buffer

    class RepoSearch:
        def __init__(self,keyword):
            self.keyword = keyword
            self.results = ''
            for name in ['official','aur']:
                 self.get_search_results(name)
                 self.parse_results(name)
            self.colorize()
     
        def get_search_results(self,name):
            if name == "official":
                query = OFFICIAL_QUERY
            elif name == "aur":
                query = AUR_QUERY
     
            f = urllib2.urlopen( query + self.keyword )
            self.search_results = f.read()
            f.close()
     
        def preformat(self,header,a,b):
            self.buffer = cut_html('<table class=\"' + header + '\"[^>]*>','</table',self.search_results)
            self.buffer = strip_html(self.buffer)
            self.buffer = self.buffer.split('\n')
            self.buffer = [line for line in self.buffer if line]
            del self.buffer[a:b]
     
        def parse_results(self,name):
            self.buffer = ''
            if name == 'official':
                 if re.search('<table class=\"results\"',self.search_results):
                    self.preformat('results',0,6)
                 elif re.search('<div class=\"box\">',self.search_results):
                    temp = re.search('<h2 class=\"title\">([^<]*)</h2>',self.search_results)
                    temp = temp.group(1)
                    temp = temp.split()
                    self.preformat('listing',7,-1)
                    for i in range(0,3): del self.buffer[i]
                    for i in temp: self.buffer.insert(temp.index(i) + 2,i)
     
            elif name == 'aur':
                p = re.compile('<td class=.data[^>]*>')
                self.buffer = self.search_results.split('\n')
                self.buffer = [strip_html(line) for line in self.buffer if p.search(line)]
     
            l = len(self.buffer)/6
            parsed_buf = ''

            for i in range(l):
                parsed_buf += self.buffer[i*6] + '/'
                parsed_buf += self.buffer[i*6+1] + ' '*(24-len(self.buffer[i*6] + self.buffer[i*6+1]))
                parsed_buf += self.buffer[i*6+2]
                if name == "official":
                    parsed_buf += ' ' + self.buffer[i*6+3]
                parsed_buf += '\n' + self.buffer[i*6+4] + '\n'
     
            self.results += parsed_buf

        def colorize(self):
            for repo,repo_color in repos.iteritems():
                self.results = re.sub(repo + '/.*','\\033[1;' + repo_color + 'm' + '\g<0>' + '\\033[0;0m',self.results)
     
    if __name__ == "__main__":
        if len(sys.argv) < 2:
            print ("Usage: " + sys.argv[0] + " <keyword>")
            sys.exit(2)
        reposearch = RepoSearch(sys.argv[1])
        sys.stdout.write(reposearch.results)

Retrieved from
"https://wiki.archlinux.org/index.php?title=RepoSearch&oldid=198606"

Categories:

-   Scripts
-   Package management

-   This page was last modified on 23 April 2012, at 18:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
