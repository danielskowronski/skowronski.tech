---
title: Hello, PHP-free world
date: 2022-11-10
---

All my websites ([skowron.ski](https://skowron.ski), [skowronski.pro](https://skowronski.pro) and [skowronski.tech](https://skowronski.tech) that replaces `blog.dsinf.net`) are PHP-free. They are based on **[Hugo](https://gohugo.io)** and hosted on S3 with only dynamic content being [plausible.io](https://plausible.io/) rewrite done by CloudFlare worker scripts.

Quick braindump on how to export Wordpress:

- first, run https://github.com/SchumacherFM/wordpress-to-hugo-exporter in CLI and download created ZIP
- extract articles to relevant Hugo path
- remove drafts and peform some basic cleanups (like 'category: no category')
- to convert mess I had with my set of plugins for images I wrote below script that fixes one exported markdown article at a time:

```python
# [<img decoding="async" loading="lazy" src="http://blog.dsinf.net/wp-content/uploads/2012/08/rondo1-300x225.png" alt="rondo1" width="300" height="225" class="alignnone size-medium wp-image-191" srcset="https://blog.dsinf.net/wp-content/uploads/2012/08/rondo1-300x225.png 300w, https://blog.dsinf.net/wp-content/uploads/2012/08/rondo1.png 640w" sizes="(max-width: 300px) 100vw, 300px" />][1]  

import re, sys

file = open(sys.argv[1], "r")
lines = file.readlines()

for i in range (0, len(lines)):
	l = lines[i]
	html_matches = re.search('(<img .*? />)', l)

	if html_matches:
		html = html_matches.groups()[0]

		print(html)

		alt_matches = re.search('alt="(.*?)"', html)
		if alt_matches:
			alt = alt_matches.groups()[0]
		else:
			alt = ""

		srcset_matches = re.search('srcset="(.*?)"', html)
		src_matches = re.search('src="(.*?)"', html)
		if srcset_matches:
			srcset = srcset_matches.groups()[0]
			src_descs = srcset.split(", ")
			src = src_descs[0].split(" ")[0]
			for src_desc in src_descs:
				canidate_src = src_desc.split(" ")[0]
				if len(canidate_src)<len(src):
					src = canidate_src
		elif src_matches:
			src = src_matches.groups()[0]
		else:
			continue

		md = "!["+alt+"]("+src+")"

		l = l.replace(html, md)
		lines[i] = l
		print(l)

data = lines
file.close()

file = open(sys.argv[1], "w")
file.writelines(data)
file.close()
```

- after that, replace all URLs leading to old site (full URIs with FQDN) to local ones (e.g. using `gsed -i 's|https://blog.dsinf.net/wp-content/uploads/|/wp-content/uploads/|g' *`)
- locate all files referenced from markdown, script I wrote for that parses one file at a time from markdown to XML and extracts all image sources and link targets:

```python
# https://stackoverflow.com/a/30737066/12297075

import sys
import markdown
from lxml import etree

file = open(sys.argv[1], "r")
lines = file.readlines()

urls = []

for line in lines:
	try:
		doc = etree.fromstring(markdown.markdown(line))
		for a in doc.xpath('//a'):
			# print('LINK:', a.text, a.get('href'))
			urls.append(a.get('href'))
		for img in doc.xpath('//img'):
			# print('IMG: ', img.get('alt'), img.get('src'))
			urls.append(img.get('src'))
	except:
		pass

file.close()

for url in urls:
	try:
		if url.find('/wp-content/uploads/')==0:
			print(url)
	except:
		print(url)
```
- run that against all files: `for file in *.md; do python3 extract_links.py $file; done | sort | uniq | tee urls.txt`
- for all missing files attempt copy from hugo-export:

```bash
# start in dir with posts

cd ../../../
mkdir -p 2012 2013 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022
for y in *; do mkdir -p $y/01 $y/02 $y/03 $y/04 $y/05 $y/06 $y/07 $y/08 $y/09 $y/10 $y/11 $y/12; done
cd -

for file in `cat urls.txt`; do cp -rv "../../../../../exports/attemp_01/hugo-export/$file" ../../../$file ; done | tee log.txt
```

- OLD:

and move them from exported path to `./static/wp-content/uploads/`, for example using **htmltest** on `hugo` generated `public/` dir

https://github.com/stevenvachon/broken-link-checker and something like:

```bash
curl http://127.0.0.1:1313/sitemap.xml | grep '<loc>' | sed 's/.*<loc>//g' | sed 's/<\/loc>//g' | sort | uniq > links.txt
sed -i 's|localhost|127.0.0.1|g' links.txt
for link in `cat links.txt | grep '/20[0-9][0-9]'`; do blc $link  --host-requests 512 --requests 512 --exclude https://skowron.ski/ --exclude https://skowronski.pro/ --exclude  https://linkedin.com/  --exclude https://blog.dsinf.net/ --exclude https://foto.dsinf.net/ --exclude https://keybase.io/dskowronski --exclude https://gohugo.io/ --exclude https://nunocoracao.github.io/blowfish/ --exclude https://github.com/danielskowronski/; done | tee ../../../../../results.txt 
cat ../../../../../results.txt | grep "BROKEN" | awk '{print $2}' | grep "http://127.0.0.1" | sed 's|http://127.0.0.1:1313/wp-content/uploads/||g' > missing.txt
```


