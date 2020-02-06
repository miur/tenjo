.. SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq+tenjo@gmail.com>

.. SPDX-License-Identifier: Apache-2.0

#####
tenjo
#####

Tasks enframing journal -- to manage, track and account your goals and progress.

.. note::
   Etymology: "天助" (/tenjo/) -- jp. "help of heavens"

Kind of DPMS -- Distributed Project Management System (consonant: "di-plo-ma-cy" :D),
contrasting to most others centralized project management solutions, like Jira and Trello.

Raison d'être
=============

* Store offline like git -- never lose task history even on your own PC.
* Distribute info like git -- sync repo copies between all your devices.
* Merge conflicts like git -- explicitly decide what to do, only when your descriptions differ.
* Collaborate with others like git -- give everyone his "personal world" (local clone) to live inside with time lag.
* Improve work of others like git -- create independent fork, enhance workflows and share when ready.
* Review and feedback like git -- annotate changes in tasks and their statuses, with same web tools.
* Federate like IRC -- embrace the idea of "person" and "company" are two different and largely incompatible worlds.
  Only *communicate* tasks between them, between their inherent contexts, but don't try to fully embed one into another.

We have all pieces needed to build decent tasks management solution.
If you are hooked, read how is it possible below.


Hierarchy
=========

Top-level dir contains flat list of all current projects.
Avoid nested hierarchy of projects at all costs (but you can nest tasks).
Folder-based task must contain file ``TASK`` -- because you need some standardized
file for description and metadata, and you can't commit to git empty directories anyway.

Create separate folder with symlinks to represent *view* for projects/task grouping.
Create relative symlinks in subtasks to represent dependencies.
Each time you move such dependencies -- earlier created symlinks will break,
but don't panic -- git pre-commit-hook will easily fix them back.

BUT! for this to work automatically -- task MUST be already tracked by git
(committed to history at least once). So, verify task is already committed
before creating symlink (``tenjo`` tool will do this automatically for you).

.. code-block:: bash

   .
   ├── %stability-CW08
   │   ├── new.task          ---> collab-project/new.task (symlink)
   │   └── step4.task        ---> myproject/with-subtasks.task/step4.task (symlink)
   ├── .done
   │   └── old-project
   │       └── a-b-c.task
   ├── collab-project
   │   ├── .cancelled
   │   ├── .done             # can be used to archive whole "@user1" when he is transferred to another project or company
   │   ├── @user1
   │   │   ├── .done
   │   │   │   └── a.task
   │   │   ├── 2020-03-03
   │   │   │   └── planned.task
   │   │   └── today1.task
   │   ├── @user2
   │   │   ├── .done
   │   │   └── current.task
   │   ├── future.task
   │   ├── new.task
   │   ├── nobody.task
   │   └── undistributed.task
   └── myproject
       ├── .done
       │   └── old.task
       ├── simple.task
       ├── with-artifacts.task
       │   ├── TASK
       │   ├── a
       │   └── b
       └── with-subtasks.task
           ├── step1.task
           ├── step2.task    ---> collab-project/@user2/current.task (symlink)
           ├── step3.task
           └── step4.task
               └── TASK

..  print -l .done/old-project/a-b-c.task myproject/{.done/old.task,simple.task,with-artifacts.task/{a,b,TASK},with-subtasks.task/{step{1,2,3}.task,step4.task/TASK}} collab-project/{.cancelled,@user1/{.done/a.task,2020-03-03/planned.task,today1.task},@user2/{.done,current.task},{future,new,nobody,undistributed}.task} %stability-CW08/{new,step4}.task | tree --noreport --fromfile -a | sed 's/^/   /'  Y


USAGE
=====

.. warning::
   Remember! ``tenjo(1)`` implementation is nothing more than "convenient and efficient tool".
   You can manage tasks fully manually by using only ``git(1)`` and your favorite **file manager**.

Install ``tenjo``, create convenient alias for yourself, and register ``pre-commit`` hook in git main tasks-repo:

.. code-block:: bash

   sudo make install  # OR: sudo checkinstall
   echo "alias t=tenjo" >> ~/.bashrc
   cd /path/to/taskrepo
   tenjo init

TBD

Workflow
========

Project management must never be harder than moving files by file manager.
Look at captivating simplicity of such workflow, easy enough even from cmdline:

.. code-block:: bash

   mkdir -p myproject
   cd myproject
   touch "short-desc_for_feature.task"
   git add --all && git commit --allow-empty-message

And if the task had grown too big, work log become too large, you must track blockers
and store artifacts -- use folder with the same name as task, "divide and conquer":

.. code-block:: bash

   cd myproject
   td(){ mkdir -p "$1.tmp"; mv -vT "$1" "$1.tmp/TASK"; mv -vT "$1.tmp" "$1"; }
   td "short-desc_for_feature.task"
   touch "bug-on-input.task"
   touch "refactoring-step-2.task"
   git add --all && git commit --allow-empty-message

When you are done with subtask -- simply move it into ``./.done/``,
regardless if subtask is a standalone file or became a directory too:

.. code-block:: bash

   cd myproject/short-desc_for_feature.task
   mkdir -p .done
   mv -vt .done "bug-on-input.task"
   git add --all && git commit --allow-empty-message

When you had finished whole task -- move whole task:

.. code-block:: bash

   cd myproject
   mkdir -p .done
   mv -vt .done "short-desc_for_feature.task"
   git add --all && git commit --allow-empty-message

And when your project was closed -- move whole project:

.. code-block:: bash

   mkdir -p .done
   mv -vt .done "myproject"
   git add --all && git commit --allow-empty-message

That's all.
With your favorite **file manager** it will be piece of cake.

Of course, tasks may undergo very long journey through different folders until
they find themselves inside ``./.done/``.
Read full spec RFC below for more complex conceptual worklows you can build.


Trivia
======

File ``*.task`` has completely arbitrary textual format.

* It may remain empty -- for tasks with obvious names.
* File ought to contain detailed description for complex tasks.
* It can resemble personal worklog for scientific research:
  what you did (in chronological order) and what results you got.

I recommend using ``reStructuredText`` format for all your notes.
Then you will be able to generate wiki web site directly from tasks worklogs,
or parse and convert them into changelogs, dashboards and weekly reports.

Folder ``./.done/`` will become hidden on linux, which will prevent it from being accessed
by file manager preview each time you open project directory -- which may become quite expensive
after number of your task files will exceed ~5000 on typical filesystem.

Reasonings:

* You don't need to have any commit description, really. Because they have no additional value.
* Everybody works on ``master``. Branches here have no meaning -- only history of changes matters.
* Who created and who closed task is the same question as "who committed changes".
* When task was created and when it was closed is easily inferable from git log.
* You already have ``find + grep`` and whole world of other tools to manage tasks by any OS.


RFC (full spec)
===============

TBD
