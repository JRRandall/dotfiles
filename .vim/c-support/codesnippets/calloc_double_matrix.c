
/****************************************************************************
 * Method: calloc_double_matrix()   Author: |AUTHORREF|
 ***************************************************************************/
double** calloc_double_matrix ( int rows, int columns )
{
    int      i;
    double **m;
    m = calloc ( rows, sizeof(double*) );         /* alloc pointer array   */
    assert( m != NULL );                          /* abort if alloc failed */
    *m = calloc ( rows*columns, sizeof(double) ); /* allocate data array   */
    assert(*m != NULL );                          /* abort if alloc failed */
    for ( i = 1; i < rows; i += 1 )               /* set pointers          */
    {
        m[i] = m[i-1] + columns;
    }
    return m;
}

/****************************************************************************
 * Method: free_double_matrix()   Author: |AUTHORREF|
 ***************************************************************************/
void free_double_matrix ( double **m )
{
    free(*m);        /* free data array      */
    free( m);        /* free pointer array   */
    return ;
}

