
/****************************************************************************
 * Method: calloc_int_matrix()   Author: |AUTHORREF|
 ***************************************************************************/
int** calloc_int_matrix ( int rows, int columns )
{
    int   i;
    int **m;
    m = calloc ( rows, sizeof(int*) );           /* alloc pointer array   */
    assert( m != NULL );                         /* abort if alloc failed */
    *m = calloc ( rows*columns, sizeof(int) );   /* allocate data array   */
    assert(*m != NULL );                         /* abort if alloc failed */
    for ( i = 1; i < rows; i += 1 )              /* set pointers          */
    {
        m[i] = m[i-1] + columns;
    }
    return m;
}

/****************************************************************************
 * Method: free_int_matrix()   Author: |AUTHORREF|
 ***************************************************************************/
void free_int_matrix ( int **m )
{
  free(*m);             /* free data array      */
  free( m);             /* free pointer array   */
  return ;
}

