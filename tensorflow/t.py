#! /usr/bin/env python

import tensorflow as tf
from tensorflow.contrib import lookup
from tensorflow.python.platform import gfile

PADWORD = 'ZZZ'

LINES = ['the quick brown fox',
         'quick the fox brown',
         'foo foo bar',
         'baz']

init_op = tf.global_variables_initializer()
MAX_DOC_LENGTH = max([len(L.split(" ")) for L in LINES])
vocab_processor = tf.contrib.learn.preprocessing.VocabularyProcessor(MAX_DOC_LENGTH)
vocab_processor.fit(LINES)

with tf.Session() as sess:
    sess.run(init_op)

    with gfile.Open('vocab.csv', 'wb') as f:
        f.write("{}\n".format(PADWORD))
        for w, i in vocab_processor.vocabulary_._mapping.iteritems():
            f.write("{}\n".format(w))
    NWORDS = len(vocab_processor.vocabulary_)
    print (NWORDS)