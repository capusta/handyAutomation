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


def save_vocab(outfilename):
    # the text to be classified
    vocab_processor = tf.contrib.learn.preprocessing.VocabularyProcessor(MAX_DOC_LENGTH)
    vocab_processor.fit(LINES)

    with gfile.Open(outfilename, 'wb') as f:
        f.write("{}\n".format(PADWORD))
        for w, i in vocab_processor.vocabulary_._mapping.iteritems():
            f.write("{}\n".format(w))
    NWORDS = len(vocab_processor.vocabulary_)
    print('Vocab length: {}, File: {}'.format(NWORDS, outfilename))

def load_vocab(infilename):
    table = lookup.index_table_from_file(
        vocabulary_file=infilename, num_oov_buckets=1, vocab_size=None, default_value=-1)
    numbers = table.lookup(tf.constant('quick fox'.split()))
    with tf.Session() as sess:
        tf.tables_initializer().run()
        print "{} --> {}".format(LINES[0], numbers.eval())


save_vocab('model.tfmodel')
load_vocab('model.tfmodel')
