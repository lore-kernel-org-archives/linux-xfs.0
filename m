Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4ALrov7076269 for <xfs@oss.sgi.com>; Thu, 10 May 2012 16:53:50 -0500
Message-ID: <4FAC38EB.1090601@sgi.com>
Date: Thu, 10 May 2012 16:53:47 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Still seeing hangs in xlog_grant_log_space
References: <CADLDEKs01GnxgYh2UTt1waVDUXHbB_RcBcUTBr5REFg5aD5jHA@mail.gmail.com>
	<20120425223845.GX9541@dastard>
	<CADLDEKvYkpUnMrqdMyqCmsYrZcUtiJ6ZRhrRu_ERTjn=r7M3Pg@mail.gmail.com>
	<20120426224412.GA9541@dastard>
	<CADLDEKs6oMDA-6OhmcFxyRoBVpduKtSput=53TQGn9NCAOXC1Q@mail.gmail.com>
	<20120426230738.GB9541@dastard>
	<CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
	<20120507171908.GA16881@sgi.com>
	<CADLDEKvgT_FcGhJKoPaQv0mh_Jqdaqu8SYatc9xxU7vOY217YQ@mail.gmail.com>
	<loom.20120510T180646-433@post.gmane.org>
In-Reply-To: <loom.20120510T180646-433@post.gmane.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Chris J Arges <chris.j.arges@canonical.com>
Cc: Juerg Haefliger <juergh@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On 05/10/12 11:11, Chris J Arges wrote:
> <snip>
>> Canonical attached them to the bug report that they filed yesterday:
>> http://oss.sgi.com/bugzilla/show_bug.cgi?id=922
>>
>> ...Juerg
>>
>
> Hello,
> I am able to reproduce this bug with the instructions posted in this bug. Let me
> know what I can do to help.
> --chris j arges
>
> <snip>
>

I have been running the test for 8+ hours with top of tree sources and 
an additional log cleaner kicker patch without problem. I will leave 
that one running and start another machine with just the top of tree 
kernel without the additional patch and then go back to an earlier sources.

Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
