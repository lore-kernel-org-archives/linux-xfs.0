Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Aug 2006 23:36:22 -0700 (PDT)
Received: from mail.rentalia.net (mail.rentalia.com [213.192.209.8])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7H6a5DW003952
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 23:36:06 -0700
Message-ID: <44E40E25.2090101@rentalia.com>
Date: Thu, 17 Aug 2006 08:35:17 +0200
From: Ruben Rubio <ruben@rentalia.com>
MIME-Version: 1.0
Subject: Re: File problem question
References: <44DC44FA.4060401@rentalia.com> <Pine.LNX.4.64.0608111637290.7492@prinz64.housecafe.de>
In-Reply-To: <Pine.LNX.4.64.0608111637290.7492@prinz64.housecafe.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian <evilninja@gmx.net>, xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Christian wrote:
> On Fri, 11 Aug 2006, Ruben Rubio wrote:
>> root@rigodon log # ls -al lastlog
>> - -r--------  1 root root 146292 ago 11 10:44 lastlog
> ---^
>    is that a typo or is there a space in the permission field?

This is an error when I did copy/paste

> 
>> I have a file witch size is 7,6 GB. However, if I ls -al is another
>> file. Seems like filesystems is being corrupted.
> 
> What does xfs_check say? Which (linux?-)kernel are you using? If you are

I did't run xfs_check yet. I have to disconnect the server because I
have to unmount the filesystem in orden to run the program (I ll do it
after holidays if there is not risk).

xfsprogs version: 2.6.13-2
Kernel: 2.6.9-1.667smp
Distro: Fedora Core release 3

> about to xfs_*, please make sure you have the *latest* xfsprogs[0],
> which is 2.8.10-1 right now...
> 
> Christian.
> [0] ftp://oss.sgi.com/projects/xfs/cmd_tars/

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFE5A4lIo1XmbAXRboRAv6zAJ0TUw3nJZEH+1yyJQROwVduFnkoXwCgsRaU
kXjPxH4aFKStRAOWvRaGGw4=
=4JFf
-----END PGP SIGNATURE-----
