#!/usr/bin/env node

// html2md.js
//
// A node.js html-to-markdown converter by:
//     Kevin MacMartin <prurigro at gmail dot com>
//
// This script is based on:
//     JS.Markdown.Converter -- html2markdown and markdown2html for javascript https://github.com/Inxo/JS.Markdown.Converter.git
//
//     Which was created using:
//         Showdown -- A JavaScript port of Markdown https://github.com/coreyti/showdown
//         html2markdown -- Convert an HTML document to Markdown https://bitbucket.org/tim_heap/html2markdown/

var path = require('path');
var fs = require('fs');
var args = process.argv.slice(2);
var Markdown = exports;

(
    function () {
        function identity(x) { return x; }
        function returnFalse(x) { return false; }
        function HookCollection() { }

        HookCollection.prototype = {
            chain: function (hookname, func) {
                var original = this[hookname];
                if (!original)
                    throw new Error("unknown hook " + hookname);

                if (original === identity)
                    this[hookname] = func;
                else
                    this[hookname] = function (x) { return func(original(x)); }
            },
            set: function (hookname, func) {
                if (!this[hookname])
                    throw new Error("unknown hook " + hookname);
                this[hookname] = func;
            },
            addNoop: function (hookname) {
                this[hookname] = identity;
            },
            addFalse: function (hookname) {
                this[hookname] = returnFalse;
            }
        };

        Markdown.HookCollection = HookCollection;
        Markdown.Converter = function () {};
    }
)();

Markdown.Converter.prototype.makeMarkdown = function(string) {
    // Elements
    var ELEMENTS = [
        {
            patterns: 'p',
            replacement: function(str, attrs, innerHTML) {
                return innerHTML ? '\n\n' + innerHTML + '\n' : '';
            }
        },
        {
            patterns: 'br',
            type: 'void',
            replacement: '\n'
        },
        {
            patterns: 'h([1-6])',
            replacement: function(str, hLevel, attrs, innerHTML) {
                var hPrefix = '';
                for(var i = 0; i < hLevel; i++) {
                    hPrefix += '#';
                }
                return '\n\n' + hPrefix + ' ' + innerHTML + '\n';
            }
        },
        {
            patterns: 'hr',
            type: 'void',
            replacement: '\n\n* * *\n'
        },
        {
            patterns: 'a',
            replacement: function(str, attrs, innerHTML) {
                var href = attrs.match(attrRegExp('href')),
                    title = attrs.match(attrRegExp('title'));
                return href ? '[' + innerHTML + ']' + '(' + href[1] + (title && title[1] ? ' "' + title[1] + '"' : '') + ')' : str;
            }
        },
        {
            patterns: ['b', 'strong'],
            replacement: function(str, attrs, innerHTML) {
                return innerHTML ? '**' + innerHTML + '**' : '';
            }
        },
        {
            patterns: ['i', 'em'],
            replacement: function(str, attrs, innerHTML) {
                return innerHTML ? '_' + innerHTML + '_' : '';
            }
        },
        {
            patterns: 'code',
            replacement: function(str, attrs, innerHTML) {
                return innerHTML ? '`' + innerHTML + '`' : '';
            }
        },
        {
            patterns: 'img',
            type: 'void',
            replacement: function(str, attrs, innerHTML) {
                var src = attrs.match(attrRegExp('src')),
                    alt = attrs.match(attrRegExp('alt')),
                    title = attrs.match(attrRegExp('title'));
                return '![' + (alt && alt[1] ? alt[1] : '') + ']' + '(' + src[1] + (title && title[1] ? ' "' + title[1] + '"' : '') + ')';
            }
        }
    ];
    for(var i=0, len = ELEMENTS.length; i<len; i++) {
        if(typeof ELEMENTS[i].patterns === 'string') {
            string = replaceEls(string, {
                tag: ELEMENTS[i].patterns,
                replacement: ELEMENTS[i].replacement,
                type: ELEMENTS[i].type
            });
        }
        else {
            for(var j=0, pLen = ELEMENTS[i].patterns.length; j<pLen; j++) {
                string = replaceEls(string, {
                    tag: ELEMENTS[i].patterns[j],
                    replacement: ELEMENTS[i].replacement,
                    type: ELEMENTS[i].type
                });
            }
        }
    }
    function replaceEls(html, elProperties) {
        var pattern = elProperties.type === 'void' ? '<' + elProperties.tag + '\\b([^>]*)\\/?>' : '<' + elProperties.tag + '\\b([^>]*)>([\\s\\S]*?)<\\/' + elProperties.tag + '>',regex = new RegExp(pattern, 'gi'),markdown = '';

        if(typeof elProperties.replacement === 'string') {
            markdown = html.replace(regex, elProperties.replacement);
        }
        else {
            markdown = html.replace(regex, function(str, p1, p2, p3) {
                return elProperties.replacement.call(this, str, p1, p2, p3);
            });
        }
        return markdown;
    }
    function attrRegExp(attr) {
        return new RegExp(attr + '\\s*=\\s*["\']?([^"\']*)["\']?', 'i');
    }

    // Pre-code blocks
    string = string.replace(/<pre\b[^>]*>`([\s\S]*)`<\/pre>/gi, function(str, innerHTML) {
        innerHTML = innerHTML.replace(/^\t+/g, '    '); // convert tabs to spaces
        innerHTML = innerHTML.replace(/\n/g, '\n    ');
        return '\n\n    ' + innerHTML + '\n';
    });

    // Lists (converts lists with no child lists (of same type) first, then works up
    string = string.replace(/(\d+). /g, '$1\\. '); // Escape numbers that could trigger an ol
    var noChildrenRegex = /<(ul|ol)\b[^>]*>(?:(?!<ul|<ol)[\s\S])*?<\/\1>/gi;
    while(string.match(noChildrenRegex)) {
        string = string.replace(noChildrenRegex, function(str) {
            return replaceLists(str);
        });
    }
    function replaceLists(html) {
        html = html.replace(/<(ul|ol)\b[^>]*>([\s\S]*?)<\/\1>/gi, function(str, listType, innerHTML) {
            var lis = innerHTML.split('</li>');
            lis.splice(lis.length - 1, 1);

            for(i = 0, len = lis.length; i < len; i++) {
                if(lis[i]) {
                    var prefix = (listType === 'ol') ? (i + 1) + ".  " : "*   ";
                    lis[i] = lis[i].replace(/\s*<li[^>]*>([\s\S]*)/i, function(str, innerHTML) {
                        innerHTML = innerHTML.replace(/^\s+/, '');
                        innerHTML = innerHTML.replace(/\n\n/g, '\n\n    ');
                        innerHTML = innerHTML.replace(/\n([ ]*)+(\*|\d+\.) /g, '\n$1    $2 '); // indent nested lists
                        return prefix + innerHTML;
                    });
                }
            }
            return lis.join('\n');
        });
        return '\n\n' + html.replace(/[ \t]+\n|\s+$/g, '');
    }

    // Blockquotes
    var deepest = /<blockquote\b[^>]*>((?:(?!<blockquote)[\s\S])*?)<\/blockquote>/gi;
    while(string.match(deepest)) {
        string = string.replace(deepest, function(str) {
            return replaceBlockquotes(str);
        });
    }
    function replaceBlockquotes(html) {
        html = html.replace(/<blockquote\b[^>]*>([\s\S]*?)<\/blockquote>/gi, function(str, inner) {
            inner = inner.replace(/^\s+|\s+$/g, '');
            inner = cleanUp(inner);
            inner = inner.replace(/^/gm, '> ');
            inner = inner.replace(/^(>([ \t]{2,}>)+)/gm, '> >');
            return inner;
        });
        return html;
    }

    // Strip and cleanup
    function cleanUp(string) {
        // Tags
        string = string.replace(/\<[pP][rR][eE]\>/g, '```\n'); // <pre> -> ``` then line break
        string = string.replace(/\<\/[pP][rR][eE]\>/g, '\n```'); // </pre> -> line break then ```
        string = string.replace(/\<[tT][iI][tT][lL][eE]\>[^\<]*\<[^\>]*\>/g, ''); // remove <title>*</title>
        string = string.replace(/\<[^\>]*\>/g, ''); // remove leftover tags
        string = string.replace(/([[^\]]*\]\([^\)\ ]*)\s\s*[^\)]*\)/g, '$1\)'); // strip everything after whitespace in links
        string = string.replace(/\[(\s*[^\]]*)\]\(\s*mailto:([^\)]*\))/g, '$1 \($2'); // convert [mail](mailto:a@b.c) -> mail (a@b.c)
        string = string.replace(/\[\s*(http[^\]]*)\]\(\s*http[^\)]*\)/g, '$1'); // convert external links with [url](url)
        string = string.replace(/\[([^\]]*)\](\(\s*http[^\)]*\))/g, '$1 $2'); // convert the remaining external links
        string = string.replace(/\[([^\]]*)\]\([^\)]*\)/g, '$1'); // strip internal links

        // Content
        string = string.replace(/([^\s])\ {2,3}(\ {2,3})*/g, '$1\ '); // 2-3 spaces to 1 space (4=tab)
        string = string.replace(/\*\ Privacy policy[\S\s]*/g, ''); // strip the privacy policy and everything after

        // Whitespace
        string = string.replace(/\n\s*\n\s*\n*/g, '\n\n'); // more than two line breaks -> two line breaks
        string = string.replace(/(\n\*.*\n)\n*\*/g, '$1\*'); // remove spaces between unordered list items
        string = string.replace(/(\n[0-9][0-9]*\..*\n)\n*([0-9][0-9]*\.)/g, '$1$2'); // remove spaces between ordered list items
        string = string.replace(/\ \ *\n/g, '\n'); // trim trailing line whitespace
        string = string.replace(/^[\t\r\n]+|[\t\r\n]+$/g, ''); // trim leading/trailing document whitespace
        return string;
    }
    return cleanUp(string);
};

function file2markdown(file){
    fs.readFile(file, {encoding: 'utf-8'}, function(err,data){
        if (err){
            console.log(err);
        }
        else{
            console.log(converter.makeMarkdown(data));
        }
    });
}

var converter = new Markdown.Converter;

args.forEach(function (val, index, array) {
    var filePath = path.join(__dirname + '/' + val);
    file2markdown(filePath);
});
