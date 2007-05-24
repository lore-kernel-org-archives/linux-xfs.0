Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 May 2007 04:25:06 -0700 (PDT)
Received: from poczta.o2.pl (mx10.go2.pl [193.17.41.74])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4OBOwWt022222
	for <xfs@oss.sgi.com>; Thu, 24 May 2007 04:24:59 -0700
From: =?utf-8?q?=C5=81ukasz_Fibinger?= <lucke@o2.pl>
Reply-To: lucke@o2.pl
Subject: Re: RESVSP problems
Date: Thu, 24 May 2007 13:24:52 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705241324.53283.lucke@o2.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: dgc@sgi.com

>>> You've probably hit:
>>> http://oss.sgi.com/bugzilla/show_bug.cgi?id=418
>>> unwritten extents remain unwritten after mmap() modifies them
>>>
>>> Bug dchinner about it... ;-)
>> 
>> Dave, consider it a bugging from my humble self :-)

> Yeah, yeah ;)

> I'm waiting to see what happens with Nick's patches in .22 before
> going any further. If they are not merged into .22, then I think we
> should push the XFS specific fix in....

I wonder, what's the status of it, Dave?

Cheers,

Luke
