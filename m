Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 000F17F72
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 23:23:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E27D0304059
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 21:23:06 -0700 (PDT)
Received: from mail02.lsn.net (mail02.lsn.net [66.90.130.128]) by cuda.sgi.com
	with ESMTP id gwWfYmm5MJQHB7Qy for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 21:23:05 -0700 (PDT)
Message-ID: <540FD1EB.8070007@mygrande.net>
Date: Tue, 09 Sep 2014 23:22:03 -0500
From: Leslie Rhorer <lrhorer@mygrande.net>
MIME-Version: 1.0
Subject: Re: Corrupted files
References: <540F1B01.3020700@mygrande.net>	<20140909220645.GH20518@dastard>	<540FA586.9090308@mygrande.net>	<20140910015331.GJ20518@dastard>	<540FC135.8010601@mygrande.net>	<20140910033331.GA27048@dastard>
	<540FD038.5010202@mygrande.net>
In-Reply-To: <540FD038.5010202@mygrande.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


>>>     OK. I'll scarf the source and compile.  All I need is to git clone
>>> git://oss.sgi.com/xfs/xfs and git://oss.sgi.com/xfs/cmds/xfsprogs,
>>> right?
>>
>> Just clone git://oss.sgi.com/xfs/cmds/xfsprogs and check out the
>> v3.2.1 tag and build that..

	Oops!  Hold on.  I didn't read that closely enough.  You were saying I 
only need to compile xfs-progs.  That's working.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
