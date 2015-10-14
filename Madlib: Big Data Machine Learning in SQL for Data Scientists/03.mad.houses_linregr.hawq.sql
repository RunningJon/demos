--Single regression on all of the data
SELECT madlib.linregr_train( 'mad.houses',
                             'mad.houses_linregr',
                             'price',
                             'ARRAY[1, tax, bath, size, lot]'
                           );
