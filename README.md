## Imlib2 Image Processor for Paperclip

Lets you process thumbnails with Paperclip using imlib2, a lighter alternative to ImageMagick.

## Requirements

 - imlib2-ruby library (apt-get install libimlib2-ruby)
 - Rails app with the Paperclip gem installed.

## Installation

Create a folder under RAILS_ROOT/lib called paperclip_processors, and drop resizer.rb in it. Paperclip automatically loads processors available in that path.

Now you can pass :resizer as a Paperclip processor in the has_attached_file options hash. Example:

```
has_attached_file :avatar
  :processors => [:resizer],
  :styles => {
    :thumb=> "100x100",
    :small  => "150x150" }
```

And voilá! Your images will now be processed with Imlib2. Easy peasy, right?

## Notes

Doesn't handle cropping yet, only resizing. Shouldn't be too hard to implement though.

## Credits

Written by Tomás Pollak.

## Legal

(c) 2011 - Fork Ltd. Released under the MIT license.
