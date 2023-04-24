# MT Exercise 3: Pytorch RNN Language Models

This repo shows how to train neural language models using [Pytorch example code](https://github.com/pytorch/examples/tree/master/word_language_model). Thanks to Emma van den Bold, the original author of these scripts. 

# Requirements

- This only works on a Unix-like system, with bash.
- Python 3 must be installed on your system, i.e. the command `python3` must be available
- Make sure virtualenv is installed on your system. To install, e.g.

    `pip install virtualenv`

## Alternative (work with Google Colab)
- You do not need to install `virtualenv` if you work with Google Colab

# Steps -- Work with your Terminal or IDE

Clone this repository in the desired place:

    git clone https://github.com/moritz-steiner/mt-exercise-03
    cd mt-exercise-03

Create a new virtualenv that uses Python 3. Please make sure to run this command outside of any virtual Python environment:

    ./scripts/make_virtualenv.sh

**Important**: Then activate the env by executing the `source` command that is output by the shell script above.

Download and install required software:

    ./scripts/install_packages.sh

Download and preprocess data:

    ./scripts/download_data.sh

Train a model:

    ./scripts/train.sh

The training process can be interrupted at any time, and the best checkpoint will always be saved.

Generate (sample) some text from a trained model with:

    ./scripts/generate.sh

# Steps -- Work with Google Colab

Clone this repository in the desired place:

    git clone https://github.com/moritz-steiner/mt-exercise-03
    cd mt-exercise-03

* It is recommended to directly clone it to your Google Drive. 
* If you firstly clone it to your local machine, please upload it to your Google Drive. (This is how we did it because we worked with IDE at first, but switched to Google Colab for training)

**Important**: You want to use the GPU from Colab for the convenience of training. So, let's change the `Runtime type` to GPU.

    Open mt-2023-ex03.ipynb
    Click: Edit -> Notebook settings -> in Hardware accelerator -> Select: GPU
    Run cells in mt-2023-ex03.ipynb
Make sure to adapt the `cd` cell and `cd` to your Google Drive folder where the `mt-exercise-03` is in.

Here is the explanations of the functionality of some cells:

Cell for downloading and installing required software:

    !bash scripts/install_packages.sh

Cell for downloading and preprocessing data:

    !bash scripts/download_data.sh

Cell for training a model:

    !bash scripts/train.sh

The training process can be interrupted at any time, and the best checkpoint will always be saved.

Cell for generating (sample) some text from a trained model with:

    !bash scripts/generate.sh

# Visualization

* Open `ppl_visualization.ipynb` in the directory `scripts`
* Run the cells in it.

# Changes we made in the provided bash scripts
Here is the recording of all the changes we made in the provided bash scripts:

* `install_packages.sh`: unchanged
* `download_data.sh`: 
We made two versions of `download_data.sh` because we first want to have a large dataset, but the large dataset took too long to train for the part 2, so we also made a version for download a small dataset. 
  * `download_data_large.sh`: 
    * We found a dataset from kaggle which listed [1002 short stories from gutenberg](https://www.kaggle.com/datasets/shubchat/1002-short-stories-from-project-guttenberg). We downloaded `db_book.csv` which contains metadata for these short stories, specifically, their unique values. It is stored in the directory `tools`. 
    * In the `download_data_large.sh`,
      1. we loop through each row in the `db_book.csv` to extract the unique value from "number.txt" and make an url for each book.
      2. we download the books using `wget` and concatenate them into one big file.
      3. We follow the provided script to preprocess the big file for short stories slightly.
      4. We preprocess it by tokenization and generating vocabulary of a given vocabulary size.
      5. After preprocessing, we found some duplicates in the big file, so we decided to remove the duplication to avoid the same sentences to be seen during testing or validation.
      6. Last but not least, we split the data into train, test, validation sets by getting the length of the data and divide it by 80%, 10%, 10%.
  * `download_data.sh`:
    * Later we want to work with smaller dataset to make our life easier, so we created this bash which closely followed the provided script.
    * The only change of it is the file path and the url name of the book to be downloaded.

* `train.sh`:
From now on we moved to Google Colab
  * In order to use the GPU from Colab, we deleted the statement of `CUDA_VISIBLE_DEVICES=$device`.
  * We changed the path to the data and for storing the model.
    * Firstly, we trained a LSTM model with our larger dataset and the training epoch is 40. It took 5408s.
    * Secondly, we trained a Transformer model with our larger dataset and the training epoch is 30. It took 3689s.
    * In the end, we trained 5 model with different dropout rates for part 2 with our smaller dataset, using LSTM model, and with 40 epochs.
      * The reason for using LSTM is that after comparing the texts generated by transformer model and LSTM model, we found that even for our larger dataset, it was still too small to use transformer. The text generated by LSTM model is better than the one by transformer.
    
  **Note:** For the part 2 of the exercise, namely training 5 different models using 5 different dropout parameters, we put all the commands for training 5 models in this `train_part2.sh`.

* `generate.sh`
  * As for the `train.sh`, we deleted the `CUDA_VISIBLE_DEVICES=$device` and changed the file path and the model path.
  * We also changed the words to generate from 100 to 1000.

