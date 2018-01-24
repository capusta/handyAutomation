#! /usr/bin/env python

import tensorflow as tf
from tensorflow.contrib import lookup
from tensorflow.python.platform import gfile

MAX_DOC_LENGTH = 5
PADWORD = 'ZZZ'

LINES = ['the quick brown fox',
         'quick the fox brown',
         'foo foo bar',
         'baz']


vocab_processor = tf.contrib.learn.preprocessing.VocabularyProcessor(MAX_DOC_LENGTH)
vocab_processor.fit_transform(LINES)

init_op = tf.global_variables_initializer()

with tf.Session() as sess:
    sess.run(init_op)
    sess.run(vocab_processor)

    with gfile.Open('vocab.csv', 'wb') as f:
        f.write("{}".format(PADWORD))
        for w, i in vocab_processor.vocabulary_.mapping.iteritems():
            f.write("{}".format(w))
    NWORDS = len(vocab_processor.vocabulary_)
    print (NWORDS)