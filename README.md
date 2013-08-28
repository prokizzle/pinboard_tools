# _Pinboard Tools_

_Description: A set of tools for manipulating Pinboard.in articles

## Project Setup

1. Register for Pinboard.in
2. Register for a free Embed.ly API key
3. Run the following commands

`bundle install`
`rake pinboard:login`

## Testing

No tests yet.

### Unit Tests

TBA

### Integration Tests

TBA


## Usage

### Replace keywords based on existing tag
`ruby bin/pinboardtools -t [tag name]`

### Import Safari Reading List
_replaces title, description, and keywords with Embedly data_
`ruby bin/pinboardtools -s`

## License
TBD