Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6OL2PQU193518 for <xfs@oss.sgi.com>; Tue, 24 Jul 2012 16:02:25 -0500
Received: from x.digitalelves.com (x.digitalelves.com [209.98.77.55]) by
	cuda.sgi.com with ESMTP id 2c8dhheCfWlCu9RB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jul 2012 14:02:24 -0700 (PDT)
Message-ID: <500F0D57.7010502@thebarn.com>
Date: Tue, 24 Jul 2012 16:02:15 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: wiki spam
References: <50082D6A.30901@sandeen.net> <20120724132352.GB9142@infradead.org>
In-Reply-To: <20120724132352.GB9142@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On 7/24/12 8:23 AM, Christoph Hellwig wrote:
> On Thu, Jul 19, 2012 at 10:53:14AM -0500, Eric Sandeen wrote:
>> We're back up to about a 3:1 ratio of spam to content on the wiki.
>>
>> Constantly weeding it out is a poor use of our time... where are we at with this, have we required an account to create pages, at least?
> I suspect Russell isn't reading the xfs list to actively any more.
>
> Russell, any chance to disabllow posting for users that don't have an
> account on the wiki?
Ok I updated mediawiki to 1.19 so that the ConfirmUser extension wold work.

All accounts must be approved by a sysop before they are active.
Hopefully I can just reject the obvious spam accounts.


There was some 1500 accounts on the system most of them with no edit's
so I just deleted those.

There is a bunch of spam accounts with 1 or 2 posts these should be deleted
with the mergeuser extension but that is a bit more time consuming.


Please let me know if the upgrade has caused any problems.

-Russell

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
