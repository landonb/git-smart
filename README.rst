@@@@@@@@@
git-smart
@@@@@@@@@

.. Contagious Git Config & Commands

A collection of one dev's curated Git config and commands.

#####
USAGE
#####

Poke around the ``.gitconfig``, which is well annotated, to find most
of the features.

You'll find more complicated commands under ``bin/``.

And there's a ``git`` wrapper at ``lib/git_safe.sh``, if you'd
like to be prompted when running destructive Git operations.

#####
SETUP
#####

If you trust what you see and want to install and use all these
great aliases and commands, try something like this::

    # Clone this repo somewhere.
    git clone https://github.com/landonb/git-smart.git

    # Record the path for symlinks we'll create.
    git_smart_dir="$(pwd)/git-smart"

    # Keep your config, which will be sourced after git-smart's.
    # - If you don't already have a private config, see:
    #     git-smart/.gitconfig.local.example
    mv ~/.gitconfig ~/.gitconfig.local

    # Wire git-smart's .gitconfig via symlink.
    cd "${HOME}"
    ln -s "${git_smart_dir}/.gitconfig"

    # Wire the attributes file for enhanced binary diff.
    cd "${HOME}/.config/git"
    ln -s "${git_smart_dir}/.config/git/attributes"

    # Wire a `git init` template to be deliberate about the default branch name.
    # (In lieu of running `git init && git co -b 'release'`.)
    mkdir "${HOME}/.config/git/template"
    cd "${HOME}/.config/git/template"
    # Edit HEAD to set a different default branch name, then copy it.
    /bin/cp "${git_smart_dir}/.config/git/template/HEAD" .

    # Reality check.
    git whoami

#######
CAVEATS
#######

Note: The ``git-extras`` distro package installs its own ``git-undo``,
e.g., at ``/usr/bin/git-undo``.

- You'll want to set your user's ``PATH`` so that ``git-smart/lib`` is listed
  before ``/usr/bin`` -- if you want the git-smart script to win.

- git-smart's ``git undo`` is a ``git reset --soft @~1``, whereas
  git-extras' version is a ``reset --hard``.

  - In git-smart, the ``--hard`` reset is aliased from ``git rollback``.

    Semantics!

#######
RELATED
#######

- Git-smart, this project:

    `https://github.com/landonb/git-smart#💡
    <https://github.com/landonb/git-smart#💡>`__

- The Veggie Patch, an interactive rebase hook:

    `https://github.com/landonb/git-veggie-patch#🥦
    <https://github.com/landonb/git-veggie-patch#🥦>`__

- My Merge Status, a beautiful, super-charged status command:

   `https://github.com/landonb/git-my-merge-status#🌵
   <https://github.com/landonb/git-my-merge-status#🌵>`__

- Awesome suite of powerful Git commands:

  `https://github.com/tj/git-extras
  <https://github.com/tj/git-extras>`__

