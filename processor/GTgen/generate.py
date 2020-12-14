import os
import ipdb
import yaml
import shutil
import argparse

import graph
import timeserie
import weighted_graph
#from graph import *
from utils import *

"""
output format
timeserie:
0 1
1573 1
5768 3

graph:
<0-1>,<1-1> 3
<0-1>,<1-2> 2
<0-2>,<2-3> 3

"""

def main():
    parser = argparse.ArgumentParser(description='Graph and Time serie generator')
    parser.add_argument(
        '-y', '--yaml', metavar='config-file', default='./config.yaml',
        help='The YAML configuration file to read.'
        'If not specified, uses ./config.yaml')
    parser.add_argument(
        '-g', '--graph_input', default=None,
        help='Input graph to use for parameters')
    parser.add_argument(
        '-ts', '--timeserie_input', default=None,
        help='Input time serie to use for paramets')
    parser.add_argument(
        '-o', '--output', default='./',
        help='Folder in which output will be written')
    parser.add_argument(
        '--to_console', default=False,
        help='if enabled, write output directly to console (might be useful for piping, might remove...)')
    parser.add_argument(
        '-v', '--verbose', default=False,
        help='Be more verbose')
    args = parser.parse_args()

    config = read_config(args.yaml)
    check_config(config)
    if not os.path.isdir(args.output):
        os.makedirs(args.output)
    if config['Graph']['generate']:
        print('graphing')
        Model = getattr(graph, config['Graph']['params']['model'])
        #generator = Model(**config['Graph']['params']['n'], config['Graph']['params']['p'])
        generator = Model(**config['Graph']['params'])
        generator.run()


        # generate weights from dataset
        weighted = weighted_graph.WeightFromDataset(generator.graph, **config['Graph']['params'])
        weighted.run()
        # todo getparams
        generator.write_graph(os.path.join(args.output, "model.weight"), weighted.weights)

    if config['TimeSerie']['generate']:
        Model = getattr(timeserie, config['TimeSerie']['params']['model'])
        #generator = Model(config['TimeSerie']['params']['duration'], config['TimeSerie']['params']['bound_up'], config['TimeSerie']['params']['bound_down'])
        generator = Model(**config['TimeSerie']['params'])
        generator.run()
        generator.write_TS(os.path.join(args.output, "model.ts"))
    # copy yaml in output folder
    shutil.copyfile(args.yaml, os.path.join( args.output, "benchmark.yaml"))


if __name__ == "__main__":
    main()

