import pandas as pd
import numpy as np
import os
import spacy
from spacy import displacy
import networkx as nx

import matplotlib.pyplot as plt



def ner(file_name):
    """""
    Function to process text from a text file (.txt) using Spacy.
    
    Params:
    file_name -- name of txt file as string 
    
    Returns:
    a processed doc file using Spacy English language model 
    
    """"
    # Load spacy English language model
    NER = spacy.load('en_core_web_sm')
    NER.max_length = 2400382
    book_text = open(book).read()
    book_doc = NER(book_text)
    return book_doc



def get_ne_list_per_sentence(spacy_doc):
    """
    Get a list of entites per sentence of a Spacy document and store in a dataframe.
    
    Params:
    spacy_doc -- a Spacy processed document
    
    Returns:
    a dataframe containing the sentences and corresponding list of recognised named entities in the sentences
    """
    
    # Parse book by sentence and store each respective named entity in corresponding dictionary 'key: values'
    sent_entity_df = []

    for sent in book_doc.sents:
        entity_list = [ent.text for ent in sent.ents]
        sent_entity_df.append({"sentence": sent, "entities": entity_list})

    sent_entity_df = pd.DataFrame(sent_entity_df)

    return sent_entity_df



def filter_entity(ent_list, char_df):
    """
    Function to filter out non-character entities.
    
    Params:
    ent_list -- list of entities to be filtered
    character_df -- a dataframe contain characters' names and characters' first names
    
    Returns:
    a list of entities that are characters (matching by names or first names).
    
    """
    return [ent for ent in ent_list
            if ent in list(char_df.characters)
            or ent in list(char_df.character_firstname)]



def create_relationships(df, window_size):
    
    """
    Create a dataframe of relationships based on the df dataframe (containing lists of chracters per sentence) and the  window size of n sentences.
    
    Params:
    df -- a dataframe containing a column called character_entities with the list of chracters for each sentence of a document.
    window_size -- size of the windows (number of sentences) for creating relationships between two adjacent characters in the text.
    
    Returns:
    a relationship dataframe containing 3 columns: source, target, value.
    
    """
    
    # Window size and relationship dictionary instantiation 
    relationships = []

    for i in range(sent_entity_df_filtered.index[-1]):
        end_i = min(i+5, sent_entity_df_filtered.index[-1])
        char_list = sum((sent_entity_df_filtered.loc[i: end_i].character_entities), [])

        # Remove diplicate characters next to each other
        char_unique = [char_list[i] for i in range(len(char_list))
                      if (i == 0) or char_list[i] != char_list[i-1]] 
        if len(char_unique) > 1:
            for idx, a in enumerate(char_unique[:-1]):
                b = char_unique[idx + 1]
                relationships.append({"source": a, "target": b})
           
    # Transform newly created relationship dictionary into pd DF 
    relationship_df = pd.DataFrame(relationships)
    relationship_df = pd.DataFrame(np.sort(relationship_df.values, axis = 1), columns = relationship_df.columns)

    # Find relationship weight of each character and select the first 500 entries 
    relationship_df["value"] = 1 
    relationship_df = relationship_df.groupby(["source","target"], sort=False, as_index=False).sum()
    relationship_df = relationship_df.iloc[:500, :]
                
    return relationship_df