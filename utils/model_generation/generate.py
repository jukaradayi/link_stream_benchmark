import yaml
import argparse

def parser():
    """Initialize options for 'speech-features config'"""
    parser = argparse.ArgumentParser(description='Process some integers.')

    parser.add_argument(
        '-i', '--input', metavar='config-file', default=None,
        help='The YAML configuration file to read. '
        'If not specified, write to stdout')


    args = parser.parse_args()    

def read_config(yaml):
    """ Read yaml configuration file """
    assert os.path.isfile(yaml), "input file doesn't exist"
    config = yaml.load(yaml)

    try:
        check_config(config)
        return config
    except Exception as err:
        print("Please fix the following error in configuration file:")
        print(err)
        raise IOError

def check_config(config):
    """ Check consistency of configuration file """
    # graph check
    assert config["Graph"]["params"]["m"] == sum(config["Graph"]["params"]["seq"] ), "Graph : number of edges should be sum of degree sequence"
    assert config["Graph"]["params"]["m"] > 0
    assert config["Graph"]["params"]["n"] > 0

    # timeseries check
    assert config["TimeSerie"]["params"]["duration"] > 0, "TimeSerie: can't generate time serie with duration <0"
    assert config["TimeSerie"]["params"]["bound_up"] >  config["TimeSerie"]["params"]["bound_down"]
    
    # graph TS check 
    ## TODO weights ?!
    # assert config["TimeSerie"]["params"]["cumulative_sum"] == sum(config["Graph"]["params"]["weights"]

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

    if config['Graph']['generate']:
        # todo getparams

    if config['TimeSerie']['generate']:
        # todo getparams

if __name__ == "__main__":
    main()

