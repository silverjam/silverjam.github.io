# Apps Script Google Docs Header Numbers

| Metadata   | Value           |
| ---------- | --------------- |
| Date | 2013-05-26 |
| Categories | google, apps, script, archive |

---

Google [*Apps Script*][apps-script] presents an interesting solution to extend
the features of Google applications.  The usual way to do this is with client
side browser extensions, but they are not portable (that is, specific to a
browser, and specific to the web)-- and cannot run unattended.

[apps-script]: https://developers.google.com/apps-script/

Google's apps (and similarly, 99% of other web apps) have long lacked
scriptability that native applications enjoy. *Apps script* is a play to
resolve that deficiency.

## TL;DR

Jump to [the solution][solution] for the script that adds header numbers.
[solution]: #The_Solution

## The problem

Google docs has undergone some interesting simplifications in recent times, and
it'd be interesting to learn why certain features got chopped.

In particular, at one point it was possible to insert numeric headers into a
Google doc, though it looks like this was a [CSS hack][css-hack].  Since Google
docs isn't exposing the underlying CSS of the document anymore, this method no
longer works.  You can also turn your headers
[into numbered lists][numbered-headers]
...  but this is **really** cumbersome.

[css-hack]: http://www.youtube.com/watch?v=xaypUbQd6wI
[numbered-headers]: http://webapps.stackexchange.com/questions/23861/header-numbering-in-google-docs

Why do you need numeric headers?  Well, it's a pretty standard word processor
feature-- if you're packaging information into a fairly static format (say a
PDF), it's useful for communication purposes to reference a specific part of
the document; for example, if you were writing a technical review of someone's
software.

## Background

Google offers several different types of scripts:

{% img /images/gapps-script-types.png %}

The biggest distinction appears to be if a script is bound to a
[container][script-containers] or [not][standalone-script] -- that is, whether
the script lives inside a doc, form, spreadsheet, or if it sits outside one of
these (sitting in the script editor).  Scripts can also become a standalone
WebApp.

[script-containers]: https://developers.google.com/apps-script/scripts_containers
[standalone-script]: https://developers.google.com/apps-script/execution_script_editor

As first, standalone scripts seemed useful for testing things out, but the
inability to interact with the user quickly made a standalone scripts
useless...  I found myself thinking that as I developed useful things with
standalone scripts (macros!) that it'd be nice to share these, and simply
insert some silly UI prompts to make the script generic-- it's unclear how to
do this without making the script specific to a container, then sharing it in
the [document specific script gallery][script-gallery] -- right now, there's no
script gallery for text documents.

[script-gallery]: https://developers.google.com/apps-script/publishing_gallery#installing_a_script_from_the_gallery

### Power users, macro sharing, and the apps script gallery

The apps script gallery seems sadly lacking... why is the script gallery buried
inside the document?  This hardly seems like the "happening" place to showcase
cool macros:

{% img /images/gapps-script-gallery.png %}

I did manage to find apps script "gallery" at one point, but it was full of
commercial apps geared at implementing solution on top of Google Apps for
businesses.  This is great, but if Google wants to crowd source all the crazy
features that users want by providing power-users with scripting capabilities,
there should probably be something more like the chrome extensions gallery to
showcase macros.  That is, something easily accessible from a Google search.

## The solution <a name="The_Solution"></a>

The solution is to simply use the Google apps script API to create your own
header numbers.  It's somewhat cumbersome, and will probably break in many
cases, but it works.  

There's probably a better way to do this... for example, one improvement would
be to figure out how to share this to a common repository so it could be
imported into other documents.

Start by creating a new apps script in the document:

{% img /images/launch-script-editor.png %}

Then insert the following script (also maintained [in a gist][gist]):

[gist]: https://gist.github.com/silverjam/5613969

``` javascript

var state = {
  headerLevel1: 0,
  headerLevel2: 0,
  headerLevel3: 0,
}

var private = {
  getSectionNumber: function (paragraph)
  {
    if ( paragraph.getHeading() == DocumentApp.ParagraphHeading.HEADING1 )
    {
      state.headerLevel2 = 0;
      state.headerLevel3 = 0;
      
      return (++state.headerLevel1) + " ";
    }
    else if ( paragraph.getHeading() == DocumentApp.ParagraphHeading.HEADING2 )
    {
      if (state.headerLevel1 == 0)
        state.headerLevel1 = 1;
      
      state.headerLevel3 = 0;
      
      return state.headerLevel1 + "." + (++state.headerLevel2) + " ";
    }
    else if ( paragraph.getHeading() == DocumentApp.ParagraphHeading.HEADING3 )
    {
      if (state.headerLevel2 == 0)
        state.headerLevel2 = 1;
      
      return state.headerLevel1 + "." + state.headerLevel2 + "." + (++state.headerLevel3) + " ";
    }
    
    return "";
  },
  
  isNumber: function (text)
  {
    return !isNaN(text);
  },

  removeExistingHeaderNumber: function (text)
  { 
    for (var i = 0; i < text.length; i++)
    {
      if ( private.isNumber(text.charAt(i)) || text.charAt(i) == "." )
          continue;
      
      break;
    }
    
    return text.substr(i);
  }
};

function addHeaderNumbers() 
{
  var doc = DocumentApp.getActiveDocument();
  var body = doc.getBody()

  for (var i = 0; i < body.getNumChildren(); i++)
  {
    var element = body.getChild(i);
    
    if ( element.getType() != DocumentApp.ElementType.PARAGRAPH )
      continue;
    
    var paragraph = element.asParagraph();
    
    if ( paragraph.getHeading() != DocumentApp.ParagraphHeading.NORMAL )
    {
      var sectionNumber = private.getSectionNumber(paragraph);
      paragraph.setText(sectionNumber + private.removeExistingHeaderNumber(paragraph.getText()))
    }
  }
  
  doc.saveAndClose();
}
```

Save the project and return to the document.  Then use the script manager to
open the list of available functions to run:

{% img /images/gapps-script-manager.png %}

Then select the 'addHeaderNumbers' script:

{% img /images/gapps-script-run-script.png %}

And magically your document will now have header numbering:

{% img /images/gapps-example-header-numbers.png %}

EOT
