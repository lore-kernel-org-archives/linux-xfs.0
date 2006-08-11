Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Aug 2006 02:52:02 -0700 (PDT)
Received: from mail.rentalia.net (mail.rentalia.com [213.192.209.8])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7B9poDW029797
	for <xfs@oss.sgi.com>; Fri, 11 Aug 2006 02:51:51 -0700
Message-ID: <44DC44FA.4060401@rentalia.com>
Date: Fri, 11 Aug 2006 10:51:06 +0200
From: Ruben Rubio <ruben@rentalia.com>
MIME-Version: 1.0
Subject: File problem question
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

I have a problem with xfs filesystem. I have lost a file. So:

root@rigodon log # pwd
/var/log
root@rigodon log # ls -al lastlog
- -r--------  1 root root 146292 ago 11 10:44 lastlog
root@rigodon log # du -sh * | grep lastlog
7,6G    lastlog

I have a file witch size is 7,6 GB. However, if I ls -al is another
file. Seems like filesystems is being corrupted.

How can I delete 7,6 G file?
Is this dangerous? Is there any another action that I shoud do?

Thanks in advance
Ruben Rubio Rey
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFE3ET6Io1XmbAXRboRAjaMAKCysw9xUYamyezyTsiq2PaRlZ7sWQCfaMhb
OhuGEystqU3NZZtIaRFJa/M=
=I0Tx
-----END PGP SIGNATURE-----
