# Week 8 Tutorial Problems
1. A ``connection`` object essentially starts a **session** with the database. A ``cursor`` is obtained from a ``connection`` and is a **handle** that can perform queries or updates on the database.

2. ``conn`` is scoped only to the ``try`` clause and does not extend to the ``finally`` clause. Using it in an ``if`` condition will hence cause a ``NameError``.