@@@@@@@
git-FlU
@@@@@@@

.. Contagious Git Config & Commands

A collection of one dev's curated Git config and commands.

#####
USAGE
#####

Poke around the ``.gitconfig``, which is well annotated.

See also each of the scripts under ``bin/``. You're smart enough to figure it out!

#####
SETUP
#####

If you want to blindly install and use all these great aliases and commands,
try something like this::

    # Clone this repo somewhere.
    git clone https://github.com/landonb/git-FlU.git

    # Record the path for symlinks we'll create.
    git_FlU_dir="$(pwd)/git-FlU"

    # Keep your config, which will be sourced after git-FlU's.
    # - If you don't already have a private config, see:
    #     git-FlU/.gitconfig.local.example
    mv ~/.gitconfig ~/.gitconfig.local

    # Wire git-FlU's .gitconfig via symlink.
    cd "${HOME}"
    ln -s "${git_FlU_dir}/.gitconfig"

    # Wire the attributes file for enhanced binary diff.
    cd "${HOME}/.config/git"
    ln -s "${git_FlU_dir}/.config/git/attributes"

    # Sanity check.
    git whoami

#######
CAVEATS
#######

Note: The ``git-extras`` distro package installs its own ``git-undo``,
e.g., at ``/usr/bin/git-undo``.

- You'll want to set your user's ``PATH`` so that ``git-FlU/lib`` is listed
  before ``/usr/bin`` -- if you want the git-FlU script to win.

- git-FlU's ``git undo`` is a ``git reset --soft @~1``, whereas
  git-extras' version is a ``reset --hard``.

  - In git-FlU, the ``--hard`` reset is mapped to ``git rollback``.

    Semantics!

