# xTest Castaway bot

Castaway is kinda fun, but kinda grindy. This script skips the boring grindy parts by repeatedly killing low level ennemies to get XP and gold.

Castaway's scriptable part is on the maps that have exclusively passive ennemies. Ennemies actively attacking the character would eventually bring its HP to 0, but passive ennemies give the opportunity to wait and recover HP before triggering the next fight. This takes a while, but does not require attention, and can be left running while doing more interesting things. The script essentially:
* looks for any valuable item and picks it up
* if injured, wait until healed
* look for ennemies, and attack them

Looking for items, ennemies, and injuries are all done based on patterns. Two methods were used to create patterns. The first was using patextract directly on screenshots ("patextract pattners" folder), but proved inconvenient and unreliable. The second was taking screenshot, isolating the patterns using The Gimp, then using png2pat to convert them all.

Adding more patterns should not be necessary at this stage. The only steps to use this should be:
* download & extract
* have Castaway running, visible, go to one of the maps with exclusively passive ennemies
* run Castaway.sh
* go to sleep

## Comparison with AutoIt

* xTest screenshot takes longer than convenient
* AutoIt can search for patterns through the screen directly. It can also search for pixels of a specific color, which can be convenient.
* AutoIt can detect and even intercept keypresses, which can conveniently be used to trigger or interrupt actions.
* AutoIt can be used to create the patterns directly, rather than taking screenshots and using gimp to isolate the specific areas.

xTest is very convenient, but clearly loses to AutoIt, both in speed and convenience.

However, xTest works well in bash scripts, and can be included into other projects more easily.

