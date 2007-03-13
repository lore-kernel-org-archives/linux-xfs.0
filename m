Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Mar 2007 09:53:25 -0700 (PDT)
Received: from osl1smout1.broadpark.no (osl1smout1.broadpark.no [80.202.4.58])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2DGrF6p010511
	for <xfs@oss.sgi.com>; Tue, 13 Mar 2007 09:53:18 -0700
Received: from osl1sminn1.broadpark.no ([80.202.4.59])
 by osl1smout1.broadpark.no
 (Sun Java System Messaging Server 6.1 HotFix 0.05 (built Oct 21 2004))
 with ESMTP id <0JEU005X3MSP1CA0@osl1smout1.broadpark.no> for xfs@oss.sgi.com;
 Tue, 13 Mar 2007 16:53:13 +0100 (CET)
Received: from [10.0.0.3] ([80.202.169.161]) by osl1sminn1.broadpark.no
 (Sun Java System Messaging Server 6.1 HotFix 0.05 (built Oct 21 2004))
 with ESMTP id <0JEU003VKMSO7TH2@osl1sminn1.broadpark.no> for xfs@oss.sgi.com;
 Tue, 13 Mar 2007 16:53:13 +0100 (CET)
Date: Tue, 13 Mar 2007 16:53:12 +0100
From: "Stein M. Hugubakken" <dulci@start.no>
Subject: Re: Questions about XFS
In-reply-to: <200703131440.56678.clflush@chello.be>
Message-id: <45F6C8E8.5070208@start.no>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <200703131440.56678.clflush@chello.be>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

clflush wrote:
> Basically, my two question that I have are:
> 
> - Why did I lost bookmarks on a machine running XFS while on another one which 
> runs the same OS version but uses Ext3 as file system, it never happened, no 
> matter how many times I had to reset it.
> 
> - Are there any efforts currently made to increase the data integrity of XFS?
> 

Take a look at the FAQ:
http://oss.sgi.com/projects/xfs/faq.html#wcache

Regarding the lost bookmarks, you might find an old backup in 
~/.mozilla/firefox/<userprofile>/bookmarkbackups.

Regards
Stein
