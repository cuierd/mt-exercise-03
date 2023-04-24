#! /bin/bash

scripts=$(dirname "$0")
base=$(realpath $scripts/..)

models=$base/models
data=$base/data
tools=$base/tools

mkdir -p $models

num_threads=4
device=""

SECONDS=0

(cd $tools/pytorch-examples/word_language_model &&
    OMP_NUM_THREADS=$num_threads python main_ppl.py --data $data/new \
        --epochs 40 \
        --log-interval 100 \
        --emsize 200 --nhid 200 --dropout 0.0 --tied \
        --save $models/model00.pt \
        --cuda \
        --save-ppl $models/ppls00.csv
)

echo "time taken:"
echo "$SECONDS seconds"

(cd $tools/pytorch-examples/word_language_model &&
    OMP_NUM_THREADS=$num_threads python main_ppl.py --data $data/new \
        --epochs 40 \
        --log-interval 100 \
        --emsize 200 --nhid 200 --dropout 0.2 --tied \
        --save $models/model02.pt \
        --cuda \
        --save-ppl $models/ppls02.csv
)

echo "time taken:"
echo "$SECONDS seconds"

(cd $tools/pytorch-examples/word_language_model &&
    OMP_NUM_THREADS=$num_threads python main_ppl.py --data $data/new \
        --epochs 40 \
        --log-interval 100 \
        --emsize 200 --nhid 200 --dropout 0.4 --tied \
        --save $models/model04.pt \
        --cuda \
        --save-ppl $models/ppls04.csv
)

echo "time taken:"
echo "$SECONDS seconds"

(cd $tools/pytorch-examples/word_language_model &&
    OMP_NUM_THREADS=$num_threads python main_ppl.py --data $data/new \
        --epochs 40 \
        --log-interval 100 \
        --emsize 200 --nhid 200 --dropout 0.6 --tied \
        --save $models/model06.pt \
        --cuda \
        --save-ppl $models/ppls06.csv
)

echo "time taken:"
echo "$SECONDS seconds"

(cd $tools/pytorch-examples/word_language_model &&
    OMP_NUM_THREADS=$num_threads python main_ppl.py --data $data/new \
        --epochs 40 \
        --log-interval 100 \
        --emsize 200 --nhid 200 --dropout 0.8 --tied \
        --save $models/model08.pt \
        --cuda \
        --save-ppl $models/ppls08.csv
)

echo "time taken:"
echo "$SECONDS seconds"

