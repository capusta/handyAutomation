#! /usr/bin/env python

import tensorflow as tf
import os, sys, argparse
from tensorflow.contrib import lookup
from tensorflow.python.platform import gfile

os.environ['WORKSPACE'] = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
#sys.path[0] = os.environ(['WORKSPACE'])

PADWORD = '###'

LINES = ['the quick brown fox',
         'foo foo bar',
         'quick the fox brown',
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
    v = arguments.pop('vocab', None)
    if v is None:
        return
    print ("Loading Vocabulary {0}".format(v))
    table = lookup.index_table_from_file(
        vocabulary_file=infilename, num_oov_buckets=1, vocab_size=None, default_value=-1)
    numbers = table.lookup(tf.constant('quick fox the not blah blah'.split()))
    with tf.Session() as sess:
        tf.tables_initializer().run()
        print "{} --> {}".format(LINES[0], numbers.eval())

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--vocab',
        help="Use a specific vocab file",
        required=False
    )
    args = parser.parse_args()
    arguments = args.__dict__
    save_vocab('model.tfmodel')
    load_vocab('model.tfmodel')
