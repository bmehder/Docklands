---
title: Make Impossible States Impossible with PHP Enums
description: Use a stoplight to see how PHP enums can replace fragile combinations of booleans.
published: 2026-10-05
tags: PHP, Enums, Data modeling
featured_image: /assets/images/note-impossible-states.webp
featured_alt: A traffic signal with one green light illuminated as many invalid paths converge into one valid path
---

# Make Impossible States Impossible with PHP Enums

{{ featured-image }}

Suppose we are writing software for a stoplight. We might represent it with three true-or-false values:

```php
$light = [
    'red' => true,
    'yellow' => false,
    'green' => false,
];
```

This looks reasonable, but three booleans produce eight possible combinations:

```text
red    yellow    green
off    off       off
on     off       off     ✓
off    on        off     ✓
off    off       on      ✓
on     on        off
on     off       on
off    on        on
on     on        on
```

Only three are valid. The other five describe no light or several lights at once. Our model contains more incorrect states than correct ones.

We could write a function that counts how many values are `true` and rejects the array unless the answer is exactly one. That would detect bad data, but it would not prevent us from *creating* bad data. Garbage in, garbage out. We would also have to *remember* to call the validator whenever the array changes.

PHP 8.1 introduced **enums**. An enum is a type with a fixed set of named choices. Our stoplight has exactly three:

```php
enum Stoplight
{
    case Red;
    case Yellow;
    case Green;
}
```

A variable typed as `Stoplight` can contain one of those cases and nothing else:

```php
function display(Stoplight $light): void
{
    // $light is Red, Yellow, or Green.
}

display(Stoplight::Red);
```

> Here, `Stoplight $light` means that PHP will accept only a `Stoplight` value for the `$light` parameter.

There is no combination representing two lights at once. There is no stoplight with every light off. Instead of detecting those invalid states, we removed the ability to represent them.

The enum can also describe how the light changes:

```php
enum Stoplight
{
    case Red;
    case Yellow;
    case Green;

    public function next(): self
    {
        return match ($this) {
            self::Red => self::Green,
            self::Green => self::Yellow,
            self::Yellow => self::Red,
        };
    }
}

$light = Stoplight::Red;
$light = $light->next(); // Green
```

The `match` lists the behavior for every valid state. We intentionally leave out a `default`. If another enum case is added later but `next()` is not updated, PHP throws an `UnhandledMatchError` when that new case reaches this code instead of silently choosing potentially incorrect behavior.

PHP does not check this exhaustiveness when it compiles the file, so tests should exercise every case. What PHP *does guarantee* is that a `Stoplight` value itself is always one of the declared cases.

That is the idea behind **making impossible states impossible**: shape the data so invalid combinations cannot be created in the first place.

Native enums require PHP 8.1 or newer. In PHP 7, class constants and private constructors can imitate parts of this design, but they require more code and provide weaker guarantees. An enum is a built-in PHP feature for saying, “this value must be exactly one of these choices.”
