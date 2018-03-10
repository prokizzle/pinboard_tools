# Pinboard Tools

## Synopsis

Pinboard Tools is a helpful organizer for your existing [Pinboard](http://www.pinboard.in) bookmarks. When run against user-specified tags, it will find the appropriate title, synopsis and keyword tags for each matching article URL and save them to Pinboard as unread items. Pinboard Tools uses the [Embedly API][7071-001], in order to optimize speed, quality, and consistency. 

## Code Example

    |2.0.0-p0| giggy in ~/dev/pinboard_tools    
    $  pinboard_tools tag fever
    => [##########################################################] [1/1] [100.00%] [00:03] [00:00] [0.32/s]


## Motivation

I have been saving articles to Pinboard for about a year, but attempted to use various auto-tagging systems, such as [delicio.us](http://delicio.us) tagging suggestions and [IFTTT](http://IFTTT.com) RSS tags. The result of those two workflows resulted in a mess of useless tags, and an almost useless tag cloud. 

I needed a way to make sense of my existing bookmarks, to make them browsable by tag and searchable, with correct article titles (not just the ones added by saving from an article link), and usable descriptions. The [Embedly Extract API][7071-002] does a beautiful job of handling these tasks, using a hierarchy of acceptable meta data sources within articles. [Embedly][7071-001] can determine which element on a page is best suited for the data you want to retrieve. 

After a bit of tinkering, I came up with this simple script. It gets all of your pinboard articles, filters them by tag, and passes each one through Embedly, replacing existing meta-data.

## Installation

You will need:

* A [Pinboard][7071-003] account
* An [Embedly API ][7071-001] key (free for 5000 requests per month)

Install the gem

    gem install pinboard_tools

To configure, run the `init` command to store your Pinboard login and Embedly API token
  
      pinboard_tools init

You will be prompted for you [pinboard][7071-003] username and password, as well as your [Embedly][7071-001] API key. 
 
*  I have only tested against Ruby 2.1.1
  
    
  

## Usage

    pinboard_tools <command> <argument>
   
 Pinboard Tools accepts two arguments. 
 
     pinboard_tools safari [-v]
Runs the Safari Reading List import to Pinboard task. This will parse your Reading List plist file, extract resolvable URLs, use Embedly to determine the correct metadata, and add each item to Pinboard. Once complete, it will clear out the Reading List to prevent duplicate tasks and minimize future Embedly API usage. 

    pinboardtools tag [optional tag name] [-v]
 Runs the pinboard re-tagger task. When run without a tag name, it will process every article you saved to Pinboard. If you specify a tag (case sensitive), it will process every article that has that tag, and replace the metadata of the item with Embedly data. 

 Adding the `-v` option to either command will display a progress bar for the parsing queue.

## Tests

Tests are written in cucumber, and ensure your connection to pinboard and Embedly.

## Contributors

All suggestions and pull requests are welcome. Add all issues and bugs to the Issues page.

## License

Licensed under the [MIT license][7071-005]. 
[7071-001]: http://embed.ly/ "Embedly: Front-end developer tools for websites and apps"
[7071-002]: http://embed.ly/docs/extract/api "Extract - API | Embedly"
[7071-003]: http://pinboard.in/ "Pinboard: social bookmarking for introverts"
[7071-004]: https://github.com/bundler/bundler/ "bundler/bundler · GitHub"
[7071-005]: http://opensource.org/licenses/MIT "The MIT License (MIT) | Open Source Initiative"
