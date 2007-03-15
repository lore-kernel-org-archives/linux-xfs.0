Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 07:59:08 -0700 (PDT)
Received: from evaldomino.Falconstor.com (mail1.falconstor.com [216.223.47.230])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2FEx26p010004
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 07:59:03 -0700
Message-ID: <45F95B21.9040603@falconstor.com>
Date: Thu, 15 Mar 2007 10:41:37 -0400
From: "Geir A. Myrestrand" <geir.myrestrand@falconstor.com>
Reply-To: geir.myrestrand@falconstor.com
MIME-Version: 1.0
Subject: Re: Questions about XFS
References: <200703131440.56678.clflush@chello.be> <1173890016.20671.11.camel@localhost.localdomain> <45F8CAEA.3050408@list.rakugaki.org> <200703151007.32630.clflush@chello.be>
In-Reply-To: <200703151007.32630.clflush@chello.be>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-2022-JP
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

clflush wrote:
> On the one hand you have the old Ext3 FS which doesn't perform very well in 
> many areas but IMO is a lot safer to work on (doesn't loose data that easily 
> compared to XFS - and I'm talking from experience here because I use both 
> file systems and I lost much more on the XFS system than on the Ext3 one) and 
> on the other hand you have this excellent XFS file system with its clean 
> layout and awesome performance + fancy features like GRIO, extents, allocate 
> on flush, real time volumes, etc *but* is not "safe" enough to work with if 
> you have unreliable hardware and/or a lot of power outage issues  - I've 
> never lost data on Ext3 during a power outage but already lost 2 times data 
> on XFS

You *always* use a UPS when you use XFS.
XFS does not prevent power outages [yet]...

> Just my $0.02

Save them for a UPS. ;-)

-- 

Geir A. Myrestrand
