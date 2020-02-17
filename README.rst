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

