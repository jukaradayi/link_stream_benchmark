import argparse


def timeserieParser(subparsers):
    parser = subparsers.add_parser(
        'model',
        description='Generate a configuration for features extraction, '
        "have a 'speech-features --help' for more details",
        epilog=epilog,
        formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument(
        '-o', '--output', metavar='config-file', default=None,
        help='The YAML configuration file to write. '
        'If not specified, write to stdout')


    raise NotImplementedError

def graphParser(subparsers):
    parser = subparsers.add_parser(
        'model',
        description='Generate a configuration for features extraction, '
        "have a 'speech-features --help' for more details",
        epilog=epilog,
        formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument(
        '-o', '--output', metavar='config-file', default=None,
        help='The YAML configuration file to write. '
        'If not specified, write to stdout')

    raise NotImplementedError

def parser_config(subparsers, epilog):
    """Initialize options for 'speech-features config'"""
    parser = argparse.ArgumentParser(description='Process some integers.')

    parser.add_argument(
        '-i', '--input', metavar='config-file', default=None,
        help='The YAML configuration file to read. '
        'If not specified, write to stdout')

    args = parser.parse_args()    

def main():


if __name__ == "__main__":
    main()

