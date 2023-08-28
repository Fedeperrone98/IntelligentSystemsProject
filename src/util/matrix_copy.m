%{
This function allows you to copy the content of a vector within a 
specific row of a matrix, setting the various start and end indexes of 
the rows and columns respectively
INPUTS:
     A: Matrix in which I want to copy the vector
     B: Vector I want to copy
     start_index_row: index of the specific row of the matrix from which
                      i want to start copying the vector
     start_index_column: index of the specific column of the matrix from which
                         i want to start copying the vector
OUTPUT:
    A: matrix in which I copied the now modified vector
%}
function [A] = matrix_copy(A, B, start_index_row, start_index_column)
    
    [number_row_matrix_to_copy,number_column_matrix_to_copy]=size(B);
    A(start_index_row:start_index_row + number_row_matrix_to_copy - 1,...
        start_index_column:start_index_column + number_column_matrix_to_copy -1) = B;

end