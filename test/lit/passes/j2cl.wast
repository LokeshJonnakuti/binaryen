;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt --optimize-j2cl -all -S -o - | filecheck %s

;; Simple primitives are hoisted.
(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (global $field-f64@Foo f64 (f64.const 1))

  ;; CHECK:      (global $field-i32@Foo i32 (i32.const 1))
  (global $field-i32@Foo (mut i32) (i32.const 0))
  (global $field-f64@Foo (mut f64) (f64.const 0))

  ;; CHECK:      (func $clinit_<once>_@Foo (type $0)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $clinit_<once>_@Foo
    (global.set $field-i32@Foo (i32.const 1))
    (global.set $field-f64@Foo (f64.const 1))
  )
)

;; Fields with more complex constant initialization are hoisted.
(module

  ;; CHECK:      (type $A (struct (field i32)))
  (type $A (struct (field i32)))

  ;; CHECK:      (type $1 (func))

  ;; CHECK:      (global $field2@Foo (mut anyref) (ref.null none))

  ;; CHECK:      (global $referredField@Foo i32 (i32.const 42))
  (global $referredField@Foo (i32) (i32.const 42))

  ;; CHECK:      (global $field1@Foo anyref (struct.new $A
  ;; CHECK-NEXT:  (global.get $referredField@Foo)
  ;; CHECK-NEXT: ))

  ;; CHECK:      (global $referredFieldMut@Foo (mut i32) (i32.const 42))
  (global $referredFieldMut@Foo (mut i32) (i32.const 42))

  (global $field1@Foo (mut anyref) (ref.null none))

  (global $field2@Foo (mut anyref) (ref.null none))

  ;; CHECK:      (global $field3@Foo anyref (global.get $field1@Foo))
  (global $field3@Foo (mut anyref) (ref.null none))

  ;; CHECK:      (func $clinit_<once>_@Foo (type $1)
  ;; CHECK-NEXT:  (global.set $field2@Foo
  ;; CHECK-NEXT:   (struct.new $A
  ;; CHECK-NEXT:    (global.get $referredFieldMut@Foo)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $clinit_<once>_@Foo
    ;; Referred field is immutable, should hoist
    (global.set $field1@Foo (struct.new $A (
      global.get $referredField@Foo)
    ))

    ;; Referred field is mutable, should not hoist
    (global.set $field2@Foo (struct.new $A
      (global.get $referredFieldMut@Foo)
    ))

    ;; Referred field is mutable but hoistable hence also this one.
    ;; (Note that requires multiple iterations in a single run)
    (global.set $field3@Foo (global.get $field1@Foo))
  )
)

;; Fields initialized to a non-default value shouldn't be hoisted.
(module
  ;; CHECK:      (type $A (struct ))
  (type $A (struct))
  ;; CHECK:      (type $1 (func))

  ;; CHECK:      (global $field-any@Foo (mut anyref) (struct.new_default $A))

  ;; CHECK:      (global $field-i32@Foo (mut i32) (i32.const 2))
  (global $field-i32@Foo (mut i32) (i32.const 2))

  (global $field-any@Foo (mut anyref) (struct.new $A))

  ;; CHECK:      (func $clinit_<once>_@Foo (type $1)
  ;; CHECK-NEXT:  (global.set $field-i32@Foo
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (global.set $field-any@Foo
  ;; CHECK-NEXT:   (struct.new_default $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $clinit_<once>_@Foo
    (global.set $field-i32@Foo (i32.const 1))
    (global.set $field-any@Foo (struct.new $A))
  )
)

;; Non-block body is optimized
(module

  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (global $field@Foo i32 (i32.const 1))
  (global $field@Foo (mut i32) (i32.const 0))

  ;; CHECK:      (func $clinit_<once>_@Foo (type $0)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $clinit_<once>_@Foo
    (global.set $field@Foo (i32.const 1))
  )
)

;; $$class-initialized are not hoisted
(module

  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (global $$class-initialized@Foo (mut i32) (i32.const 0))
  (global $$class-initialized@Foo (mut i32) (i32.const 0))

  ;; CHECK:      (func $clinit_<once>_@Foo (type $0)
  ;; CHECK-NEXT:  (global.set $$class-initialized@Foo
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $clinit_<once>_@Foo
    (global.set $$class-initialized@Foo (i32.const 1))
  )
)

;; Fields from different classes are not hoisted.
(module

  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (global $field@Foo (mut i32) (i32.const 0))
  (global $field@Foo (mut i32) (i32.const 0))

  ;; CHECK:      (func $clinit_<once>_@Bar (type $0)
  ;; CHECK-NEXT:  (global.set $field@Foo
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $clinit_<once>_@Bar
    ;; Note that $clinit is @Bar and field is @Foo.
    (global.set $field@Foo (i32.const 1))
  )
)