import networkx as nx
import matplotlib.pyplot as plt

# Extract all simple paths from
# one town to another and calculate
# some basic statistics. 


# Init A Graph in networkx
G = nx.Graph()

# Townspeople and towns
KimberleyTown = ['Alice', 'Bob', 'Cathy', 'Dan',
                 'Ed', 'Fred', 'Gail', 'Hal', 'Ike', 'John']
WordenTown = ['Kim', 'Liz', 'Mike', 'Ned', 'Olivia',
              'Pete', 'Quinn', 'Ralph', 'Sally', 'Ted', 'Uma']
Towns = ['KimberleyTown', 'WordenTown']


# Add nodes to graph from twoTowns
G.add_node(Towns[0])
G.add_node(Towns[1])
# The road connecting two towns
G.add_edge(Towns[0], Towns[1], weight=2)


G.add_edge(Towns[0], KimberleyTown[0], weight=1)
G.add_edge(Towns[0], KimberleyTown[1], weight=1)
G.add_edge(KimberleyTown[0], KimberleyTown[2], weight=1)
G.add_edge(KimberleyTown[1], KimberleyTown[3], weight=1)
G.add_edge(KimberleyTown[2], KimberleyTown[4], weight=1)
G.add_edge(KimberleyTown[2], KimberleyTown[5], weight=1)
G.add_edge(KimberleyTown[3], KimberleyTown[6], weight=1)
G.add_edge(KimberleyTown[3], KimberleyTown[7], weight=1)
G.add_edge(KimberleyTown[7], KimberleyTown[8], weight=1)
G.add_edge(KimberleyTown[6], KimberleyTown[9], weight=1)


G.add_edge(Towns[1], WordenTown[0], weight=1)
G.add_edge(Towns[1], WordenTown[1], weight=1)
G.add_edge(WordenTown[0], WordenTown[2], weight=1)
G.add_edge(WordenTown[1], WordenTown[3], weight=1)
G.add_edge(WordenTown[2], WordenTown[4], weight=1)
G.add_edge(WordenTown[2], WordenTown[5], weight=1)
G.add_edge(WordenTown[3], WordenTown[6], weight=1)
G.add_edge(WordenTown[3], WordenTown[7], weight=1)
G.add_edge(WordenTown[4], WordenTown[8], weight=1)
G.add_edge(WordenTown[5], WordenTown[9], weight=1)
G.add_edge(WordenTown[5], WordenTown[10], weight=1)


# Plot graph
fig = plt.figure(0)
fig.canvas.set_window_title('2 Towns')

# Set position of nodes, alos used for labels
pos = nx.spring_layout(G, seed=123)


nx.draw(G, with_labels=True, node_size=200, node_color='#A0CBE2',
        # horizontalalignment='left', verticalalignment='top',
        font_size=10, font_color='#000000', font_weight='bold',
        font_family='sans-serif', pos=pos)


labels = nx.get_edge_attributes(G, 'weight')
# draw edge data
nx.draw_networkx_edge_labels(G, pos=pos, edge_labels=labels)


# get all paths between each townsperson

# List to store path costs
pathCosts = []

# Let's jsut do one town to another for now
# Extract paths from one town to another

for i in range(len(KimberleyTown)):
    for j in range(len(WordenTown)):
        paths = nx.all_simple_paths(G, KimberleyTown[i], WordenTown[j])
        # get path cost and add to path costs 
        for path in paths:
            # print(path)            
            pathCost = nx.path_weight(G, path, 'weight')
            # print(pathCost)
            pathCosts.append(pathCost)

# Results:

# Total paths:  110
# Max path:  10
# Min path:  4
# Average path:  7.327272727272727

print('Total paths: ', len(pathCosts))
print('Max path: ', max(pathCosts))
print('Min path: ', min(pathCosts))
print('Average path: ', sum(pathCosts)/len(pathCosts))

plt.show()