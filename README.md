# SYNOPSIS

    use Template::Mustache;

    print Template::Mustache->render(
        "Hello {{planet}}", {planet => "World!"}), "\n";

# DESCRIPTION

Template::Mustache is an implementation of the fabulous Mustache templating
language for Perl 5.8 and later.

See [http://mustache.github.com](http://mustache.github.com).

## Functions

- build\_pattern($otag, $ctag)

    Constructs a new regular expression, to be used in the parsing of Mustache
    templates.

    - $otag

        The tag opening delimiter.

    - $ctag

        The tag closing delimiter.

    Returns a regular expression that will match tags with the specified
    delimiters.

- read\_file($filename)

    Reads a file into a string, returning the empty string if the file does not
    exist.

    - $filename

        The name of the file to read.

    Returns the contents of the given filename, or the empty string.

- parse($tmpl, \[$delims, \[$section, $start\]\])

    Can be called in one of three forms:

    - parse($tmpl)

        Creates an AST from the given template.

        - $tmpl

            The template to parse.

        An array reference to the AST represented by the given template.

    - parse($tmpl, $delims)

        Creates an AST from the given template, with non-standard delimiters.

        - $tmpl

            The template to parse.

        - $delims

            An array reference to the delimiter pair with which to begin parsing.

        Returns an array reference to the AST represented by the given template.

    - parse($tmpl, $delims, $section, $start)

        Parses out a section tag from the given template.

        - $tmpl

            The template to parse.

        - $delims

            An array reference to the delimiter pair with which to begin parsing.

        - $section

            The name of the section we're parsing.

        - $start

            The index of the first character of the section.

        Returns an array reference to the raw text of the section (first element),
        and the index of the character immediately following the close section tag
        (last element).

- generate($parse\_tree, $partials, @context)

    Produces an expanded version of the template represented by the given parse
    tree.

    - $parse\_tree

        The AST of a Mustache template.

    - $partials

        A subroutine that looks up partials by name.

    - @context

        The context stack to perform key lookups against.

    Returns the fully rendered template as a string.

- lookup($field, @context)

    Performs a lookup of a `$field` in a context stack.

    - $field

        The field to look up.

    - @context

        The context stack.

    Returns the context element and value for the given `$field`.

## Methods

- new(%args)

    Standard hash constructor.

    - %args

        Initialization data.

    Returns A new `Template::Mustache` instance.

- template\_path

    Filesystem path for template and partial lookups.

    Returns a string containing the template path (defaults to '.').

- template\_extension

    File extension for templates and partials.

    Returns the file extension as a string (defaults to 'mustache').

- template\_namespace

    Package namespace to ignore during template lookups.

    As an example, if you subclass `Template::Mustache` as the class
    `My::Heavily::Namepaced::Views::SomeView`, calls to `render` will
    automatically try to load the template
    `./My/Heavily/Namespaced/Views/SomeView.mustache` under the
    `template_path`.  Since views will very frequently all live in a common
    namespace, you can override this method in your subclass, and save yourself
    some headaches.

        Setting template_namespace to:      yields template name:
          My::Heavily::Namespaced::Views => SomeView.mustache
          My::Heavily::Namespaced        => Views/SomeView.mustache
          Heavily::Namespaced            => My/Heavily/Namespaced/Views/SomeView.mustache

    As noted by the last example, namespaces will only be removed from the
    beginning of the package name.

    Returns the empty string.

- template\_file

    The template filename to read.  The filename follows standard Perl module
    lookup practices (e.g. `My::Module` becomes `My/Module.pm`) with the
    following differences:

    - Templates have the extension given by `template_extension` ('mustache' by
    default).
    - Templates will have `template_namespace` removed, if it appears at the
    beginning of the package name.
    - Template filename resolution will short circuit if
    `$Template::Mustache::template_file` is set.
    - Template filename resolution may be overriden in subclasses.
    - Template files will be resolved against `template_path`, not `$PERL5LIB`.

    Returns The path to the template file, relative to `template_path` as a
    string.  See [template](https://metacpan.org/pod/template).

- template

    Reads the template off disk.

    Returns the contents of the `template_file` under `template_path`.

- partial($name)

    Reads a named partial off disk.

    - $name

        The name of the partial to lookup.

    Returns the contents of the partial (in `template_path` of type
    `template_extension`), or the empty string, if the partial does not exist.

- render

    Render a class or instances data, in each case returning the fully rendered
    template as a string; can be called in one of the following forms:

    - render()

        Renders a class or instance's template with data from the receiver.  The
        template will be retrieved by calling the `template` method.  Partials will
        be fetched by `partial`.

    - render($tmpl)

        Renders the given template with data from the receiver.  Partials will be
        fetched by `partial`.

        - $tmpl

            The template to render.

    - render($data)

        Renders a class or instance's template with data from the receiver.  The
        template will be retrieved by calling the `template` method.  Partials
        will be fetched by `partial`.

        - $data

            Data (as hash or object) to be interpolated into the template.

    - render($tmpl, $data)

        Renders the given template with the given data.  Partials will be fetched
        by `partial`.

        - $tmpl

            The template to render.

        - $data

            Data (as a hash, class, or object) to be interpolated into the template.

    - render($tmpl, $data, $partials)

        Renders the given template with the given data.  Partials will be looked up
        by calling the given code reference with the partial's name.

        - $tmpl

            The template to render.

        - $data

            Data (as a hash, class, or object) to be interpolated into the template.

        - $partials

            A function used to lookup partials.

    - render($tmpl, $data, $partials)

        Renders the given template with the given data.  Partials will be looked up
        by calling the partial's name as a method on the given class or object.

        - $tmpl

            The template to render.

        - $data

            Data (as a hash, class, or object) to be interpolated into the template.

        - $partials

            A thing (class or object) that responds to partial names.

    - render($tmpl, $data, $partials)

        Renders the given template with the given data.  Partials will be looked up
        in the given hash.

        - $tmpl

            The template to render.

        - $data

            Data (as a hash, class, or object) to be interpolated into the template.

        - $partials

            A hash containing partials.
