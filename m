Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Sep 2006 05:58:21 -0700 (PDT)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.168])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k86CwADW002687
	for <xfs@oss.sgi.com>; Wed, 6 Sep 2006 05:58:11 -0700
Received: by ug-out-1314.google.com with SMTP id j3so2316337ugf
        for <xfs@oss.sgi.com>; Wed, 06 Sep 2006 05:57:36 -0700 (PDT)
Message-ID: <60fdb1ad0609060459k6132f8b8s40e4f20f51a746ed@mail.gmail.com>
Date: Wed, 6 Sep 2006 12:59:24 +0100
From: "Vijay Gill" <vijay.s.gill@gmail.com>
Subject: Bad block on partition, how to deal with it?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

Got this bad sector in a seagate 40G hard disk. Is there any tool
under linux to scan the surface of the disk and mark the sectors bad
in file system (or at even lower level like seatools does)?

Running Linux Fedora Core 5.

In the mean while I am doing a dd on that partition to copy the data
and try to recover it from there.

Also I have run badblocks to get the number of the block which is bad,
but how do I get it marked now so that the OS does not try to allocate
it for data in future.

Thanks
Vijay
