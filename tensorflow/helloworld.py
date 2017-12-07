#! /usr/bin/env python
import tensorflow as tf

# Set a simple constant
const = tf.constant(2.0, name="const")

b = tf.Variable(2.0, name='b')
c = tf.Variable(1.0, name='c')

op1 = tf.add(b,c, name='d')
init_op = tf.global_variables_initializer()

# start tensorflow session
with tf.Session() as sess:
  sess.run(init_op)
  out = sess.run(op1)
  print("done: {}".format(out))
