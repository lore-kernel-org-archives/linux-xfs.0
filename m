Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 26 Mar 2007 03:14:55 -0700 (PDT)
Received: from srv-mailrelais-dz1.argus.int (smtp.argus-presse.fr [213.244.9.225])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2QAEi6p018549
	for <xfs@oss.sgi.com>; Mon, 26 Mar 2007 03:14:46 -0700
Subject: Re: xfs_repair on Debian testing 64bits
From: Patrick =?ISO-8859-1?Q?No=EBl?= <patrick.noel@argus-presse.fr>
In-Reply-To: <17926.26297.892974.270267@base.ty.sabi.co.UK>
References: <1174655443.5441.37.camel@localhost.localdomain>
	 <17926.26297.892974.270267@base.ty.sabi.co.UK>
Content-Type: text/plain; charset=ISO-8859-1
Date: Mon, 26 Mar 2007 12:14:38 +0200
Message-Id: <1174904078.5978.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Grandi <pg_xfs@xfs.for.sabi.co.UK>, xfs@oss.sgi.com

Le dimanche 25 mars 2007 à 13:10 +0100, Peter Grandi a écrit :


>    «To successfully check or run repair on a multi-terabyte
>     filesystem, you need:
> 
> 	- a 64bit machine
> 	- a 64bit xfs_repair/xfs_check binary
> 	- ~2GB RAM per terabyte of filesystem
> 	- 100-200MB of RAM per million inodes in the filesystem.
> 
>     

for 5,3To 

	2GB * 5,3 = 10,6Go
	
	100MB/million inodes * 45 = 4,5Go

Total = 16Go Ram

i presume the number of inodes is the number of used inodes because the
number of inode on 5,3To is 5119 million.

The goal is to use a device of 15To with the same data, consider the
amount total of RAM at 45Go.

I will go to the store of the corner to buy RAM :)

Thanks

Patrick
