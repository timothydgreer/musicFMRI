import argparse
import numpy as np
import csv

# model_type is a string indicating what prefix should be added to the default filename
def params_setup(model_type):
    parser = argparse.ArgumentParser()
    parser.add_argument('--attention_len', type=int, default=40)
    parser.add_argument('--data_set', type=str, default='none')
    parser.add_argument('--horizon', type=int, default=40)
    parser.add_argument('--output_filename', type=str, default="none")
    parser.add_argument('--variable_threshold', type=float, default=0.5)
    parser.add_argument('--time_snip', type=int, default=0) # seconds to snip from beginning
    parser.add_argument('--test_set_at_beginning', type=bool, default=False) # Test Set at Beginning or End
    parser.add_argument('--show_plots', type=bool, default=False)
    parser.add_argument('--sample_rate', type=int, default=40) # sample rate in Hz


    para = parser.parse_args()

    assert para.data_set is not "none", "You must specify a data_set in the arguments! (Should be a path to a .csv file)"
    if para.output_filename == "none":
        para.output_filename = "./results/"+model_type+"_"+para.data_set+"_al_"+(str)(para.attention_len)+"_h_"+(str)(para.horizon)+".txt"
        print("Warning: output_filename not specified in arguments. Defaulting to "+para.output_filename)

    return para

def load_data(para):
    # Load X
    with open(para.data_set, 'r') as f:
        reader = csv.reader(f)
        your_list = list(reader)

    X = np.array(your_list, dtype=np.float)

    # Load y (y will be first column in X)
    y = X[:, 0]
    X = X[:, 1:]


    # Snip out first time_snip secs
    X_cut = X[para.sample_rate * para.time_snip:]
    y_cut = y[para.sample_rate * para.time_snip:]

    return (X_cut, y_cut)
