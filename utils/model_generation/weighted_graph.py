import argparse
import random

from graph import AbstractGraphGenerator

""" add weight to graphs """

class AbstractWeightedGraph(AbstractGraphGenerator): # pas sûr  de la dépendance
    """ Given a graph, generate a weighted graph
    ### TODO if weighted graph, need to check that sum of real data distrib = m 

    """
    def __init__(self, graph, weight_distrib):
        self.graph = graph
        self.weight_distrib = weight_distrib

    def set_weights(self):
        raise NotImplementedError

class FromDataset(AbstractWeightedGraph):
    """ Read real graph weight distribution and generate weights
    """
    def __init__(self, graph, **kwargs):
        self.graph = graph
        self.dataset = kwargs['dataset']

    def _read_dataset(self):
        self.counter = dict()
        with open(self.dataset, 'r') as fin: ## put other option to read gz
            data = fin.readlines()
            for line in data:
                val, weight = line.strip().split()
                self.distribution.append((int(val), int(weight)))
                self.counter[int(val)] = int(weight)


    def _generate_from_distribution(self): 
        ## TODO : otherwise just get counters ... 
        self.weights = np.array((0,))
        for val, weight in self.distribution:
            self.weights = np.concatenate((self.weights, val * np.ones((weight,))), axis=0)

        # then shuffle it
        np.random.shuffle(self.weights)

    def write_graph(self,out_path):

        with open(out_path,'w') as fout:
            for e, val in enumerate(self.time_serie):
                fout.write(f'{time} {val}\n')

