#! /bin/bash

scripts=$(dirname "$0")
base=$scripts/..

data=$base/data

mkdir -p $data

tools=$base/tools

# link default training data for easier access

# mkdir -p $data/wikitext-2
# 
# for corpus in train valid test; do
#     absolute_path=$(realpath $tools/pytorch-examples/word_language_model/data/wikitext-2/$corpus.txt)
#     ln -snf $absolute_path $data/wikitext-2/$corpus.txt
# done
# 
# # download a different interesting data set!
# 
# mkdir -p $data/grimm
# 
# mkdir -p $data/grimm/raw
# 
# wget https://www.gutenberg.org/files/52521/52521-0.txt
# mv 52521-0.txt $data/grimm/raw/tales.txt
# 
# # preprocess slightly
# 
# cat $data/grimm/raw/tales.txt | python $base/scripts/preprocess_raw.py > $data/grimm/raw/tales.cleaned.txt
# 
# # tokenize, fix vocabulary upper bound
# 
# cat $data/grimm/raw/tales.cleaned.txt | python $base/scripts/preprocess.py --vocab-size 5000 --tokenize --lang "en" --sent-tokenize > \
#     $data/grimm/raw/tales.preprocessed.txt
# 
# # split into train, valid and test
# 
# head -n 440 $data/grimm/raw/tales.preprocessed.txt | tail -n 400 > $data/grimm/valid.txt
# head -n 840 $data/grimm/raw/tales.preprocessed.txt | tail -n 400 > $data/grimm/test.txt
# tail -n 3075 $data/grimm/raw/tales.preprocessed.txt | head -n 2955 > $data/grimm/train.txt
#  


##********* download our own interesting data set!  **********##

mkdir -p $data/stories

mkdir -p $data/stories/raw

touch "$data/stories/raw/stories.txt"

# Input CSV file path for getting file names of short stories from gutenberg.
csv_file=$tools/db_books.csv

# Output concatenated short stories 
cat_files=$data/stories/raw/stories.txt 

# Loop through each row in the CSV file
while IFS=',' read -r bookno _; do
	# Extract the book number from the CSV row
	bookno=$(echo "$bookno" | awk -F',' '{print $1}')
	if [[ $bookno == *-* ]]; then
		# Extract the number part from "number.txt"
		number=$(echo "$bookno" | cut -d'-' -f1)
	else
		number=$(echo "$bookno" | cut -d'.' -f1)
	url="https://www.gutenberg.org/files/$number/$bookno"
	
	fi
	# Download the file using wget
	wget "$url" -O - >> "$cat_files"
	
done < "$csv_file"

echo "All files downloaded and concatenated successfully to $cat_files"

preprocess slightly

cat $data/stories/raw/stories.txt $data/grimm/raw/tales.txt $data/fairy_tales.txt| python $base/scripts/preprocess_raw.py > $data/stories/raw/stories.cleaned.txt

# tokenize, fix vocabulary upper bound

cat $data/stories/raw/stories.cleaned.txt | python $base/scripts/preprocess.py --vocab-size 10000 --tokenize --lang "en" --sent-tokenize > \
    $data/stories/raw/stories.preprocessed.txt

There are many duplicate in the data, we decide to remove them.
awk '!seen[$0]++' $data/stories/raw/stories.preprocessed.txt > $data/stories/raw/stories.unipreprocessed.txt

split into train, valid and test
# If we want to shuffle the sentences:
sort --random-sort $data/stories/raw/stories.preprocessed.txt | uniq > $data/stories/raw/stories.shuffled.txt

total_lines=$(wc -l < $data/stories/raw/stories.unipreprocessed.txt)
valid_lines=$((total_lines * 10 / 100))
test_lines=$((total_lines * 20 / 100))
train_lines=$((total_lines - test_lines))

head -n $valid_lines $data/stories/raw/stories.unipreprocessed.txt > $data/stories/valid.txt
head -n $test_lines $data/stories/raw/stories.unipreprocessed.txt | tail -n $valid_lines > $data/stories/test.txt
tail -n $train_lines $data/stories/raw/stories.unipreprocessed.txt > $data/stories/train.txt
