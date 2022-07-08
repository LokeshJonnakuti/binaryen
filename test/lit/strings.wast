;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; Check that string types are emitted properly in the binary format.

;; RUN: foreach %s %t wasm-opt --enable-strings --enable-reference-types --roundtrip -S -o - | filecheck %s

(module
  ;; CHECK:      (type $ref?|string|_=>_none (func (param stringref)))

  ;; CHECK:      (type $ref?|string|_ref?|string|_=>_none (func (param stringref stringref)))

  ;; CHECK:      (type $ref?|string|_ref?|stringview_wtf8|_ref?|stringview_wtf16|_ref?|stringview_iter|_ref?|string|_ref?|stringview_wtf8|_ref?|stringview_wtf16|_ref?|stringview_iter|_ref|string|_ref|stringview_wtf8|_ref|stringview_wtf16|_ref|stringview_iter|_=>_none (func (param stringref stringview_wtf8 stringview_wtf16 stringview_iter stringref stringview_wtf8 stringview_wtf16 stringview_iter (ref string) (ref stringview_wtf8) (ref stringview_wtf16) (ref stringview_iter))))

  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (global $string-const stringref (string.const "string in a global"))
  (global $string-const stringref (string.const "string in a global"))

  ;; CHECK:      (func $string.new (param $a stringref) (param $b stringview_wtf8) (param $c stringview_wtf16) (param $d stringview_iter) (param $e stringref) (param $f stringview_wtf8) (param $g stringview_wtf16) (param $h stringview_iter) (param $i (ref string)) (param $j (ref stringview_wtf8)) (param $k (ref stringview_wtf16)) (param $l (ref stringview_iter))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (string.new_wtf8 utf8
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:    (i32.const 2)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (string.new_wtf8 wtf8
  ;; CHECK-NEXT:    (i32.const 3)
  ;; CHECK-NEXT:    (i32.const 4)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (string.new_wtf8 replace
  ;; CHECK-NEXT:    (i32.const 5)
  ;; CHECK-NEXT:    (i32.const 6)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (string.new_wtf16
  ;; CHECK-NEXT:    (i32.const 7)
  ;; CHECK-NEXT:    (i32.const 8)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.new
    (param $a stringref)
    (param $b stringview_wtf8)
    (param $c stringview_wtf16)
    (param $d stringview_iter)
    (param $e (ref null string))
    (param $f (ref null stringview_wtf8))
    (param $g (ref null stringview_wtf16))
    (param $h (ref null stringview_iter))
    (param $i (ref string))
    (param $j (ref stringview_wtf8))
    (param $k (ref stringview_wtf16))
    (param $l (ref stringview_iter))
    (drop
      (string.new_wtf8 utf8
        (i32.const 1)
        (i32.const 2)
      )
    )
    (drop
      (string.new_wtf8 wtf8
        (i32.const 3)
        (i32.const 4)
      )
    )
    (drop
      (string.new_wtf8 replace
        (i32.const 5)
        (i32.const 6)
      )
    )
    (drop
      (string.new_wtf16
        (i32.const 7)
        (i32.const 8)
      )
    )
  )

  ;; CHECK:      (func $string.const
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (string.const "foo")
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (string.const "foo")
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (string.const "bar")
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.const
    (drop
      (string.const "foo")
    )
    (drop
      (string.const "foo") ;; intentionally repeat the previous one
    )
    (drop
      (string.const "bar")
    )
  )

  ;; CHECK:      (func $string.measure (param $ref stringref)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.eqz
  ;; CHECK-NEXT:    (string.measure_wtf8 wtf8
  ;; CHECK-NEXT:     (local.get $ref)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (string.measure_wtf8 utf8
  ;; CHECK-NEXT:    (local.get $ref)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (string.measure_wtf16
  ;; CHECK-NEXT:    (local.get $ref)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.measure (param $ref stringref)
    (drop
      (i32.eqz ;; validate the output is i32
        (string.measure_wtf8 wtf8
          (local.get $ref)
        )
      )
    )
    (drop
      (string.measure_wtf8 utf8
        (local.get $ref)
      )
    )
    (drop
      (string.measure_wtf16
        (local.get $ref)
      )
    )
  )

  ;; CHECK:      (func $string.encode (param $ref stringref)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.eqz
  ;; CHECK-NEXT:    (string.encode_wtf8 wtf8
  ;; CHECK-NEXT:     (local.get $ref)
  ;; CHECK-NEXT:     (i32.const 10)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (string.encode_wtf8 utf8
  ;; CHECK-NEXT:    (local.get $ref)
  ;; CHECK-NEXT:    (i32.const 20)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (string.encode_wtf16
  ;; CHECK-NEXT:    (local.get $ref)
  ;; CHECK-NEXT:    (i32.const 30)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.encode (param $ref stringref)
    (drop
      (i32.eqz ;; validate the output is i32
        (string.encode_wtf8 wtf8
          (local.get $ref)
          (i32.const 10)
        )
      )
    )
    (drop
      (string.encode_wtf8 utf8
        (local.get $ref)
        (i32.const 20)
      )
    )
    (drop
      (string.encode_wtf16
        (local.get $ref)
        (i32.const 30)
      )
    )
  )

  ;; CHECK:      (func $string.concat (param $a stringref) (param $b stringref)
  ;; CHECK-NEXT:  (local.set $a
  ;; CHECK-NEXT:   (string.concat
  ;; CHECK-NEXT:    (local.get $a)
  ;; CHECK-NEXT:    (local.get $b)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.concat (param $a stringref) (param $b stringref)
    (local.set $a ;; validate the output is a stringref
      (string.concat
        (local.get $a)
        (local.get $b)
      )
    )
  )

  ;; CHECK:      (func $string.eq (param $a stringref) (param $b stringref)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.eqz
  ;; CHECK-NEXT:    (string.eq
  ;; CHECK-NEXT:     (local.get $a)
  ;; CHECK-NEXT:     (local.get $b)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.eq (param $a stringref) (param $b stringref)
    (drop
      (i32.eqz ;; validate the output is an i32
        (string.eq
          (local.get $a)
          (local.get $b)
        )
      )
    )
  )

  ;; CHECK:      (func $string.is_usv_sequence (param $ref stringref)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.eqz
  ;; CHECK-NEXT:    (string.is_usv_sequence
  ;; CHECK-NEXT:     (local.get $ref)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.is_usv_sequence (param $ref stringref)
    (drop
      (i32.eqz ;; validate the output is i32
        (string.is_usv_sequence
          (local.get $ref)
        )
      )
    )
  )
)
