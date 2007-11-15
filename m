Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Nov 2007 19:26:13 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAF3Q6F6008298
	for <xfs@oss.sgi.com>; Wed, 14 Nov 2007 19:26:08 -0800
Message-ID: <473BBC55.7050804@sandeen.net>
Date: Wed, 14 Nov 2007 21:26:13 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
References: <06CCEA2EB1B80A4A937ED59005FA855101AED622@svits26.main.ad.rit.edu>
In-Reply-To: <06CCEA2EB1B80A4A937ED59005FA855101AED622@svits26.main.ad.rit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jay Sullivan <jpspgd@rit.edu>
Cc: xfs@oss.sgi.com

Jay Sullivan wrote:
> Of course this had to happen one more time before my scheduled
> maintenance window...  Anyways, here's all of the good stuff I
> collected.  Can anyone make sense of it?  Oh, and I upgraded to xfsprogs
> 2.9.4 last week, so all output you see is with that version.  
> 

Forgot to ask, are you running w/ 4k stacks?

And/or, do you have stack usage debugging enabled?  That's quite a
backtrace you've got there... just a shot in the dark.

-Eric
