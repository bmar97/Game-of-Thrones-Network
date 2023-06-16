# GAME OF THRONES
### NAMED ENTITY RECOGNITION NETWORK

Extract relationships between Game of Thrones Characters found from webScraping the offical wikipedia site. Through graph analyses (centrality measures/community detection) and visualization, Pyvis, analyze the relationships between characters


### ETL using Selenium webscraper
To find the relationships between characters within the Game of Thrones Series we will build relationship dataframes for all 5 books and extract the communities within them.

1. We begin by cleaning our character list dataFrame found from [scraping](https://github.com/bmar97/Game-of-Thrones-NueralNet/blob/main/WebScraper_ETL.ipynb) the official Game of Thrones characters [Wiki](https://en.wikipedia.org/wiki/List_of_Game_of_Thrones_characters). Making sure to adjust the first and last name's of characters to apropriate aliases and nicknames before parsing the [books](https://github.com/bmar97/Game-of-Thrones-Network/tree/main/data).
- ("Samwell, Samwell Tarly --> Sam, Sam Tarly") 

2. Using Spacy, an open-source software library for advanced natural language processing, we obtain a list of entites per sentence in every book and store them in a dataframe. Then, filter out non-character entities:
![My Image](https://github.com/bmar97/Game-of-Thrones-NueralNet/blob/main/images/book_filter.png?raw=true)

3. Create a relationship dictionary based on the dataframe containing lists of chracters per sentence and a 5 sentence window size. We then transform the newly created relationship dictionary into pd DF and find weight of each relationship for all characters:

| Source| Target | Weight |
| :--- | :--- | :---: |
| Davos | Stannis | 302 |
| Joffrey | Sansa | 294 |
| Jon | Sam | 271 |
| Arya | Gendry | 229 |
| Arya | Yordan | 218 |

4. Using Pyvis, a python library that allows you to create interactive network graphs, we create a graph from a pandas dataframe and set node size to be indicitive of the relationship's assoicated weight. Each graph can be filtered by character name to see their surrounding communities
![My Image](https://github.com/bmar97/Game-of-Thrones-NueralNet/blob/main/images/pyvis_demo.png?raw=true)


### **Pyvis Demo**
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/bmar97/Game-of-Thrones-NueralNet/HEAD?labpath=Pyvis_Graph_Demo.ipynb)
### Community found through centrality 
Community detection methods are designed to locate communities based on network structure, such as strongly connected groupings of nodes; however, they often ignore node properties. Due to this we introduce degree, betweeness, and closeness centrality measures.
- The Degree centrality of a node is simply its degree—the number of edges it has. The higher the degree, the more central the node is.
- Betweenness centrality is a way of detecting the amount of influence a node has over the flow of information in a graph. It is often used to find nodes that serve as a bridge from one part of a graph to another.
- Closeness centrality is a useful measure that estimates how fast the flow of information would be through a given node to other nodes. Closeness centrality measures how short the shortest paths are from node i to all nodes.
![My Image](https://github.com/bmar97/Game-of-Thrones-NueralNet/blob/main/images/pyvisCD_demo.png?raw=true)


### **Pyvis Demo**
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/bmar97/Game-of-Thrones-NueralNet/HEAD?labpath=Community_Detecion.ipynb)
### A look at the data: Book1
Now let's take the top 15 nodes for each measure of centrality to asses how balanced the book is relative to our measures

Degree Centrality - Most connected characters
![alt text](https://github.com/bmar97/Game-of-Thrones-NueralNet/blob/main/images/degree_centrality.png?raw=true)

Betweenness Centrality - Most influential characters 
![alt text](https://github.com/bmar97/Game-of-Thrones-NueralNet/blob/main/images/betweenness_centrality.png?raw=true)

Closeness Centrality - Most central characters
![alt text](https://github.com/bmar97/Game-of-Thrones-NueralNet/blob/main/images/closeness_centrality.png?raw=true)

### Most Central Characters Over Time
Let's now take a look at the top 5 most cetnral characters with respect to each centrality measure from book1, (0,y), through book5, (4,y)
- x axis: time
- y axis: centrality measure

Degree Centrality - Most connected characters
![alt text](https://github.com/bmar97/Game-of-Thrones-NueralNet/blob/main/images/degree_ovt.png?raw=true)

Betweenness Centrality - Most influential characters
![alt text](https://github.com/bmar97/Game-of-Thrones-NueralNet/blob/main/images/betweenness_ovt.png?raw=true)

Closeness Centrality - Most central characters
![alt text](https://github.com/bmar97/Game-of-Thrones-NueralNet/blob/main/images/closeness00_ovt.png?raw=true)

### **Pyvis Book Series Demo**
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/bmar97/Game-of-Thrones-NueralNet/main?labpath=Centrality_ovt.ipynb)
## Acknowledgements

 - In every measure of centrality [Jon Snow ](https://en.wikipedia.org/wiki/Jon_Snow_(character)) completes the series as the highest ranked character while [Sansa's](https://en.wikipedia.org/wiki/Sansa_Stark) importance weigned most acrros nearly all measures by the end. As an avid fan it is amusing to see the the ebbs and flows of some of my favorite characters' importance throughout the series reaffirm their value to the story. 

[Documentation](https://github.com/bmar97/Game-of-Thrones-NueralNet/blob/main/code/functions.py)
