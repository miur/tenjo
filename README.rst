.. SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq+tenjo@gmail.com>

.. SPDX-License-Identifier: Apache-2.0

.. SRC: https://stackoverflow.com/questions/10870719/inline-code-highlighting-in-restructuredtext
.. TODO: add prefix '$ ' before each command
.. role:: bash(code)
   :language: bash

#####
tenjo
#####

Tasks enframing journal -- to manage, track and account your goals and progress for highly entangled projects.

.. note::
   Etymology: "天助" (/tenjo/) -- jp. "help of heavens"

Kind of DPMS -- Distributed Project Management System (consonant: "di-plo-ma-cy" :D)
with explicit and conscious resolution of conflicts, contrasting to most others centralized
project management solutions, like Jira and Trello, based on locks inside "one source of truth".


Raison d'être
=============

* Store offline like git -- never lose task history even on your own PC.
* Distribute info like git -- advance progress and sync repo copies between all your devices.
* Merge conflicts like git -- explicitly decide what to do, how to do, and only when your descriptions differ.
* Collaborate with others like git -- give everyone his "personal world" (local clone) to live inside with time lag.
* Improve work of others like git -- create independent fork, enhance workflows and share when ready.
* Review and feedback like git -- annotate changes in tasks and their statuses, with the same web tools for code reviewing.
* Federate like IRC -- embrace the idea of "person" and "company" are two different and largely incompatible worlds.
  Only *communicate* tasks between them, between their inherent contexts, but don't try to fully embed one into another.
* Generate reports along CI/CD -- use server jobs to re-generate reports and dashboards on each commit (like testing).
* Integrate under single git -- store tasks alongside your project source code inside **feature/tasks/** folder per each module

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
   SEE: :title`Workflow (grassroots)`

Install ``tenjo``, create convenient alias for yourself, and register ``pre-commit`` hook in git main tasks-repo:

.. code-block:: bash

   sudo make install  # OR: sudo checkinstall
   echo "alias t=tenjo" >> ~/.bashrc
   cd /path/to/taskrepo
   tenjo init

TBD

ARCH
====

You have 3 degrees of freedom:
  * project-graph nesting (xpath) :: Supergroup Group Project Subproject Task Subtask Dependency
  * task-lifecycle status (flow) :: {Pending | Now | Done | Seized}
  * task-mgmt distribution (planning) :: Prio User {Undecided(New) | Next | Someday | BacklogForDuration(CW09) | DecideAtDate(2020-04-02)}

Conventional ideas are simulated:
  * To express *blocked-by* create a new symlinked subtask inside task (dependency).
  * TEMP: *due-date* is meaningless in personal flow as it affects only priority on current day
    (However it may become quite interesting if you diligently estimate each
    your task -- you would be able to auto-prioritize tasks based on the time
    left to deadline and remind yourself to write follow-up mails that you
    can't accomplish some chosen task on the time)
  * You have 5 ways to express *In-Progress* status depending on who has decision power
    (i.e. you yourself or only your PM can decide which task from the list you will be doing now)
    + create symlink named ``!now`` directly to your task (yes, you can't work on multiple things at the same time)
    + move task to folder ``!now`` inside your own ``@user`` folder (NICE: task is actually **moved** from the backlog)
    + create inside folder ``!now`` symlink to your own task (NICE: task keeps its xpath location)
    + use single folder ``!now`` in project-root and move/symlink tasks into its subfolders ``!now/@user/``
    + use additional folder ``!now`` in project-root to contain symlinks to all ``!now`` tasks (only for mngr|can auto-gen)

Each task undergoes evolution and accumulates path-prefixes along the way::

    Task -> Project -> Prio -> User -> {Now|Date} -> {Done|Cancel} -> Seized

Resulting path is striving to be self-explanatory, e.g:

* CASE (1) single person::

    ./my-project/clarify-rq.task
    ./my-project/next/clarify-rq.task
    ./my-project/!now/clarify-rq.task
    ./my-project/.done/clarify-rq.task
    ./my-project/.seized/clarify-rq.task

* CASE (2) team distributes tasks::

    ./my-project/clarify-rq.task
    ./my-project/backlog/clarify-rq.task
    ./my-project/@user/clarify-rq.task
    ./my-project/@user/!now/clarify-rq.task
    ./my-project/.done/@user/clarify-rq.task

* CASE (3) manager affects priority::

    ./my-project/clarify-rq.task
    ./my-project/3/clarify-rq.task
    ./my-project/3/@user/clarify-rq.task
    ./my-project/3/@user/!now/clarify-rq.task  <--  ./my-project/!now/clarify-rq.task
    ./my-project/.done/3/@user/clarify-rq.task


Workflow (simplest)
===================

* ADD:  :bash:`$ tenjo add clarify rq`
* EDIT: :bash:`$ tenjo edit clarify rq`
* NOW:  :bash:`$ tenjo now clarify rq`
* DONE: :bash:`$ tenjo done clarify rq`
* MARK: :bash:`$ tenjo mark clarify rq`
* MOVE: :bash:`$ tenjo move dst-project` NEED: ※⡞⡬⣇⡃


Workflow (grassroots)
=====================

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
