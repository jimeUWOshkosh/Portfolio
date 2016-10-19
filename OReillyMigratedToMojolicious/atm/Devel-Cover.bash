export HARNESS_PERL_SWITCHES=-MDevel::Cover
prove -l
cover
# cover -delete
