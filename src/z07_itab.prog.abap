*&---------------------------------------------------------------------*
*& Report z07_itab
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z07_itab.


TYPES gt_flights
TYPE STANDARD TABLE OF d400_t_flights.

TYPES gt_percentage
TYPE STANDARD TABLE OF d400_t_percentage.

DATA: gt_connections TYPE z07_t_connections, "Aufgabe 2
      gt_flights     TYPE d400_t_flights, "Aufgabe 5
      gt_percentage  TYPE d400_t_percentage. "Aufgabe 6

*Aufgabe 3
gt_connections = VALUE #(
( carrid = 'LH'
connid = '0400')
( carrid = 'LH'
connid = '0402')
).

*Aufgabe 5
CALL FUNCTION 'Z_07_GET_CONNECTION'
  EXPORTING
    it_connections = gt_connections
  IMPORTING
    et_flights     = gt_flights.

*Aufgabe 7
gt_percentage = CORRESPONDING #( gt_flights ).

*Aufgabe 9
Write: `Carrier`, AT 10 `Conn.`, at 20 `date`, at 35 `occupied`, at 45 'max.', at 55 `percentage`.

*Aufgabe 8
LOOP AT gt_percentage REFERENCE INTO DATA(gt_percentage_ref).
  IF gt_percentage_ref->seatsmax <> 0.
    gt_percentage_ref->percentage = gt_percentage_ref->seatsocc / gt_percentage_ref->seatsmax * 100.
  ENDIF.
  Write: / gt_percentage_ref->carrid, at 10 gt_percentage_ref->connid, at 20
  gt_percentage_ref->fldate, at 35 gt_percentage_ref->seatsocc, at 45
  gt_percentage_ref->seatsmax, at 55  |{ gt_percentage_ref->percentage align = left }|.
ENDLOOP.
