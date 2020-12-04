import argparse

from networkx.generators.random_graphs import gnm_random_graph
from networkit.generators import EdgeSwitchingMarkovChainGenerator, HavelHakimiGenerator, ErdosRenyiGenerator

class AbstractGraphGenerator():
    """ Abstract Class for graph Generators
        Generate a random graph, picked uniformely, given a number of nodes,
        a number of edges, and a degree sequence.
        Attributes:
        -----------
        n : int
            the number of nodes 
        m : int
            the number of edges
        seq : list of int
            the degree sequence

    """
    def __init__(self, **kwargs):
        self.n = None
        self.m = None
        self.seq = None

    def is_realisable():
        raise NotImplementedError

    def write_graph(self,):
        # sort nodes
        for (u, v) in self.graph.iterEdges():
            if u<v :
                print((u,v))
            else:
                print((v,u))

    def run(self):
        raise NotImplementedError

class FromDataset(AbstractGraphGenerator):
    """ Get parameters from real dataset
        Can be plugged in with other models
        
        Attributes:
        -----------
        dataset: str
            path to the input graph, stored as a text files with the following format
                u1 v1 val1
                u2 v2 val2
                u3 v3 val3
                .
                .
                .

            where ui vi is an edge between nodes ui and vi , and val i is the weight of this edge
    """
    def __init__(self, **kwargs):
        self.dataset = kwargs['dataset']
        self.graph = []

    def read_input(self):
        with open(self.dataset, 'r') as fin: ## put other option to read gz
            data = fin.readlines()
            for line in data:
                u_, v_, w_ = line.strip().split()
                u, v, w = int(u), int(v), int(w)
                if u <= v:
                    self.graph.append((u, v, w))
                else:
                    self.graph.append((v, u, w))


class EdgeSwitchingMarkovChain(AbstractGraphGenerator):
    """ Wrapper of Networkit EdgeSwitchingMarkovChainGenerator 
        Also called 'configuration model' in networkit.
        TODO
        Parameters:
        -----------
        degreeSequence : vector[count]
            The degree sequence that shall be generated
        ignoreIfRealizable : bool, optional
            If true, generate the graph even if the degree sequence is not realizable. Some nodes may get lower degrees than requested in the sequence.
    """

    def __init__(self, **kwargs):
        self.sequence = kwargs['seq']
        self.generator = EdgeSwitchingMarkovChainGenerator(self.sequence)
        self.generator.isRealizable()
        self.graph = None

    def run(self):
        self.graph = self.generator.generate()

class HavelHakimi(AbstractGraphGenerator):
    """ Wrapper of Networkit HavelHakimi
        TODO
        Parameters:
        -----------
        sequence : vector
            Degree sequence to realize. Must be non-increasing.
        ignoreIfRealizable : bool, optional
            If true, generate the graph even if the degree sequence is not realizable. Some nodes may get lower degrees than requested in the sequence.
    """

    def __init__(self, **kwargs):
        self.sequence = kwargs['seq']
        self.generator = HavelHakimiGenerator(self.sequence)
        self.graph = None

    def run(self):
        self.graph = self.generator.generate()

class ErdosRenyi(AbstractGraphGenerator):
    """ Wrapper of Networkit ErdosRenyiGenerator
        TODO
        Parameters:
           -----------
           nNodes : count
               Number of nodes n in the graph.
           prob : double
               Probability of existence for each edge p.
           directed : bool
               Generates a directed
           selfLoops : bool
               Allows self-loops to be generated (only for directed graphs)
    """   
    #def __init__(self, n, p):
    def __init__(self, **kwargs):
        self.n = kwargs['n']
        self.p = kwargs['p']
        self.generator = ErdosRenyiGenerator(self.n, self.p, directed = False, selfLoops=False)
        self.graph = None

    def run(self):
        #assert
        self.graph = self.generator.generate()

class GNM(AbstractGraphGenerator):
    """ Wrapper of Networkx gnm_random_graph
    Parameters:
    -----------
        n: int
            number of nodes
        m: int
            number of edges
        seed: int
            random seed
    """
    def __init__(self, **kwargs):
        self.n = kwargs['n']
        self.m = kwargs['m']
        #self.seed = seed if not None else None

    def write_graph(self,):
        for (u, v) in self.graph.edges():
            print((u,v))

    def run(self):
        print(self.n)
        print(self.m)
        self.graph = gnm_random_graph(self.n, self.m, seed=None, directed=False)
