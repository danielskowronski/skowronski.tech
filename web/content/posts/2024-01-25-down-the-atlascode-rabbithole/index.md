---
title: "Down the AtlasCode rabbit hole - debugging Atlassian VS Code extension"
date: 2024-01-25T00:00:00+01:00
tags:
  - vscode
  - jira
  - atlassian
  - npm
  - javascript
  - reverse-engineering
---

Everyone knows Jira, an Atlassian product where you work with tickets (issues). They have a handy extension to VS Code that (among other things, including Bitbucket support) lets you view tickets inside code editor and have a preview of them, when you hover issue ID in code. However, for quite some time that official extension does not work with managed Jira instances in random places, especially with ticket previews. Stubborn as always, I went on a quest to identify what's going on and found a plethora of issues in multiple projects; however, the culprits are typical ones - lazy changelog keeping, improper testing, chained bugs and reliance on Open-Source community.

<!--more-->

## Intro to AtlasCode

### Extension itself

`AtlasCode` is the internal name of the VS Code extension in question. I'll keep using it, as Atlassian refers to it in multiple ways - *Jira and Bitbucket (Atlassian Labs)*, *Atlassian for VS Code* and probably a few others. For reference, it's hosted [here on VS Marketplace](https://marketplace.visualstudio.com/items?itemName=Atlassian.atlascode), has the source code available on [Atlassian official Bitbucket account](https://bitbucket.org/atlassianlabs/atlascode/src/main/) and public bug tracker is [here](https://bitbucket.org/atlassianlabs/atlascode/issues?status=new&status=open). 

The important message from the vendor is the usual form of (alleged, of course) "here's something that should be official, but we don't make money on it and use so many open-source libraries that we can't keep it private, so no support even for paying customers":

> Note: 'Atlassian for VS Code' is published as an Atlassian Labs project. Although you may find unique and highly useful functionality in the Atlassian Labs apps, Atlassian takes no responsibility for your use of these apps.

The code is MIT licensed and should be freely available, but when I was debugging the issue, I had random problems with repo availability. I do have a local snapshot of it in case they try to mess with it. However, they use libraries hosted on their private npm repository in such a way that you'd need to change several URLs and probably still keep local copies of their other public repositories to compile the project.

The entire post is based on my experiences with version `3.0.9` released on 2023-11-30 with the latest VS Code (`1.85.2`) on the latest ARM macOS `14.2.1`. As I'll later discover, the issue is platform-independent, and you can replicate it in VS Code versions from at least the last two years.

### Jira types

Jira comes in two flavours - self-hosted and cloud. Cloud one is fully managed by Atlassian and can be safely treated as "always in the latest version". For self-hosted, it's up to the owners to update it, and I'm not 100% sure if versions are released at the same time. There are also some features which are only available in cloud versions.

That distinction is important for us, mostly when it comes to versions. It's obvious that many people will be complaining at software clients if they use obsolete (by any standard) versions of server and expect everything to work. Of course, it'd be preferable if software was not ghosting users with missing features or nasty crashes, rather showing "you're on unsupported versions". Ideally, deprecation notices ahead of time would be available.

However, version incompatibility is always easy to blame - both for users (especially when ancient IT departments do not update servers) and vendors as a way not to investigate if version is old. It also makes it harder to validate for other users if reported issues are due to versions or are present the same way in software for years. Even more so, if you look at the official product and are naive enough to believe the vendor wouldn't resolve issue for years `;)`

As a spoiler, I was interacting with managed Jira cloud on the latest version, however, initially, I wasn't sure about it.

### Problematic feature

As mentioned in the intro, there's one particular feature which was broken for me - pop-up triggered by mouse hover over issue ID. It's controlled by boolean `atlascode.jira.hover.enabled` in `settings.json` or in the extension settings UI under Jira tab as ***Jira issue hovers: Show details when hovering over issue keys in the editor***. It's enabled by default.

It's especially handy when working with comments, changelogs and in note-keeping (for example, I use it in my daily journal on periods where work involves coordination of project or just jumping between tasks) - that way you don't have to paste entire links that make it harder to edit Markdown - just short ID, which usually looks like `ABC-1234`, while having ability to quickly check what's that ticket about and open full-view inside the same app (i.e. without switching to browser). 

However, for me, it wasn't working - pop-up saying `Loading...` showed and was disappearing after less than a second (or millisecond if the network was fast and instance relatively empty). Other Jira-related features were working correctly, including issue explorer (sidebar list of tickets) and full-tab issue viewer/editor.

## Diagnosing the issue

### Looking online

A reasonable first step is to just check if others have the same issue. 

VS Marketplace shows [3/5 stars for this extension](https://marketplace.visualstudio.com/items?itemName=Atlassian.atlascode&ssr=false#review-details), and it's easy to find [over two years old issue](https://bitbucket.org/atlassianlabs/atlascode/issues/678/issue-hovers-no-longer-display) on public bug tracker for the extension. Not a good start.

There are plenty of other plugins, but at that stage I was afraid that if Atlassian couldn't keep up with some API changes, then the community can have problems as well. So, I decided to dig into the problem for fun.

The original issue suggested downgrading to 2.10.0 from late 2021, but this didn't work for me. Even after full removal and reinstallation, I couldn't log in to Jira. I suspect that some critical API changes occurred in the past 2 years, so what worked for other months ago, didn't for me.

That specific downgrade to 2.10.0 and issue present straight in 2.10.1 will be important later. At that moment, I didn't have access to source code and the changelog for that bump contained only this:

> Fixed bug causing excessive calls to refresh Bitbucket Pipelines status

### Checking VS Code logs

Various internal logs in VS Code can be accessed from the *Output* tab in the same area where the built-in terminal lives. It can be toggled with `>View: Toggle Output`. On the right-hand side, there's a dropdown allowing user to select which log to show, as well as some controls like line scrolling or clearing what's visible. 

Each extension can produce its own logs. For AtlasCode to show anything, you need to set `atlascode.outputLevel` to `debug` because the default `silent` disables all messages. In our case, the log channel is called `Atlassian` and there's nothing interesting reported there, which made initial issue discovery harder for me. For some time, I assumed that maybe the hover process itself didn't work - maybe VS Code didn't interact with macOS correctly, or the extension wasn't recognizing parts of open text files as issue IDs.

Fortunately, there's a second place worth checking in such instances called `Extension Host`. Here I could clearly see that hovering over issue was triggering such stack trace:

```
[error] [atlassian.atlascode] provider FAILED
[error] TypeError: Right-hand side of 'instanceof' is not an object
	at pt (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:1:345814)
	at lt (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:1:345689)
	at Zn (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:1:368478)
	at Zn (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:1:368597)
	at Jn (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:1:368275)
	at Ae (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:1:341659)
	at je.insertToken (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:1:345073)
	at nt (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:1:344677)
	at on (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:1:361046)
	at Le (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:1:343336)
	at Object.parse (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:1:342301)
	at t.createDocument (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:1:1165397)
	at bl.parseFromString (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:1:2020708)
	at new xl (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:1:2020792)
	at Ml.turndown (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:1:2024607)
	at Ul.<anonymous> (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:1:2025825)
	at Generator.next (<anonymous>)
	at a (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:1:2025196)
	at process.processTicksAndRejections (node:internal/process/task_queues:95:5)
```

### Checking extension config options

One of the paths I went included checking all settings in the extension, assuming the Jira instance had some specific quirks. In VS Code it's easy to find all of them, even if they are not included in custom extension UI, as they all have to be declared. Therefore, they are available in settings, some fields mentioning they are only available in plain JSON (very complex objects or lazy developers). In JSON settings that you can open with `>Preferences: Open User Settings (JSON)`, there's syntax highlighting to finding suspicious ones from there is simple - just a matter of adding a property in the same namespace as extension - in our case `atlascode.` and using IntelliSense to select fields to set.

After some time, I found nothing that could impact issue loading. I mostly suspected manually setting default Jira instances by ID and different project key, but it changed nothing.

### Accidental discovery with different Jira

I was in the lucky position to have access to two Jira instances (and another personal one) and I've seen some other issue described that are related to having multiple instances bound to VS Code. Because I was not 100% sure about the nature of my primary Jira (it has a full custom domain), I tried to connect another one that I knew was managed cloud one (subdomain of `jira.com` or `atlassian.net`) and see if that changed anything. And it worked.

I don't have admin access to any of those instances, so following the [docs](https://confluence.atlassian.com/jirakb/how-to-check-your-jira-cloud-version-1272283464.html) I issued a simple API call to check versions. That confirmed both instances are managed and on the latest version. 

From there, I thought maybe I lack access or tokens were issued incorrectly. After multiple tries to delete and re-add integration, I was lost. It couldn't also be a matter of permissions, as other parts of the extension were working, including ticket edit in a separate tab view. Actually, it could be the case, if there were different scopes used for separate functions, but quite unlikely after quick review of the API specification.

### Another accidental discovery with different issue

A year or two ago, Jira had some internal changes, so I thought maybe it's a matter of my main Jira instance using some newer features (maybe in fields) that crash rendering process. 

With a lucky strike, I tried changing issue number but keeping within the same projects. Those numbers are sequential, and I wanted to query for my work tasks, which have 4-digit numbers. I tried lowering that to something like 100 and it worked!

To prove my theory of some change that affected only newly created tickets (from some point onwards) I tried bin-searching for the cut-off number to compare tickets. And I found two in sequence: 423 which worked and 424 that didn't. From that point, I tried comparing them and a few known-to-be-faulty current ones. After attempts to set or unset fields like labels, release versions, work time logged, time estimates, I wasn't any closer to the solution.

It was time to programmatically compare different tickets. Unfortunately, I wasn't able to find a way to make Chromium that runs VS Code to see internal extension traffic, so I went to the Jira web browser side of things wanting to extract JSON downloaded by frontend using XHR. But a simpler approach was available - option to export the ticket as XML. Not a perfect thing, as some issues could be caused by JSON encoding (which is known to be used in the REST API that extensions uses), but a good start. For reference, XML exports in Jira use RSS format and are available under `/si/jira.issueviews:issue-xml/${KEY}/${KEY}.xml`, where the KEY is something like `ABC-1234`.

And that XML gave me the answer - description field! In the cluttered view of old tickets that had several Jira plugins attached I missed the fact that "good" ticket had no description - completely empty, XML representation had `<description/>`, so it would be `null` and not `""` (empty string). A logical way forward was to edit some recent ticket and remove only description field. And it worked!

I checked that with a few other tickets in the main instance and found out that the random ticket from the other instance I randomly chose also had no description. The Pop-up was showing all expected fields and in all cases the description field had `No description` in italics. 

What was strange, was the fact that in full-tab issue viewer descriptions in tickets with non-empty descriptions were rendering correctly. It was just about hover pop-up.

Happy path is represented by pop-up over `TEST-1` below, sad path is, well, lack of said pop-up for `TEST-2`:

![](./demo_bugged_empty_description.png)

## Determining root cause of description problems

Knowing the issue lies only within the description and not server versions, permissions or other fields, I tried to figure out where it breaks.

### Chasing API spec

Still having no access to internal traffic of extension (however I should have probably fired up `mitmproxy` at that stage) and remembering that last year another Atlassian product (Confluence) introduced Markdown support, I tried to see if the format of the description field returned by the API has changed. From what the XML endpoint returned and how data was exchanged by the REST API for the browser, it seemed that the current format is plain HTML. It was the case even for single-line description with no formatting - text still encapsulated in `<p></p>` tags and no way to make it plaintext. The docs didn't explicitly mention format, but examples shown that such HTML is expected. With no access to previous API spec versions, I even tried the Internet Wayback Machine, but there was no change in that format.

Having no access to older Jira instance, I could not verify if there was some server-side format change, even for something subtle like an XML declaration for HTML - the one that for HTML5 is `<!DOCTYPE html>`, but in older versions points to externally hosted XML DTD. For DTD of HTML, I strongly suggest diving into [Mozilla Developer Network page](https://developer.mozilla.org/en-US/docs/Glossary/Doctype) and resources linked there.

### Reverse engineering extension

Important disclaimer: I know very little about NodeJS and the specifics of VS Code extension engine - just plain old school JavaScript plus some stubbornness required in reverse-engineering. Therefore, my methods, especially on stage where I didn't have source code are probably very ineffective.

#### Intro

It was time to check how the VS Code extension actually behaves. Because VS Code is Chromium-based, extensions are JavaScript packages, written in NodeJS. Basic intro is available on [MS page](https://code.visualstudio.com/api/get-started/extension-anatomy). To open dev tools known from browsers, it's enough to issue `>Developer: Toggle Developer Tools`. Extension source code lives on disk, in a path following `~/.vscode/extensions/${developer}.${extension}-${semantic-version}/...`, and in our case the main file is `~/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js`. It's possible and easy to load that extension source code in VS Code itself. 

The last pieces of toolset to debug things are test case and way to apply changes. For the test path, I chose a static Markdown file with several Jira ticket IDs (because fault behaviour is triggered only by hovering over text). To apply potential code changes, you need to reload VS Code, it can be easily triggered by `>Developer: Reload Window`. Quite handy feature of that command is the fact that you're restored to exactly the same place you were, and built-in terminal sessions stay active (not even killing processes), so it's a viable option.

#### Decompilation

Unless otherwise stated, code analysis focuses on version 3.0.9 of the extension. As part of path (`build`) suggest we're dealing with at least minified code. 

As far as my knowledge goes, JavaScript can only be plain-text, compiled to WebAssembly, minified with optional obfuscation or optimized. [WebAssembly](https://webassembly.org) is kind of similar to how Java VM works (only for purposes of understanding artefact available to user) and if used, would require full-blown reverse engineering like with x86 ELF analysis. Optimization with tools like [Closure Compiler](https://developers.google.com/closure/compiler/), but that with that method artefact stays within plain JavaScript. Minification is the same in effect of readability, but the main goal is to compress human-readable code to something that's better to deliver over the internet, especially in the case of larger libraries. The simplest things that can be done to achieve that include indentation and line-break removal, as well as stripping code of any comments or unused, but helpful variables. Usually, partial obfuscation happens as well when long human-friendly variable names are replaced with short identifiers.

As it turned out, code here was just minified into one bundle from several NodeJS packages, into the usual form of a single, extra long line. Any reasonable editor has limits on line-length for purposes of tokenization (stuff like syntax highlighting via AST, so even bracket matching does not work in such a mess). The main reason for that is performance, especially true when the editor is just JavaScript in Chromium. In our case, that single line is 2.3 million characters long, so even non-Chromium based utilities like Sublime Text struggle. As a sidenote, [Zed](https://zed.dev) handles such files pretty well in raw form.

VS Code with any reasonable number of extensions struggles with such a long file, even on a machine like 2022 Mac Studio (M1 Max and barely used 64GB RAM). When it somehow worked, the usual VS Code extensions I use to format/beautify code were failing. I tried using [Prettier](https://prettier.io), which is my main formatter in VS Code, externally and it produced quite good output. Prettier can also be tried [in the browser](https://prettier.io/playground/), and in Chrome, it even accepted and then parsed that 2.2MB of code, but it's not a reasonable way to use it. 

To get started with Prettier in CLI on OS that supports brew, you can use:

```bash
brew install npm

npm install -g npx
npm install --save-dev --save-exact prettier

npx prettier --help
```

After run, the file size increases by 61% and from single-line we have now 84k of them. But it's both human- and tokenization-friendly. VS Code no longer has any issues analysing code. For ease of debugging, I replaced the original, minified `extension.js` with a file after Prettier fixed it, as for VS Code it's the same thing, and I'm avoiding pointless decompilation.

It's also worth noting, that breaking the file into multiple lines and using the same file to run as extension will make the stack trace of JS exceptions much more readable even with minified object/function/variable names, as we no longer have each level marked with `on line 1, char XXXXXX`, but all calls will have line numbers human can parse and easily jump to. Both VS Code and Sublime Text on macOS allow line-jumping by common `⌃+G` (that's one of the combinations which is not re-mapped to `⌘`).

To keep this analysis easy and useful (mainly to match line numbers), I'm self-hosting the main file of problematic extension in both [original (`atlascode_3-0-9_extension.min.js`)](./atlascode_3-0-9_extension.min.js) and [prettied (`atlascode_3-0-9_extension.js`)](./atlascode_3-0-9_extension.js) form.

#### Figuring out what's going on with prettied code

After replacing minified code with prettified version linked above, reloading window and re-triggering fault behaviour, we got following stack trace:

```
[error] [atlassian.atlascode] provider FAILED
[error] TypeError: Right-hand side of 'instanceof' is not an object
	at pt (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:19968:24)
	at lt (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:19958:19)
	at Zn (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:22288:27)
	at Zn (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:22303:11)
	at Jn (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:22272:22)
	at Ae (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:19655:41)
	at je.insertToken (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:19924:15)
	at nt (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:19899:34)
	at on (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:21473:26)
	at Le (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:19782:21)
	at Object.parse (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:19705:28)
	at t.createDocument (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:36694:22)
	at bl.parseFromString (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:67822:25)
	at new xl (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:67829:16)
	at Ml.turndown (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:68063:33)
	at Ul.<anonymous> (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:68145:21)
	at Generator.next (<anonymous>)
	at a (/Users/daniel/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js:68098:21)
	at process.processTicksAndRejections (node:internal/process/task_queues:95:5)
```

As we don't get the source map in the extension bundle, none of the usual tools could make it straightforward. We can deduce a few things from this stack trace:

- obfuscated `Ml` object is used somewhere between getting issue details and rendering it in pop-up
- from the mixture of calls that keep the name `turndown` reasonable and its presence in `package.json` (which holds NodeJS dependency list), we can assume it's actually NodeJS package [turndown](https://github.com/mixmark-io/turndown)
- above is further confirmed by comparing some non obfuscated parts of code (like literal strings)
- `Ml` is an instance of `turndown`

A quick check on what's Turndown doing shows it's a tool to convert HTML into Markdown, which also works server-side without usual browser APIs. 

At this stage, it'd be very easy to skip a few steps of investigation, but I had a long detour caused by not focusing on `package.json` and assuming that Turndown is some internal class for this extension only.

### Detours

#### Detour part 1 - following stack trace

As an exercise in stubbornness and an example of missing other useful files in artefacts, I attempted to analyse the stack trace shown when pop-up should be presented. It's worth noting, that each time various ticket IDs where description is not empty were hovered, the same trace was produced.

1. Deepest call to `process.processTicksAndRejections` is internal VS Code and entry point to our problem
2. `a` from line, 68098 is difficult to match
3. `Generator.next` from `<anonymous>` is actually line 68121
4. `Ul.<anonymous>` from line 68145 is part of `Ul` class that implements functions `provideHover(e, t)` and `getIssueDetails(e)` which clearly hint we're somewhere in provider for hover pop-up functionality
   1. Further analysis shows code that handles non-existing issues (with literal message `issue not found`) and compiles what would be pup-up contents into Markdown. All expected fields are clearly defined here, like `t.summary` (which is issue title), `t.status.name` and `t.descriptionHtml`, which confirms that the API should be returning HTML.
   2. The last one is part of IIF expression, which checks if the field is non-empty to return `r.turndown(t.descriptionHtml)` result, or `*No description*` otherwise, which matches the italics message we identified before.
   3. `r` is an instance of `Ql`, which is an alias for `Ml`, which I'll later identify as Turndown class. For now, it (correctly) looks like just an HTML to Markdown converter.

5. `Ml.turndown` at line 68063 is another layer of calls confirming we're dealing with the Turndown class (with prototype defined at line 68045 and constructor implemented at line 67968)
6. `new xl` at line 67829 checks if input `e` is of type `string` and if so calls some parser with parameter `e` wrapped in XML tag `<x-turndown id="turndown-root">` and indicating it'll be of MIME type `text/html`; otherwise it's assumed that `e` is some sort of object that implements `cloneNode` method
7. `bl.parseFromString` at line 67822 shows that said parser is called by a function named `parseFromString`, which is part of `El` object; therefore `e` is string
   1. if `parseFromString` didn't throw an exception, the object that would be returned would have `.getElementById("turndown-root")` called on it, which seems like a standard DOM-tree operation that would extract rendered `e` 
   2. that indicates `<x-turndown>` is used as some sort of XML tag to wrap what needs to be parsed, likely meaning that `e` is supposed only to be part of HTML DOM-tree (i.e. is not wrapped in `<html><body>...`), meaning API returns correct value
8. `t.createDocument` at line 36694 if part of a function that calls a parser on some input if it's not null, otherwise returns an empty HTML document (`return new i(null).createHTMLDocument("")`)
   1. it's part of a package that contains several Atlassian API-related resources (like certificates and paths)
   2. it also has several calls to `n()` method with just numbers, this is likely result of minification
   3. when diagnosed with simple log dump, it shows that for issue with single-line description `whatever`, the input is `<x-turndown id="turndown-root"><p>whatever</p></x-turndown>`, so API must have returned `<p>whatever</p>` and `<x-turndown>` comes from previous point
9. `Object.parse` at line 19705 is part of parser and by checking series of next function calls it seems like LALR-type parser that's aimed at XML/HTML due to the number of behaviours switching based upon finding `<` or `>`
10. `Le` at line 19782 is part of that parser with recursion
    1.  worth noting are static numbers 13 (ASCII for CR) and 65535 (last value of UTF-8 - 0xFFFF, most likely indicating UTF-16 or other encoding used)
    2.  I wasn't able to identify the meaning of `switch (typeof ue.lookahead)`, but we're at `undefined` branch
11. `on` at line, 21473 is just a switch-case
    1.  following options that are most likely representing ASCII characters, it switches between:
        1.  for 9 (TAB), 10 (LF - Unix line break or 2nd part of Windows line break; see [Wikipedia](https://en.wikipedia.org/wiki/Newline)), 12 (FF - page break, rarely used) and 32 (space) -> `ue = $t`
        2.  for 47 (`/`, in XML is most likely to indicate closing tag or part of self-closing tag) -> `ue = cn`
        3.  for 62 (`>`, in XML signifies end of tag) -> `(ue = Et), nt();`
        4.  for -1 which was set by `Le` in case of 0xFFFF character encountered, so used for some sort of fall-back -> `rt()`
        5.  for all other values `At(0, $t)`
    2.  all the above suggest we're in a function that is scanning all characters after opening XML tag
    3.  line indicated by stack trace shows that we hit `>` case
        1.  knowing that input is always wrapped in `<x-turndown>` tag, it's likely to be the end of that opening tag
        2.  to investigate further, we can add `console.log` calls on beginning of `on(e)` function to observe live execution
        3.  it turns out it's the only occurrence of `on` being called, so it fails when trying to parse first (and static) tag
12. `nt` at line 19899 is unknown to me
13. `je.insertToken` at line 19924 does some checks regarding XML tag type, probably connected only to SVG and mglyph
14. `Ae` at line 19655 checks tag type, one of those checks looks for XHTML DTD at fixed URL
15. `Jn` at line 22272 is another switch-case over parameter `e`:
    1.  for 1, it does `if (0 === (t = t.replace(Z, "")).length) return;`
    2.  for 5 it returns immediately
    3.  for 4 it returns `void Fe._appendChild(Fe.createComment(t))`
    4.  for 2 it checks if tag is `html` and if so seems to start DOM-tree
    5.  for 3 it checks if we're in tags like `html`, `head`, `body` or `br` and in such case does nothing extra and if not - returns
    6.  as a final part for code that didn't return, some operations on what appears to be DOM-tree are performed and `Ae` is set to alias `Zn`
16. `Zn` at line 22303 is very similar to the previous step:
    1.  for 1, 5, 4 and 3 behaviour is the same
    2.  for 2, it returns `void ei(e, t, n, i)` when tag is `html` and some other behaviour for `head`
    3.  finally, `Zn(2, "head", null), Ae(e, t, n, i);` is called, likely inserting `head` to DOM-tree if it wasn't part of plain XML document; this is called in our trace
17. `Zn` at line 22288 is a recursion call from previous step
18. `lt` at line 19958 calls `pt` on anonymous function that is just a call of `ct` with some other parameters added
19. `pt` at line 19968 is the final crash place
    1.  there's nested IIF and part of it that fails checks if `Ie.top` is an instance of `c.HTMLTemplateElement`
    2.  runtime checks show that `c.HTMLTemplateElement` does not exist and `Ie.top` is null, latter is not a problem that throws exception
20. `ct` is not part of trace, but it's defined on line 19949
    1.  it creates some DOM element and if something is true, loops over it setting attributes (via `_setAttribute`)
    2.  it looks like some sort of element duplication that includes all its attributes

#### Detour part 2 - chasing `HTMLTemplateElement`

`HTMLTemplateElement` is a common [standard element of Web API](https://developer.mozilla.org/en-US/docs/Web/API/HTMLTemplateElement) in core JavaScript that's part of DOM-parsing. It's supported by all browsers for a long time, so it can't be a problem with Chromium running VS Code not exposing it. 

It's also not re-defined anywhere in the code, so it indicates that `c`, where `HTMLTemplateElement` is expected to be one of the fields, has it missing. That `c` is not a local variable, declared and set in line 16919 as `o.elements` with `o` set just one line before as a result of `n(95)`. That `n` is input to the anonymous function we're in (declared on line 16911). Said function is full of HTML tags and attributes, as well as regexes for HTML DTDs.

Moreover, there are quite a few other calls to `n`, like `n(5).NAMESPACE`. Initially, I suspected those are Jira ticket fields, as I know that custom fields in Jira are identified with numbers, and it seemed logical to have base fields including description to internally have similar numbers. I couldn't find any docs on that, and now I think those are just indices of a function array, a result of minification of some minification process.

As part of random experiments, I guarded check in line 19968, by prefixing it with `c.HTMLTemplateElement && ` to prevent calling `instanceof` if "Right-hand side of 'instanceof' is not an object". This, however, caused a similar problem with the undefined property of `c` as part of `instanceof` call. Several attempts later, it seemed like all similar properties are missing.

It seemed like someone forgot to implement a bunch of things, but to do so to such extent seemed like madness, crossing regular boundaries of shipping crappy code.

#### Random theories tested

Not understanding the nature of the Turndown class, I attempted to replace wrapping the description object inside `<x-turndown>` with a full HTML tree, but it also failed to work the same way. 

Another theory was related to text encoding. The initial ticket I worked on had a description with non-ASCII quotation marks, so I thought that maybe something broken in the parser there. However, removing that from the description on the server didn't change behaviour. After dumping the input string to raw bytes and checking them locally, there were no weird characters or rogue line breaks, so I abandoned this theory.

### Back on track

#### Input source code diff

At this stage, I took a break. When I got back, I was able to load source code on Atlassian Bitbucket and [run diff](https://bitbucket.org/atlassianlabs/atlascode/branches/compare/2.10.1%0D2.10.0#diff) between `2.10.0` (reported as last working one) and `2.10.1`.

As I later discovered, I could do the same diff over packaged VS Code extension artefacts as `package.json` is published as well.

As usual, the public changelog was not showing the whole truth. Indeed, some Bitbucket pipeline loading bugs were tackled, but at the same time, a number of NodeJS libraries were upgraded. One of them was `turndown`. At that moment, I realized it's a completely independent library from community (hosted [on Github](https://github.com/mixmark-io/turndown)). 

To make matters worse, for build/production it was changed from `^5.0.3` to `^7.1.1` and for dev testing from `^5.0.0` to `^5.0.1`. That means that when running in dev environment (in case of extensions - testing with code not getting minified) a change was made in such a way that kept the major version the same, so no breaking changes were expected and developers weren't affected during development. However, users of compiled version were upgraded by two major versions, which is not unexpected to break things.

For the latest release of AtlasCode, Turndown for dev is the same and for production is `7.1.2`, so there should be no drastic change.

#### Validating faulty converter theory

To make sure I'm really tackling the faulty code, I figured out if I went back to `getIssueDetails(e)`, I could check what would happen if I returned input `t.descriptionHtml` instead of `r.turndown(t.descriptionHtml)`.

It worked, but the description was empty. That's a result of VS Code parsing one of the Markdown flavours that mixes up some HTML tags into proper Markdown. A result for `<p>` was hidden text. After finding out that `t` also has field `description` that's a plaintext version of `descriptionHtml`, I set the function to return just `t.description` and it worked - no formatting in the pop-up, but the text worked.

After some more digging, I found that by default, Jira API returns only plaintext fields (one of them is description). If you add `renderedFields` to query parameters, all rich-text fields will be additionally returned rendered as HTML. That didn't change and is likely to stay that way, regardless of the format Jira internally uses to keep data (I believe it's Markdown now).

#### Going outside AtlasCode

With that discovery, I matched most of the stack trace to be part of Turndown. It also meant that to understand the technical reason for the issue, I had to leave AtlasCode and investigate Turndown. But the "business"/"political" reason was clear - not testing released code and hiding major changes from public changelog...

### Diagnosing external libraries

#### Poking around Turndown in runtime

A simplest solution to compare behaviour of suspected HTML to Markdown converter would be to take input HTML from live execution, feed it to Turndown object constructed with same parameters as AtlasCode and compare outputs between script using older and newer version. After reading input AtlasCode source code, I found out that it uses default parameters for that part of extension.

Because Turndown can be used without NodeJS and all versions are available on CDN, I prepared simple test HTML to be loaded in a web browser, where I could easily swap versions and observe dev console.

```html
<!--<script src="https://unpkg.com/turndown@5.0.3/dist/turndown.js"></script>-->
<script src="https://unpkg.com/turndown@7.1.1/dist/turndown.js"></script>
<script>
var input='<x-turndown id="turndown-root"><p>whatever</p></x-turndown>';
var turndownService = new TurndownService()
var markdown = turndownService.turndown(input)
console.log(input);
console.log(markdown);
console.log(turndownService); //for in-browser options checking
</script>
```
It turned out that for every version release, behaviour was the same - output markdown was `whatever`.

#### Poking around Turndown source code

Since runtime was not producing any problems, I assumed that maybe the environment inside VS Code was causing some changes, and it'd be best to start checking diffs and changelog of Turndown. 

There I found that between versions 5 and 6, dependency of Turndown used for DOM-tree operations that are independent of the browser (i.e. for server-side code) was swapped from JSDOM to Domino, probably due to some vulnerability. That quickly led me to [this Github issue from June 2023](https://github.com/mixmark-io/turndown/issues/439) for exactly the same issue - missing properties, but only in bundled Turndown.

That last part explains why my plain Turndown calls in browser worked, but minified and bundled Turndown inside AtlasCode was failing.

#### Deepest root-cause identified

The [issue in Domino](https://github.com/fgnass/domino/issues/146) linked there is quite troubling, as it was reported in October 2019 (yes, over 4 years ago). It boils down to some incompatibility with minification (here called transpilation). Fix was proposed the same year as fork, published as a library you can replace Domino with. 

What's most troubling is that this critical issue, that's manifesting in one of the most used ways of including library, was not touched on a project that stayed active for several months after it was reported. Project ceased updates in July 2020.

Later, in March 2020, it was included in Turndown. So the issue was known, but the project seemed to be alive. However, because the Turndown developer didn't use the bundled version, it wasn't discovered until much later. 

## Attempting to fix

### Simplest fix for users

As mentioned before, the easiest fix that completely disables parsing would be to replace `r.turndown(t.descriptionHtml)` with plain `(t.description)`. It can be done with the following script and goes into effect after VS Code reload.

```bash
# use `sed` if GNU sed is default, like on GNU/Linux

gsed -i \
  's/r.turndown(t.descriptionHtml)/(t.description)/g' \
  ~/.vscode/extensions/atlassian.atlascode-3.0.9/build/extension/extension.js
```

### Fixing AtlasCode

The source code of AtlasCode points to several NodeJS packages that seem to be open-source and have their source code on the same Bitbucket. Unfortunately, they are referenced on the dependency list as packages that they deployed to an internal npm repository that's not accepting anonymous pulls. Therefore, I can't easily compile extension myself to prove if proposed solutions could work.

#### Worst option - downgrade

In normal circumstances, the best fix to save vendor image would be to release the simplest fix ASAP. That would be to downgrade Turnkey dependency to 5.x.x and rebuild. 

However, Turnkey specifically made breaking changes to mitigate vulnerabilities in JSDOM, most likely [CVE-2021-20066](https://github.com/jsdom/jsdom/issues/3124) or similar, which allows renderer to load local resources. This could be potentially used by anyone with write access to given Jira instance to execute some code (e.g. by local HTTP call) in VS Code of all engineers that are reading from given Jira (most likely all employees of a company).

#### Trivial option - disable rich-text rendering

They could also apply my proposed fix that can be done from user side. However, this approach would yield terrible (for UX) results if the description is long or includes anything more complex than paragraphs and lists.

#### Best option - mitigate faulty Domino

It seems like there are two options to mitigate fault further down the chain. One would involve using the browser build mentioned [here](https://github.com/mixmark-io/turndown/issues/439#issuecomment-1611317512) and the other - replacing the dependency with explicit use of [this fork of Domino](https://github.com/fgnass/domino/issues/146#issuecomment-554955159).

More context on mitigation can be found in [other Turndown discussion](https://github.com/mixmark-io/turndown/issues/265), that was initially unrelated to the bug, but rather performance issues.

The second fix, related to using for of Domino, could also be applied in Turndown. However, it requires resources, which the open-source community does not have at the moment.
## Summary

### Highlights from RCA

#### Technical path

The most obvious to see path of issues is, as always, technical. On the other hand, it doesn't show the whole picture.

AtlasCode developers introduced hidden breaking changes without tracking, and they also don't have any reasonable test suite (come on, only bad tickets have empty descriptions). Additionally, they ignored a bug report that's 2 years old.

The Turndown developer mitigated the vulnerability by swapping a library that was abandoned shortly after and didn't address issue that is open for several months. Domino developer ignored issue opened for numerous months and then the project died. Both Turnkey and AtlasCode used abandoned libraries and didn't maintain a software bill of materials.

#### Human path

Those technical issues are caused by multiple human and "business"/"political" factors.

- AtlasCode developers neglected tests and user reports, probably blaming everything on self-hosted Jira users, not testing compiled product on normal tickets themselves. There's no other way, as the project was actively developed for the last 2 years, and it's nearly free to patch the problem.
- AtlasCode developers behaved like most commercial users of open-source, that is, consumed Turndown and didn't contribute back. That would pay them back as the library they rely upon would work, and they'd gain respect. The same is the case for Domino, they consumed further down the chain.
- Both Turndown and Domino developers are just humans that made projects, probably for themselves, and let the community use it for free. Since they didn't use those in bundled form, they had no way of finding out. Because they do it for free, they cannot be blamed at all!
- There were no PRs made by community to fix Turndown. Domino [has one still open since 2019](https://github.com/fgnass/domino/pull/151), but one of the collaborators commented on it in a way that could be discouraging to the PR reporter. It looks to be a case, as the PR was marked as draft and abandoned from there. Later, the entire project was abandoned.

### Wrapping up and lessons learnt

This issue was following classical pattern of open-source reliance, poor testing and ignoring users inside AtlasCode project. In the world where we've seen corporations demanding answers about log4j vulnerability report from cURL maintainer that had nothing to do with them (and didn't use Java), plain open-source community reliance (maybe even abuse) path could be even boring. However, coupled with specific operating parameters that are not normal bugs, this case shows even deeper implications of just importing publicly available code.

As for technical benefits for me and others with a similar starting point after reading this post, there are quite a few. I could definitely include more in-depth understanding of VS Code extension engine, NodeJS and related minification/transpilation, as well as the importance of looking into all files in artefact, not just a code. However, I don't feel like time spent on digging through raw JS and the stack trace was lost.

That post also reminded me about the benefits of making write-ups for similar private investigations (post-mortems and demos in work are obvious). I learned quite a few things, gathering results of my hyperfocused session on reverse engineering and tracing issues in order not to post completely incorrect information. Retrospective look at such session also makes it easier to identify how to spot some things earlier.

What was left from things available to me was to comment on the AtlasCode issue in hope that some users will get availability to patch their extension and maybe the vendor would fix the code. It's [here](https://bitbucket.org/atlassianlabs/atlascode/issues/678/issue-hovers-no-longer-display#comment-66382314).

---

## Last-minute update

When proofreading this post, I found some hope and activity on the Atlassian side.

It seems that after two years, the vendor noticed exactly the same issue in other place and started the mitigation process as seen in [this PR](https://bitbucket.org/atlassianlabs/atlascode/pull-requests/1080). One thing I can't complain about is the fact they host the code and review process in public so we can see progress.

So it turns out that the middle-ground solution is to wrap Turndown input into JSDOM, so it parses DOM-tree and not raw string from API. An example of such a change is on this branch [fix/VSCODE-1450-Comments-in-PR-diff-view-no-longer-show-up](https://bitbucket.org/atlassianlabs/atlascode/branch/fix/VSCODE-1450-Comments-in-PR-diff-view-no-longer-show-up#Lsrc/views/pullrequest/prCommentController.tsT953). It involves no changes to libraries, so it's probably easiest. Shame they didn't notice other places.
