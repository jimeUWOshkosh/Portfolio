dbicdump -o dump_directory=./lib \
             -o components='["InflateColumn::DateTime"]' \
             -o use_moose=1 \
             -o relationships=1 \
             -o debug=1 \
             ATM::Schema2 \
             'dbi:mysql:dbname=atm' \
             wds \
             wds
