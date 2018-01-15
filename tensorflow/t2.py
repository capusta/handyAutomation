#! /usr/bin/env python

import tensorflow as tf

with tf.Session() as sess:
  mapping_string = tf.constant(["foo", "bar", "baz"])
  p = tf.string_to_hash_bucket_strong(mapping_string, 3, key=[123, 456])
  q = tf.string_to_hash_bucket_strong(tf.constant(["zoo","bar","baz"]), 3, key=[123, 456])

  i = sess.run(p)
  j = sess.run(q)
  print(i)
  print(j)


