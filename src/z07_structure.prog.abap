*&---------------------------------------------------------------------*
*& Report z07_structure
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z07_structure.

TYPES: BEGIN OF ts_complete,
         carrid    TYPE d400_struct_s1-carrid,
         connid    TYPE d400_struct_s1-connid,
         cityfrom  TYPE d400_struct_s1-cityfrom,
         cityto    TYPE d400_struct_s1-cityto,
         fldate    TYPE d400_s_flight-fldate,
         planetype TYPE d400_s_flight-planetype,
         seatsmax  TYPE d400_s_flight-seatsmax,
         seatsocc  TYPE d400_s_flight-seatsocc,
       END OF ts_complete.

DATA gs_connection TYPE z07_connection.
DATA gs_flight TYPE d400_s_flight.
DATA gs_complete TYPE ts_complete.

gs_connection = VALUE #( carrid = 'LH'
                    connid = '0400'
                    cityfrom = 'Frankfurt'
                    cityto = 'New York').

TRY.
    cl_s4d400_flight_model=>get_next_flight(
        EXPORTING
          iv_carrid = gs_connection-carrid
          iv_connid = gs_connection-connid
        IMPORTING
          es_flight = gs_flight
      ).
    gs_complete = CORRESPONDING #( BASE (  gs_complete ) gs_connection ).
    gs_complete = CORRESPONDING #( BASE (  gs_complete ) gs_flight ).

    cl_s4d_output=>display_structure( iv_structure = gs_complete ).

  CATCH cx_s4d400_no_data.
    cl_s4d_output=>display_line( iv_text = |{ TEXT-tel }| ).
ENDTRY.
