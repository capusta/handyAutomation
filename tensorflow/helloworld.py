#! /usr/bin/env python
import numpy as np
import tensorflow as tf

x = np.random.randint(low=1,high=10,size=10)
y = np.random.randint(low=1,high=10,size=10)

print("Multiply {0} by {1}".format(x,y))

# Each input is a 1x? array/matrix
b = tf.placeholder(tf.int8, [None, ], name='inputx1')
c = tf.placeholder(tf.int8, [None, ], name='inputx2')
sum_op = tf.multiply(b, c, name='mult')

sess = tf.Session()
sess.run(tf.global_variables_initializer())

out = sess.run(sum_op, feed_dict={b: x, c: y})