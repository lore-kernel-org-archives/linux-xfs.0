Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 14:44:09 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1OMi3ld031348
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 14:44:05 -0800
Received: from mail.inarad.ro (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34B22611059
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 14:44:30 -0800 (PST)
Received: from mail.inarad.ro (inarad.ro [216.139.218.116]) by cuda.sgi.com with ESMTP id aHMLU4upPHmgFOhA for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 14:44:30 -0800 (PST)
Received: from inarad.ro (ldc564.local [127.0.0.1])
	by mail.inarad.ro (Postfix) with ESMTP id DF03B1A71C
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 10:43:00 -0600 (CST)
MIME-Version: 1.0
Date: Sun, 24 Feb 2008 10:43:00 -0600
From: <office@inarad.ro>
Subject: xfs recovery - is it possible
Message-ID: <12b28db387e305d34fd0b57952d5884d@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello

I accidentally formatted my data partition with fsck.xfs -f /dev/sda2. I
use Debian Linux on a Dell Inspiron laptop and wanted to upgrade my bios.
The Upgrade tool work only on Windows - so I had to delete 2 partitions and
make 1 NTFS partition to be able to run bios upgrade tool.

The data partition used to be sda4 - but after I removed the first 2
partitions and made only one, when I tried to reinstall Debian, I didn't
realise that partition numbers changed after i removed NTFS partition and
made a boot partition.

Is there any method to retrieve the data back? The files are there... just
need a scan tool to be able to retrieve them, is there any?

Thank you
Dacian
