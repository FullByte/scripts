from aitextgen.TokenDataset import TokenDataset
from aitextgen.tokenizers import train_tokenizer
from aitextgen.utils import GPT2ConfigCPU
from aitextgen import aitextgen
import os

# The name of the downloaded Shakespeare text for training
file_name = os.path.dirname(__file__) + "../../_data/input.txt"

# Train a custom BPE Tokenizer on the downloaded text
# This will save two files: aitextgen-vocab.json and aitextgen-merges.txt,
# which are needed to rebuild the tokenizer.
train_tokenizer(file_name)
vocab_file = "aitextgen-vocab.json"
merges_file = "aitextgen-merges.txt"

# GPT2ConfigCPU is a mini variant of GPT-2 optimized for CPU-training
# e.g. the # of input tokens here is 64 vs. 1024 for base GPT-2.
config = GPT2ConfigCPU()

# Instantiate aitextgen using the created tokenizer and config
ai = aitextgen(vocab_file=vocab_file, merges_file=merges_file, config=config)

# You can build datasets for training by creating TokenDatasets,
# which automatically processes the dataset with the appropriate size.
data = TokenDataset(file_name, vocab_file=vocab_file, merges_file=merges_file, block_size=64)

# Train the model! It will save pytorch_model.bin periodically and after completion.
# On a 2016 MacBook Pro, this took ~25 minutes to run.
ai.train(data, batch_size=16, num_steps=5000)

# Generate text from it!
ai.generate(10, prompt="ROMEO:")