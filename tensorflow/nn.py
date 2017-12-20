#! /usr/bin/env python

import tensorflow as tf
import numpy as np
import sys

learning_rate = 0.5
epochs = 10

x = tf.placeholder(tf.float32, [None, 20])
# Classifier with 5-space placeholder
y = tf.placeholder(tf.float32, [None, 5])

# One hidden layer ... x->H (with 8 neurons) and biases
W1 = tf.Variable(tf.random_normal([20, 8], stddev=0.03), name='W1')
b1 = tf.Variable(tf.random_normal([8]), name='b1')

# Second layer  H->Y
W2 = tf.Variable(tf.random_normal([8, 5], stddev=0.03), name='W2')
b2 = tf.Variable(tf.random_normal([5]), name='b2')

# Multipply input by weights, add biases
H = tf.add(tf.matmul(x, W1), b1)
# Activate the neurons
H = tf.nn.relu(H)

# Set up the output
y_ = tf.nn.softmax(tf.add(tf.matmul(H, W2), b2))
# clip the output
y_clipped = tf.clip_by_value(y_, 1e-10, 0.9999999)

cross_entropy = -tf.reduce_mean(tf.reduce_sum(y * tf.log(y_clipped)
                         + (1 - y) * tf.log(1 - y_clipped), axis=1))

# General optimizer for the cost function
optimiser = tf.train.GradientDescentOptimizer(learning_rate=learning_rate).minimize(cross_entropy)

init_op = tf.global_variables_initializer()

correct_prediction = tf.equal(tf.argmax(y,1), tf.argmax(y_,1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

with tf.Session() as sess:
  sess.run(init_op)
  for epoch in range(epochs):
    avg_cost = 0
    x_raw = np.random.randint(low=1, high=60, size=20)
    y_raw = np.random.randint(low=0, high=2, size=5)
