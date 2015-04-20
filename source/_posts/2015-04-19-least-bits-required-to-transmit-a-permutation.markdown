---
layout: post
title: "Least bits to transmit a permutation"
date: 2015-04-19 23:53
comments: true
categories: math permutations
---

{%blockquote%}

Consider the 52 cards of a deck. You generated a random sequence for these
cards and want to send that sequence to a receiver. You want to minimize the
communication between you and the receiver, i.e., minimize the number of bits
required to send the sequence.

{%endblockquote%}

What is the minimum number of bits required to send the sequence?

To arrive at the solution, I'm going to consider a smaller example: What are
all the permutations of [0,1,2,3]?

    [0,1,2,3] => perm 00 => binary: 0 0 0 0 0   || [0,3,1,2] => perm 12 => binary: 0 1 1 0 0
    [0,2,1,3] => perm 01 => binary: 0 0 0 0 1   || [0,3,2,1] => perm 13 => binary: 0 1 1 0 1
    [1,0,2,3] => perm 02 => binary: 0 0 0 1 0   || [1,3,0,2] => perm 14 => binary: 0 1 1 1 0
    [1,2,0,3] => perm 03 => binary: 0 0 0 1 1   || [1,3,2,0] => perm 15 => binary: 0 1 1 1 1
    [2,0,1,3] => perm 04 => binary: 0 0 1 0 0   || [2,3,0,1] => perm 16 => binary: 1 0 0 0 0
    [2,1,0,3] => perm 05 => binary: 0 0 1 0 1   || [2,3,1,0] => perm 17 => binary: 1 0 0 0 1
    [0,1,3,2] => perm 06 => binary: 0 0 1 1 0   || [3,0,1,2] => perm 18 => binary: 1 0 0 1 0
    [0,2,3,1] => perm 07 => binary: 0 0 1 1 1   || [3,0,2,1] => perm 19 => binary: 1 0 0 1 1
    [1,0,3,2] => perm 08 => binary: 0 1 0 0 0   || [3,1,0,2] => perm 20 => binary: 1 0 1 0 0
    [1,2,3,0] => perm 09 => binary: 0 1 0 0 1   || [3,1,2,0] => perm 21 => binary: 1 0 1 0 1
    [2,0,3,1] => perm 10 => binary: 0 1 0 1 0   || [3,2,0,1] => perm 22 => binary: 1 0 1 1 0
    [2,1,3,0] => perm 11 => binary: 0 1 0 1 1   || [3,2,1,0] => perm 23 => binary: 1 0 1 1 1

How many bits do you need to represent a number in general?  Another way of
phrasing: how many digits do I need to represent this number?  Take a base 10
number, say 123, written as a function combination of it's bases: `(10^2 * 1) +
(10^1 * 2) + (10^0 * 3) = 100 + 20 + 3`.  So, the largest component is `100`, and
we need at least `3` digits (or 1 + the power of largest component).

So, 10^N = X, we want to know what N is, thus, log_10(X) = N.  This holds for
base 2 numbers, thus:

    log_2(X) = N

So, if we have 24 permutations (4 factorial), we need this many bits:

    log_2(24) = 4.58; ceil(4.58) = 5

Since we can't have partial bits we round up... and arrive at 5.

If we need only 5-bits to number each sequence, we could just store a lookup
table... but for larger inputs, you cannot just transmit a sequence number and
have the remote end look-up which permutation to use in a lookup table, this
would use too much memory...

However, what if we choose to map these as choices, noting that choices cannot
be repeated and the that pool of choices shrinks each time.  Since the pool is
`[0, 1, 2, 3]`, the choices would be for example:

                           Sequence     Choices
                           --------     -------
    Perm 1 -                            [0,1,2,3]
           - choose(00) => [0]          [1,2,3]
           - choose(00) => [0,1]        [2,3]
           - choose( 0) => [0,1,2]      [3]
           - choose( _) => [0,1,2,3]    []

        binary: 000 00 => decimal: 0

    ---------------------------------------------

                           Sequence     Choices
                           --------     -------
    Perm 2 -                            [0,1,2,3]
           - choose(00) => [0]          [1,2,3]
           - choose(01) => [0,2]        [1,3]
           - choose( 0) => [0,2,1]      [3]
           - choose( _) => [0,1,2,3]    []

        binary: 00 01 0 => decimal: 2

Then, we can rewrite the list of permutation like this:

    Permutation   Choices    |  Permutation   Choices
    -----------   ---------  |  -----------   ---------
    [3,2,1,|]     [D,C,A,B]  |  [1,2,1,|]     [B,D,A,C]
    [3,2,0,|]     [D,C,B,A]  |  [1,2,0,|]     [B,D,C,A]
    [3,1,1,|]     [D,B,A,C]  |  [1,1,1,|]     [B,C,A,D]
    [3,1,0,|]     [D,B,C,A]  |  [1,1,0,|]     [B,C,D,A]
    [3,0,1,|]     [D,A,B,C]  |  [1,0,1,|]     [B,A,C,D]
    [3,0,0,|]     [D,A,C,B]  |  [1,0,0,|]     [B,A,D,C]
    [2,2,1,|]     [C,D,A,B]  |  [0,2,1,|]     [A,D,B,C]
    [2,2,0,|]     [C,D,B,A]  |  [0,2,0,|]     [A,D,C,B]
    [2,1,1,|]     [C,B,A,D]  |  [0,1,1,|]     [A,C,B,D]
    [2,1,0,|]     [C,B,D,A]  |  [0,1,0,|]     [A,C,D,B]
    [2,0,1,|]     [C,A,B,D]  |  [0,0,1,|]     [A,B,C,D]
    [2,0,0,|]     [C,A,D,B]  |  [0,0,0,|]     [A,B,D,C]

Writing it this way, a pattern emerges... the first column is never greater
than `3`, the second is never great than `2`, the third is only every `1` or
`0`.

We can map these choices into a number that uses only 5-bits by noticing:

    Always 0-3 for most significant
      [00, 01, 10, 11] => [0, 1, 2, 3]

    Then always 0-2 for next bits
      [00, 01, 10] => [0, 1, 2]

    Then only 1 or 0 left:
      [0, 1] => [0, 1]

    So, the bit pattern is roughly:
      ZZ YY X (Z = first choice, Y = second choice, X = final choice)

The "bit pattern" idea isn't really a good model of the general idea, since
we'll be spreading `ZZ` portion into the coded sequence number.  Let `max = 3`,
to prepare the first choice to be mapped we multiply the choice by max, then we
can use integer division to recover the number:

    b000 * 3 => b0000 (0)
    b001 * 3 => b0011 (3)
    b010 * 3 => b0110 (6)
    b011 * 3 => b1001 (9)

Now, we can add the second choice to this number, if we mod by `3`, we'll get
back the second choice, if we use integer division by `3`, we'll get back the
first choice:

    (b0000 + b00) => b0000 ( 0) | mod 3 => 0 | div 3 => 0
    (b0000 + b01) => b0001 ( 1) | mod 3 => 1 | div 3 => 0
    (b0000 + b10) => b0010 ( 2) | mod 3 => 2 | div 3 => 0

    (b0011 + b00) => b0011 ( 3) | mod 3 => 0 | div 3 => 1
    (b0011 + b01) => b0100 ( 4) | mod 3 => 1 | div 3 => 1
    (b0011 + b10) => b0101 ( 5) | mod 3 => 2 | div 3 => 1

    (b0110 + b00) => b0110 ( 6) | mod 3 => 0 | div 3 => 2
    (b0110 + b01) => b0111 ( 7) | mod 3 => 1 | div 3 => 2
    (b0110 + b10) => b1000 ( 8) | mod 3 => 2 | div 3 => 2

    (b1001 + b00) => b1001 ( 9) | mod 3 => 0 | div 3 => 3
    (b1001 + b01) => b1010 (10) | mod 3 => 1 | div 3 => 3
    (b1001 + b10) => b1011 (11) | mod 3 => 2 | div 3 => 3

To map the final choice into this number we multiply each of these numbers by
`max-1 = 2`, and add in the final choice:

    (b0000 * 2) + 0 => b0000 00 ( 0) | (b0110 * 2) + 0 => b0001 10 (12)
    (b0000 * 2) + 1 => b0000 01 ( 1) | (b0110 * 2) + 1 => b0001 11 (13)

    (b0001 * 2) + 0 => b0000 10 ( 2) | (b0111 * 2) + 0 => b0011 10 (14)
    (b0001 * 2) + 1 => b0000 11 ( 3) | (b0111 * 2) + 1 => b0011 11 (15)

    (b0010 * 2) + 0 => b0001 00 ( 4) | (b1000 * 2) + 0 => b1000 00 (16)
    (b0010 * 2) + 1 => b0001 01 ( 5) | (b1000 * 2) + 1 => b1000 01 (17)

    (b0011 * 2) + 0 => b0001 10 ( 6) | (b1001 * 2) + 0 => b0100 10 (18)
    (b0011 * 2) + 1 => b0001 11 ( 7) | (b1001 * 2) + 1 => b0100 11 (19)

    (b0100 * 2) + 0 => b0010 00 ( 8) | (b1010 * 2) + 0 => b0101 00 (20)
    (b0100 * 2) + 1 => b0010 01 ( 9) | (b1010 * 2) + 1 => b0101 01 (21)

    (b0101 * 2) + 0 => b0010 10 (10) | (b1011 * 2) + 0 => b0101 10 (22)
    (b0101 * 2) + 1 => b0010 11 (11) | (b1011 * 2) + 1 => b0101 11 (23)

Each number from the above table can be divided by `2` (integer division) to
recovery the 2nd choice, or modulo by `2` to recover the last choice.
