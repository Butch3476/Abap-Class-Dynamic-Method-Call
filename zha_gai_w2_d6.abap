*&---------------------------------------------------------------------*
*& Report zha_gai_w2_d6
*&---------------------------------------------------------------------*

report zha_gai_w2_d6.

" This is our humble target class, ready to say hello or goodbye.
class zcl_dynamic_call_target definition.
  public section.
    methods:
      say_hello,
      say_goodbye.
  protected section.
  private section.
endclass.

class zcl_dynamic_call_target implementation.

  method say_goodbye.
    write:/ |Goodbye World.|.
  endmethod.

  method say_hello.
    " Oldest trick in the book, but still feels magical.
    write:/ |Hello World.|.
  endmethod.

endclass.


" This one is the caller – dynamic and slightly dangerous :)
class zcl_dynamic_caller definition.
  public section.
    class-methods:
      execute_method
        importing
          io_object      type ref to object 
          iv_method_name type string.
  protected section.
  private section.
endclass.

class zcl_dynamic_caller implementation.

  method execute_method.
    try.
        if io_object is instance of zcl_dynamic_call_target.
          write: / |Found you, buddy :)|.
        endif.

            " Here’s the magic: calling a method whose name we only know at runtime.
            " (Yes, those parentheses are not decoration, they are VITAL!)
        call method io_object->(iv_method_name).
      catch cx_sy_dyn_call_illegal_method.
        message |Method '{ iv_method_name }' not found or cannot be called.| type 'E'.
      catch cx_sy_dyn_call_param_not_found.
        message |Dynamic call parameter error: { iv_method_name }| type 'E'.
      catch cx_root.
        message |An unknown error occurred during dynamic call: { iv_method_name }| type 'E'.
    endtry.
  endmethod.

endclass.


" Showtime!
start-of-selection.
  data(lo_target) = new zcl_dynamic_call_target( ).

  zcl_dynamic_caller=>execute_method(
    exporting
      io_object      = lo_target
      iv_method_name = |SAY_HELLO|
  ).

  zcl_dynamic_caller=>execute_method(
    exporting
      io_object      = lo_target
      iv_method_name = |SAY_GOODBYE|
  ).
