#! /usr/bin/env python

import numpy as np
import tensorflow as tf

# Embedding 10 x 5
vocabulary_size = 10  # Samples / raw data
embed_size = 5        # actual unique items in the data set

init_embeds = tf.random_uniform([vocabulary_size, embed_size], -1.0, 1.0, name='Initial_Embeds')
embeddings = tf.Variable(init_embeds)

init = tf.initialize_all_variables()

with tf.Session() as sess:
    sess.run(init)
    e = sess.run(embeddings)
    print(e)
