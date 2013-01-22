#include <stdio.h>
#include <string.h>
#include "ruby.h"
#include "ruby/io.h"
#include "ruby/intern.h"

#define LINE_BUF_LEN 1000
#define FIELD_BUF_LEN 1000

static VALUE rb_LwcsvC;

int parse_field(char **source_ptr, char *field_buf, int max_length) {
  char *ptr = *source_ptr;
  char *start = *source_ptr;
  char *field_ptr = field_buf;

  while (1) {
    if (*ptr == '\0' || *ptr == '\n' || *ptr == '\r') {
      // End of source (line)
      *source_ptr = NULL;
      break;
    }
    if (field_ptr - field_buf + 2 >= max_length) {
      // Field buffer is full
      *source_ptr = NULL;
      return 1;
    }
    if (*ptr == ',') {
      // End of field
      *source_ptr = ++ptr;
      break;
    }
    *(field_ptr++) = *(ptr++);
  }
  *(field_ptr++) = '\0';
  return 0;
}

static VALUE stream_foreach(VALUE self, VALUE stream) {
  char *source_ptr;
  long field_len;
  char line_buf[LINE_BUF_LEN];
  char field_buf[FIELD_BUF_LEN];
  int idx;
  VALUE ary;
  VALUE rline;

  if (!RTEST(rb_funcall(stream, rb_intern("respond_to?"), 1, rb_str_new2("readline")))) {
    rb_raise(rb_eRuntimeError, "Argument needs to respond to #readline");
  }

  while (1) {
    if (RTEST(rb_funcall(stream, rb_intern("eof?"), 0))) {
      break;
    }
    rline = rb_funcall(stream, rb_intern("readline"), 0);
    source_ptr = RSTRING_PTR(rline);

    idx = 0;
    ary = rb_ary_new();

    while (source_ptr) {
      if (parse_field(&source_ptr, field_buf, FIELD_BUF_LEN)) {
        rb_raise(rb_eRuntimeError, "Line is too long");
      }
      field_len = strlen(field_buf);
      rb_ary_store(ary, idx, rb_str_new(field_buf, field_len));
      idx++;
    }
    rb_yield(ary);
  }

  return Qnil;
}

void Init_lwcsv() {
  rb_LwcsvC = rb_define_class("Lwcsv", rb_cObject);
  rb_define_singleton_method(rb_LwcsvC, "stream_foreach", stream_foreach, 1);
}
