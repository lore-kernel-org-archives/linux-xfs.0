Return-Path: <xfs-bounces@oss.sgi.com>
Received: from nfs10.americas.sgi.com (nfs10.americas.sgi.com [128.162.245.67])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAUHwoSW208146 for <xfs@oss.sgi.com>; Wed, 30 Nov 2011 11:58:50 -0600
From: Ben Myers <bpm@sgi.com>
Subject: XFS update for 3.1-stable (resent)
Date: Wed, 30 Nov 2011 12:10:54 -0600
Message-Id: <1322676660-22945-1-git-send-email-bpm@sgi.com>
In-Reply-To: <20111128214018.GB1650@kroah.com>
References: <20111128214018.GB1650@kroah.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: greg@kroah.com, stable@vger.kernel.org
Cc: bpm@sgi.com, xfs@oss.sgi.com

Hey Greg,

The last mailing of this patch set went AWOL.  Here's another whirl.

Greg K-H wrote:
> Was stable@vger.kernel.org on the to: line?   If so, I should have seen them
> through that, but I don't, which is worrysome to me.

I thought so.

> The 3.0 series is already in the last 3.0.11 release, so I don't need them, I
> think I need the 3.1 patches, right? 

Affirmative.  You only need the 3.1 patches, here they are:

---

This is a series of XFS fixes from current mainline which are important for
3.1-stable.  Note that it is the same patch set that Christoph submitted for
3.0-stable, minus the first three patches which are already included in 3.1.

My QA came out ok with these six patches atop 3.1.y.

Thanks!
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
