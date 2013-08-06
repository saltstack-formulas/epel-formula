epel
====

Install the EPEL RPM and GPG key on RHEL 5/6 or CentOS 5/6.

Instructions
------------

1.  Add this repository as a `GitFS backend`__ in your Salt master config.

2.  Add an ``epel.sls`` file to your Pillar using the ``pillar.example`` file
    as a reference.

3.  Make sure the ``epel.sls`` file is linked from your Pillar top
    file. One possible example::

        base:
          'os_family:RedHat':
            - match: grain
            - epel

4.  The EPEL state can now be included and referenced as normal from other
    state declarations::

        include:
          - epel

        python26:
          pkg:
            - installed
          require:
            - pkg: epel

.. __: http://docs.saltstack.com/topics/tutorials/gitfs.html
