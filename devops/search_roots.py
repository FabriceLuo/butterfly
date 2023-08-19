#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import click

default_exclude_dirs = ['.git']

default_signs = [
    'setup.cfg',
]

default_outfs = '/dev/stdout'
default_find_roots = ['.']
verbose = False


def find_roots_in_dir(find_root,
                      signs,
                      exclude_dirs=None,
                      depth=1,
                      max_depth=None):
    roots = []

    if max_depth and depth > max_depth:
        return roots

    if not signs:
        raise ValueError('signs must have one value at least')

    if not os.path.isdir(find_root):
        raise ValueError('find root must be a dir')

    for name in os.listdir(find_root):
        if name in signs:
            root = os.path.abspath(find_root)
            roots.append(root)

            continue

        child_root = os.path.join(find_root, name)

        if not os.path.isdir(child_root):
            continue

        if exclude_dirs and name in exclude_dirs:
            continue

        child_roots = find_roots_in_dir(child_root,
                                        signs,
                                        exclude_dirs=exclude_dirs,
                                        depth=depth + 1,
                                        max_depth=max_depth)
        roots.extend(child_roots)

    return roots


def find_roots_in_dirs(find_roots, signs, exclude_dirs=None, max_depth=None):
    roots = []

    for find_root in find_roots:
        dir_roots = find_roots_in_dir(find_root,
                                      signs,
                                      exclude_dirs,
                                      max_depth=max_depth)
        roots.extend(dir_roots)

    return roots


def dump_to_fp(roots, fp):
    for root in roots:
        fp.write(root + '\n')

    fp.flush()


def dump(roots, outfile):
    if not isinstance(outfile, str):
        dump_to_fp(roots, outfile)

        return

    with open(outfile, 'w+') as fp:
        dump_to_fp(roots, fp)


@click.command(help='Collect roots of python libs in dirs')
@click.option('find_roots',
              '-r',
              '--root',
              default=default_find_roots,
              required=False,
              multiple=True,
              show_default=True)
@click.option('signs',
              '-s',
              '--sign',
              default=default_signs,
              required=False,
              multiple=True)
@click.option('outfile',
              '-o',
              '--outfile',
              default=default_outfs,
              required=False,
              show_default=True)
@click.option('excludes',
              '-e',
              '--exclude-dir',
              default=default_exclude_dirs,
              required=False,
              multiple=True)
@click.option('max_depth', '-m', '--max-depth', default=10, required=False)
@click.option('ver',
              '-v',
              '--verbose',
              default=False,
              required=False,
              is_flag=True)
def main(find_roots, signs, outfile, excludes, max_depth, ver):
    verbose = ver

    if verbose:
        print("find_roots:{find_roots}, signs:{signs}, outfile={outfile},"
              " exclude_dirs:{exclude_dirs}, max_depth={max_depth}".format(
                  find_roots=find_roots,
                  signs=signs,
                  outfile=outfile,
                  exclude_dirs=excludes,
                  max_depth=max_depth))
    roots = find_roots_in_dirs(find_roots,
                               signs=signs,
                               exclude_dirs=excludes,
                               max_depth=max_depth)
    dump(roots, outfile)


if __name__ == "__main__":
    main()
