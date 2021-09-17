*&---------------------------------------------------------------------*
*& Report s4d4400_var_s2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z07_function_module.


DATA: gv_int1   TYPE i,
      gv_int2   TYPE i,
      gv_op     TYPE c LENGTH 1,
      gv_result TYPE p LENGTH 16 DECIMALS 2,
      gv_output TYPE string.


cl_s4d_input=>get_calc_input(
  IMPORTING
    ev_num1 = gv_int1
    ev_num2 = gv_int2
    ev_op   = gv_op
).

IF gv_op = '+' OR gv_op = '-' OR gv_op = '*' OR gv_op = '/' AND gv_int2 <> 0.
  CASE gv_op.
    WHEN '+'.
      gv_result = gv_int1 + gv_int2.
    WHEN '-'.
      gv_result = gv_int1 - gv_int2.
    WHEN '*'.
      gv_result = gv_int1 * gv_int2.
    WHEN '/'.
      gv_result = gv_int1 / gv_int2.
    WHEN '%'.
      CALL FUNCTION 'S4D400_CALCULATE_PERCENTAGE'
        EXPORTING
          iv_int1          = gv_int1
          iv_int2          = gv_int2
        IMPORTING
          ev_result        = gv_result
        EXCEPTIONS
          division_by_zero = 1.

  ENDCASE.

  gv_output = |{ TEXT-t01 } { gv_result }|.

ELSEIF gv_op = '/' AND gv_int2 = 0.
  gv_output = TEXT-te1.
ELSE.
  gv_output = TEXT-te2.
ENDIF.
cl_s4d_output=>display_string( iv_text = gv_output ).
