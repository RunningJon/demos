SELECT houses.tax, bedroom, bath, size, lot, price,
       (madlib.linregr_predict( ARRAY[1,tax,bath,size, lot],
                               m.coef
                             ))::int as predict,
        price -
          (madlib.linregr_predict( ARRAY[1,tax,bath,size, lot],
                                  m.coef
                                ))::int as residual
FROM mad.houses, mad.houses_linregr m
LIMIT 10;
