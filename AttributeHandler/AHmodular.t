#!/usr/bin/env perl
use strict; use warnings; use feature 'say';
use MySubs;

my %jetsons = (Dad => 'George', Mom => 'Jane', girl => 'Judy', boy => 'Elroy');
MySubs->table(%jetsons);
MySubs::table(%jetsons);

exit 0;
