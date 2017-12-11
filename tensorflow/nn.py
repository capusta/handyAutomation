#! /usr/bin/env python
learning_rate = 0.5
epochs = 10
batch_size = 100

# Random array of 20
x = tf.placeholder(tf.float32, [None, 20])
# Classifier with 5-space placeholder
y = tf.placeholder(tf.float32, [None, 5])

# One hidden layer ... x->H (with 8 neurons)
W1 = tf.Variable(tf.random_normal([20, 8], stddev=0.03), name='W1')
# H1 corresponding weights
b1 = tf.Variable(tf.random_normal([8], name='b1')

# Second layer  H->Y
W2 = tf.Variable(tf.random_normal([8, 5], stddev=0.03  name='W2')
b2 = tf.Variable(tf.random_normal([5], name='b2')
