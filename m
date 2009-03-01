Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n211bCTu132458 for <xfs@oss.sgi.com>; Sat, 28 Feb 2009 19:37:13 -0600
Message-ID: <49A9E7C3.1050903@sgi.com>
Date: Sun, 01 Mar 2009 12:41:23 +1100
From: Greg Banks <gnb@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
References: <200902240010.25434.vapier@gentoo.org>	<200902242322.48314.agruen@suse.de>	<20090226230300.GA6289@infradead.org>
	<200902280107.06699.agruen@suse.de> <49A9BA50.7050101@sandeen.net>
In-Reply-To: <49A9BA50.7050101@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>, Mike Frysinger <vapier@gentoo.org>

Eric Sandeen wrote:
> Andreas Gruenbacher wrote:
>   
>> On Friday, 27 February 2009 0:03:00 Christoph Hellwig wrote:
>>     
>>> Do you plan to take over nfs4acl, too?
>>>       
>> I can sure copy the repository over from you if that is any help. How that 
>> project will proceed is still unclear though, so don't expect a lot to happen 
>> there anytime soon.
>>
>> Andreas
>>     
>
> I'd check in w/ Greg on that too, maybe?
>
>
>   
I think the best thing for nfs4acl is for there to be repo owned by
Andreas and adjacent to the attr and acl ones.

I'd also like eventually to see a sensible and unified nfs4acl kernel
repo so we can fix up the mess that is the current  crop of nfs4acl
kernel trees on oss.sgi.com.  For various reasons I'd prefer to see that
on kernel.org or linux-nfs.org rather than oss.sgi.com.  However I doubt
I'll have any chance to do anything on that in the next few weeks.

-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
the brightly coloured sporks of revolution.
I don't speak for SGI.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
