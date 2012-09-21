Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8LK7pEI245127 for <xfs@oss.sgi.com>; Fri, 21 Sep 2012 15:07:51 -0500
Date: Fri, 21 Sep 2012 15:09:01 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfstests: fix TEST_MNT typos (should be TEST_DIR)
Message-ID: <20120921200901.GD1140@sgi.com>
References: <1347894935-1495-1-git-send-email-bfoster@redhat.com>
	<50589E53.2050407@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50589E53.2050407@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Sep 18, 2012 at 11:16:19AM -0500, Mark Tinguely wrote:
> On 09/17/12 10:15, Brian Foster wrote:
> >We mistakenly use TEST_MNT in tests 222 and 253, which is undefined.
> >Replace these two instances with TEST_DIR.
> >
> >Signed-off-by: Brian Foster<bfoster@redhat.com>
> >---
> 
> Good catch.
> 
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

committed to git://oss.sgi.com/xfs/cmds/xfstests.git, master branch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
