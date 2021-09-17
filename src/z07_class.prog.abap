*&---------------------------------------------------------------------*
*& Report z07_class
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z07_class.
*aufgabe 15.2
CLASS lcl_airplane DEFINITION.
  PUBLIC SECTION.

*aufgabe 18.1
    METHODS constructor
      IMPORTING iv_name      TYPE string
                iv_planetype TYPE saplane-planetype
      RAISING   cx_s4d400_wrong_plane.

*aufgabe 15.4
    TYPES: BEGIN OF ty_attribute,
             attribute TYPE string,
             value     TYPE string,
           END OF   ty_attribute.

*aufgabe 15.5
    TYPES ty_attributes
    TYPE STANDARD TABLE OF ty_attribute
    WITH NON-UNIQUE KEY attribute.

*aufgabe 15.6
    METHODS set_attributes
      IMPORTING iv_name      TYPE string
                iv_planetype TYPE saplane-planetype.

    METHODS get_attributes
      EXPORTING et_attributes TYPE ty_attributes.

*andere, in der Praxis benutzte Methode
    METHODS get_attributes_return
      RETURNING
        VALUE(r_attributes) TYPE ty_attributes.


    CLASS-METHODS get_n_o_airplanes
      EXPORTING ev_number TYPE i.

*aufgabe 22.6
  PROTECTED SECTION.
    DATA mv_name TYPE string.
    DATA mv_planetype TYPE saplane-planetype.

  PRIVATE SECTION.

*aufgabe 15.3
    CLASS-DATA gv_n_o_airplanes TYPE i.
ENDCLASS.
CLASS lcl_airplane IMPLEMENTATION.

*aufgabe 15.7 + 15.8
  METHOD set_attributes.
    mv_name = iv_name.
    mv_planetype = iv_planetype.
    gv_n_o_airplanes = gv_n_o_airplanes + 1.
  ENDMETHOD.

  METHOD get_attributes.
    et_attributes = VALUE #( ( attribute = 'Name' value = mv_name )
                             ( attribute = 'Planetype' value = mv_planetype ) ).
  ENDMETHOD.

  METHOD get_n_o_airplanes.
    ev_number = gv_n_o_airplanes.
  ENDMETHOD.


  METHOD get_attributes_return.
    r_attributes = VALUE #( ( attribute = 'Name' value = mv_name )
                                 ( attribute = 'Planetype' value = mv_planetype ) ).
  ENDMETHOD.

  METHOD constructor.
    mv_name = iv_name.
    mv_planetype = iv_planetype.
  ENDMETHOD.

ENDCLASS.

*aufgabe 16.1
DATA go_airplane TYPE REF TO lcl_airplane.

*aufgabe 16.2
DATA gt_airplanes TYPE TABLE OF REF TO lcl_airplane.

*aufgabe 22.1
CLASS lcl_cargoplane DEFINITION
INHERITING FROM lcl_airplane.

*aufgabe 22.2
  PUBLIC SECTION.
    METHODS get_attributes REDEFINITION.

*aufgabe 22.4
    METHODS constructor
      IMPORTING iv_name      TYPE string
                iv_planetype TYPE saplane-planetype
                iv_weight    TYPE i
      RAISING   cx_s4d400_wrong_plane.

*get weight Methode
    METHODS get_weight
      RETURNING VALUE(rv_weight) TYPE i.

*aufgabe 22.3
  PRIVATE SECTION.
    DATA mv_weight TYPE i.

ENDCLASS.

*aufgabe 22.5
CLASS lcl_cargoplane IMPLEMENTATION.

  METHOD constructor.
    super->constructor( iv_name = iv_name
    iv_planetype = iv_planetype ).
    mv_weight = iv_weight.
  ENDMETHOD.

*aufgabe 22.6
  METHOD get_attributes.
    et_attributes = VALUE #( ( attribute = 'Name' value = mv_name )
                                ( attribute = 'Planetype' value = mv_planetype )
                                ( attribute = 'Gewicht' value = mv_weight ) ).
  ENDMETHOD.

  METHOD get_weight.
    rv_weight = mv_weight.
  ENDMETHOD.

ENDCLASS.

*aufgabe 22.8
CLASS lcl_passenger_plane DEFINITION
INHERITING FROM lcl_airplane.

*aufgabe 22.9
  PUBLIC SECTION.
    METHODS get_attributes REDEFINITION.

    METHODS constructor
      IMPORTING iv_name      TYPE string
                iv_planetype TYPE saplane-planetype
                iv_seats     TYPE i
      RAISING   cx_s4d400_wrong_plane.


*aufgabe 22.10
  PRIVATE SECTION.
    DATA mv_seats TYPE i.
ENDCLASS.

*aufgabe 22.12
CLASS lcl_passenger_plane IMPLEMENTATION.

*aufgabe 22.14
  METHOD constructor.

    super->constructor( iv_name = iv_name iv_planetype = iv_planetype ).
    mv_seats = iv_seats.

  ENDMETHOD.

*aufgabe 22.13
  METHOD get_attributes.
    et_attributes = VALUE #( ( attribute = 'Name' value = mv_name )
                                  ( attribute = 'Planetype' value = mv_planetype )
                                  ( attribute = 'Sitze' value = mv_seats )  ).

  ENDMETHOD.

ENDCLASS.

*aufgabe 23.1
CLASS lcl_carrier DEFINITION.

  PUBLIC SECTION.

*aufgabe 23.2
    TYPES tt_planetab
    TYPE STANDARD TABLE OF REF TO lcl_airplane
    WITH EMPTY KEY.

*aufgabe 23.4
    METHODS add_plane
      IMPORTING io_plane TYPE REF TO lcl_airplane.

*aufgabe 23.5
*    METHODS get_planes
*      RETURNING VALUE(rt_planes) TYPE tt_planetab.

*aufgabe 24.1
    METHODS get_highest_cargo_weight
      RETURNING VALUE(rv_weight) TYPE i.

  PRIVATE SECTION.

*aufgabe 23.3
    DATA mt_planes TYPE tt_planetab.
ENDCLASS.

CLASS lcl_carrier IMPLEMENTATION.

*aufgabe 23.4
  METHOD add_plane.
    mt_planes = VALUE #( BASE mt_planes ( io_plane ) ).
  ENDMETHOD.

*aufgabe 23.5
*  METHOD get_planes.
*    rt_planes = mt_planes.
*  ENDMETHOD.

*aufgabe 24.1
  METHOD get_highest_cargo_weight.

*aufgabe 24.2
    DATA lo_plane TYPE REF TO lcl_airplane.

*aufgabe 24.3
    DATA lo_cargoplane TYPE REF TO lcl_cargoplane.

*aufgabe 24.2
    LOOP AT mt_planes INTO lo_plane .

*aufgabe 24.3
      IF lo_plane IS INSTANCE OF lcl_cargoplane.
        lo_cargoplane = CAST #( lo_plane ).
      ENDIF.

*aufgabe 24.4
      DATA lo_weight TYPE i.
      lo_weight = lo_cargoplane->get_weight( ).
      IF lo_weight > rv_weight.
        rv_weight = lo_weight.
      ENDIF.

    ENDLOOP.


  ENDMETHOD.

ENDCLASS.

*aufgabe 23.6
DATA go_passenger TYPE REF TO lcl_passenger_plane.
DATA go_cargo TYPE REF TO lcl_cargoplane.
DATA go_carrier TYPE REF TO lcl_carrier.

*aufgabe 16.3
START-OF-SELECTION.

*aufgabe 23.7
  TRY.
      go_airplane = NEW #( iv_name = 'plane' iv_planetype = 'a380-800').
      go_carrier->add_plane( go_airplane ).
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.

  TRY.
      go_passenger = NEW #( iv_name = 'plane' iv_planetype = '146-200' iv_seats = '100').
      go_carrier->add_plane( go_airplane ).
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.
  TRY.
      go_cargo = NEW #( iv_name = 'plane' iv_planetype = '747-400' iv_weight = 100 ).
      go_carrier->add_plane( go_airplane ).
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.

*aufgabe 16.4
  TRY.
      go_airplane = NEW #(
          iv_name      = 'Plane 1'
          iv_planetype = 'XXX'
      ).
      gt_airplanes = VALUE #( BASE gt_airplanes
                            ( go_airplane )
                            ).
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.

  TRY.
      go_airplane = NEW #(
          iv_name      = 'Plane 2'
          iv_planetype = 'A340-600'
      ).
      gt_airplanes = VALUE #( BASE gt_airplanes
                            ( go_airplane )
                            ).
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.

  TRY.
      go_airplane = NEW #(
          iv_name      = 'Plane 3'
          iv_planetype = 'A380-800'
      ).
      gt_airplanes = VALUE #( BASE gt_airplanes
                            ( go_airplane )
                            ).
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.

*aufgabe 4
  DATA gt_output TYPE lcl_airplane=>ty_attributes.

*aufgabe 17.1
  gt_airplanes[ 1 ]->set_attributes(
  EXPORTING
  iv_name = 'Plane 1'
  iv_planetype = '146-200' ).

  gt_airplanes[ 2 ]->set_attributes(
  EXPORTING
  iv_name = 'Plane 2'
  iv_planetype = '146-300' ).

  gt_airplanes[ 3 ]->set_attributes(
  EXPORTING
  iv_name = 'Plane 3'
  iv_planetype = '727-200' ).

*aufgabe 23.9
*  gt_airplanes = go_carrier->get_planes( ).

*aufgabe 17.2 + 17.3
  DATA gt_attributes TYPE lcl_airplane=>ty_attributes.

  LOOP AT gt_airplanes INTO go_airplane.
    go_airplane->get_attributes( IMPORTING et_attributes = gt_attributes ).
    gt_output = CORRESPONDING #(  BASE ( gt_output ) gt_attributes ).
  ENDLOOP.

*aufgabe 23.6
data gt_highest_weight type i.
gt_highest_weight = go_carrier->get_highest_cargo_weight( ).

*aufgabe 13.5
*  cl_s4d_output=>display_table( gt_output ).
data gv_output type string.
gv_output = | { 'Das höchste Gewicht ist' } { gt_highest_weight } |.
   cl_s4d_output=>display_string( gv_output ).
