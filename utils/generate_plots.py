import os
import argparse
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

def read_distribution(distrib):
    return pd.read_csv(distrib, sep=' ', names=['key', 'values'])

def plot_distribution(df, xlab, ylab, title, basename, log):
    #plt.plot(df['key'], df['values'])
    if log:
        plt.loglog(df['key'], df['values'], 'x')
    else:
        plt.plot(df['key'], df['values'])
    plt.xlabel(xlab)
    plt.ylabel(ylab)
    plt.title(title)
    plt.savefig(basename + '.eps', format='eps')
    plt.clf()

def main():
    parser = argparse.ArgumentParser(
            description='Graph and Time serie plot')
    parser.add_argument(
        'folder', 
        help='The folder containing the distributions')
    parser.add_argument(
        'basename',
        help='The basename of the dataset. Will infer filenames from that')
    args = parser.parse_args()
    
    # Read Weight Distribution
    print('plotting weight')
    df = read_distribution(os.path.join(args.folder, args.basename + '.weight.d'))
    plot_distribution(df, 'weight', 'number of occurence', 'weight distribution', args.basename + '.weight', True)

    # Read Timeserie
    print('plotting timeserie')
    df = read_distribution(os.path.join(args.folder, args.basename + '.ts'))
    plot_distribution(df, 'timestamps', 'number of interactions', 'timeserie', args.basename + '.ts', False)

    # Read Timeserie
    print('plotting timeserie distribution')
    df = read_distribution(os.path.join(args.folder, args.basename + '.ts.d'))
    plot_distribution(df, 'timeserie value', 'number of occurence', 'timeserie distribution', args.basename + '.ts.d', True)

    # Read Degree sequence and generate degree distribution
    print('plotting degree')
    df = read_distribution(os.path.join(args.folder, args.basename + '.deg'))
    df_distrib = df['values'].value_counts()
    to_plot = {'key': df_distrib.keys(), 'values': df_distrib.values}
    plot_distribution(to_plot, 'degree', 'number of occurence', 'degree distribution', args.basename + '.degree', True)


if __name__ == "__main__":
    main()


