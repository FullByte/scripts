import networkx as nx # pip install networkx
import matplotlib.pyplot as plt # pip install matplotlib

# Basic Example for networkx

# Init A Graph in networkx
G = nx.Graph()

# Add Single Node:
G.add_node(1)
# Add multiple nodes:
G.add_nodes_from([2, 3, 4, 5])


# Add Edges:
G.add_edge(1, 2)
# Add multiple edges:
# G.add_edges_from([(1, 3), (2, 4)])

# NODES
print("EDGES:", G.edges(), '# EDGES:', G.number_of_edges())
print("NODES:", G.nodes(), '# NODES:', G.number_of_nodes())

# Plot graph
fig = plt.figure(0)
fig.canvas.set_window_title('Networkx Graph')
nx.draw(G, with_labels=True)
plt.show()