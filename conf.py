# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

import warnings

warnings.filterwarnings(
    "ignore",
    category=UserWarning,
    message="Matplotlib is currently using agg, which is a"
    " non-GUI backend, so cannot show the figure.",
)

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
# import os
# import sys
# sys.path.insert(0, os.path.abspath('.'))


# -- Project information -----------------------------------------------------

import datetime
#from sphinx_gallery.sorting import ExplicitOrder

project = 'kevbase'
copyright = f'2015-{datetime.date.today().year}, Kevin Anderson'
author = 'Kevin Anderson'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    "myst_nb",
    "ablog",
    "sphinx_design",
    "sphinxcontrib.bibtex",
#    "sphinx_gallery.gen_gallery",
    'IPython.sphinxext.ipython_directive',
    'IPython.sphinxext.ipython_console_highlighting',
    #'sphinxcontrib.images',
    #"sphinxext.opengraph",
]


# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = [
    '_build',
    "**/pandoc_ipynb/inputs/*",
    "examples/README.rst",
    "gallery/*/*[!.rst]",
    "posts/.ipynb_checkpoints/*",
]

suppress_warnings = [
    'ref.citation',  # WARNING: Citation [anderson2013] is not referenced.
]


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'pydata_sphinx_theme'
html_title = 'the kevbase'

html_theme_options = {
  "github_url": "https://github.com/kanderso-nrel/",
  "search_bar_text": "Search this site...",
  #"google_analytics_id": "UA-88310237-1",
  #"search_bar_position": "navbar",
  "navbar_end": ["theme-switcher"],
  "show_toc_level": 2,
  "secondary_sidebar_items": {
    "tools/phase-plotter": [],
  },
}
html_favicon = "_static/favicon.ico"
html_logo = "_static/favicon.png"

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']
html_extra_path = []
html_sidebars = {
    "index": [],
    "publications": ["pubs_profiles.html"],
    "gallery/**": [],
    "blog": ['tagcloud.html', 'archives.html'],
    "posts/**": ['postcard.html', 'recentposts.html', 'archives.html'],
    "photos": ["sidebar-nav-bs.html"],
    "photos/**": ["sidebar-nav-bs.html"],
    "blog/**": [],
    "tools/phase-plotter": [],
}
blog_baseurl = "https://kevbase.com"
blog_title = "kevbase"
fontawesome_included = True
blog_post_pattern = "posts/*"
post_auto_image = 1
post_auto_excerpt = 2
post_date_format="%Y-%m-%d"
#disqus_shortname = "chrisholdgraf"

# Panels config
panels_add_bootstrap_css = False

# MyST config
myst_admonition_enable = True
myst_deflist_enable = True
myst_enable_extensions = ['dollarmath']

# bibtex
bibtex_bibfiles = ['my-publications.bib']

# OpenGraph config
#ogp_site_url = "https://predictablynoisy.com"
#ogp_image = "https://predictablynoisy.com/_static/profile-bw.png"

jupyter_execute_notebooks = "off"

def setup(app):
    app.add_css_file("custom.css")


# settings for sphinx-gallery
#sphinx_gallery_conf = {
#    'examples_dirs': 'examples',  # location of gallery scripts
#    'gallery_dirs': 'gallery',  # location of generated output
#    'subsection_order': ExplicitOrder(['examples/pv',
#                                       'examples/efficiency',
#                                       'examples/circuits',
#                                       'examples/misc']),
#    'filename_pattern': r'.*\.py',
#    'ignore_pattern': r'.*/_.*\.py',  # ignore filenames starting with underscore
#    'download_all_examples': False,
#}

# config for sphinxcontrib-images
images_config = {
    "default_image_height": "100px",
    "default_image_width": "auto",
}
