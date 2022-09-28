import networkx as nx
import matplotlib.pyplot as plt


# Simple Two Town graph in networkx

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
G.add_edge(Towns[0], Towns[1])



# Add townspeople to first town( no loop )
G.add_edge(Towns[0], KimberleyTown[0])
G.add_edge(Towns[0], KimberleyTown[1])
G.add_edge(Towns[0], KimberleyTown[2])
G.add_edge(Towns[0], KimberleyTown[3])
G.add_edge(Towns[0], KimberleyTown[4])
G.add_edge(Towns[0], KimberleyTown[5])
G.add_edge(Towns[0], KimberleyTown[6])
G.add_edge(Towns[0], KimberleyTown[7])
G.add_edge(Towns[0], KimberleyTown[8])
G.add_edge(Towns[0], KimberleyTown[9])

# Add townspeople to second town ( with a loop )

for i in range(len(WordenTown)):
    G.add_edge(Towns[1], WordenTown[i])


# Plot graph
fig = plt.figure(0)
fig.canvas.set_window_title('2 Towns')

# added some extra drawing options:

nx.draw(G, with_labels=True, node_size=200, node_color='#A0CBE2',
        horizontalalignment='left', verticalalignment='top',
        font_size=10, font_color='#000000', font_weight='bold',
        font_family='sans-serif')

plt.show()