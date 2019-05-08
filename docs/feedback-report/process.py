"""
Convert the data to org, to read the entries more easily, and to export to a revealjs presentation with Emacs
Prints to standard output (STDOUT), redirect the stream to a file to save it, e.g. python3 process.py > out.org
"""
import csv
import os
from pprint import pprint

def parse_csv_from_file(path=""):
    """
    Returns a list of OrderedDict instances, one for each row in the csv file
    """
    if path == '' or not os.path.splitext(path)[1] == '.csv':
        return []
    content = []
    with open(path) as csv_file:
        reader = csv.DictReader(csv_file)
        for row in reader:
            content.append(row)
    return content


class OrgDocument:
    """
    Basic representation of an org document, with a name, a description, and a list of OrgTree instances
    """
    def __init__(self, title="", description="", author="", trees=[]):
        self.title = title
        self.description = description
        self.author = author
        self.trees = trees

    def add_child(self, node):
        assert isinstance(node, OrgTree)
        self.trees.append(node)

    def add_children(self, node_list=[]):
        for node in node_list:
            self.add_child(node)

    def __str__(self):
        text = ""
        if self.title:
            text += "#+TITLE: {}\n".format(self.title)
        if self.description:
            text += "#+DESCRIPTION: {}\n".format(self.description)
        if self.author:
            text += "#+AUTHOR: {}\n".format(self.author)
        text += "\n"
        for tree in self.trees:
            text += str(tree)
        return text


class OrgTree:
    """
    Holds one branch of an org document, starting from a level 1 heading, including all subtrees
    """
    def __init__(self, name="", content="", children=[], start_level=-1):
        self.name = name
        self.content = content
        self.level = start_level if start_level != -1 else 1
        self.parent = None
        self.children = []
        if children != []:
            for node in children:
                self.add_child(node)

    def add_child(self, node):
        """
        Adds and stores a subheading
        """
        assert isinstance(node, OrgTree)
        self.children.append(node)
        node.parent = self

    def add_children(self, node_list=[]):
        for node in node_list:
            self.add_child(node)

    def get_child_count(self):
        return len(self.children)

    @property
    def parent(self):
        return self.__parent

    @parent.setter
    def parent(self, node):
        if node is None:
            self.level = 1
            return
        self.__parent = node
        self.update_level()

    def update_level(self):
        if not self.parent:
            self.level = 1
        self.level = self.parent.level + 1
        for child in self.children:
            child.update_level()

    def as_string(self):
        heading = "*" * self.level + " " + self.name
        string = heading + "\n" * 2
        if self.content:
            string += self.content + "\n" * 2
        for child in self.children:
            string += child.as_string()
        return string

    def __str__(self):
        return self.as_string()


class FormAnswers:
    """
    Data container for form answers, splits the OrderedDict into 5 dictionaries
    """
    def __init__(self, answers, name=""):
        """
        answers: OrderedDict
        """
        self.name = name
        self.profile = {
            'gamedev': answers['gamedev'],
            'dev': answers['dev'],
            'godot': answers['godot'],
            'assignements': answers['assignments'],
            'topics': answers['topics']}
        self.expectations = {
            'expectations': answers['expectations'],
            'struggles': answers['struggles']}
        self.tutorials = {
            'tutorial_disliked': answers['tutorial_disliked'],
            'tutorial_liked': answers['tutorial_liked']}
        self.improve = answers['improve']
        self.comments = answers['comments']

    def as_tree(self):
        """
        Returns the data as an Org tree with subtrees
        """
        main_tree = OrgTree(self.name)
        subtrees = []

        # Profile
        profile = OrgTree("Profile")

        profile.content += "- Gamedev: " + self.profile['gamedev'] + "\n"
        profile.content += "- Development: " + self.profile['dev'] + "\n"
        profile.content += "- Godot: " + self.profile['godot'] + "\n"

        assignments_string = ""
        if self.profile['assignements'].lower() == "yes":
            assignments_string = "Wants"
        elif self.profile['assignements'].lower() == "maybe":
            assignments_string = "May want"
        else:
            assignments_string = "Doesn't want"
        if assignments_string:
            profile.content += "- {} assignements \n".format(assignments_string)

        interests_string = ""
        for interest in self.profile['topics'].split(';'):
            interests_string += "  + {}\n".format(interest)
        if interests_string:
            profile.content += "- Interested in \n" + interests_string[:-1]
        subtrees.append(profile)

        # Expectations
        expectations = OrgTree("Expectations")
        wishes = OrgTree("Wishes")
        wishes.content = self.expectations['expectations']
        if wishes.content:
            expectations.add_child(wishes)
        struggles = OrgTree("Struggles")
        struggles.content = self.expectations['struggles']
        if struggles.content:
            expectations.add_child(struggles)
        if expectations.get_child_count() > 0:
            subtrees.append(expectations)

        # Tutorials
        tutorials = OrgTree("Tutorials")

        liked_most = OrgTree("Most Liked")
        liked_most.content = self.tutorials['tutorial_liked']
        if liked_most.content:
            tutorials.add_child(liked_most)

        liked_least = OrgTree("Least Liked")
        liked_least.content = self.tutorials['tutorial_disliked']
        if liked_least.content:
            tutorials.add_child(liked_least)

        if tutorials.get_child_count() > 0:
            subtrees.append(tutorials)

        # Improve and Comments
        improve = OrgTree("How can we improve?", self.improve)
        if improve.content:
            subtrees.append(improve)

        comments = OrgTree("Anything else?", self.comments)
        if comments.content:
            subtrees.append(comments)

        main_tree.add_children(subtrees)
        return main_tree

if __name__ == '__main__':
    data_list = parse_csv_from_file("data.csv")
    document = OrgDocument("Godot course 2: backers feedback", "Processed and filtered data from the backers' feedback on the course's form, converted to org mode to read more easily and export to revealjs", "Nathan Lovato")
    counter = 1
    for row in data_list:
        answer = FormAnswers(row, name=str(counter).zfill(3))
        tree = answer.as_tree()
        if tree.get_child_count() == 1:
            continue
        document.add_child(tree)
        counter += 1
    print(document)

