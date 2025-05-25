*&---------------------------------------------------------------------*
*& Report zha_gai_w2_d6_en
*&---------------------------------------------------------------------*
*& Dynamic method call demo
*&---------------------------------------------------------------------*
REPORT zha_gai_w2_d6_en.

CLASS zcl_dynamic_call_target DEFINITION.
  PUBLIC SECTION.
    METHODS:
      say_hello,
      say_goodbye.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_dynamic_call_target IMPLEMENTATION.

  METHOD say_goodbye.
    WRITE:/ |Goodbye, World.|.
  ENDMETHOD.

  METHOD say_hello.
    WRITE:/ |Hello, World.|.
  ENDMETHOD.

ENDCLASS.


CLASS zcl_dynamic_caller DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      execute_method
        IMPORTING
          io_object      TYPE REF TO object
          iv_method_name TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_dynamic_caller IMPLEMENTATION.

  METHOD execute_method.
    TRY.
        IF io_object IS INSTANCE OF zcl_dynamic_call_target.
          WRITE: / |Hey, I found you :)|. "optional debug/info output
        ENDIF.
        
        CALL METHOD io_object->(iv_method_name).
      CATCH cx_sy_dyn_call_illegal_method.
        MESSAGE |Method '{ iv_method_name }' not found or cannot be called.| TYPE 'E'.
      CATCH cx_sy_dyn_call_param_not_found.
        MESSAGE |Parameter error in dynamic call: { iv_method_name }| TYPE 'E'.
      CATCH cx_root.
        MESSAGE |Unknown error occurred during dynamic call: { iv_method_name }| TYPE 'E'.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  DATA(lo_target) = NEW zcl_dynamic_call_target( ).

  zcl_dynamic_caller=>execute_method(
    EXPORTING
      io_object      = lo_target
      iv_method_name = |SAY_HELLO|
  ).

  zcl_dynamic_caller=>execute_method(
    EXPORTING
      io_object      = lo_target
      iv_method_name = |SAY_GOODBYE|
  ).
