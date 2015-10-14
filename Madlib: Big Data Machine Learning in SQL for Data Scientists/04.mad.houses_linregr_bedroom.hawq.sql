--Four output models with one for each value of "bedroom"

SELECT madlib.linregr_train( 'mad.houses',
                             'mad.houses_linregr_bedroom',
                             'price',
                             'ARRAY[1, tax, bath, size, lot]',
                             'bedroom'
                           );
