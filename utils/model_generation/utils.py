import os
import yaml

def check_config(config):
    """ Check consistency of configuration file
    """
    # Graph parameters
    if config['Graph']['params']['model'] == 'ErdosRenyi':
        
        # check that n and p are filled as int ## TODO check positivity
        assert 'n' in config['Graph']['params']
        assert 'p' in config['Graph']['params']
        assert type(config['Graph']['params']['n']) is int
        assert type(config['Graph']['params']['p']) is int   
    elif config['Graph']['params']['model'] == 'GNM': 
        
        # check that n and m are filled as int ## TODO check positivity
        assert 'n' in config['Graph']['params']
        assert 'm' in config['Graph']['params']
        assert type(config['Graph']['params']['n']) is int
        assert type(config['Graph']['params']['m']) is int   
    elif (config['Graph']['params']['model'] == 'HavelHakimi' 
        or config['Graph']['params']['model'] == 'EdgeSwitchingMarkovChain'):
        
            # check that sequence of degree is filled
            ## check all positive integeres
        assert 'seq' in config['Graph']['params']
        assert type(config['Graph']['params']) is list

    ## weighted graph parameters
    if config['Graph']['params']['use_dataset'] is True:
        
        # check dataset path is filled and exists
        assert "dataset" in config['Graph']['params']
        assert os.path.isfile(config['Graph']['params']['dataset'])

        # if dataset_fit set to strict, read weight distribution file and check
        # if number of weights is the same as number of edges or
        # as sum of degree sequence
        if config['Graph']['params']['dataset_fit'] == "stric":
            weights = _read_dataset(config['Graph']['params']['dataset'])
            # get implied number of edges
            n_edges = 0
            for value, count in weights:
                n_edges += count

            if config['Graph']['params']['model'] == 'GNM':
                m = config['Graph']['params']['m']
                assert n_edges == m, f"Dataset weight distribution has {n_edges} edges, but GNM model only requests {m}"
            elif (config['Graph']['params']['model'] == 'HavelHakimi' 
        or config['Graph']['params']['model'] == 'EdgeSwitchingMarkovChain'):
                sum_seq = sum(config['Graph']['params']['seq'])
                assert sum_seq == 2 * n_edges, f"Dataset weight distribution has {n_edges} edges, but degree sequence requests {sum_seq}/2"


    # Timeseries parameters

    # Cross graph - timeseries check

def _read_dataset(self):
        self.counter = dict()
        self.distribution = []
        with open(self.dataset, 'r') as fin: ## put other option to read gz
            data = fin.readlines()
            for line in data:
                val, weight = line.strip().split()
                self.distribution.append((int(val), int(weight)))
                self.counter[int(val)] = int(weight)


