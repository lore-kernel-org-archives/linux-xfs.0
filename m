Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 285617F3F
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 00:35:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0A2F78F8033
	for <xfs@oss.sgi.com>; Sun, 10 May 2015 22:35:33 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 1tfl6NLia4tZQYnf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 10 May 2015 22:35:23 -0700 (PDT)
Date: Sun, 10 May 2015 22:35:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] xfsprogs: master branch updated to v3.2.3-rc1
Message-ID: <20150511053523.GA29703@infradead.org>
References: <20150511005524.GE16689@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150511005524.GE16689@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, May 11, 2015 at 10:55:25AM +1000, Dave Chinner wrote:
> Hi folks,
> 
> The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
> just been updated. This update is the first candidate for a
> v3.2.3 release, so please test and report any problems you find.
> 
> The new head of the master branch is commit:
> 
> c8c0837 xfsprogs: update for 3.2.3-rc1 release

FYI, I don't think enabling v5 file system without at least a minor
version bump makes sense.  While I'm not fan of release number inflation
this might even be a case for a major number bump to 4.x.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
