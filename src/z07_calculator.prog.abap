*&---------------------------------------------------------------------*
*& Report z07_calculator
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z07_calculator.

PARAMETERS: gv_int1 TYPE i, gv_int2 TYPE i, gv_op TYPE c LENGTH 1.

DATA result TYPE p LENGTH 16 DECIMALS 2.

DATA gv_output TYPE string.

CASE gv_op.
  WHEN '+'.
    result = gv_int1 + gv_int2.
    gv_output = result.
  WHEN '-'.
    result = gv_int1 - gv_int2.
    gv_output = result.
  WHEN '*'.
    result = gv_int1 * gv_int2.
    gv_output = result.
  WHEN '/'.
    IF gv_int2 = 0.
      gv_output = 'Division durch null ist nicht möglich.'.
      EXIT.
    ENDIF.
    result = gv_int1 / gv_int2.
    gv_output = result.
  WHEN OTHERS.
    gv_output = 'Bitte gib einen gültigen Operator ein.'.
ENDCASE.
WRITE gv_output.
