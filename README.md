# xTest Castaway bot

Castaway is kinda fun, but kinda grindy. This script skips the boring grindy parts by repeatedly killing low level ennemies to get XP and gold.

Castaway's scriptable part is on the maps that have exclusively passive ennemies. Ennemies actively attacking the character would eventually bring its HP to 0, but passive ennemies give the opportunity to wait and recover HP before triggering the next fight. This takes a while, but does not require attention, and can be left running while doing more interesting things. The script essentially:
* looks for any valuable item and picks it up
* if injured, wait until healed
* look for ennemies, and attack them

Looking for items, ennemies, and injuries are all done based on "patterns", i.e a small group of pixels unmistakenly identifying the object, in a format (PAT) usable by xTest. Two methods were used to create patterns. The first was using patextract directly on screenshots ("patextract patterns" folder), but proved inconvenient and unreliable. The second was taking screenshot, isolating the patterns using The Gimp, then using png2pat to convert them all.

Adding more patterns should not be necessary at this stage. The only steps to use this should be:
* download & extract
* have Castaway running, visible, go to one of the maps with exclusively passive ennemies
* run Castaway.sh
* go to sleep

## Comparison with AutoIt

I had in the past done a similar bot on Windows using AutoIt. I found it convenient, and failed for the longest time to find any equivalent Linux tool. Here are my impressions on comparing the two automation systems:
* xTest screenshot takes longer than convenient - things have moved by the time the patterns are matched.
* AutoIt can search for patterns through the screen directly. It can also search for pixels of a specific color, which is much faster and can sometimes be sufficient.
* AutoIt can detect and even intercept keypresses, which can conveniently be used to trigger or interrupt actions.
* AutoIt can be used to create the patterns directly, rather than taking screenshots and using gimp to isolate the specific areas.

xTest is very convenient, but clearly loses to AutoIt, both in speed and convenience.

However, xTest works well in bash scripts, and can be included into other projects more easily.

